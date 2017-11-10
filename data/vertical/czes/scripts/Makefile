ROOT_DIR := $(realpath $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/..)
langs = cs
top_layer = w
name = czes
source_urls = https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0001-CCCF-C/czes.xdedupl.onioned.vert.gz
vertical_subdir = $(vertical_dir)/monolingual/czes

include $(ROOT_DIR)/../../../scripts/common.mk

clean:
	rm -f "$(output_paths)"

$(output_paths): $(input_paths)
	zcat $+ > $@
