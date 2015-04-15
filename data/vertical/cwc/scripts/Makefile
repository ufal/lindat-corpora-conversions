ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/../
langs = cs
top_layer = w
name = CWC
source_urls = https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0006-B847-6/plain.articles_shuffled.txt.bz2 
vertical_subdir = $(vertical_dir)/monolingual/CWC/2011

include $(ROOT_DIR)/../../../scripts/common.mk
#input_dir = $(ROOT_DIR)/input.sample

clean:
	rm -f "$(output_paths)"

$(output_paths): $(input_paths)
	bzcat $+ > $@
