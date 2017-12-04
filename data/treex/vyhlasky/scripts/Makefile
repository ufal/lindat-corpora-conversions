ROOT_DIR := $(realpath $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/..)
langs = cs
top_layer = a
name = vyhlasky
source_urls = https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0006-B847-6/raw_input_parsed.txt
vertical_subdir = $(vertical_dir)/monolingual/vyhlasky/

include $(ROOT_DIR)/../../../scripts/common.mk


#clean:
#	rm -f "$(output_paths)"

$(output_paths): $(input_paths)
	cat $+ | sed -e '/doc/ s/ genre=""//' |  awk -F$$'\t' 'BEGIN {FS="\t";OFS="\t"} $2 {print $$1,$$2,$$3,$$7,$$20,$$22,$$23,$$24,$$25,$$21,$$26,$$27,$$28,$$29,$$30}' > $@
