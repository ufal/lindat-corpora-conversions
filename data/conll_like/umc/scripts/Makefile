ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/../
lang_a = cs
column_a = 1
lang_b = ru
column_b = 2
langs = $(lang_a) $(lang_b)
top_layer = m
name = UMC_0.1
source_urls = https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0001-4909-7/Czech-Russian-tagged.gz
vertical_subdir = $(vertical_dir)/parallel/UMC/0.1

include $(ROOT_DIR)/../../../scripts/common.mk

input_dir =  $(ROOT_DIR)/input

clean:
	rm -f $(output_paths)
	rm -rf $(tmp_dir)

define make_output
$(call output_path,$(1)): 
	@echo "Creating file $$@"
	@for file in $(input_dir)/*; do \
		echo -n "Processing file $$$$file ..."; \
		id=`basename $$$$file`; \
		echo "<doc id=\"$$$$id\">" >>$$@; \
		zcat $$$$file | cut -f$(2) | cat -n | sed 's/^ *\([0-9][0-9]*\)\t\(.*\)$$$$/<align id="\1">\n\2\n<\/align>/' | sed '/|/s/ /\n/g;s/|/\t/g' | sed -e '/<s>/i <\/s>' -e '/<\/align>/i <\/s>' -e '/<align/a <s>' >>$$@; \
		echo "</doc>" >>$$@; \
		echo " DONE"; \
	done
endef

$(eval $(call make_output,$(lang_a),$(column_a)))

$(eval $(call make_output,$(lang_b),$(column_b)))
