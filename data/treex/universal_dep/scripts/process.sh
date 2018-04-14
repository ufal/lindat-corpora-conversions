#!/bin/bash
ud_version_short=22
ud_version_long=2.2
ROOT_FOLDER=/a/LRC_TMP/vernerova/lindat-corpora-conversions/data/treex/universal_dep/
INPUT_FOLDER=$ROOT_FOLDER/input
OUTPUT_FOLDER=$ROOT_FOLDER/output
SCRIPT_FOLDER=$ROOT_FOLDER/scripts
TEMPLATE_FOLDER=$ROOT_FOLDER/templates
vertical_dir=/opt/lindat/kontext-data/corpora/vert/monolingual/UD/$ud_version_long/
registry_dir=/opt/lindat/kontext-data/corpora/registry
data_dir=/opt/lindat/kontext-data/corpora/data/monolingual/UD/$ud_version_long

mkdir -p $vertical_dir
for dir in $INPUT_FOLDER/UD_*; do
  language=${dir#*UD_}
  language=${language%%-*}
  language=${language/_/ }
  corpname=${dirname#*-}
  if [ ! -f $dir/*train.conllu ]; then
    continue   ## skip corpora with no training data
  else
    filename=$(basename $dir/*train.conllu .conllu)
    filename=${filename%%-*}
    languagecode=${filename%%_*}
    cd $SCRIPT_FOLDER
    echo "Creating the template for $filename and linking to it"
    python generate_templates.py "$filename" "$languagecode" "$language" "$corpname"   # writes to ../templates/ud_${ud_version_short}_${filename}_a
    ln -s $TEMPLATE_FOLDER/ud_${ud_version_short}_${filename}_a -t $registry_dir
    echo "Linking to the vertical file"
	ln -s $OUTPUT_FOLDER/$filename -t $vertical_dir
	echo "Compiling the corpus  /opt/projects/lindat-services-kontext/devel/data/corpora/registry/ud_$lang_full""_a"
	mkdir -p $data_dir/$filename
	compilecorp --no-sketches --recompile-corpus /opt/projects/lindat-services-kontext/devel/data/corpora/registry/ud_22_"$filename"_a
  fi
done
