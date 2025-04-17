SITEDIR                 ?= docs
HUGO                    = $(shell which hugo)
HUGO_VERSION            := 0.146.5
INSTALLED_HUGO_VERSION  = $(shell hugo version)
OS   										:= $(shell uname -s)


$(info    SITEDIR is $(SITEDIR))
$(info    HUGO is $(HUGO))
$(info    HUGO_VERSION is $(HUGO_VERSION))
$(info    INSTALLED_HUGO_VERSION is $(INSTALLED_HUGO_VERSION))
$(info    OS is $(OS))

ifeq ($(OS),Darwin)
# on macOS the dependency are installed via brew
build: images
	$(HUGO) --destination $(SITEDIR)
else ifeq ($(OS),Linux)
# install dependencies first on linux hosts (i.e. Actions runners)
build: linux-deps images
	$(HUGO) --destination $(SITEDIR)
else
build:
	echo "Unsupported OS: $(OS)"
	exit 1
endif
.DEFAULT_GOAL := build
.PHONY: build

.PHONY: linux-deps
linux-deps:
	sudo wget https://github.com/gohugoio/hugo/releases/download/v$(HUGO_VERSION)/hugo_$(HUGO_VERSION)_linux-amd64.deb
	sudo dpkg -i hugo_$(HUGO_VERSION)_linux-amd64.deb
	sudo apt-get update && sudo apt-get install -y imagemagick
	$(info    HUGO is now $(HUGO))
	$(info    HUGO_VERSION is now $(HUGO_VERSION))
	$(info    INSTALLED_HUGO_VERSION is now $(INSTALLED_HUGO_VERSION))

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

$(POSTS_IMAGES_FOLDER)/%large.jpeg: $(POSTS_IMAGES_FOLDER)/%original.jpeg
	convert $< -resize 500x500^ $@

.PHONY: images
images: $(ART_LARGE_ONES) $(ART_THUMBNAILS) $(POSTS_IMAGES_LARGE_ONES)
