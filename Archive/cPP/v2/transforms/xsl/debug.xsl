<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!--#####################################
    This file is where debug templates 
	should go.
    #####################################-->

  <!--#####################-->
  <!-- Debugging templates -->
  <!--#####################-->
  <xsl:template name="debug-2">
    <xsl:param name="msg"/>
    <xsl:if test="contains($debug, 'vv')">
      <xsl:message><xsl:value-of select="$msg"/></xsl:message>
    </xsl:if>
  </xsl:template>

  <!-- -->
  <xsl:template name="debug-1">
    <xsl:param name="msg"/>
    <xsl:if test="contains($debug, 'v')">
      <xsl:message><xsl:value-of select="$msg"/></xsl:message>
    </xsl:if>
  </xsl:template>


<!--#####################################
    This template should construct a path
	for the node it is applied to.
	It was copied from 
    https://stackoverflow.com/questions/953197/how-do-you-output-the-current-element-path-in-xslt
    #####################################-->

  <xsl:template name="genPath">
    <xsl:param name="prevPath" select="''"/>
    <xsl:variable name="currPath" select="concat('/',name(),'[',count(preceding-sibling::*[name() = name(current())])+1,']','&quot;',substring(normalize-space(text()),0,10),'&quot;',$prevPath)"/>
    
    <xsl:for-each select="parent::*">
      <xsl:call-template name="genPath">
        <xsl:with-param name="prevPath" select="$currPath"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:if test="not(parent::*)"><xsl:value-of select="$currPath"/></xsl:if>
  </xsl:template>

</xsl:stylesheet>
