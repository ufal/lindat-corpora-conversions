ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/../
lang = en
top_layer = w
name = enTenTen_2011-12-16
source_urls = https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0001-CCDF-8/ententen08.vert.gz
input_dir = $(ROOT_DIR)/input
input_file = ententen08.vert.gz
input_path = $(input_dir)/$(input_file)
output_dir = $(ROOT_DIR)/output
output_file = $(name)_$(lang)-$(top_layer)
output_path = $(output_dir)/$(output_file)

.PHONY: clean

all: clean $(output_path)

clean:
	rm -f "$(output_path)"

$(output_path): $(input_path)
	zcat $< > $@
