ROOT_DIR := $(realpath $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/..)
lang = cs
langs = $(lang)
top_layer = w
name = CzechParl_2012-03-28
source_urls = https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110212_003546.trs\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110212_003546.wav\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110325_010705.trs\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110325_010705.wav\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110427_005836.trs\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110427_005836.wav\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110428_005954.trs\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110428_005954.wav\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110429_005820.trs\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110429_005820.wav\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110504_005351.trs\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110504_005351.wav\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110505_005813.trs\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110505_005813.wav\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110506_005821.trs\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110506_005821.wav\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110507_005803.trs\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110507_005803.wav\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110511_005438.trs\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110511_005438.wav\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110609_005958.trs\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110609_005958.wav\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110611_010015.trs\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110611_010015.wav\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110617_010946.trs\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110617_010946.wav\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110618_010259.trs\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110618_010259.wav\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110619_001010.trs\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110619_001010.wav\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110714_010025.trs\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110714_010025.wav\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110715_005912.trs\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110715_005912.wav\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110831_005909.trs\
	https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0005-CF9C-4/SOUND_110831_005909.wav
vertical_subdir = $(vertical_dir)/monolingual/CzechParl/2012-03-28
sox_commands_path = $(tmp_dir)/sox.sh
speech_dir = $(output_dir)/speech
download_method = wget

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
	$(foreach file,$(filter %.trs,$(input_paths)), $(ROOT_DIR)/scripts/czechparl2manatee.py $(file) $@ $(sox_commands_path);)

