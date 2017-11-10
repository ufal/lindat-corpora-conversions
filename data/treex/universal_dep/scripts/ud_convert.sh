#/bin/bash
#ROOT_FOLDER=/net/cluster/TMP/kljueva/kontext/ud
#TRAIN_FILES=$ROOT_FOLDER/input/*/UD_*/*ud-train.conllu
ROOT_FOLDER=/net/cluster/TMP/vernerova
TRAIN_FILES=$ROOT_FOLDER/
TRAIN_FOLDER=$ROOT_FOLDER/input/
TREEX_FOLDER=$ROOT_FOLDER/treex/
#TREEX_FOLDER=/net/cluster/TMP/kljueva/kontext/ud/input.sample/
JSON_FOLDER=$ROOT_FOLDER/input/json/
OUT_FOLDER=$ROOT_FOLDER/output/
TRAIN_FILES_UD2=$ROOT_FOLDER/input/*/UD_*/*ud-train.conllu



#as Write::ViewJSON process properly only .treex.gz files, I have to generate from conllu to treex.gz first
function generate_treex {
        echo "===============generating TREEX from file: $1============";
	echo "language: $2";
	foldername="ud_"$4"_a"
	#cd $TREEX_FOLDER;
        treex -L$2 -p --jobs=50 --mem=8G Read::CoNLLU from=$1 Write::Treex to=.  
       # mkdir -v $foldername;
      #	mv -v *.treex.gz $foldername;
}

function generate_vertical {
        echo "==========generating VERITCAL from file: $1========";
        echo "language: $2";
	cd $OUT_FOLDER;
       # treex -L$2 -p --jobs=50 --mem=8G Read::CoNLLU from=$1 Write::ManateeU to=.
         treex -L$2 --mem=8G Read::CoNLLU from=$1 Write::ManateeU to=.
        
}


function generate_json {
        echo "==========Generate JSON: "$1;
        foldername=$(sed 's/.treex.gz//g' <<<$2);        
        cd $TRAIN_FOLDER;

	treex_file=$(sed 's/conllu/treex.gz/g' <<<$1)
	echo "FOLDERNAME: $foldername, treex_file: $treex_file"	
        treex Read::Treex from=$treex_file -L$3 --mem=8G bundles_per_doc=1 Write::ViewJSON to=.
}

for file in $TRAIN_FOLDER/*conllu
do
        filename=$(basename "$file")
	folder_json=$(sed 's/-train.conllu/_ud_a/g' <<<$filename) #czech!!!
        lang=$(echo $filename | cut -f1 -d-)
	lang_truncated=$(echo "$lang" | sed 's/_.*//g');
        echo "processing $file, lang: $lang_truncated";
        generate_vertical $file $lang_truncated $lang; 
        generate_treex $file $lang_truncated $filename $lang;	 
        generate_json $file $filename $lang_truncated;
	cd $TRAIN_FOLDER && mkdir $folder_json && mv *.json $folder_json	

done

