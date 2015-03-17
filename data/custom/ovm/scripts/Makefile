ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/../

lang = cs
langs = $(lang)
top_layer = w
name = OVM
source_urls = https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_110904.trs\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_110904.wav
vertical_subdir = $(vertical_dir)/speech/OVM
sox_commands_path = $(tmp_dir)/sox.sh
speech_input_dir = $(tmp_dir)/speech
speech_output_dir = $(output_dir)/speech
download_method = wget

convert: download mp3

include $(ROOT_DIR)/../../../scripts/common.mk

input_dir =  $(ROOT_DIR)


#$(tmp_dir)/trs_cp1250: $(input_paths)
#	(cd $(tmp_dir) && tar -xv --no-same-permissions -f $(input_dir)/speech.tar)
#	(cd $(tmp_dir) && tar -xzv --no-same-permissions -f $(input_dir)/trs_cp1250.tgz)


clean:
	rm -f $(output_path)
	rm -f $(filelist_path)
	rm -rf $(speech_output_dir)

%.mp3: 
	lame $(input_dir)/$(patsubst %.mp3,%wav,$(notdir $@)) $(speech_output_dir)/$@

$(speech_output_dir):
	mkdir -p $@

mp3: $(speech_output_dir) $(patsubst %.wav.trn,%.mp3,$(notdir $(input_paths)))

