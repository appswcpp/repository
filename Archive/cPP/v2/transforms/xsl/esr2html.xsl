<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:esr="http://common-criteria.rhcloud.com/ns/esr" xmlns="http://www.w3.org/1999/xhtml"
	xmlns:fn="http://www.w3.org/2005/xpath-functions" version="1.0">

	<!-- very important, for special characters and umlauts iso8859-1-->
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>


	<xsl:template match="/esr:ESR">
	    <!-- Start with !doctype preamble for valid (X)HTML document. -->
	    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;&#xa;</xsl:text>
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<style type="text/css">
					/*       { background-color: #FFFFFF; } */
					body{
					    margin-left:8%;
					    margin-right:8%;
					    foreground:black;
					}
					td{
					    vertical-align:top;
					}
					div.section{
					    text-align:center;
					    margin-left:0%;
					    margin-top:1em;
					    margin-bottom:1em;
					    border:2px solid #000000;
					    width:100%;
					    background-color:#FFFF99;
					    font-family:arial, helvetica, sans-serif;
					    font-weight:bold;
					    box-shadow:2px 2px 2px #888888;
					}
					div.note{
					    margin-left:10%;
					    margin-right:10%;
					    margin-top:1em;
					}
					
					table.intro{
					    table-layout:fixed;
					    width:100%;
					    margin-top:1em;
					    border:1px solid black;
					    box-shadow:2px 2px 2px #888888;
					    text-align:center;
					    vertical-align:middle;
					    font-family:arial, helvetica, sans-serif;
					}
					ul,
					ol{
					    margin-bottom:0.5em;
					    margin-top:0.5em;
					}
					li{
					    margin-bottom:0.5em;
					    margin-top:0.25em;
					}</style>
			</head>

			<body>
				<xsl:apply-templates select="esr:intro"/>
				<xsl:apply-templates select="//esr:section"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="esr:intro">
		<!-- table with CC logo-->
		<table class="intro">
			<tr>
				<td style="width: 50%;">
					<img style="max-width:100%;" src="images/cclogo.png"/>
				</td>
				<td style="vertical-align: middle;">
					<b>Common Criteria Evaluation and Validation Scheme</b><p/>National Information
					Assurance Partnership (NIAP) </td>
			</tr>
		</table>
		<p/>
		<b>Title: </b>
		<xsl:apply-templates select="esr:esrtitle"/>
		<p/>
		<b>Maintained by: </b>
		<xsl:apply-templates select="esr:maintainer"/>
		<p/>
		<b>Unique Identifier: </b>
		<xsl:apply-templates select="esr:identifier"/>
		<p/>
		<b>Version: </b>
		<xsl:apply-templates select="esr:version"/>
		<p/>
		<b>Status: </b>
		<xsl:apply-templates select="esr:status"/>
		<p/>
		<b>Date of issue: </b>
		<xsl:apply-templates select="esr:issuedate"/>
		<p/>
		<b>Approved by: </b>
		<xsl:apply-templates select="esr:approver"/>
		<p/>
		<b>Supersedes: </b>
		<xsl:apply-templates select="esr:superseded"/>
		<p/>
	</xsl:template>



	<xsl:template match="esr:section">
		<div class="section" id="{@id}">
			<xsl:value-of select="@title"/>
		</div>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="esr:note">
		<div class="note">
			<b>Note: </b>
			<i><xsl:apply-templates/></i>
		</div>
	</xsl:template>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

<!-- ############### -->
<!--            -->
  <xsl:template match="esr:figref">
    <a onclick="showTarget('figure-{@refid}')" href="#figure-{@refid}" class="figure-{@refid}-ref">
      <xsl:variable name="refid"><xsl:value-of select="@refid"></xsl:value-of></xsl:variable>

      <xsl:for-each select="//esr:figure[@id=$refid]">
	<xsl:call-template name="getPre"/>
      </xsl:for-each>
<!--      <xsl:value-of select="//esr:ctr[@id=$refid]">"/>-->
      <span class="counter"><xsl:value-of select="$refid"/></span>
    </a>
  </xsl:template>
  
<!-- ############### -->
<!--            -->
  <xsl:template match="esr:figure">
    <div class="figure" id="figure-{@id}">
      <img id="{@id}" src="{@entity}" width="{@width}" height="{@height}" />
      <p/>
      <span class="ctr" data-myid="figure-{@id}" data-counter-type="ct-figure">
	<xsl:call-template name="getPre"/>
	<span class="counter"><xsl:value-of select="@id"/></span>
      </span>:
      <xsl:value-of select="@title"/>
    </div>
  </xsl:template>

<!-- ############### -->
<!--            -->
  <xsl:template name="getPre">
    <xsl:choose>
      <xsl:when test="@pre"><xsl:value-of select="@pre"/></xsl:when>
      <xsl:when test="name()='figure'"><xsl:text>Figure </xsl:text></xsl:when>
      <xsl:when test="@ctr-type"><xsl:value-of select="@ctr-type"/><xsl:text>  </xsl:text></xsl:when>
      <xsl:otherwise><xsl:text>Table </xsl:text></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
