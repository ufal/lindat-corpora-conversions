ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/../
langs = cs
top_layer = a
name = PDT_3.0
source_urls = https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0023-1AAF-3/PDT_3.0.zip
filelist_path = $(tmp_dir)/filelist.txt.$(1)
filelist_paths = $(foreach lang,$(langs),$(call filelist_path,$(lang)))
vertical_subdir = $(vertical_dir)/monolingual/PDT/3.0

include $(ROOT_DIR)/../../../scripts/common.mk

define make_output
$(call output_path,$(1)): $(tmp_dir) $(call filelist_path,$(1))
	(cd $(tmp_dir) && treex -L$(1) $(cluster_params) Read::PDT from="@$(call filelist_path,$(1))" schema_dir=$(ROOT_DIR)/scripts/resources top_layer=$(top_layer) Write::Manatee >$$@.tmp)
	$(ROOT_DIR)/scripts/fix_pdt_corpus.py $$@.tmp >$$@ && rm $$@.tmp
endef

define make_filelist
$(call filelist_path,$(1)): $(tmp_dir)
	(cd $(tmp_dir) && find $(input_dir) -type f -wholename '*.m.gz') >$$@
endef

clean:
	rm -f $(output_paths)
	rm -f $(filelist_paths)
	rm -rf $(tmp_dir)

$(foreach lang,$(langs),$(eval $(call make_filelist,$(lang))))

$(foreach lang,$(langs),$(eval $(call make_output,$(lang))))
