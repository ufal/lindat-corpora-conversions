ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/../
langs = ar cs da et fa fi grc la nl pt ro sv ta
top_layer = a
name=HamleDT_2.0
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
	treex -L$(1) Read::Treex from="@$$<" schema_dir=resources top_layer=$(top_layer) Write::Manatee >$$@
endef

define make_filelist
$(call filelist_path,$(1)):
	mkdir -p $(tmp_dir)
	(cd $(tmp_dir) && find $(input_dir) -type f -wholename '*/$(1)/*/001_pdtstyle/*.treex.gz') >$$@
endef

clean:
	rm -f $(output_paths)
	rm -f $(filelist_paths)

$(foreach lang,$(langs),$(eval $(call make_filelist,$(lang))))

$(foreach lang,$(langs),$(eval $(call make_output,$(lang))))
