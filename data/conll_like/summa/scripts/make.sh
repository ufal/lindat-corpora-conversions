#!/bin/bash

#HUNALIGNWRAPPER=/a/LRC_TMP/varis/umc-devel/tools/align/hunalignwrapper.pl
HUNALIGNWRAPPER=aligner/hunalignwrapper.pl   ## run with --keep during debugging
HUNALIGN=/a/LRC_TMP/varis/umc-devel/tools/external/hunalign-1.1/hunalign
SPLITTER=splitter/split-sentences.pl

## temp dir for hunalign
temp_dir=$(mktemp -d /a/LRC_TMP/vernerova/summa.XXXXX)
#temp_dir=/tmp
#temp_dir=/dev/null

out_laen=${1}.aligned.la-en
out_lacs=${1}.aligned.la-cs
rm -f $out_laen $out_lacs


echo Temporary directory: $temp_dir    
cut -f1 $1 | sed -e 's@\(</\?h[123]>\)@#\1#@g; s@\(</\?p>\)@ \1 @g; s/##\+/#/g; s/^#//; s/#$//; s/#/\n/g' | $SPLITTER -l cs > $temp_dir/tmp.cs
echo -e "\n">> tmp.cs
echo
cut -f2 $1 | sed -e 's@\(</\?h[123]>\)@#\1#@g; s@\(</\?p>\)@ \1 @g; s/##\+/#/g; s/^#//; s/#$//; s/#/\n/g' | $SPLITTER -l en > $temp_dir/tmp.en
echo -e "\n">> tmp.en
echo
cut -f3 $1 | sed -e 's@\(</\?h[123]>\)@#\1#@g; s@\(</\?p>\)@ \1 @g; s/##\+/#/g; s/^#//; s/#$//; s/#/\n/g' | $SPLITTER -l la > $temp_dir/tmp.la
echo -e "\n" >> tmp.la
echo

echo "Aligning la-en" >&2
$HUNALIGNWRAPPER $temp_dir/tmp.la $temp_dir/tmp.en --hunalign=$HUNALIGN --tempdir=$temp_dir --segdelim='<SENT_DELIM/>' --obey-document-boundaries --method=atonce --verbose --blank-line-at-file-break |\
    strings -e S | uconv -i -f utf-8 -t utf-8 |\
    strings -e S | cut -f3,4 >> $out_laen
echo

echo "Aligning la-cs" >&2
$HUNALIGNWRAPPER $temp_dir/tmp.la $temp_dir/tmp.cs --hunalign=$HUNALIGN --tempdir=$temp_dir --segdelim='<SENT_DELIM/>' --obey-document-boundaries --method=atonce --verbose --blank-line-at-file-break |\
    strings -e S | uconv -i -f utf-8 -t utf-8 |\
    strings -e S | cut -f3,4 >> $out_lacs

rm translate.txt

##rm -r $temp_dir
