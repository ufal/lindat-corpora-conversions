ROOT_DIR := $(realpath $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/..)
lang_a = en
column_a = 4
lang_b = hi
column_b = 5
langs = $(lang_a) $(lang_b)
top_layer = m
name = HindEnCorp_0.5
source_urls = https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0023-625F-0/hindencorp05.export.gz
splitted_tmp_dir = $(tmp_dir)/splitted
vertical_subdir = $(vertical_dir)/parallel/HindEnCorp/0.5

include $(ROOT_DIR)/../../../scripts/common.mk

$(splitted_tmp_dir): $(tmp_dir) $(input_paths)
	mkdir -p $(splitted_tmp_dir)
	gunzip -c $(input_paths) | awk '{print >> "$(splitted_tmp_dir)/"$$1}'

split: $(splitted_tmp_dir)

clean:
	rm -f $(output_paths)
	rm -rf $(splitted_tmp_dir)
	rm -rf $(tmp_dir)

define make_output
$(call output_path,$(1)): split
	@echo "Creating file $$@"
	@for file in $(splitted_tmp_dir)/*; do \
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
