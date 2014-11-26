ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/../
lang = cs
top_layer = w
name = Vystadial_2013
tmp_dir = $(ROOT_DIR)/tmp
filelist_path = $(tmp_dir)/filelist.txt
input_dir = $(ROOT_DIR)/input/data_voip_cs/data
input_paths = $(wildcard $(input_dir)/*.trn)
output_dir = $(ROOT_DIR)/output
output_file = $(name)_$(lang)-$(top_layer)
output_path = $(output_dir)/$(output_file)
speech_dir = $(output_dir)/speech

.PHONY: clean

all: clean output mp3

clean:
	rm -f $(output_path)
	rm -f $(filelist_path)
	rm -rf $(speech_dir)

%.mp3:
	lame --quiet $(input_dir)/$(patsubst %.mp3,%.wav,$(notdir $@)) $(speech_dir)/$@

$(speech_dir):
	mkdir -p $@

mp3: $(speech_dir) $(patsubst %.wav.trn,%.mp3,$(notdir $(input_paths)))

output: $(output_path)

$(output_path): $(filelist_path)
	$(ROOT_DIR)/scripts/vystadial2manatee.py $< >$@

$(filelist_path):
	mkdir -p $(tmp_dir)
	echo $(input_paths) | sed -e 's/ /\n/g' >$@


