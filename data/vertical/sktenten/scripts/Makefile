ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/../
lang = sk
top_layer = w
name = skTenTen_2011-12-16
input_dir = $(ROOT_DIR)/input
input_file = skTenTen.vert.gz
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
