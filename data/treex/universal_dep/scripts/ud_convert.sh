#/bin/bash
#ROOT_FOLDER=/net/cluster/TMP/vernerova
ROOT_FOLDER=/a/LRC_TMP/vernerova/lindat-corpora-conversions/data/treex/universal_dep/
TRAIN_FOLDER=$ROOT_FOLDER/input
OUT_FOLDER=$ROOT_FOLDER/output
SCRIPT_FOLDER=$ROOT_FOLDER/scripts

for dir in $TRAIN_FOLDER/*; do
  #$TRAIN_FOLDER/UD_*; do
#  if [ ! -f $dir/*train1.conllu ]; then
#    continue   ## skip corpora with no training data
#  else
    echo $(date) "==========generating VERITCAL from dir: $dir========"
    #treex -L$2 --parallel --jobs 50 --qsub "-hard -l mem_free=3g -l act_mem_free=3g" --mem=8G Read::CoNLLU from="$files" Write::ManateeGeneral format=UD2.2  unique_ids=1 > $OUT_FOLDER/$(basename $1)
    if [ $dir == "$TRAIN_FOLDER/UD_Czech-CAC" ] || [ $dir == "$TRAIN_FOLDER/UD_Czech-PDT" ] || [ $dir == "$TRAIN_FOLDER/UD_Russian-SynTagRus" ]; then
      ## with these very large corpora, the submitted job will likely fail on an out-of-memory error; let's create the vertical for each file separately + it is necessary to somehow divide the train data into smaller files
      for file in $(echo $dir/*.conllu); do
        filename=$(basename $file .conllu)
        languagecode=${filename%%_*}
        echo "processing $file, lang: $languagecode, saving to $(basename $dir)_$(basename $file)"
        qsub -S /bin/bash -cwd -j y -l mem_free=8G,act_mem_free=8G,h_vmem=12G -v PATH  -v PERL5LIB $SCRIPT_FOLDER/run_treex.sh $languagecode "$file" $OUT_FOLDER/$(basename $dir)_$(basename $file)
      done
    else
      filename=$(basename $dir/*train.conllu .conllu)
      languagecode=${filename%%_*}
      files=$(echo $dir/*{train,dev}.conllu)
      if [ $languagecode == "fro" ]; then languagecode="fr"; fi   #Old French
      echo "processing $files, lang: $languagecode, saving to $(basename $dir)"
      qsub -S /bin/bash -cwd -j y -l mem_free=8G,act_mem_free=8G,h_vmem=12G -v PATH  -v PERL5LIB $SCRIPT_FOLDER/run_treex.sh $languagecode "$files" $OUT_FOLDER/$(basename $dir)
    fi
#  fi
done

