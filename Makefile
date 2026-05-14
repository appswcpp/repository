BASE=application
DIFF_TAGS=v1.4
TRANS?=transforms
SD_HTML ?= $(OUT)/$(BASE)-sd.html
BUILD_SD=$(call DOIT,$(PP_XML),$(TRANS)/xsl/module2sd.xsl,$(SD_HTML))
.DEFAULT_GOAL := cpp-release

# Let user's include their own makefiles (if they exist)
-include User.make
-include ~/commoncriteria/User.make
include $(TRANS)/Helper.make

cpp-release: release $(PP_HTML) meta-info

#APP_RECIPROCITY_WORKSHEET=$(OUT)/application-vetting-report-sample.html
#all: $(APP_RECIPROCITY_WORKSHEET)
#$(APP_RECIPROCITY_WORKSHEET): schema/results2vettingreport.xsl schema/results-example.xml
#	xsltproc -o $(APP_RECIPROCITY_WORKSHEET) schema/results2vettingreport.xsl schema/results-example.xml
