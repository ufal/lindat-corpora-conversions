ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/../
subsystems = $(wildcard $(ROOT_DIR)/data/*/*/scripts)

all: compile

clean:
	$(foreach subsystem,$(subsystems),$(MAKE) -C $(subsystem) $@;)

download:
	$(foreach subsystem,$(subsystems),$(MAKE) -C $(subsystem) $@;)

convert:
	$(foreach subsystem,$(subsystems),$(MAKE) -C $(subsystem) $@;)

install:
	$(foreach subsystem,$(subsystems),$(MAKE) -C $(subsystem) $@;)

compile:
	$(foreach subsystem,$(subsystems),$(MAKE) -C $(subsystem) $@;)


