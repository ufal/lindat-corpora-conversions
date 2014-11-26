ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/../
lang = cs
top_layer = m
name = WebColl
source_urls = /net/data/webcoll/tr-tag/am-trns-sgml.tar.gz\
	/net/data/webcoll/tr-tag/cn-trns-sgml.tar.gz\
	/net/data/webcoll/tr-tag/cr-trns-sgml.tar.gz\
	/net/data/webcoll/tr-tag/gg-trns-sgml.tar.gz\
	/net/data/webcoll/tr-tag/hn-trns-sgml.tar.gz\
	/net/data/webcoll/tr-tag/id-trns-sgml.tar.gz\
	/net/data/webcoll/tr-tag/jx-trns-sgml.tar.gz\
	/net/data/webcoll/tr-tag/ln-trns-sgml.tar.gz\
	/net/data/webcoll/tr-tag/mn-trns-sgml.tar.gz\
	/net/data/webcoll/tr-tag/np-trns-sgml.tar.gz\
	/net/data/webcoll/tr-tag/rf-trns-sgml.tar.gz
tmp_dir = $(ROOT_DIR)/tmp
input_dir = $(ROOT_DIR)/input
input_paths = $(wildcard $(input_dir)/*.tar.gz)
output_dir = $(ROOT_DIR)/output
output_file = $(name)_$(lang)-$(top_layer)
output_path = $(output_dir)/$(output_file)

.PHONY: clean

all: clean output

clean:
	rm -f $(output_path)

all: $(output_path)

output: $(output_path)

$(output_path):
	find $(tmp_dir)/trns/*.sgml -type f | xargs -n 1 ./webcoll2manatee.py >$@

unpack:
	mkdir -p $(tmp_dir)
	(cd $(tmp_dir) && for file in $(input_dir)/*; do tar xzf $$file; done)
