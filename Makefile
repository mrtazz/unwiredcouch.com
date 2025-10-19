SITEDIR                 ?= docs
HUGO_VERSION            := 0.151.0
OS   										:= $(shell uname -s)
DEPS_DIR                := .deps
GOOS                    ?= $(shell go env GOOS)
GOARCH                  ?= $(shell go env GOARCH)
HUGO                    ?= $(DEPS_DIR)/hugo


$(info    SITEDIR is $(SITEDIR))
$(info    HUGO is $(HUGO))
$(info    HUGO_VERSION is $(HUGO_VERSION))
$(info    OS is $(OS))

ifeq ($(OS),Darwin)
# on macOS the dependency are installed via brew
# also the hugo builds are 'universal' and not different by arch
GOARCH=universal
build: macos-deps images
	$(HUGO) --destination $(SITEDIR)
else ifeq ($(OS),Linux)
# install dependencies first on linux hosts (i.e. Actions runners)
build: linux-deps images
	$(HUGO) --destination $(SITEDIR)
else ifeq ($(OS),FreeBSD)
# install dependencies first on linux hosts (i.e. Actions runners)
build: freebsd-deps
	$(HUGO) --destination $(SITEDIR)
else
build:
	echo "Unsupported OS: $(OS)"
	exit 1
endif
.DEFAULT_GOAL := build
.PHONY: build

.PHONY: install-hugo
install-hugo:
	install -d $(DEPS_DIR)
	curl -Lsf https://github.com/gohugoio/hugo/releases/download/v$(HUGO_VERSION)/hugo_$(HUGO_VERSION)_$(GOOS)-$(GOARCH).tar.gz \
		-o $(DEPS_DIR)/hugo_$(HUGO_VERSION)_$(GOOS)-$(GOARCH).tar.gz
	tar xvfz $(DEPS_DIR)/hugo_$(HUGO_VERSION)_$(GOOS)-$(GOARCH).tar.gz -C $(DEPS_DIR)

.PHONY: freebsd-deps
freebsd-deps: install-hugo

.PHONY: linux-deps
linux-deps: install-hugo
	sudo apt-get update && sudo apt-get install -y imagemagick

.PHONY: macos-deps
macos-deps: install-hugo
	brew install imagemagick

serve:
	$(HUGO) server --bind "0.0.0.0" --disableFastRender

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
