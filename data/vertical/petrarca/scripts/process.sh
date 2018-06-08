#!/bin/bash
name=petrarca
language_code=it
top_layer=m
registryname=${name}_${language_code}_${top_layer}
lindatrepo="https://bitbucket.org/ritia/corpus/raw/master/vertical_kontext_imprtag_finvers.txt"
outname=${name}.txt
ROOT_FOLDER=/export/KONTEXT/kontext-dev/corpora/conversions/data/vertical/$name
INPUT_FOLDER=$ROOT_FOLDER/input
OUTPUT_FOLDER=$ROOT_FOLDER/output
SCRIPT_FOLDER=$ROOT_FOLDER/scripts
TEMPLATE_FOLDER=$ROOT_FOLDER/templates
vertical_dir=/opt/lindat/kontext-data/corpora/vert/monolingual/$name
registry_dir=/opt/lindat/kontext-data/corpora/registry
data_dir=/opt/lindat/kontext-data/corpora/data/monolingual/$name

mkdir -p $INPUT_FOLDER $OUTPUT_FOLDER
echo "Downloading the vertical file from bitbucket to $INPUT_FOLDER"
wget $lindatrepo --user Ansa211 --ask-password -O $INPUT_FOLDER/$outname
echo "Copy $INPUT_FOLDER/$outname to $OUTPUT_FOLDER/$outname"
cp $INPUT_FOLDER/$outname $OUTPUT_FOLDER/$outname

echo "Linking to the vertical file $vertical_dir/$outname"
mkdir -p $vertical_dir
ln -is $OUTPUT_FOLDER/$outname -t $vertical_dir
if [ $? -ne 0 ]; then echo "linking to the vertical failed"; exit; fi

echo "Linking to the template file $TEMPLATE_FOLDER/$registryname"
ln -is $TEMPLATE_FOLDER/$registryname -t $registry_dir
if [ $? -ne 0 ]; then echo "linking to template failed"; exit; fi

echo "Compiling the corpus  /opt/projects/lindat-services-kontext/devel/data/corpora/registry/$registryname"
mkdir -p $data_dir/$registryname
compilecorp --no-sketches --recompile-corpus /opt/projects/lindat-services-kontext/devel/data/corpora/registry/$registryname
if [ $? -ne 0 ]; then echo "compilation failed"; exit; fi
