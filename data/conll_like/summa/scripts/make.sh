#!/bin/bash

HUNALIGNWRAPPER=../../../umc-devel/tools/align/hunalignwrapper.pl
HUNALIGN=../../../umc-devel/tools/external/hunalign-1.1/hunalign
SPLITTER=../../../umc-devel/tools/sentence_splitter/split-sentences.perl
#SPLITTER=./sentence_split.py

temp_dir=$(mktemp -d /a/LRC_TMP/vernerova/tmp/sthXXXX)

outfile_prefix=$2
out_encs=${outfile_prefix}.section.en-cs
out_enla=${outfile_prefix}.section.en-la
out_csla=${outfile_prefix}.section.cs-la

rm $out_encs
rm $out_enla
rm $out_csla

echo Temporary directory: $temp_dir    
#cut -f1 $1 | sed 's/<[^<]*>/ /g;s/  / /g' | $SPLITTER -l en > $temp_dir/tmp.en
#cut -f2 $1 | sed 's/<[^<]*>/ /g;s/  / /g' | $SPLITTER -l cs > $temp_dir/tmp.cs
#cut -f3 $1 | sed 's/<[^<]*>/ /g;s/  / /g' | $SPLITTER -l la > $temp_dir/tmp.la
cut -f1 $1 | sed 's/<\/p><p>/ PARAGRAPH /g;s/<[^<]*>/ /g;s/  / /g' | $SPLITTER -l en > $temp_dir/tmp.en
cut -f2 $1 | sed 's/<\/p><p>/ PARAGRAPH /g;s/<[^<]*>/ /g;s/  / /g' | $SPLITTER -l cs > $temp_dir/tmp.cs
cut -f3 $1 | sed 's/<\/p><p>/ PARAGRAPH /g;s/<[^<]*>/ /g;s/  / /g' | $SPLITTER -l la > $temp_dir/tmp.la
touch  $temp_dir/empty.dic

echo "Aligning en-cs" >&2
$HUNALIGNWRAPPER $temp_dir/tmp.en $temp_dir/tmp.cs --hunalign=$HUNALIGN --tempdir=$temp_dir --segdelim='<SENT_DELIM/>' --obey-document-boundaries --method=atonce |\
    strings -e S | uconv -i -f utf-8 -t utf-8 |\
    strings -e S >> $out_encs

echo "Aligning en-la" >&2
$HUNALIGNWRAPPER $temp_dir/tmp.en $temp_dir/tmp.la --hunalign=$HUNALIGN --tempdir=$temp_dir --segdelim='<SENT_DELIM/>' --obey-document-boundaries --method=atonce |\
    strings -e S | uconv -i -f utf-8 -t utf-8 |\
    strings -e S >> $out_enla

echo "Aligning cs-la" >&2
$HUNALIGNWRAPPER $temp_dir/tmp.cs $temp_dir/tmp.la --hunalign=$HUNALIGN --tempdir=$temp_dir --segdelim='<SENT_DELIM/>' --obey-document-boundaries --method=atonce |\
    strings -e S | uconv -i -f utf-8 -t utf-8 |\
    strings -e S >> $out_csla

out_encs=${outfile_prefix}.paragraph.en-cs
out_enla=${outfile_prefix}.paragraph.en-la
out_csla=${outfile_prefix}.paragraph.cs-la

rm $out_encs
rm $out_enla
rm $out_csla

cut -f1 $1 | sed 's/<\/p>/<\/p>\n\n/g' | sed 's/<[^<]*>/ /g;s/  / /g' | $SPLITTER -l en > $temp_dir/tmp.en
cut -f2 $1 | sed 's/<\/p>/<\/p>\n\n/g' | sed 's/<[^<]*>/ /g;s/  / /g' | $SPLITTER -l cs > $temp_dir/tmp.cs
cut -f3 $1 | sed 's/<\/p>/<\/p>\n\n/g' | sed 's/<[^<]*>/ /g;s/  / /g' | $SPLITTER -l la > $temp_dir/tmp.la
touch  $temp_dir/empty.dic

echo "Aligning en-cs" >&2
$HUNALIGNWRAPPER $temp_dir/tmp.en $temp_dir/tmp.cs --hunalign=$HUNALIGN --tempdir=$temp_dir --segdelim='<SENT_DELIM/>' --obey-document-boundaries --method=atonce |\
    strings -e S | uconv -i -f utf-8 -t utf-8 |\
    strings -e S >> $out_encs

echo "Aligning en-la" >&2
$HUNALIGNWRAPPER $temp_dir/tmp.en $temp_dir/tmp.la --hunalign=$HUNALIGN --tempdir=$temp_dir --segdelim='<SENT_DELIM/>' --obey-document-boundaries --method=atonce |\
    strings -e S | uconv -i -f utf-8 -t utf-8 |\
    strings -e S >> $out_enla

echo "Aligning cs-la" >&2
$HUNALIGNWRAPPER $temp_dir/tmp.cs $temp_dir/tmp.la --hunalign=$HUNALIGN --tempdir=$temp_dir --segdelim='<SENT_DELIM/>' --obey-document-boundaries --method=atonce |\
    strings -e S | uconv -i -f utf-8 -t utf-8 |\
    strings -e S >> $out_csla

#rm -r $temp_dir
