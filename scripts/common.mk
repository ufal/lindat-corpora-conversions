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
repository_server = lindat.mff.cuni.cz
python_metadata_tool = /sources/dspace-1.8.2/bits/tools/python-dspace-metadata/main.py
python_metadata_dir = $(dir $(python_metadata_tool))
extract_filename = $(shell echo -n "$(1)" | rev | cut -d/ -f1 | rev)
extract_handle = $(shell echo -n "$(1)" | rev | cut -d/ -f2,3 | rev)
fetch_remote_path =  $(shell ssh $(repository_server) 'cd $(python_metadata_dir) && python $(python_metadata_tool) --assetstore-path --handle="$(1)" --name="$(2)" 2>/dev/null')

all: compile

define input_path
$(addprefix $(input_dir)/,$(call extract_filename,$(1))):
	@remote_path=$(call fetch_remote_path,$(call extract_handle,$(1)),$(call extract_filename,$(1))); \
	if [ -n "$$$$remote_path" ]; then \
		 (cd $(input_dir) && scp $(repository_server):$$$$remote_path $$@); \
	fi
endef

$(foreach source_url,$(source_urls),$(eval $(call input_path,$(source_url))))

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
