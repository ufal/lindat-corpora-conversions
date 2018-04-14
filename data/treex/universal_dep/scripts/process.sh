#!/bin/bash
ud_version_short=22
ud_version_long=2.2
lindatrepo=""
pmltqlink=""
ROOT_FOLDER=/export/KONTEXT/kontext-dev/corpora/conversions/data/treex/universal_dep
INPUT_FOLDER=$ROOT_FOLDER/input
OUTPUT_FOLDER=$ROOT_FOLDER/output
SCRIPT_FOLDER=$ROOT_FOLDER/scripts
TEMPLATE_FOLDER=$ROOT_FOLDER/templates
vertical_dir=/opt/lindat/kontext-data/corpora/vert/monolingual/UD/$ud_version_long
registry_dir=/opt/lindat/kontext-data/corpora/registry
data_dir=/opt/lindat/kontext-data/corpora/data/monolingual/UD/$ud_version_long

mkdir -p $vertical_dir
for dir in $INPUT_FOLDER/UD_*; do
  language=${dir#*UD_}
  language=${language%%-*}
  language=${language/_/ }
  if [ ! -f $dir/*train.conllu ]; then
    echo "skip $dir"
    continue   ## skip corpora with no training data
  else
    filename=$(basename $dir/*train.conllu .conllu)
    filename=${filename%%-*}
    languagecode=${filename%%_*}
    registryname=ud_${ud_version_short}_${filename}_a
    dir=$(basename $dir)
    corpname=${dir##*-}
    cd $SCRIPT_FOLDER
    echo "Creating the template for $filename and linking to it"
    python generate_templates.py "$filename" "$languagecode" "$language" "$corpname" "$dir"  # writes to ../templates/$corpname and a line to to_corplist
    #echo "<corpus ident=\"$filename\" sentence_struct=\"s\" features=\"morphology, syntax\" keyboard_lang=\"$languagecode\" repo=\"$lindatrepo\" pmltq=\"$pmltqlink\"/>" >> to_corplist
    ln -s $TEMPLATE_FOLDER/$registryname -t $registry_dir
    if [ $? -ne 0 ]; then echo "linking to template failed"; exit; fi
    echo "Linking to the vertical file $vertical_dir/$dir"
	ln -s $OUTPUT_FOLDER/$dir -t $vertical_dir
    if [ $? -ne 0 ]; then echo "linking to the vertical failed"; exit; fi
	echo "Compiling the corpus  /opt/projects/lindat-services-kontext/devel/data/corpora/registry/$registryname"
	mkdir -p $data_dir/$registryname
	compilecorp --no-sketches --recompile-corpus /opt/projects/lindat-services-kontext/devel/data/corpora/registry/$registryname
    if [ $? -ne 0 ]; then echo "compilation failed"; exit; fi
  fi
done
