ROOT_DIR := $(realpath $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/..)
langs = sk
top_layer = w
name = skTenTen_2011-12-16
source_urls = https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0001-CCDB-0/skTenTen.vert.xz
vertical_subdir = $(vertical_dir)/monolingual/skTenTen/2011-12-16

include $(ROOT_DIR)/../../../scripts/common.mk

clean:
	rm -f "$(output_paths)"

$(output_paths): $(input_paths)
	xzcat $+ > $@
