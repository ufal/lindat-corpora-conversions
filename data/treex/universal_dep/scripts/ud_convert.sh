#/bin/bash
#ROOT_FOLDER=/net/cluster/TMP/vernerova
ROOT_FOLDER=/a/LRC_TMP/vernerova/lindat-corpora-conversions/data/treex/universal_dep/
TRAIN_FOLDER=$ROOT_FOLDER/input
OUT_FOLDER=$ROOT_FOLDER/output
SCRIPT_FOLDER=$ROOT_FOLDER/scripts
LOG_FOLDER=$ROOT_FOLDER/log
mkdir -p $LOG_FOLDER; mkdir -p $OUT_FOLDER

###export PATH; export PERL5LIB  # needed when I try to run treex directly without resorting to run_treex.sh - but then it does not appear in qsub which I find worrying

for dir in $TRAIN_FOLDER/UD_Spanish-AnCora; do
    dirname=$(basename $dir)
    shortname=${dirname/UD_/}
#  if [ ! -f $dir/*train1.conllu ]; then
#    continue   ## skip corpora with no training data
#  else
    echo -e "\n==========generating VERITCAL from dir: $dir========" $(date)
    if [ $dir == "$TRAIN_FOLDER/UD_Czech-CAC" ] || [ $dir == "$TRAIN_FOLDER/UD_Czech-PDT" ] || [ $dir == "$TRAIN_FOLDER/UD_Russian-SynTagRus" ] || [ $dir == "$TRAIN_FOLDER/UD_Arabic-NYUAD" ] || [ $dir == "$TRAIN_FOLDER/UD_Japanese-BCCWJ" ] || [ $dir == "$TRAIN_FOLDER/UD_Spanish-AnCora" ] ; then
      ## with these very large corpora, the submitted job will likely fail on an out-of-memory error; let's create the vertical for each file separately + it is necessary to somehow divide the train data into smaller files
      for file in $dir/*.conllu; do
        filename=$(basename $file .conllu)
        languagecode=${filename%%_*}
        echo "processing $file, lang: $languagecode, saving to ${dirname}_${filename}"
        qsub -N $shortname -o $LOG_FOLDER/ -S /bin/bash -cwd -j y -l mem_free=30G,act_mem_free=30G,h_vmem=32G -v PATH  -v PERL5LIB $SCRIPT_FOLDER/run_treex.sh $languagecode $OUT_FOLDER/${dirname}_${filename} $file
      done
    else
      filename=$(basename $dir/*test.conllu .conllu)
      languagecode=${filename%%_*}
      files=$(echo $dir/*.conllu)
      #if [ $languagecode == "fro" ]; then languagecode="fr"; fi   #Old French
      echo "processing $files, lang: $languagecode, saving to $(basename $dir)"
      qsub -N $shortname -cwd -o $LOG_FOLDER/ -S /bin/bash -j y -l mem_free=8G,act_mem_free=8G,h_vmem=12G -v PATH  -v PERL5LIB $SCRIPT_FOLDER/run_treex.sh $languagecode $OUT_FOLDER/${dirname} $files
      #treex  --parallel --jobs 50 --qsub "-N $shortname -o $LOG_FOLDER/ -cwd -j y -l mem_free=8G,act_mem_free=8G,h_vmem=12G -v PATH -v PERL5LIB" --mem=20G -L$languagecode Read::CoNLLU from="$files" Write::ManateeGeneral format=UD2.2  to=$OUT_FOLDER/${dirname} unique_ids=1 2>$LOG_FOLDER/$shortname.treex.stderr
    fi
#  fi
done

### when all jobs finish, do not forget tconcatenate the output files for the 6 corpora that were converted by file
### then also run reordering of parts of data so that train comes before test and dev:
### for file in output/*; do sed -i -n -e sed -n -e '/<doc id=".*train.*">/,/<\/doc>/p;/<doc id=".*train.*"/,$!H;${x;p};' $file; sed -i -e '/^$/d' $file; done
