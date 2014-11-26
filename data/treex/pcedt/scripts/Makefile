ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/../
langs = cs en
top_layer = a
name = PCEDT_2.0
source_urls = https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0015-8DAF-4/PCEDT-2-data-only.zip
qsub := $(shell which qsub)
ifdef qsub
cluster_params = -p -j 100
else
cluster_params =
endif
tmp_dir = $(ROOT_DIR)/tmp
input_dir = $(ROOT_DIR)/input
output_dir = $(ROOT_DIR)/output
output_path = $(output_dir)/$(name)_$(1)-$(top_layer)
filelist_path = $(tmp_dir)/filelist.txt.$(1)
output_paths = $(foreach lang,$(langs),$(call output_path,$(lang)))
filelist_paths = $(foreach lang,$(langs),$(call filelist_path,$(lang)))

.PHONY: clean

all: clean $(output_paths)

define make_output
$(call output_path,$(1)): $(call filelist_path,$(1))
	(cd $(tmp_dir) && treex -L$(1) $(cluster_params) Read::Treex from="@$$<" schema_dir=resources top_layer=$(top_layer) Write::Manatee >$$@)
endef

define make_filelist
$(call filelist_path,$(1)):
	mkdir -p $(tmp_dir)
	(cd $(tmp_dir) && find $(input_dir) -type f -wholename '*.treex.gz') >$$@
endef

clean:
	rm -f $(output_paths)
	rm -f $(filelist_paths)
	rm -rf $(tmp_dir)

$(foreach lang,$(langs),$(eval $(call make_filelist,$(lang))))

$(foreach lang,$(langs),$(eval $(call make_output,$(lang))))