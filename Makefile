#
# Makefile to generate the static version of this blog. I have no idea if this
# will work.
#

SITEDIR ?=_site
SRCDIR = src
FEEDSIZE=10
PANDOC=$(shell which pandoc)
PANDOC_FLAGS=--standalone --from=markdown-hard_line_breaks+yaml_metadata_block+smart --email-obfuscation=none --to=html
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
SITE_WITH_HTML_CSS := $(SITE_WITH_HTML:%.css=%.min.css)

.PHONY: serve all static clean css index feed html

all: $(SITE_WITH_HTML_CSS)

serve: $(SITEDIR)
	cd ${SITEDIR} && php -S 0.0.0.0:8000

.PHONY: deps
deps: node_modules

node_modules:
	npm install sass

$(SITEDIR):
	mkdir -p ${SITEDIR}

# TODO: index pages

# TODO: rss feed



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
