AXIMAR_MCP ?= aximar-mcp
OUTPUT_DIR  ?= docs/pages
FORMAT      ?= maxima_html

NOTEBOOKS := $(wildcard notebooks/*/*.macnb)
# Map notebooks/category/name.macnb -> docs/pages/name.html
HTML_FILES := $(addprefix $(OUTPUT_DIR)/,$(addsuffix .html,$(basename $(notdir $(NOTEBOOKS)))))

.PHONY: all clean index

all: $(HTML_FILES) index

# Look up the source .macnb by scanning notebooks/*/ for the matching stem.
# This handles the flat output dir ← nested source dir mapping.
define nb_rule
$(OUTPUT_DIR)/$(basename $(notdir $(1))).html: $(1) | $(OUTPUT_DIR)
	$$(AXIMAR_MCP) run --allow-dangerous $$<
	uv run jupyter nbconvert --to $$(FORMAT) --output-dir $$(OUTPUT_DIR) --output $$(basename $$(notdir $$<) .macnb) $$<
endef

$(foreach nb,$(NOTEBOOKS),$(eval $(call nb_rule,$(nb))))

$(OUTPUT_DIR):
	mkdir -p $@

index: $(HTML_FILES) | $(OUTPUT_DIR)
	@./gen-index.sh

clean:
	rm -rf $(OUTPUT_DIR)
