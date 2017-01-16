#!/bin/bash
mkdir -p ../output/speech
TEMPLATES=../templates
SPEECH_LINDAT=/opt/projects/lindat-services-kontext/devel/data/corpora/speech
REGISTRY=/opt/projects/lindat-services-kontext/devel/data/corpora/registry
VERT=/opt/projects/lindat-services-kontext/devel/data/corpora/vert/speech
OUTSPEECH=../output/speech
INPUT_DIR=../input
INPUTSPEECH=$INPUT_DIR/speech
ANOT=../input/annot.snt
VERTOUT=../output/Sbaccentair_en-w
#rm Sbaccentair_en-w

#for file_wav in $INPUT_DIR/speech/*.wav; do
#	basename=$(basename $file_wav .wav)
#	echo "processing $file_wav ...lame it into  $OUTSPEECH/$basename"".mp3"
#	lame $file_wav $OUTSPEECH/$basename"".mp3
#done


function vert {
	echo "<doc>" > $VERTOUT
	cat $ANOT | perl -pne 's/^(.*?) /<segsoundfile="$1.mp3"> /g' | sed 's/$/<\/seg>/g'| sed 's/ /\n/g'| sed 's/segsound/seg sound/g' | sed '/^\s*$/d' >> $VERTOUT
	echo "</doc>" >> $VERTOUT
}

#vert

echo "Copying  $TEMPLATES/* to $REGISTRY"
#cp $TEMPLATES/* $REGISTRY
echo "MKDIR $SPEECH_LINDAT/sbaccentair_en_w"
#mkdir $SPEECH_LINDAT/sbaccentair_en_w
echo "Moving $OUTSPEECH/* to $SPEECH_LINDAT/sbaccentair_en_w"
#mv $OUTSPEECH/* $SPEECH_LINDAT/sbaccentair_en_w
echo "mkdir -p $VERT/Sbaccentair"
#mkdir -p $VERT/Sbaccentair
echo "copying vert $VERTOUT to $VERT/Sbaccentair"
#cp $VERTOUT $VERT/Sbaccentair

compilecorp --no-sketches --recompile-corpus $REGISTRY/sbaccentair_en_w
