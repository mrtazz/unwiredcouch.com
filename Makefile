SITEDIR ?=_site
HUGO=$(shell which hugo)

.DEFAULT_GOAL := build
.PHONY: build
build: images
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

###
# image conversion for posts
###

POSTS_IMAGES_FOLDER     := static/images/posts
POSTS_IMAGES_ORIGINALS  := $(shell find $(POSTS_IMAGES_FOLDER) -name "*original.jpeg")
POSTS_IMAGES_LARGE_ONES := $(patsubst $(POSTS_IMAGES_FOLDER)/%original.jpeg,$(POSTS_IMAGES_FOLDER)/%large.jpeg,$(POSTS_IMAGES_ORIGINALS))

$(info    POSTS_IMAGES_ORIGINALS is $(POSTS_IMAGES_ORIGINALS))
$(info    POSTS_IMAGES_LARGE_ONES is $(POSTS_IMAGES_LARGE_ONES))

$(POSTS_IMAGES_FOLDER)/%large.jpeg: $(POSTS_IMAGES_FOLDER)/%original.jpeg
	convert $< -resize 500x500^ $@

.PHONY: images
images: $(ART_LARGE_ONES) $(ART_THUMBNAILS) $(POSTS_IMAGES_LARGE_ONES)
