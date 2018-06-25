#!/bin/bash
lindatrepo=""
pmltqlink=""
ROOT_FOLDER=/export/KONTEXT/kontext-dev/corpora/conversions/data/conll_like/summa
OUTPUT_FOLDER=$ROOT_FOLDER/output
SCRIPT_FOLDER=$ROOT_FOLDER/scripts
TEMPLATE_FOLDER=$ROOT_FOLDER/templates
REGISTRY_FOLDER=/opt/projects/lindat-services-kontext/devel/data/corpora/registry
vertical_dir=/opt/lindat/kontext-data/corpora/vert/parallel/Summa
registry_dir=/opt/lindat/kontext-data/corpora/registry
data_dir=/opt/lindat/kontext-data/corpora/data/parallel/Summa

mkdir -p $vertical_dir
for lang in en la cs; do
  filename=source_${lang}.txt
  registryname=summa_${lang}_a
  cd $SCRIPT_FOLDER
  echo "Linking to the template $registryname"
  ln -is $TEMPLATE_FOLDER/$registryname -t $registry_dir
  if [ $? -ne 0 ]; then echo "linking to template failed"; exit; fi
  echo "Linking to the vertical file $vertical_dir/$lang"
  ln -is $OUTPUT_FOLDER/Summa_$lang-a -t $vertical_dir
  if [ $? -ne 0 ]; then echo "linking to the vertical failed"; exit; fi
  echo "Compiling the corpus $REGISTRY_FOLDER/$registryname"
  mkdir -p $data_dir/$registryname
  MATATEE_REGISTRY=$REGISTRY_FOLDER compilecorp --no-sketches --recompile-corpus $REGISTRY_FOLDER/$registryname
  if [ $? -ne 0 ]; then echo "compilation failed"; exit; fi
done
