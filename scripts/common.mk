registry_dir = /opt/projects/lindat-services-kontext/devel/data/corpora/registry
vertical_dir = /opt/projects/lindat-services-kontext/devel/data/corpora/vert
tmp_dir = $(ROOT_DIR)/tmp
templates_dir =  $(ROOT_DIR)/templates
templates_paths = $(wildcard $(templates_dir)/*)
registry_paths = $(addprefix $(registry_dir)/,$(notdir $(templates_paths)))
vertical_paths = $(addprefix $(vertical_subdir)/,$(notdir $(output_paths)))
output_path = $(output_dir)/$(name)_$(1)-$(top_layer)
output_paths = $(foreach lang,$(langs),$(call output_path,$(lang)))
input_dir =  $(ROOT_DIR)/input
output_dir =  $(ROOT_DIR)/output
qsub := $(shell which qsub)
ifdef qsub
cluster_params ?= -p -j 100
else
cluster_params ?=
endif

all: compile

$(input_paths):
	@echo
	@echo '========================================================================'
	@echo '!!! THE FILES NEED TO BE DOWNLOADED MANUALLY DUE TO LICENCING ISSUES !!!'
	@echo '========================================================================'
	@echo 'Copy downloaded files to: $(input_dir)'
	@echo '------------------------------------------------------------------------'
	@$(foreach source_url,$(source_urls),echo wget '$(source_url)';)
	@echo '========================================================================'
	@read -p "Continue (y/N)? " answer && [ "$$answer" = "y" ]
	$(foreach input_path,$(input_paths),[ -e $(input_paths) ];)

$(vertical_subdir):
	mkdir -p $@

$(tmp_dir):
	mkdir -p $@

download: $(input_paths)

convert: clean download $(output_paths)

install: $(registry_paths) $(vertical_paths)

$(vertical_paths): clean_vertical $(vertical_subdir) convert
	cp $(output_paths) $(vertical_subdir)

$(registry_paths): clean_registry $(templates_paths)
	cp $(templates_paths) $(registry_dir)

clean_registry:
	rm -f $(registry_paths)

clean_vertical:
	rm -f $(vertical_paths)

compile: install
	$(foreach registry_path,$(registry_paths),MANATEE_REGISTRY=$(registry_dir) compilecorp --no-sketches --recompile-corpus $(registry_path);)
