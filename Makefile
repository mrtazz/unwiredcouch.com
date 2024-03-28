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

ART_ORIGINALS  := $(shell find assets/images/art -name "*original.jpeg")
ART_LARGE_ONES := $(patsubst assets/images/art/%original.jpeg,assets/images/art/%large.jpeg,$(ART_ORIGINALS))
ART_THUMBNAILS := $(patsubst assets/images/art/%original.jpeg,assets/images/art/%thumbnail.jpeg,$(ART_ORIGINALS))


assets/images/art/%large.jpeg: assets/images/art/%original.jpeg
	convert $< -resize 500x500^ $@

assets/images/art/%thumbnail.jpeg: assets/images/art/%original.jpeg
	convert $< -resize 250x250^ $@

.PHONY: images
images: $(ART_LARGE_ONES) $(ART_THUMBNAILS)
