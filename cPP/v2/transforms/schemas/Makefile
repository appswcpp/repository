-include ~/commoncriteria/User.make
SHELL=/bin/bash

#- Path to the Trang java library 
TRANG_JAR?=/workspace/trang-20181222/trang.jar

FLATN=rng-to-html/bin/rng-resolve-includes.py

TOHTML?=rng-to-html/bin/rng-to-html <($(FLATN) $(1)) $(1).html;
TORNC?=java -jar $(TRANG_JAR) -I rng -O rnc  $1 $1.rnc;


files := $(shell grep -l '<start>' *.rng) 

default: docs
#- Builds javadoc-style HTML pages
#- describing the schema
docs:
	$(foreach ff, $(files), $(call TOHTML,$(ff)))

#- Builds RNC files from the RNG schemas. 
#- (Helpful for emacs users)
rncs:
	$(foreach ff, $(files), $(call TORNC,$(ff)))

#- The Help target
help:
	grep '^#-' Makefile -A 1
clean: 
	rm -f *.rnc *.html
