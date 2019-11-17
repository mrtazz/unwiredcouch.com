#
# Makefile to generate the static version of this blog. I have no idea if this
# will work.
#

SITEDIR ?=docs
FEEDSIZE=10
PANDOC=$(shell which pandoc)
PANDOC_FLAGS=--standalone --from=markdown-hard_line_breaks+yaml_metadata_block+smart --email-obfuscation=none --to=html
PANDOC_DATE_SUB=-M postdate="`gdate -d"$(shell echo $< | grep -o "\d\{4\}-\d\{2\}-\d\{2\}" | sed "s/-//g")" +'%b %d, %Y'`"
POST_TPL  := _layouts/post.pandoc
INDEX_TPL := _layouts/index.pandoc
TALK_TPL  := _layouts/talk.pandoc
TALKS_INDEX_TPL  := _layouts/talkindex.pandoc

STYLE_REV=$(shell git log -n 1 --pretty=format:'%h' css/style.css)
MOBILE_REV=$(shell git log -n 1 --pretty=format:'%h' css/mobile.css)
PANDOC_REVS=-M stylerev="$(STYLE_REV)" -M mobilerev="$(MOBILE_REV)"

# mapping function to get the resulting URL directory structure for a passed
# in source post
define map_url_to_post
$(patsubst %.html, %.md, $(subst ${SITEDIR},_posts, $(shell echo $1 | sed "s/\([0-9]\{4\}\)\/\([0-9]\{2\}\)\/\([0-9]\{2\}\)\//\1-\2-\3-/g")))
endef

define map_post_to_url
$(patsubst %.md, %.html, $(subst _posts,${SITEDIR}, $(shell echo $1 | sed "s/\([0-9]\{4\}\)-\([0-9]\{2\}\)-\([0-9]\{2\}\)-/\1\/\2\/\3\//g")))
endef

static    := $(shell find images css fonts static -type f)
pages     := $(filter-out README.md,$(shell find . -iname "*.md*" | grep -v _posts | grep -v _drafts | grep -v node_modules | sed 's/\.\///g'))
src_posts := $(shell find _posts -name "*.md" )
postdates := $(shell find _posts -name "*.md"  |  grep -o "[a-zA-Z].*\d\{4\}-\d\{2\}-\d\{2\}" | sed "s/posts\///g" | sed "s/-/\//g")
talks     := $(shell find talks -type f )

STATIC := $(patsubst %, ${SITEDIR}/%, $(static))
TALKS  := $(patsubst %.yml, ${SITEDIR}/%.html, $(talks))
PAGES  := $(patsubst %.md, ${SITEDIR}/%.html, $(pages))
POSTDATES := $(patsubst %, ${SITEDIR}/%, $(postdates))
POSTS := $(call map_post_to_url, $(src_posts))

.PHONY: serve all static pages posts clean distclean deploy css index talkindex talks feed

all: css static pages posts index talkindex talks feed favicon

serve: $(SITEDIR)
	cd ${SITEDIR} && php -S 0.0.0.0:8000

.PHONY: deps
deps: node_modules

node_modules:
	npm install sass

$(SITEDIR):
	mkdir -p ${SITEDIR}

$(STATIC): $(addprefix ${SITEDIR}/, %) : ${PWD}/% | $(SITEDIR)
	mkdir -p `dirname $@`
	cp -pr $< $@

$(TALKS): $(addprefix ${SITEDIR}/, %.html) : ${PWD}/%.yml  $(TALK_TPL) | $(SITEDIR)
	mkdir -p `dirname $@`
	$(PANDOC) $(PANDOC_FLAGS) $(PANDOC_REVS) -s --template=$(TALK_TPL) -o $@ $<

.allposts.psv: $(src_posts)
	@echo "Generating post index..."
	for post in $^; do \
		sortdate=`echo $${post} | grep -o '\d\{4\}-\d\{2\}-\d\{2\}' | sed 's/-/ /g'`; \
		title=`grep -m1 "^title: " $${post} | sed 's/title: //g' | sed 's/"//g'`; \
		url=`echo $${post} | sed "s/\([0-9]\{4\}\)-\([0-9]\{2\}\)-\([0-9]\{2\}\)-/\/\1\/\2\/\3\//g" | sed 's/_posts\///g' | sed 's/\.md/\.html/g'  `; \
		echo "$${sortdate}|$${url}|$${title}|$${post}" ; \
		done | sort -r > $@

.allposts.yml: .allposts.psv
	awk -F'|' 'BEGIN{post_year=0; print "---\ntitle: unwiredcouch\nentries:"} \
		{n=split($$1,thedate," "); if (post_year != thedate[1]) { post_year=thedate[1]; print "-\n\tyear: "post_year"\n\tposts:"}; \
		printf("\t\t-\n\t\t\tdate: %s\n\t\t\turl: %s\n\t\t\ttitle: \42%s\42\n\t\t\trawpost: \42%s\42\n", strftime("%b %d, %Y",mktime($$1" 00 00 00")), $$2, $$3, $$4) } \
		END{print "---"}' < $< > $@

$(SITEDIR)/atom.xml: .allposts.psv | $(SITEDIR)
	@echo "Processing RSS feed ..."
	head -n $(FEEDSIZE) $< | awk -f ./bin/rssfeed.awk > $@

feed: $(SITEDIR)/atom.xml

$(SITEDIR)/index.html: .allposts.yml $(INDEX_TPL) | $(SITEDIR)
	$(PANDOC) $(PANDOC_REVS) -s --template=$(INDEX_TPL) -o $@ $<

$(SITEDIR)/talks/index.html: _data/talks.yml $(TALKS_INDEX_TPL) | $(SITEDIR)
	mkdir -p $(SITEDIR)/talks
	$(PANDOC) $(PANDOC_REVS) -s --template=$(TALKS_INDEX_TPL) -o $@ $<

$(SITEDIR)/talks.html: _data/talks.yml $(TALKS_INDEX_TPL) | $(SITEDIR)
	$(PANDOC) $(PANDOC_REVS) -s --template=$(TALKS_INDEX_TPL) -o $@ $<

index: $(SITEDIR)/index.html
talkindex: $(SITEDIR)/talks/index.html $(SITEDIR)/talks.html

$(PAGES): $(addprefix ${SITEDIR}/, %.html) : ${PWD}/%.md  $(POST_TPL) | $(SITEDIR)
	mkdir -p `dirname $@`
	$(PANDOC) $< $(PANDOC_FLAGS) $(PANDOC_REVS) --template $(POST_TPL)  -o $@

$(POSTDATES): | $(SITEDIR)
	@mkdir -p $@

$(SITEDIR)/favicon.ico: favicon.ico | $(SITEDIR)
	cp $< $@

.SECONDEXPANSION:
$(POSTS): % : $$(call map_url_to_post, %)  $(POST_TPL) | $(SITEDIR)
	$(PANDOC) $< $(PANDOC_DATE_SUB) $(PANDOC_FLAGS) $(PANDOC_REVS) --template $(POST_TPL) -o $@

pages:  $(PAGES)
posts:  $(POSTDATES) $(POSTS)
static: $(STATIC)
talks: $(TALKS)
favicon: $(SITEDIR)/favicon.ico

clean:
	@echo "Removing contents in ${SITEDIR}..."
	@rm -rf ./${SITEDIR}/*
	@echo "Removing cache files..."
	@rm -rf ./.allposts*

distclean:
	@echo "Removing ${SITEDIR}..."
	@rm -rf ./${SITEDIR}
	@echo "Removing cache files..."
	@rm -rf ./.allposts*

deploy: all
	rsync -chavzOP --no-perms --stats _site/ unwiredcouch.com:/usr/local/www/unwiredcouch/

css/style.min.css: css/style.css deps
	./node_modules/sass/sass.js --no-source-map --style compressed $< $@

css/mobile.min.css: css/mobile.css deps
	./node_modules/sass/sass.js --no-source-map --style compressed $< $@

css: css/style.min.css css/mobile.min.css
