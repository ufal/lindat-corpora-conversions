#!/bin/bash
ud_version_short=23
ud_version_long=2.3
lindatrepo=""
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

function die {
  local message=$1
  [ -z "$message" ] && message="Died"
  echo "${BASH_SOURCE[1]}: line ${BASH_LINENO[0]}: ${FUNCNAME[1]}: $message."  | tee -a $log_dir/$filename >&2
  exit 1
}

mkdir -p $vertical_dir
mkdir -p $log_dir
for dir in $INPUT_FOLDER/*; do
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
    echo -e "\n\nPost-processing the output file ${dir}..." | tee -a $log_dir/$filename
    ./post_process.sh "$OUTPUT_FOLDER/$dir"
    echo "Creating the template for $filename and linking to it"
    echo python generate_templates.py "$filename" "$languagecode" "$language" "$corpname" "$dir" "$TEMPLATE_FOLDER/$registryname" "$ud_version_short" "$ud_version_long" # also writes a line to to_corplist
    python generate_templates.py "$filename" "$languagecode" "$language" "$corpname" "$dir" "$TEMPLATE_FOLDER/$registryname" "$ud_version_short" "$ud_version_long" # also writes a line to to_corplist
    if [ $? -ne 0 ]; then die "generating template $registryname failed"; fi
    ln -is $TEMPLATE_FOLDER/$registryname -t $registry_dir
    if [ $? -ne 0 ]; then die "linking to template failed"; fi 
    echo "Linking to the vertical file $vertical_dir/$dir"
	ln -is $OUTPUT_FOLDER/$dir -t $vertical_dir
    if [ $? -ne 0 ]; then die "linking to the vertical failed"; fi
    grep "^PATH\ \"[^\"]*\"\s*$" "$registry_dir/$registryname" || die "template does not set PATH properly"
	echo "Compiling the corpus  /opt/projects/lindat-services-kontext/devel/data/corpora/registry/$registryname" | tee -a $log_dir/$filename
	mkdir -p $data_dir/$registryname
	compilecorp --no-sketches --recompile-corpus /opt/projects/lindat-services-kontext/devel/data/corpora/registry/$registryname | tee -a $log_dir/$filename
    if [ $? -ne 0 ]; then die "compilation failed"; fi
#  fi
done
