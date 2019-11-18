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

STYLE_REV=1 #$(shell git log -n 1 --pretty=format:'%h' css/style.css)
MOBILE_REV=1 #$(shell git log -n 1 --pretty=format:'%h' css/mobile.css)
PANDOC_REVS=-M stylerev="$(STYLE_REV)" -M mobilerev="$(MOBILE_REV)"

src_markdown := $(shell find src -name "*.md" )
src_images := $(shell find src/images -type f )

HTML_FILES := $(src_markdown:$(SRCDIR)/%.md=${SITEDIR}/%.html)
IMAGE_FILES := $(src_images:$(SRCDIR)/%=${SITEDIR}/%)

.PHONY: serve all static pages posts clean distclean deploy css index talkindex talks feed html

all: css images favicon html images
html: $(HTML_FILES)
images:$(IMAGE_FILES)
favicon: $(SITEDIR)/favicon.ico

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


$(SRCDIR)/css/%.min.css: css/%.css deps
	./node_modules/sass/sass.js --no-source-map --style compressed $< $@

css: $(SITEDIR)/css/style.min.css $(SITEDIR)/css/mobile.min.css
