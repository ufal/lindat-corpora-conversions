#/bin/bash
#ROOT_FOLDER=/net/cluster/TMP/vernerova
ROOT_FOLDER=/a/LRC_TMP/vernerova/lindat-corpora-conversions/data/treex/universal_dep/
TRAIN_FOLDER=$ROOT_FOLDER/input
OUT_FOLDER=$ROOT_FOLDER/output
SCRIPT_FOLDER=$ROOT_FOLDER/scripts

for dir in $TRAIN_FOLDER/UD_Old_French*; do
  if [ ! -f $dir/*train.conllu ]; then
    continue   ## skip corpora with no training data
  else
    filename=$(basename $dir/*train.conllu .conllu)
    languagecode=${filename%%_*}
    echo $(date) "==========generating VERITCAL from dir: $dir========" >> log;
    files=$(echo $dir/*{train,dev}.conllu)
    if [ $languagecode == "fro" ]; then languagecode="fr"; fi   #Old French
    echo "processing $files, lang: $languagecode, saving to $(basename $dir)">> log;
    #treex -L$2 --parallel --jobs 50 --qsub "-hard -l mem_free=3g -l act_mem_free=3g" --mem=8G Read::CoNLLU from="$files" Write::ManateeGeneral format=UD2.2  unique_ids=1 > $OUT_FOLDER/$(basename $1)
    qsub -S /bin/bash -cwd -j y -l mem_free=8G,act_mem_free=8G,h_vmem=12G -v PATH  -v PERL5LIB $SCRIPT_FOLDER/run_treex.sh $languagecode "$files" $OUT_FOLDER/$(basename $dir)
  fi
done

