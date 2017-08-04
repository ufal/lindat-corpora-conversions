#!/bin/bash

input_dir=../input/en-ta-parallel-v2
output_dir=../output
langs=(en ta)

for lang in "${langs[@]}"
do
	echo "Processing $input_dir/corpus.bcn.train.$lang"
	outfile='../output/EnTam_'$lang'-w'
	echo "Echo into $outfile"
	echo "<doc>" > $outfile
	cat -n $input_dir/corpus.bcn.train.$lang | sed 's/^ *\([0-9][0-9]*\)\t\(.*\)/<align id="\1">\n\2\n<\/align>/' | sed '/|/s/ /\n/g;s/|/\t/g' |sed -e '/<s>/i <\/s>' -e '/<\/align>/i <\/s>' -e '/<align/a <s>' >> $outfile 
	echo "</doc>" >> $outfile
#sed 's/^ *\([0-9][0-9]*\)\t\(.*\)$$$$/<align id="\1">\n\2\n<\/align>/' | sed '/|/s/ /\n/g;s/|/\t/g' | cut -f1,2,4 | sed -e '/<s>/i <\/s>' -e '/<\/align>/i <\/s>' -e '/<align/a <s>'
done
