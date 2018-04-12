#/bin/bash
#ROOT_FOLDER=/net/cluster/TMP/vernerova
ROOT_FOLDER=..
TRAIN_FOLDER=$ROOT_FOLDER/input
OUT_FOLDER=$ROOT_FOLDER/output


function generate_vertical {
    echo "==========generating VERITCAL from file: $1========";
    echo "language: $2";
	cd $OUT_FOLDER;
    #treex -L$2 --parallel --mem=8G Read::CoNLLU from=$1 Write::ManateeGeneral format=UD2.2 to=.
    treex -L$2 Read::CoNLLU from=$1 Write::ManateeGeneral format=UD2.2 to=.
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
    echo "$languagecode $language"
    python generate_templates.py "$filename" "$languagecode" "$language" "$corpname"
    for file in $dir/*{train,dev}.conllu; do
      filename=$(basename "$file")
      lang=$(echo $filename | cut -f1 -d-)
      lang_truncated=$(echo "$lang" | sed 's/_.*//g');
      echo "processing $file, lang: $lang_truncated";
      generate_vertical $file $lang_truncated $lang; 
    done
  fi
done

