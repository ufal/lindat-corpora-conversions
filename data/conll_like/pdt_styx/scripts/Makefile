ROOT_DIR := $(realpath $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/..)
lang_a = cs
column_a = 1
langs = $(lang_a)
top_layer = a
name = styx10
source_urls = https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11234/1-2391/STYX-1.0.zip
vertical_subdir = $(vertical_dir)/monolingual/Styx/1.0
download_method = wget
input_dir =  $(ROOT_DIR)/input
override input_paths = $(addprefix $(input_dir)/,input-1.o input-2.o input-3.o input-4.o input-5.o train-6.o train-7.o train-8.o dtest.o etest.o)
include $(ROOT_DIR)/../../../scripts/common.mk

$(input_paths): download_and_extract

download_and_extract:
	(cd $(input_dir) && wget $(source_urls) && unzip STYX-1.0.zip && mv STYX-1.0/data/* . && rm -rf STYX-1.0*)

clean:
	rm -I $(output_paths)
	#rm -rI $(input_dir)

define make_output
$(call output_path,$(1)):
	@echo "Creating file $$@"
	treex -q -Lcs Read::CoNLLlike format=styx1.0 from=$(input_paths) Write::ManateeGeneral format=styx1.0 > $$@ 2>log
endef

$(eval $(call make_output,$(lang_a),$(column_a)))

.PHONY: download_and_extract
