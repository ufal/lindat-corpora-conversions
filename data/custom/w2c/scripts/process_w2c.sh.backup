#!/bin/bash
template_dir=../templates
links_filename=sample_list
vertical_dir=/opt/projects/lindat-services-kontext/devel/data/corpora/vert/monolingual/W2C
registry_dir=/opt/projects/lindat-services-kontext/devel/data/corpora/registry
input_dir=../input
output_dir=../output

make_template() {
	local filename="$1"
	local lang="$2"
	template_name="w2c_$lang""_w"
	echo "Creating $template_dir/$template_name"
	./oo_gen_templates.py $lang
	echo "Copying  $template_dir/$template_name to $registry_dir"
	#cp -u $template_dir/* $registry_dir
}

make_vertical() {
	local filename="$1"
	local lang="$2"
	echo "<doc>" > $output_dir/W2C_$lang-w
	zcat $input_dir/$filename | perl -pne 's/([\,\?\!\"\)\(])/ $1 /g' | perl -pne 's/[^\d]([\:\.])[^\d]/ $1 /g' | sed -e 's/^/<s> /g' -e 's/$/ <\/s>/g' -e 's/ /\n/g' | sed '/^$/d' >> $output_dir/W2C_$lang-w #some naive tokenization. Too many languages to make one for each 
	echo >> $output_dir/W2C_$lang-w
	echo "</doc>" >> $output_dir/W2C_$lang-w
	cp -u $output_dir/W2C_$lang-w $vertical_dir	
}

while read line
do
	filename=`echo -n $line | sed s/'\?.*$'//g | rev | cut -d/ -f1 | rev `
	lang=`echo -n $filename | cut -d"." -f1`
	echo "Downloading https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0022-6133-9/$filename language $lang"	
	cd $input_dir && wget https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0022-6133-9/$filename
	echo "Making template from $filename, $lang"
	make_template $filename $lang
	echo "Making vertical from $filename, $lang"
	#make_vertical $filename $lang
	echo "Performing mkdir -p /opt/lindat/kontext-data/corpora/data/monolingual/W2C/W2C_$lang-w"
	#mkdir -p /opt/lindat/kontext-data/corpora/data/monolingual/W2C/W2C_$lang-w
	echo "Compiling the corpus  /opt/projects/lindat-services-kontext/devel/data/corpora/registry/w2c_$lang""_w"
	#compilecorp --no-sketches --recompile-corpus /opt/projects/lindat-services-kontext/devel/data/corpora/registry/w2c_$lang""_w
done < ${links_filename} ;
