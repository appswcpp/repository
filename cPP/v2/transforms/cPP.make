# Point the default build to a module

SD_HTML ?= $(OUT)/$(BASE)-sd.html
BUILD_SD=$(call DOIT,$(PP_XML),$(TRANS)/xsl/module2sd.xsl,$(SD_HTML))
thedefaulttarget: cpp-target meta-info

include $(TRANS)/Helper.make



