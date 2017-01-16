#!/bin/bash
TMP_DIR=../tmp
FILES=$(cd ../input/*; pwd)

for file in $FILES/*/*cs*; do
	
	echo "Pasting Czech $file"
	base=`basename $file | sed 's/-tagged....gz//'`
	slovak_file="$(dirname $file)"/$base-tagged.sk.gz
	echo "...with Slovak $slovak_file"
	zcat $file | sed 's/^\s*$/DELETEBLANKLINE/' > cs
	zcat $slovak_file | sed 's/^\s*$/DELETEBLANKLINE/' > sk
	paste cs sk > $base
	rm cs
	rm sk
	echo "And moving all of them to $TMP_DIR"
	mv $base $TMP_DIR
	continue
done 

for tmpfile in $TMP_DIR/*; do
	echo "We will now remove DELETEBLANKLINE from the $tmpfile"
	sed -i '/DELETEBLANKLINE/d' $tmpfile	
done 
