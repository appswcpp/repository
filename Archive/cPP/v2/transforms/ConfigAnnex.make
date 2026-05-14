# This file is intentially not called [Mm]akefile, because it is not meant to be called
# directly. Rather the project directory should have a "Makefile" that
# defines all the environment variables then includes this one.
# For example:
#   ```
#   TRANS?=transforms
#   include $(TRANS)/ConfigAnnex.make
#   ```

#---
#- Config Annex Build targets
#---

#- Path to input files
IN ?= input

#- Path where output files are written
OUT ?= output

#- FPath
TRANS ?= transforms

#- Debugging levels '','v','vv' make sense right now.
DEBUG ?= v

#- XSL containing templates common to the other transforms
PPCOMMONS_XSL ?= $(TRANS)/xsl/ppcommons.xsl

#- Path to input XML document for the config annex
CONFIGANNEX_XML ?= $(IN)/configannex.xml

#- XSL that creates regular config annex document
CONFIGANNEX2HTML_XSL ?= $(TRANS)/xsl/configannex2html.xsl

#- Path where the config annex is written
CONFIGANNEX_HTML ?= $(OUT)/configannex.html

#- Your xsl transformer.
#- It should be at least XSL level-1 compliant.
#- It should be able to handle commands of the form
#- $XSL_EXE [--string-param <param-name> <param-value>]* -o <output> <xsl-file> <input>
XSL_EXE ?= xsltproc --stringparam debug '$(DEBUG)'
#---
#- Build targets
#---
#- Builds all
new-default: default $(CONFIGANNEX_HTML)

#- Build Config Annex
$(CONFIGANNEX_HTML): $(CONFIGANNEX2HTML_XSL) $(PPCOMMONS_XSL) $(CONFIGANNEX_XML)
	$(call DOXSL,$(CONFIGANNEX_XML), $(CONFIGANNEX2HTML_XSL),$(CONFIGANNEX_HTML))
