ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/../

lang = cs
langs = $(lang)
top_layer = w
name = Companions_2014-01-10
source_urls = https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0023-1D76-9/trs_cp1250.tgz\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0023-1D76-9/speech.tar
vertical_subdir = $(vertical_dir)/speech/Companions/2014-01-10
sox_commands_path = $(tmp_dir)/sox.sh
speech_input_dir = $(tmp_dir)/speech
speech_output_dir = $(output_dir)/speech
download_method = wget

convert: download mp3

include $(ROOT_DIR)/../../../scripts/common.mk

$(tmp_dir)/trs_cp1250: $(input_paths)
	(cd $(tmp_dir) && tar -xv --no-same-permissions -f $(input_dir)/speech.tar)
	(cd $(tmp_dir) && tar -xzv --no-same-permissions -f $(input_dir)/trs_cp1250.tgz)

$(tmp_dir)/filelist.txt: $(tmp_dir)/trs_cp1250
	find $(tmp_dir)/trs_cp1250 -name '*.trs' > $@

clean:
	rm -f $(call output_path,$(lang))
	rm -f $(sox_commands_path)
	rm -rf $(speech_output_dir)

mp3: $(call output_path,$(lang))
	mkdir -p $(speech_output_dir)
	(cd $(ROOT_DIR) && sh $(sox_commands_path))

$(call output_path,$(lang)): $(tmp_dir)/filelist.txt
	@$(foreach file,$(shell cat $<), $(ROOT_DIR)/scripts/companion2manatee.py $(file) $@ $(sox_commands_path) $(speech_input_dir) $(speech_output_dir);)
	sed -i '1i<doc>' $(call output_path,$(lang))
	sed -i '$$a</doc>' $(call output_path,$(lang))
