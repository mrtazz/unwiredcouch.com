SITEDIR ?=_site
HUGO=$(shell which hugo)

.PHONY: build

build:
	$(HUGO)

serve:
	$(HUGO) server
