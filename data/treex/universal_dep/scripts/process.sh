#!/bin/bash
template_dir=../templates
links_filename=sample_list
vertical_dir=/opt/projects/lindat-services-kontext/devel/data/corpora/vert/monolingual/UD/1.1/
registry_dir=/opt/projects/lindat-services-kontext/devel/data/corpora/registry
data_dir=/opt/lindat/kontext-data/corpora/data/monolingual/UD/1.1
input_dir=../input
output_dir=../output/es*

echo "Performing cp ../templates/* to $registry_dir"
#cp -u ../templates/* $registry_dir

for vertical_file in $output_dir
do
	filename=$(basename "$vertical_file")
	lang=`echo -n $filename | cut -d"-" -f1`	
#	echo "Performing cp -u ../templates/* to $registry_dir"
	cp -u  $ver $registry_dir
	echo "Performing cp -u $vertical_file $vertical_dir"
	cp -u $vertical_file $vertical_dir
	echo "Performing mkdir -p $data_dir/ud_$lang-a"
#	mkdir -p $data_dir/ud_$lang-a
	echo "Compiling the corpus  /opt/projects/lindat-services-kontext/devel/data/corpora/registry/ud_$lang""_a"
	compilecorp --no-sketches --recompile-corpus /opt/projects/lindat-services-kontext/devel/data/corpora/registry/ud_$lang""_a
done;
