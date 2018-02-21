ROOT_DIR := $(realpath $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/..)

lang = cs
langs = $(lang)
top_layer = w
name = OVM
source_urls = https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_110904.trs\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_110904.wav\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_110911.trs\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_110911.wav\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_110918.trs\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_110918.wav\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_110925.trs\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_110925.wav\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_111002.trs\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_111002.wav\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_111009.trs\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_111009.wav\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_111016.trs\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_111016.wav\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_111023.trs\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_111023.wav\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_111030.trs\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_111030.wav\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_111106.trs\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_111106.wav\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_111113.trs\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_111113.wav\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_111120.trs\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_111120.wav\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_111127.trs\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_111127.wav\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_111204.trs\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_111204.wav\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_111211.trs\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_111211.wav\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_111218.trs\
        https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-000D-EC98-3/OVM_111218.wav 
vertical_subdir = $(vertical_dir)/speech/
sox_commands_path = $(tmp_dir)/sox.sh
speech_dir = $(output_dir)/speech/
download_method = wget
registry_filename = $(notdir $(registry_paths))
convert: download mp3

include $(ROOT_DIR)/../../../scripts/common.mk

mp3: $(call output_path,$(lang))
	mkdir -p $(speech_dir)
	(cd $(ROOT_DIR) && sh $(sox_commands_path))


clean:
	rm -f $(call output_path,$(lang))
	rm -f $(sox_commands_path)
	rm -rf $(speech_dir)


$(call output_path,$(lang)): $(input_paths)
	$(foreach file,$(filter %.trs,$(input_paths)), $(ROOT_DIR)/scripts/ovm2manatee.py $(file) $@ $(sox_commands_path);)

copy_speech:
	#cp $(templates_dir)/* $(registry_dir)/
	cp $(output_paths) $(vertical_subdir)/OVM
	mkdir -p $(speech_file_dir)/$(registry_filename)
	cp $(output_dir)/speech/* $(speech_file_dir)/$(registry_filename)/

compile_speech:
	compilecorp --no-sketches --recompile-corpus $(registry_dir)/$(registry_filename)
