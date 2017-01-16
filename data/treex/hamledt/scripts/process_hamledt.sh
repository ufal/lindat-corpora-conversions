#/bin/bash
ROOT_FOLDER=/net/cluster/TMP/kljueva/kontext/hamledt
#TRAIN_FILES=$ROOT_FOLDER/input.sample/
TRAIN_FILES=$ROOT_FOLDER/input/hamledt/
JSON_FOLDER=$ROOT_FOLDER/tree-view/
OUT_FOLDER=$ROOT_FOLDER/output/
LANGS="ar bn ca cs de en es et fa grc hi ja la nl pl pt ro ru sk sl ta te tr"

for lang in $LANGS
do
        lang_truncated=$(echo "$lang" | sed 's/-.*//g');
        folderjson="hamledt_"$lang"_a";
        JSON_PATH=$JSON_FOLDER/$folderjson;
        mkdir -p $JSON_PATH;
        ALL_VERT=$OUT_FOLDER"/hamledt_"$lang"-a";
        touch $ALL_VERT;
        TRAIN_PATH=$TRAIN_FILES"$lang/treex/train";
        echo "LANG TRUNCATED: $lang_truncated";
        #parallelisation is not compatible with the option "bundles_per_doc", the jsons will be splitted by Vincents' script
	treex -L$lang_truncated Read::Treex from="!$TRAIN_PATH/*" Write::ViewJSON pretty=1 to=. substitute={$TRAIN_PATH}{$JSON_PATH};		
        treex -L$lang_truncated --selector=prague Read::Treex from="!$TRAIN_PATH/*" layer=a  Write::ManateeU hamledt=1 >>$ALL_VERT;
	for file in $JSON_PATH/*
	do
		echo "I will now split $file";
		( cd $JSON_PATH && python $ROOT_FOLDER/scripts/split_json.py $file); 
		rm $file;
	done
done
