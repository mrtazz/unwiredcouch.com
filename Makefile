#
# Makefile to generate the static version of this blog. I have no idea if this
# will work.
#

SITEDIR ?=_site
SRCDIR = src
FEEDSIZE=10
PANDOC=$(shell which pandoc)
PANDOC_FLAGS=--standalone --from=markdown-hard_line_breaks+yaml_metadata_block+smart --email-obfuscation=none --to=html
PANDOC_DATE_SUB=-M postdate="`gdate -d"$(shell echo $< | grep -o "\d\{4\}-\d\{2\}-\d\{2\}" | sed "s/-//g")" +'%b %d, %Y'`"
POST_TPL  := layouts/post.pandoc
INDEX_TPL := layouts/index.pandoc
TALK_TPL  := layouts/talk.pandoc
TALKS_INDEX_TPL  := layouts/talkindex.pandoc

STYLE_REV=1 #$(shell git log -n 1 --pretty=format:'%h' css/style.css)
MOBILE_REV=1 #$(shell git log -n 1 --pretty=format:'%h' css/mobile.css)
PANDOC_REVS=-M stylerev="$(STYLE_REV)" -M mobilerev="$(MOBILE_REV)"

src_markdown := $(shell find src -name "*.md" )

HTML_FILES := $(patsubst $(SRCDIR)/%.md, ${SITEDIR}/%.html, $(src_markdown))

.PHONY: serve all static pages posts clean distclean deploy css index talkindex talks feed html

all: css static pages posts index talkindex talks feed favicon
html: $(HTML_FILES)

serve: $(SITEDIR)
	cd ${SITEDIR} && php -S 0.0.0.0:8000

.PHONY: deps
deps: node_modules

node_modules:
	npm install sass

$(SITEDIR):
	mkdir -p ${SITEDIR}

$(SITEDIR)/%.html: $(SRCDIR)/%.md  $(POST_TPL) | $(SITEDIR)
	mkdir -p `dirname $@`
	$(PANDOC) $(PANDOC_FLAGS) $(PANDOC_REVS) -s --template=$(POST_TPL) -o $@ $<

# static file rules
$(SITEDIR)/favicon.ico: $(SRCDIR)/favicon.ico | $(SITEDIR)
	cp $< $@

$(SITEDIR)/css/%: $(SRCDIR)/css/% | $(SITEDIR)
	cp $< $@

$(SITEDIR)/images/%: $(SRCDIR)/images/% | $(SITEDIR)
	cp $< $@


# TODO: index pages
# TODO: rss feed


css/style.min.css: css/style.css deps
	./node_modules/sass/sass.js --no-source-map --style compressed $< $@

css/mobile.min.css: css/mobile.css deps
	./node_modules/sass/sass.js --no-source-map --style compressed $< $@

css: css/style.min.css css/mobile.min.css
