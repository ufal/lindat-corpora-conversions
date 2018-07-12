#!/bin/bash
DOCUMENTS_FOLDER=$1
languagecode=$2
OUT_FOLDER=$3
LOG_FOLDER=$4

shortname=$(basename $DOCUMENTS_FOLDER)
shortname=${shortname/UD_/}

for file in $DOCUMENTS_FOLDER/*.conllu ; do
  echo -e "processing file $file\n  lang: $languagecode\n  saving to $OUT_FOLDER/$(basename $file)\n"
  while [ $(qstat | wc -l) -gt 5000 ]; do
    echo "Too many submitted jobs; will retry submitting $file in a minute!"
    sleep 60
  done
  echo qsub -h -N tr_$shortname -o $LOG_FOLDER -e $LOG_FOLDER/ -S /bin/bash -cwd -l mem_free=8G,act_mem_free=8G,h_vmem=12G -v PATH  -v PERL5LIB $(dirname "$0")/run_treex.sh $languagecode "$file" $OUT_FOLDER/$(basename $file .conllu) ## the job is added to the queue with a hold, which will be raised by qunhold which is already running 
  qsub -h -N tr_$shortname -o $LOG_FOLDER/ -e $LOG_FOLDER/ -S /bin/bash -cwd -l mem_free=8G,act_mem_free=8G,h_vmem=12G -v PATH  -v PERL5LIB $(dirname "$0")/run_treex.sh $languagecode "$file" $OUT_FOLDER/$(basename $file .conllu)     ## the job is added to the queue with a hold, which will be raised by qunhold which is already running
done
