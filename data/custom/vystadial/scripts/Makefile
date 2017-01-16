ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/../

include $(ROOT_DIR)/../../../scripts/common.mk

lang = cs
top_layer = w
name = Vystadial_2013
source_urls = https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0023-4670-6/data_voip_cs.tgz\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0023-4671-4/data_voip_en.tgz
tmp_dir = $(ROOT_DIR)/tmp
filelist_path = $(tmp_dir)/filelist.txt
input_paths = $(wildcard $(input_dir)/*.trn)
output_file = $(name)_$(lang)-$(top_layer)
output_path = $(output_dir)/$(output_file)
speech_dir = $(output_dir)/speech

.PHONY: clean

all: convert

convert: output mp3

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


