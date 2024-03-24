SITEDIR ?=_site
HUGO=$(shell which hugo)

.PHONY: build

build:
	$(HUGO)

serve:
	$(HUGO) server


###
# image conversion tasks for art posts
###

ART_ORIGINALS  := $(shell find static/images/art -name "original.jpeg")
ART_LARGE_ONES := $(patsubst static/images/art/%/original.jpeg,static/images/art/%/large.jpeg,$(ART_ORIGINALS))
ART_THUMBNAILS := $(patsubst static/images/art/%/original.jpeg,static/images/art/%/thumbnail.jpeg,$(ART_ORIGINALS))


static/images/art/%/large.jpeg: static/images/art//%/original.jpeg
	convert $< -resize 500x500^ $@

static/images/art/%/thumbnail.jpeg: static/images/art/%/original.jpeg
	convert $< -resize 250x250^ $@

.PHONY: images
images: $(ART_LARGE_ONES) $(ART_THUMBNAILS)
