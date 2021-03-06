#!/bin/bash
template_dir=../templates
links_filename=sample_list
vertical_dir=/opt/projects/lindat-services-kontext/devel/data/corpora/vert/monolingual/UD/1.3/
registry_dir=/opt/projects/lindat-services-kontext/devel/data/corpora/registry
data_dir=/opt/lindat/kontext-data/corpora/data/monolingual/UD/1.3
input_dir=../input
output_dir=../output

echo "Performing cp ../templates/* to $registry_dir"
#cp -u ../templates/* $registry_dir

for vertical_file in $output_dir/ud_cs-a
do
	filename=$(basename "$vertical_file")
	lang=`echo -n $filename | cut -d"-" -f1 | cut -d"_" -f2`
        lang_full=`echo -n $filename | perl -pne 's/ud_//' | perl -pne 's/-a//'`
	echo "Performing cp -u ../templates/* to $registry_dir"
        echo "LANGUAGE: $lang" 
	echo "FULL: $lang_full"
	python generate_templates.py $lang_full;
        cp -u ../templates/ud_13_$lang_full""_a $registry_dir
        echo "Performing cp -u $vertical_file $vertical_dir"
	mkdir -p $vertical_dir
	cp -u $vertical_file $vertical_dir
	echo "Performing mkdir -p $data_dir/$vertical_file"
	mkdir -p $data_dir/$vertical_file
	#mkdir -p $vertical_dir
	echo "Compiling the corpus  /opt/projects/lindat-services-kontext/devel/data/corpora/registry/ud_$lang_full""_a"
	compilecorp --no-sketches --recompile-corpus /opt/projects/lindat-services-kontext/devel/data/corpora/registry/ud_13_$lang_full""_a
done;
