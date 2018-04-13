#/bin/bash
#ROOT_FOLDER=/net/cluster/TMP/vernerova
ROOT_FOLDER=~/Lindat-corpora-conversions/data/treex/universal_dep
TRAIN_FOLDER=$ROOT_FOLDER/input
OUT_FOLDER=$ROOT_FOLDER/output


function generate_vertical {
    echo "==========generating VERITCAL from dir: $1========" > log;
    echo "language: $2" > log;
	cd $OUT_FOLDER;
    files=$(echo $1/*{train,dev}.conllu)
    echo "processing $files, lang: $lang_truncated, saving to $(basename $1)" > log;
    treex -L$2 --parallel --mem=8G Read::CoNLLU from="$files" Write::ManateeGeneral format=UD2.2  to=$(basename $1) unique_ids=1
    #treex -L$2 Read::CoNLLU from="$files" Write::ManateeGeneral format=UD2.2 to=$(basename $1) unique_ids=1
}


for dir in $TRAIN_FOLDER/UD_*; do
  cd $ROOT_FOLDER/scripts
  dirname=${dir#*UD_}
  language=${dirname%%-*}
  language=${language/_/ }
  corpname=${dirname#*-}
  if [ ! -f $dir/*train.conllu ]; then
    continue   ## skip corpora with no training data
  else
    filename=$(basename $dir/*train.conllu .conllu)
    filename=${filename%%-*}
    languagecode=${filename%%_*}
    echo "$languagecode $language > log"
    #python generate_templates.py "$filename" "$languagecode" "$language" "$corpname"
    lang=$(echo $filename | cut -f1 -d-)
    lang_truncated=$(echo "$lang" | sed 's/_.*//g');
    generate_vertical $dir $lang_truncated $lang; 
  fi
done

