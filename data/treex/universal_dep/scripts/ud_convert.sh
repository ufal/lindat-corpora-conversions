#/bin/bash
#ROOT_FOLDER=/export/KONTEXT/kontext-dev/corpora/conversions/data/treex/universal_dep
ROOT_FOLDER=/a/LRC_TMP/vernerova/lindat-corpora-conversions/data/treex/universal_dep/
TRAIN_FOLDER=$ROOT_FOLDER/input
DOCUMENTS_FOLDER=$ROOT_FOLDER/input_divided
OUT_FOLDER=$ROOT_FOLDER/output
SCRIPT_FOLDER=$ROOT_FOLDER/scripts

for dir in $TRAIN_FOLDER/UD_*; do
#  if [ ! -f $dir/*train1.conllu ]; then
#    continue   ## skip corpora with no training data
#  else
    OUT_FOLDER=$DOCUMENTS_FOLDER/$(basename $dir)
    mkdir -p $OUT_FOLDER
    echo $(date) "==========generating VERTICAL from dir: $dir========"
    for file in $dir/*.conllu; do
      if grep "# newdoc" $file > /dev/null; then
        echo "FILE WITH NEWDOC: $file"
        python3 $(dirname "$0")/split_to_docs.py $file "doc";
      else
        size=$(du -k "$file" | cut -f1)
        if [ $size -ge 10000 ] ; then
          echo "BIG FILE: $file"
          python3 $(dirname "$0")/split_to_docs.py $file "sentid";
        else
          echo "COPY FILE: $file"
          cp $file $OUT_FOLDER
        fi
      fi
    done
#  fi
done
for dir in $DOCUMENTS_FOLDER/*; do
  filename=$(basename $file .conllu)
  languagecode=${filename%%_*}
  if [ $languagecode == "fro" ]; then languagecode="fr"; fi   #Old French
  echo "processing $file, lang: $languagecode, saving to $(basename $file)"
  qsub -S /bin/bash -cwd -j y -l mem_free=8G,act_mem_free=8G,h_vmem=12G -v PATH  -v PERL5LIB $SCRIPT_FOLDER/run_treex.sh $languagecode "$file" $OUT_FOLDER/$(basename $file)
done

