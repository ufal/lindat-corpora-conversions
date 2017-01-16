#!/bin/bash
TEMPLATES=../templates
SPEECH=../output/speech
INPUT=../input/speech
SPEECH_LINDAT=/opt/projects/lindat-services-kontext/devel/data/corpora/speech
REGISTRY=/opt/projects/lindat-services-kontext/devel/data/corpora/registry

for file in $INPUT/*
do
	basename=$(basename $file .wav)
	echo "Performing lame $file $SPEECH/$basename"".mp3"
	lame $file $SPEECH/$basename"".mp3
done

echo "Copying  $TEMPLATES/* to $REGISTRY"
cp $TEMPLATES/* $REGISTRY
echo "MKDIR $SPEECH_LINDAT/companions_cs_w"
mkdir $SPEECH_LINDAT/companions_cs_w
echo "Moving $SPEECH/* to $SPEECH_LINDAT/companions_cs_w"
mv $SPEECH/* $SPEECH_LINDAT/companions_cs_w
