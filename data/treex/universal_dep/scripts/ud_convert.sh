#/bin/bash
#ROOT_FOLDER=/export/KONTEXT/kontext-dev/corpora/conversions/data/treex/universal_dep
ROOT_FOLDER=/a/LRC_TMP/vernerova/lindat-corpora-conversions/data/treex/universal_dep/
TRAIN_FOLDER=$ROOT_FOLDER/input
SCRIPT_FOLDER=$ROOT_FOLDER/scripts


export QUNHOLD_FOREVER=1
ps | grep qunhold
if [ $? -ne 0 ]; then
  $ROOT_FOLDER/../../../scripts/qunhold > log_qunhold  &
fi

for dir in $TRAIN_FOLDER/*; do
#  if [ ! -f $dir/*train*.conllu ]; then
#    continue   ## skip corpora with no training data
#  else
    dirname=$(basename $dir)
    shortname=${dirname/UD_/}
    DOCUMENTS_FOLDER=$ROOT_FOLDER/input_divided/$dirname
    OUT_FOLDER=$ROOT_FOLDER/output/$dirname
    LOG_FOLDER=$ROOT_FOLDER/log/$shortname
    mkdir -p $DOCUMENTS_FOLDER; mkdir -p $LOG_FOLDER; mkdir -p $OUT_FOLDER
    if grep -m1 "# newdoc" $dir/*.conllu > /dev/null; then
      echo -n "FILE(S) WITH NEWDOC:" | tee -a log_ud_convert.sh
      grep -l "# newdoc" $dir/*.conllu | tee -a log_ud_convert.sh
      for file in $dir/*.conllu; do
        qsub -N sp_$shortname -cwd -o $LOG_FOLDER/ -e $LOG_FOLDER/ $SCRIPT_FOLDER/split_to_docs.py $file "doc";
      done
    else
      size=$(du -k -c $dir/*.conllu | grep total | cut -f1)
      if [ $size -ge 20000 ] ; then
        echo "BIG DIR $dir" | tee -a log_ud_convert.sh
        for file in $dir/*.conllu; do
          qsub -N sp_$shortname -cwd -o $LOG_FOLDER/ -e $LOG_FOLDER/ $SCRIPT_FOLDER/split_to_docs.py $file "sentid";
        done
      else
        echo "COPY FILES FROM $dir" | tee -a log_ud_convert.sh
        ### does it matter that for this dir there never will be job called split_$dirname???
        for file in $dir/*.conllu; do
          cp $file $DOCUMENTS_FOLDER
        done
      fi
    fi
    testfilename=$(basename $(ls $dir/*test*.conllu | head -1) .conllu)
    languagecode=${testfilename%%_*}
    if [ $languagecode = "fro" ]; then languagecode="fr"; fi   #Old French
    qsub -N sub_$shortname -hold_jid sp_$shortname -o $LOG_FOLDER/ -e $LOG_FOLDER/ -cwd -v PATH -v PERL5LIB $SCRIPT_FOLDER/submit.sh $DOCUMENTS_FOLDER $languagecode $OUT_FOLDER $LOG_FOLDER
#  fi
done

echo "Do not forget to kill qunhold when all jobs are finished!" | tee -a log_ud_convert.sh
