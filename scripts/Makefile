ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/../
subsystems = $(wildcard $(ROOT_DIR)/data/*/*/scripts)

all: compile

clean:
	$(foreach subsystem,$(subsystems),$(MAKE) -C $(subsystem) clean;)

download: clean
	$(foreach subsystem,$(subsystems),$(MAKE) -C $(subsystem) download;)

convert: download
	$(foreach subsystem,$(subsystems),$(MAKE) -C $(subsystem) convert;)

install: convert
	$(foreach subsystem,$(subsystems),$(MAKE) -C $(subsystem) compile;)

compile: install
	$(foreach subsystem,$(subsystems),$(MAKE) -C $(subsystem) install;)
