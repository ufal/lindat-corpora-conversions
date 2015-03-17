#!/bin/bash
TEMPLATES=../templates
TMP=../tmp
SPEECH=../output/speech
INPUT=../input
SPEECH_LINDAT=/opt/projects/lindat-services-kontext/devel/data/corpora/speech
REGISTRY=/opt/projects/lindat-services-kontext/devel/data/corpora/registry


for file in $INPUT/*
do
	if [[ $file == *.wav ]]; then
		basename=$(basename $file .wav)
		echo "Performing lame $file $SPEECH/$basename"".mp3"
		#lame $file $SPEECH/$basename"".mp3
		echo "Performing iconv -f cp1250 -t UTF-8 $INPUT/$basename.trs > $INPUT/$basename""_utf8.trs"
		utf8="_utf8.trs"
		#iconv -f cp1250 -t UTF-8 $INPUT/$basename.trs > $INPUT/$basename
		echo "Performing write $INPUT/$basename$utf8 to $TMP/filelist.txt"
		
	fi	
done


#echo "Copying  $TEMPLATES/* to $REGISTRY"
#cp $TEMPLATES/* $REGISTRY
#echo "MKDIR $SPEECH_LINDAT/ovm_cs_w"
#mkdir $SPEECH_LINDAT/ovm_cs_w
#echo "Moving $SPEECH/* to $SPEECH_LINDAT/ovm_cs_w"
#mv $SPEECH/* $SPEECH_LINDAT/ovm_cs_w
