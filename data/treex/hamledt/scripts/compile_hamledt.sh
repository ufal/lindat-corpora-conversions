#!/bin/bash
template_dir=../templates
links_filename=sample_list
vertical_dir=/opt/projects/lindat-services-kontext/devel/data/corpora/vert/monolingual/HamleDT/3.0
registry_dir=/opt/projects/lindat-services-kontext/devel/data/corpora/registry
data_dir=/opt/lindat/kontext-data/corpora/data/monolingual/HamleDT/3.0
input_dir=../input
output_dir=../output

echo "Performing cp ../templates/* to $registry_dir"
cp -u ../templates/* $registry_dir

for vertical_file in $output_dir/*
do
	filename=$(basename "$vertical_file")
	lang=`echo -n $filename | cut -d"-" -f1 | cut -d"_" -f2`
	echo "LANGUAGE: $lang"	
        python generate_templates.py $lang; #change fa and ar righttoleft
	echo "Performing cp -u $vertical_file $vertical_dir"
	mkdir -p $vertical_dir
	cp -u $vertical_file $vertical_dir
	echo "Performing mkdir -p $data_dir/hamledt_$lang-a"
	mkdir -p $data_dir/hamledt_$lang-a
	echo "Compiling the corpus  /opt/projects/lindat-services-kontext/devel/data/corpora/registry/hamledt_30_$lang""_a"
	compilecorp --no-sketches --recompile-corpus /opt/projects/lindat-services-kontext/devel/data/corpora/registry/hamledt_30_$lang""_a
done;
