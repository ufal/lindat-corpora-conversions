ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/../
lang_a = en
column_a = 4
lang_b = hi
column_b = 5
langs = $(lang_a) $(lang_b)
top_layer = m
name = HindEnCorp_0.5
source_urls = https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0023-625F-0/hindencorp05.export.gz
tmp_dir = $(ROOT_DIR)/tmp
filelist_path = $(tmp_dir)/filelist.txt
from = @$(filelist_path)
input_dir = $(ROOT_DIR)/input
splitted_input_dir = $(tmp_dir)/splitted
input_file = hindencorp05.export
input_path = $(input_dir)/$(input_file)
output_dir = $(ROOT_DIR)/output
output_path = $(output_dir)/$(name)_$(1)-$(top_layer)
output_paths = $(foreach lang,$(langs),$(call output_path,$(lang)))

.PHONY: clean

all: clean $(output_paths)

split: $(input_path)
	mkdir -p $(splitted_input_dir)
	awk '{print >> "$(splitted_input_dir)/"$$1}' $<

clean:
	rm -f $(output_paths)
	rm -f $(filelist_path)
	rm -rf $(splitted_input_dir)

define make_output
$(call output_path,$(1)): split
	for file in $(splitted_input_dir)/*; do \
		echo -n "Processing file $$$$file ..."; \
		id=`basename $$$$file`; \
		echo "<doc id=\"$$$$id\">" >>$$@; \
		cut $$$$file -f$(2) | cat -n | sed 's/^ *\([0-9][0-9]*\)\t\(.*\)$$$$/<align id="\1">\n\2\n<\/align>/' | sed '/|/s/ /\n/g;s/|/\t/g' | sed -e '/<s>/i <\/s>' -e '/<\/align>/i <\/s>' -e '/<align/a <s>' >>$$@; \
		echo "</doc>" >>$$@; \
		echo " DONE"; \
	done
endef

$(eval $(call make_output,$(lang_a),$(column_a)))

$(eval $(call make_output,$(lang_b),$(column_b)))
