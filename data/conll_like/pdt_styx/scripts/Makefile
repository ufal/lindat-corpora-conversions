ROOT_DIR := $(realpath $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/..)
lang_a = cs
column_a = 1
langs = $(lang_a)
top_layer = a
name = styx10
source_urls = https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11234/1-2391/STYX-1.0.zip
vertical_subdir = $(vertical_dir)/monolingual/Styx/1.0
download_method = wget
include $(ROOT_DIR)/../../../scripts/common.mk

$(input_paths):
	(cd $(input_dir) && wget $(source_urls) && unzip STYX-1.0.zip && mv STYX-1.0/data/* . && rm -rf STYX-1.0*)

clean:
	rm -I $(output_paths)
	#rm -rI $(input_dir)

define make_output
$(call output_path,$(1)):
	@echo "Creating file $$@"
	@for file in $(input_dir)/*train* $(input_dir)/*test*; do \
		echo -n "Processing file $$$$file ..."; \
		id=`basename $$$$file`; \
		echo "<doc id=\"$$$$id\">" >>$$@; \
        awk -v OFS='\t' '/^#/ {print "<s id=\"" substr($$$$0,2,length($$$$0)-2) "\">"; next}; /^\s*$$$$/ {print "</s>"; next}; $$2 {print $$$$2,$$$$3,$$$$4,$$$$1,$$$$5,$$$$6,$$$$7,$$$$8} ' $$$$file >>$$@; \
		echo "</doc>" >>$$@; \
		echo " DONE"; \
	done
endef
#        awk -v OFS='\t' '/^#/ {print "<s id=\"" $$$$0 "\">"; next}; /^\s*$$$$/ {print "</s>"; next}; $$2 {print $$$$2,$$$$3,$$$$4,$$$$1,$$$$5,$$$$6,$$$$7,$$$$8} ' $$$$file >>$$@; \

$(eval $(call make_output,$(lang_a),$(column_a)))

