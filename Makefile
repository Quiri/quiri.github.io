#!/usr/bin/make -f
.PHONY: publish draft new

ROOT_DIR=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
CACHE_DIR=.
R_DIR=$(CACHE_DIR)/_R
POST_DIR=$(CACHE_DIR)/_posts
IMAGES=images
IMAGE_DIR=$(CACHE_DIR)/$(IMAGES)
NAME=new
DATE=$(shell date +%Y-%m-%d)
NEWPOST=$(DATE)-$(NAME)

RMD_FILES=$(notdir $(wildcard $(R_DIR)/*.Rmd))
MD_FILES=$(RMD_FILES:.Rmd=.md)

publish: $(MD_FILES:%=$(POST_DIR)/%) 

draft: $(MD_FILES:%=$(R_DIR)/%)

new: 
	@mkdir -p '$(R_DIR)'
	@echo "---" > '$(R_DIR)/$(NEWPOST).Rmd'
	@echo "layout: single" >> '$(R_DIR)/$(NEWPOST).Rmd'
	@echo "title: \"$(NAME)\"" >> '$(R_DIR)/$(NEWPOST).Rmd'
	@echo "date: $(DATE)" >> '$(R_DIR)/$(NEWPOST).Rmd'
	@echo "categories: articles" >> '$(R_DIR)/$(NEWPOST).Rmd'
	@echo "tags: []" >> '$(R_DIR)/$(NEWPOST).Rmd'
	@echo "---" >> '$(R_DIR)/$(NEWPOST).Rmd'
	@echo "Created $(R_DIR)/$(NEWPOST).Rmd"

$(R_DIR)/%.md: $(R_DIR)/%.Rmd
	@mkdir -p '$(@D)'	
	Rscript $(R_DIR)/build.R -b '$(CACHE_DIR)' -f '$(IMAGE_DIR)' -o '$@' '$<' \
		&& sed -i "s/\](.*\/$(IMAGES)/]({{ site.url }}\/$(IMAGES)/g" '$@'

$(POST_DIR)/%.md: $(R_DIR)/%.md
	cp '$<' '$@'
