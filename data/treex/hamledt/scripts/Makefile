ROOT_DIR := $(realpath $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/..)
langs ?= ar cs da et fa fi grc la nl pt ro sv ta
top_layer = a
name = HamleDT_2.0
source_urls = https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0023-9551-4/hamledt-2.0-free.tar
filelist_path = $(tmp_dir)/filelist.txt.$(1)
filelist_paths = $(foreach lang,$(langs),$(call filelist_path,$(lang)))
vertical_subdir = $(vertical_dir)/monolingual/HamleDT/2.0

include $(ROOT_DIR)/../../../scripts/common.mk

define make_output
$(call output_path,$(1)): $(tmp_dir) $(call filelist_path,$(1))
	(cd $(tmp_dir) && treex -L$(1) $(cluster_params) Read::Treex from="@$$(call filelist_path,$(1))" schema_dir=$(ROOT_DIR)/scripts/resources top_layer=$(top_layer) Write::Manatee >$$@)
endef

$(tmp_dir)/2.0: $(input_paths)
	(cd $(tmp_dir) && tar -x --no-same-permissions -f $(input_paths))

define make_filelist
$(call filelist_path,$(1)): $(tmp_dir)/2.0
	(cd $(tmp_dir) && find $(tmp_dir) -type f -wholename '*/$(1)/*/001_pdtstyle/*.treex.gz') >$$@
endef

clean:
	rm -f $(output_paths)
	rm -f $(filelist_paths)
	rm -rf $(tmp_dir)/2.0

$(foreach lang,$(langs),$(eval $(call make_filelist,$(lang))))

$(foreach lang,$(langs),$(eval $(call make_output,$(lang))))
