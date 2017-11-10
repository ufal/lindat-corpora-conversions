ROOT_DIR := $(realpath $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/..)

lang = en
langs = $(lang)
top_layer = w
name = Airtraffic
source_urls = https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0001-CCA1-0/ZCU_CZ_ATC.rar  
vertical_subdir = $(vertical_dir)/speech
sox_commands_path = $(tmp_dir)/sox.sh
speech_dir = $(output_dir)/speech/
download_method = wget
registry_filename = $(notdir $(registry_paths))
convert: download mp3

include $(ROOT_DIR)/../../../scripts/common.mk

input_dir =  $(ROOT_DIR)/input
input_paths = $(ROOT_DIR)/input/*
output_file = $(name)_$(lang)-$(top_layer)
output_path = $(output_dir)/$(output_file)


print_input_paths:
	echo $(input_paths)

mp3: $(call output_path,$(lang))
	mkdir -p $(speech_dir)
	(cd $(ROOT_DIR) && sh $(sox_commands_path))


clean:
	rm -f $(call output_path,$(lang))
	rm -f $(sox_commands_path)
	rm -rf $(speech_dir)


$(call output_path,$(lang)): $(input_paths)
	#$(foreach file,$($(input_paths)), $(ROOT_DIR)/scripts/air2manatee.py $(file) ../output/Airtraffic_en-w $(sox_commands_path);)
	$(foreach file,$(filter %.trs,$(input_paths)), $(ROOT_DIR)/scripts/air2manatee.py $(file) $(output_dir)/$(output_file) $(sox_commands_path);)

copy_speech:
	cp $(templates_dir)/$(registry_filename) $(registry_dir)
	mkdir -p $(vertical_subdir)/Airtraffic
	cp $(output_paths) $(vertical_subdir)/Airtraffic/
	mkdir -p $(speech_file_dir)/$(registry_filename)
	cp $(output_dir)/speech/* $(speech_file_dir)/$(registry_filename)/

compile_speech:
	compilecorp --no-sketches --recompile-corpus $(registry_dir)/$(registry_filename)
