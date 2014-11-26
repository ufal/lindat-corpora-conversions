ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/../
lang_a = hi
column_a = 3
langs = $(lang_a)
top_layer = m
name = HindMonoCorp_0.5
source_urls = https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0023-6260-A/hindmonocorp05.export.gz
tmp_dir = $(ROOT_DIR)/tmp
filelist_path = $(tmp_dir)/filelist.txt
from = @$(filelist_path)
input_dir = $(ROOT_DIR)/input
splitted_input_dir = $(tmp_dir)/splitted
input_file = hindmonocorp05.export
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

