ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/../
lang_a = hi
column_a = 3
langs = $(lang_a)
top_layer = m
name = HindMonoCorp_0.5
source_urls = https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0023-6260-A/hindmonocorp05.export.gz
splitted_tmp_dir = $(tmp_dir)/splitted
input_files = hindmonocorp05.export.gz
input_paths = $(addprefix $(input_dir)/,$(input_files))
vertical_subdir = $(vertical_dir)/monolingual/HindMonoCorp/0.5

include $(ROOT_DIR)/../../../scripts/common.mk

$(splitted_tmp_dir): $(tmp_dir) $(input_paths)
	mkdir -p $(splitted_tmp_dir)
	gunzip -c $+ | awk '{print >> "$(splitted_tmp_dir)/"$$1}'

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

