#!/bin/bash

HUNALIGNWRAPPER=/a/LRC_TMP/varis/umc-devel/tools/align/hunalignwrapper.pl
HUNALIGN=/a/LRC_TMP/varis/umc-devel/tools/external/hunalign-1.1/hunalign
SPLITTER=splitter/split-sentences.pl
#SPLITTER=./sentence_split.py

temp_dir=$(mktemp -d /a/LRC_TMP/vernerova/tmp/sthXXXX)
#temp_dir=/tmp

out_laen=${1}.aligned.la-en
out_lacs=${1}.aligned.la-cs
rm -f $out_laen $out_lacs


echo Temporary directory: $temp_dir    
cut -f1 $1 | sed -e 's@\(</\?[ph][12]\?>\)@#\1#@g;s/##\+/#/g;s/#/\n/g' | $SPLITTER -l cs > $temp_dir/tmp.cs
cut -f2 $1 | sed -e 's@\(</\?[ph][12]\?>\)@#\1#@g;s/##\+/#/g;s/#/\n/g' | $SPLITTER -l en > $temp_dir/tmp.en
cut -f3 $1 | sed -e 's@\(</\?[ph][12]\?>\)@#\1#@g;s/##\+/#/g;s/#/\n/g' | $SPLITTER -l la > $temp_dir/tmp.la

touch  $temp_dir/empty.dic

echo "Aligning la-en" >&2
$HUNALIGNWRAPPER $temp_dir/tmp.en $temp_dir/tmp.la --hunalign=$HUNALIGN --tempdir=$temp_dir --segdelim='<SENT_DELIM/>' --obey-document-boundaries --method=atonce |\
    strings -e S | uconv -i -f utf-8 -t utf-8 |\
    strings -e S >> $out_enla

echo "Aligning la-cs" >&2
$HUNALIGNWRAPPER $temp_dir/tmp.cs $temp_dir/tmp.la --hunalign=$HUNALIGN --tempdir=$temp_dir --segdelim='<SENT_DELIM/>' --obey-document-boundaries --method=atonce |\
    strings -e S | uconv -i -f utf-8 -t utf-8 |\
    strings -e S >> $out_csla

##rm -r $temp_dir
