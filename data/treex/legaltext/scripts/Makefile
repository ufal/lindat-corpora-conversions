ROOT_DIR := $(realpath $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/..)
langs = cs
top_layer = a
name = legaltext
source_urls = https://lindat.mff.cuni.cz/*/*/*/*/*/*/cltt_2.0.zip
vertical_subdir = $(vertical_dir)/monolingual/legaltext/

include $(ROOT_DIR)/../../../scripts/common.mk
input_dir =  $(ROOT_DIR)/input/kontext
input_paths = $(input_dir)/*.csv


clean:
	rm -f "$(output_paths)"

$(output_paths): $(input_paths)
	cat $+ | sed -e '/doc/ s/ genre=""//' |  awk -F$$'\t' 'BEGIN {FS="\t";OFS="\t"} $2 {print $$1,$$2,$$3,$$7,$$20,$$22,$$23,$$24,$$25,$$21,$$26,$$27,$$28,$$29,$$30}' > $@
