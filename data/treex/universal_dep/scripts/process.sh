#!/bin/bash
ud_version_short=22
ud_version_long=2.2
lindatrepo="http://hdl.handle.net/11234/1-2837"
pmltqlink=""
ROOT_FOLDER=/export/KONTEXT/kontext-dev/corpora/conversions/data/treex/universal_dep
INPUT_FOLDER=$ROOT_FOLDER/input
OUTPUT_FOLDER=$ROOT_FOLDER/output
SCRIPT_FOLDER=$ROOT_FOLDER/scripts
TEMPLATE_FOLDER=$ROOT_FOLDER/templates
log_dir=$ROOT_FOLDER/logs
vertical_dir=/opt/lindat/kontext-data/corpora/vert/monolingual/UD/$ud_version_long
registry_dir=/opt/lindat/kontext-data/corpora/registry
data_dir=/opt/lindat/kontext-data/corpora/data/monolingual/UD/$ud_version_long

mkdir -p $vertical_dir
mkdir -p $log_dir
for dir in $INPUT_FOLDER/UD_*; do
  language=${dir#*UD_}
  language=${language%%-*}
  language=${language/_/ }
#  if [ ! -f $dir/*train.conllu ]; then
#    echo "skip $dir"
#    continue   ## skip corpora with no training data
#  else
    filename=$(basename $dir/*test.conllu .conllu)
    filename=${filename%%-*}
    languagecode=${filename%%_*}
    registryname=ud_${ud_version_short}_${filename}_a
    dir=$(basename $dir)
    corpname=${dir##*-}
    cd $SCRIPT_FOLDER
    echo "Post-processing the output file..."
    ./post_process.sh "$OUTPUT_FOLDER/$dir"
    echo "Creating the template for $filename and linking to it"
    python generate_templates.py "$filename" "$languagecode" "$language" "$corpname" "$dir"  # writes to ../templates/$corpname and a line to to_corplist
    #echo "<corpus ident=\"$filename\" keyboard_lang=\"$languagecode\" sentence_struct=\"s\" features=\"morphology, syntax\" repo=\"$lindatrepo\" pmltq=\"pmltqlink\"/>" >> to_corplist
    ln -is $TEMPLATE_FOLDER/$registryname -t $registry_dir
    if [ $? -ne 0 ]; then echo "linking to template failed"; exit; fi
    echo "Linking to the vertical file $vertical_dir/$dir"
	ln -is $OUTPUT_FOLDER/$dir -t $vertical_dir
    if [ $? -ne 0 ]; then echo "linking to the vertical failed"; exit; fi
	echo "Compiling the corpus  /opt/projects/lindat-services-kontext/devel/data/corpora/registry/$registryname" | tee -a $log_dir/$filename
	mkdir -p $data_dir/$registryname
	compilecorp --no-sketches --recompile-corpus /opt/projects/lindat-services-kontext/devel/data/corpora/registry/$registryname | tee -a $log_dir/$filename
    if [ $? -ne 0 ]; then echo "compilation failed"; exit; fi | tee -a $log_dir/$filename
#  fi
done
