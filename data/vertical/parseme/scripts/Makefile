ROOT_DIR := $(realpath $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/..)
langs ?= cs de el es fa fr hu it mt pl pt ro sl sv tr
top_layer = a
name = parseme
source_urls = https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11372/LRT-2282/*.tgz
filelist_path = $(tmp_dir)/filelist.txt.$(1)
filelist_paths = $(foreach lang,$(langs),$(call filelist_path,$(lang)))
vertical_subdir = $(vertical_dir)/monolingual/parseme/1.0

include $(ROOT_DIR)/../../../scripts/common.mk
