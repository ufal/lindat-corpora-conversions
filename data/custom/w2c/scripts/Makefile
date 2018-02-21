ROOT_DIR := $(realpath $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/..)
links_filename=sample_list
links=`cat $(links_filename)`
include $(ROOT_DIR)/../../../scripts/common.mk

template:
	@while read -r file; do \
		echo "$$file"; \
	done <$(links_filename) 



#$(foreach lang,$(langs),$(eval $(call make_output,$(lang))))

































