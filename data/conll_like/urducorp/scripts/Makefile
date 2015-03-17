ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/../
lang_a = ur
column_a = 1
langs = $(lang_a)
top_layer = m
name = UrduCorp
source_urls = http://hdl.handle.net/11858/00-097C-0000-0023-65A9-5 
vertical_subdir = $(vertical_dir)/monolingual/UrduCorp

include $(ROOT_DIR)/../../../scripts/common.mk

input_dir = $(ROOT_DIR)/input

clean:
	rm -f $(output_paths)
	rm -rf $(tmp_dir)

define make_output
$(call output_path,$(1)):
	@echo "Creating file $$@"
	@for file in $(input_dir)/*; do \
		echo -n "Processing file $$$$file ..."; \
		echo "<doc id=\"Urdu Corpus\">" >>$$@; \
		cut $$$$file -f$(2) | cat -n | sed 's/^ *\([0-9][0-9]*\)\t\(.*\)$$$$/<s id="\1">\n\2\n<\/s>/' | sed '/|/s/ /\n/g;s/|/\t/g' >>$$@; \
		echo "</doc>" >>$$@; \
		echo " DONE"; \
	done
endef

$(eval $(call make_output,$(lang_a),$(column_a)))

