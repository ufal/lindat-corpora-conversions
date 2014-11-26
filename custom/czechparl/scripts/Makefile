ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/../
lang = cs
top_layer = w
name = CzechParl_2012-03-28
tmp_dir = $(ROOT_DIR)/tmp
input_dir = $(ROOT_DIR)/input
input_paths := $(input_dir)/*.trs
output_dir = $(ROOT_DIR)/output
output_file = $(name)_$(lang)-$(top_layer)
output_path = $(output_dir)/$(output_file)
sox_commands_path = $(tmp_dir)/sox.sh
speech_dir = $(output_dir)/speech

.PHONY: clean

all: clean mp3

clean:
	rm -f $(output_path)
	rm -f $(sox_commands_path)
	rm -rf $(speech_dir)

mp3: $(sox_commands_path)
	mkdir -p $(speech_dir)
	(cd $(ROOT_DIR) && sh $(sox_commands_path))

$(sox_commands_path): $(input_paths)
	$(foreach file,$+, $(ROOT_DIR)/scripts/czechparl2manatee.py $(file) $(output_path) $(sox_commands_path);)

