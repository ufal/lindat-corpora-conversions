ROOT_DIR := $(realpath $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/..)
langs = cs
top_layer = a
name = PDT_3.0
source_urls = https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0023-1AAF-3/PDT_3.0.zip
filelist_path = $(tmp_dir)/filelist.txt.$(1).$(2)
filelist_paths = $(call filelist_path,cs,a) $(call filelist_path,cs,m)
vertical_subdir = $(vertical_dir)/monolingual/PDT/3.0
download_method = wget

include $(ROOT_DIR)/../../../scripts/common.mk

define make_output
$(call output_path,$(1)): $(call filelist_path,$(1),a) $(call filelist_path,$(1),m)
	(cd $(tmp_dir) && treex -L$(1) $(cluster_params) Read::PDT from="@$(call filelist_path,$(1),a)" schema_dir=$(ROOT_DIR)/scripts/resources top_layer=a Write::Manatee >$$@.tmp.a)
	(cd $(tmp_dir) && treex -L$(1) $(cluster_params) Read::PDT from="@$(call filelist_path,$(1),m)" schema_dir=$(ROOT_DIR)/scripts/resources top_layer=m Write::Manatee >$$@.tmp.m)
	$(ROOT_DIR)/scripts/fix_pdt_corpus.py $$@.tmp.a >$$@ && rm $$@.tmp.a
	$(ROOT_DIR)/scripts/fix_pdt_corpus.py $$@.tmp.m >>$$@ && rm $$@.tmp.m
endef

$(tmp_dir)/PDT_3.0: $(input_paths)
	(cd $(tmp_dir) && unzip $(input_paths))

$(call filelist_path,cs,a): $(tmp_dir)/PDT_3.0
	find $(tmp_dir)/PDT_3.0/data/*amw -type f -wholename '*.a.gz' >$@

$(call filelist_path,cs,m): $(tmp_dir)/PDT_3.0
	find $(tmp_dir)/PDT_3.0/data/mw -type f -wholename '*.m.gz' >$@

clean:
	rm -f $(output_paths)
	rm -f $(filelist_paths)
	rm -rf $(tmp_dir)

$(foreach lang,$(langs),$(eval $(call make_output,$(lang))))
