#/bin/bash
INPUT_PATH_ENG=/net/cluster/TMP/kljueva/kontext/ud/udpipe_hebrew/input/corpus/eng
INPUT_PATH_HEB=/net/cluster/TMP/kljueva/kontext/ud/udpipe_hebrew/input/corpus/heb
OUTPUT_PATH=/net/cluster/TMP/kljueva/kontext/ud/udpipe_hebrew/output_fixed
ALIGN=/net/cluster/TMP/kljueva/kontext/ud/udpipe_hebrew/align

for file in $INPUT_PATH_ENG/Haaretz_*
do
	echo "Processing $file"
	with_sentence_breaks=$file"_sentence"
	echo "$with_sentence_breaks"
	touch $with_sentence_breaks
	cat $file | perl -pne 's/\n/\n\nDELETEIT_NEWLINE\n\n/g' >> $with_sentence_breaks
done


for file in $INPUT_PATH_HEB/Haaretz_*
do
        echo "Processing $file"
        with_sentence_breaks=$file"_sentence"
        echo "$with_sentence_breaks"
        touch $with_sentence_breaks
	cat $file | perl -pne 's/\n/\n\nDELETEIT_NEWLINE\n\n/g' >> $with_sentence_breaks
done

echo "Parsing English:"
/net/projects/udpipe/bin/udpipe-latest /net/projects/udpipe/models/udpipe-ud-1.2-160523/english-ud-1.2-160523.udpipe --tokenize --tag --parse --outfile=$OUTPUT_PATH/{}.conllu $INPUT_PATH_ENG/*sentence

echo "Parsing Hebrew:"
/net/projects/udpipe/bin/udpipe-latest /net/projects/udpipe/models/udpipe-ud-1.2-160523/hebrew-ud-1.2-160523.udpipe --tokenize --tag --parse --outfile=$OUTPUT_PATH/{}.conllu $INPUT_PATH_HEB/*sentence 

