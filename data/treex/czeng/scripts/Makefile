ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/../
langs = cs en
top_layer = a
name = CzEng_1.0
source_urls = https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11234/1-1458/data-treex-format.tar
filelist_path = $(tmp_dir)/filelist.txt.$(1)
filelist_paths = $(foreach lang,$(langs),$(call filelist_path,$(lang)))
vertical_subdir = $(vertical_dir)/monolingual/CzEng/1.0

include $(ROOT_DIR)/../../../scripts/common.mk

define make_output
$(call output_path,$(1)): $(tmp_dir) $(call filelist_path,$(1))
	(cd $(tmp_dir) && treex -L$(1) $(cluster_params) Read::Treex from="@$$(call filelist_path,$(1))" schema_dir=$(ROOT_DIR)/scripts/resources top_layer=$(top_layer) Write::Manatee >$$@)
endef

define make_filelist
$(call filelist_path,$(1)): $(tmp_dir)
	(cd $(tmp_dir) && find $(input_dir) -type f -wholename '*.treex.gz') >$$@
endef

clean:
	rm -f $(output_paths)
	rm -f $(filelist_paths)
	rm -rf $(tmp_dir)

$(foreach lang,$(langs),$(eval $(call make_filelist,$(lang))))

$(foreach lang,$(langs),$(eval $(call make_output,$(lang))))
