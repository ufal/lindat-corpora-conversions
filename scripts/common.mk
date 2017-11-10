conversions_dir = /opt/projects/lindat-services-kontext/devel/data/corpora/conversions
registry_dir = /opt/projects/lindat-services-kontext/devel/data/corpora/registry
vertical_dir = /opt/projects/lindat-services-kontext/devel/data/corpora/vert
speech_file_dir = /opt/projects/lindat-services-kontext/devel/data/corpora/speech
identity_file = $(conversions_dir)/.ssh/id_rsa
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
repository_server = josifko@lindat.mff.cuni.cz
python_metadata_tool = /sources/dspace-1.8.2/bits/tools/python-dspace-metadata/main.py
python_metadata_dir = $(dir $(python_metadata_tool))
extract_filename = $(shell echo -n "$(1)" | rev | cut -d/ -f1 | rev)
extract_handle = $(shell echo -n "$(1)" | rev | cut -d/ -f2,3 | rev)
input_paths = $(addprefix $(input_dir)/,$(foreach source_url,$(source_urls),$(call extract_filename,$(source_url))))
#ifndef download_method
#	download_method = scp
#endif
fetch_remote_path = $(shell ssh -i $(identity_file) $(repository_server) 'cd $(python_metadata_dir) && python $(python_metadata_tool) --assetstore-path --handle="$(1)" --name="$(2)" 2>/dev/null')

all: compile

define input_path
$(addprefix $(input_dir)/,$(call extract_filename,$(1))):
	if [ "$(download_method)" = "scp" ]; \
    then \
	    remote_path=$(call fetch_remote_path,$(call extract_handle,$(1)),$(call extract_filename,$(1))); \
	    if [ -n "$$$$remote_path" ]; then \
		 (cd $(input_dir) && scp -i $(identity_file) $(repository_server):$$$$remote_path $$@); \
	    fi; \
    else \
	    (cd $(input_dir) && wget -O $$@ $(1)); \
    fi
endef

#$(foreach source_url,$(source_urls),$(eval $(call input_path,$(source_url))))

$(vertical_subdir):
	mkdir -p $@

$(tmp_dir):
	mkdir -p $@

download: $(input_paths)

convert: download $(output_paths)

install: $(registry_paths) $(vertical_paths) install_speech

install_speech:
	# dummy

$(vertical_paths): clean_vertical $(vertical_subdir) convert
	ln -t $(vertical_subdir) -s "$$(readlink -e "$(output_dir)/$(notdir $@)")"

$(registry_paths): clean_registry $(templates_paths)
	ln -t $(registry_dir) -s "$$(readlink -e "$(templates_dir)/$(notdir $@)")"

clean_registry:
	rm -rI $(registry_paths)

clean_vertical:
	rm -rI $(vertical_paths)

compile: install
	$(foreach registry_path,$(registry_paths),MANATEE_REGISTRY=$(registry_dir) compilecorp --no-sketches --recompile-corpus $(registry_path);)
