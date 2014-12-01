ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/../
langs = en
top_layer = w
name = enTenTen_2011-12-16
source_urls = https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0001-CCDF-8/ententen08.vert.gz
input_files = ententen08.vert.gz
input_paths = $(addprefix $(input_dir)/,$(input_files))
vertical_subdir = $(vertical_dir)/monolingual/enTenTen/2011-12-16

include $(ROOT_DIR)/../../../scripts/common.mk

clean:
	rm -f "$(output_paths)"

$(output_paths): $(input_paths)
	zcat $+ > $@
