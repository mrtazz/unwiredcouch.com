#
# Makefile to generate the static version of this blog. I have no idea if this
# will work.
#

SITEDIR ?=_site
SRCDIR = src
FEEDSIZE=10
# this exists so the prefix can be passed on PR builds so that pages preview deployments work
URL_PREFIX ?= ""
PANDOC=$(shell which pandoc)
PANDOC_FLAGS=--standalone --from=markdown-hard_line_breaks+yaml_metadata_block+smart --email-obfuscation=none --to=html -M url_prefix="$(URL_PREFIX)"
POST_TPL  := layouts/post.pandoc
INDEX_TPL := layouts/index.pandoc
TALK_TPL  := layouts/talk.pandoc
TALKS_INDEX_TPL  := layouts/talkindex.pandoc

STYLE_REV=$(shell git log -n 1 --pretty=format:'%h' $(SRCDIR)/css/style.css)
MOBILE_REV=$(shell git log -n 1 --pretty=format:'%h' $(SRCDIR)/css/mobile.css)
PANDOC_REVS=-M stylerev="$(STYLE_REV)" -M mobilerev="$(MOBILE_REV)"

src_files := $(shell find $(SRCDIR) -type f | grep -v 'min.css')

SITE_FILES := $(src_files:$(SRCDIR)/%=${SITEDIR}/%)
SITE_WITH_HTML := $(SITE_FILES:%.md=%.html)
SITE_WITH_HTML_INDEX := $(SITE_WITH_HTML:%.yml=%.html)
SITE_WITH_ALL_FILES := $(SITE_WITH_HTML_INDEX:%.css=%.min.css)

.PHONY: serve all static clean css index feed html

all: $(SITE_WITH_ALL_FILES) feed

serve: $(SITEDIR)
	cd ${SITEDIR} && php -S 0.0.0.0:8000

.PHONY: deps
deps: node_modules

node_modules:
	npm install sass

$(SITEDIR):
	mkdir -p ${SITEDIR}

$(SITEDIR)/index.html: $(SRCDIR)/index.yml $(INDEX_TPL) | $(SITEDIR)
	$(PANDOC) $(PANDOC_REVS) -s --template=$(INDEX_TPL) -o $@ $<

$(SITEDIR)/talks/index.html: $(SRCDIR)/talks/index.yml $(TALKS_INDEX_TPL) | $(SITEDIR)
	mkdir -p `dirname $@`
	$(PANDOC) $(PANDOC_FLAGS) $(PANDOC_REVS) -s --template=$(TALKS_INDEX_TPL) -o $@ $<

$(SITEDIR)/talks/%.html: $(SRCDIR)/talks/%.yml $(TALK_TPL) | $(SITEDIR)
	mkdir -p `dirname $@`
	$(PANDOC) $(PANDOC_FLAGS) $(PANDOC_REVS) -s --template=$(TALK_TPL) -o $@ $<

$(SITEDIR)/talks.html: $(SRCDIR)/talks/index.yml $(TALKS_INDEX_TPL) | $(SITEDIR)
	$(PANDOC) $(PANDOC_REVS) -s --template=$(TALKS_INDEX_TPL) -o $@ $<

./rssfeed: bin/rssfeed.go
	go build -mod vendor bin/rssfeed.go

$(SITEDIR)/atom.xml: $(SRCDIR)/index.yml ./rssfeed | $(SITEDIR)
	@echo "Processing RSS feed ..."
	./rssfeed $< $@

feed: $(SITEDIR)/atom.xml

# html implict rule
$(SITEDIR)/%.html: $(SRCDIR)/%.md  $(POST_TPL) | $(SITEDIR)
	mkdir -p `dirname $@`
	$(PANDOC) $(PANDOC_FLAGS) $(PANDOC_REVS) -s --template=$(POST_TPL) -o $@ $<

# static file rules
$(SITEDIR)/%: $(SRCDIR)/% | $(SITEDIR)
	mkdir -p `dirname $@`
	cp $< $@

$(SRCDIR)/css/%.min.css: $(SRCDIR)/css/%.css deps
	./node_modules/sass/sass.js --no-source-map --style compressed $< $@

clean:
	rm -rf ./$(SITEDIR)/
