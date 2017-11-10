ROOT_DIR := $(realpath $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/..)
langs = en
top_layer = w
name = enTenTen_2011-12-16
source_urls = https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0001-CCDF-8/ententen08.vert.gz
vertical_subdir = $(vertical_dir)/monolingual/enTenTen/2011-12-16

include $(ROOT_DIR)/../../../scripts/common.mk
#input_dir = ../input.sample

clean:
	rm -f "$(output_paths)"

$(output_paths): $(input_paths)
	zcat $+ | egrep -v '</p>' | sed ':begin;$!N;s/<\/doc>\n<\/doc>/<\/doc>/;tbegin;P;D' |  sed 's/<\/doc>/<\/p>\n<\/doc>/g' | sed 's/<p>/<\/p>\n<p>/g' | sed ':begin;$!N;s/">\n<\/p>/">/;tbegin;P;D' > $@
