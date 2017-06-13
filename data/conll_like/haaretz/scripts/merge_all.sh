#/bin/bash
INPUT_PATH_ENG=/net/cluster/TMP/kljueva/kontext/ud/udpipe_hebrew/input/corpus/eng
INPUT_PATH_HEB=/net/cluster/TMP/kljueva/kontext/ud/udpipe_hebrew/input/corpus/heb
OUTPUT_FIXED=/net/cluster/TMP/kljueva/kontext/ud/udpipe_hebrew/output_fixed
ALIGN=/net/cluster/TMP/kljueva/kontext/ud/udpipe_hebrew/align

outfile_eng="all_eng.vert"
outfile_heb="all_heb.vert"
touch $outfile_eng
touch $outfile_heb
echo "<doc>" > $outfile_eng
echo "<doc>" > $outfile_heb

for file in $OUTPUT_FIXED/*eng*
do
echo "Processing $file writing to $outfile_eng"
./detect_double.py $file >> $outfile_eng
done


for file in $OUTPUT_FIXED/*heb*
do
echo "Processing $file"
./detect_double.py $file >> $outfile_heb 
done

echo "</doc>" >> $outfile_eng
echo "</doc>" >> $outfile_heb
