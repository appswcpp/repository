<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cc="https://niap-ccevs.org/cc/v1" xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:xhtml="http://www.w3.org/1999/xhtml">

	<!-- This style sheet takes as input a Protection Profile expressed in XML and
	outputs a table of the SFRs and SARs. -->


	<!-- Put all common templates into ProtectionProfileCommons -->
	<!-- They can be redefined/overridden  -->
	<xsl:include href="ppcommons.xsl"/>

	<!-- very important, for special characters and umlauts iso8859-1-->
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

	<xsl:variable name="doctype"><xsl:value-of select="local-name(/cc:*)"/></xsl:variable>

	<!-- <xsl:template match="/cc:PP"> -->
	<xsl:template match="/">
	    <!-- Start with !doctype preamble for valid (X)HTML document. -->
	    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;&#xa;</xsl:text>
		<html xmlns="http://www.w3.org/1999/xhtml">
			<style type="text/css">
			  <xsl:call-template name="common_css"/>
				h1
				{
				    text-align:left;
				    font-size:200%;
				    margin-top:2em;
				    margin-bottom:2em;
				    font-family:verdana, arial, helvetica, sans-serif;
				    margin-bottom:1.0em;
				}
				h1.title
				{
				    text-align:center;
				}
				h2
				{
				    font-size:125%;
				    border-bottom:solid 1px gray;
				    margin-bottom:1.0em;
				    margin-top:2em;
				    margin-bottom:0.75em;
				    font-family:verdana, arial, helvetica, sans-serif;
				}
				table.revisionhistory
				{
				    margin:auto;
				    margin-top:1em;
				    border-collapse:collapse;
				}
				tr.header
				{
				    border-bottom:3px solid gray;
				    padding:8px 8px;
				    text-align:left;
				    font-weight:bold;
				}
				table
				{
				    border-collapse:collapse;
				}
				table,
				th,
				td
				{
				    border-collapse:collapse;
				    border:2px solid #dcdcdc;
				    border-left:none;
				    border-right:none;
				    vertical-align:top;
				    text-align:left;
				    padding:2px;
				    font-family:verdana, arial, sans-serif;
				    font-size:11px;
				    padding-right:20px;
				}
				pre{
				    white-space:pre-wrap;
				    white-space:-moz-pre-wrap !important;
				    word-wrap:break-word;
				}
				table tr:nth-child(2n+2){
				    background-color:#f4f4f4;
				}
				thead
				{
				    display:table-header-group;
				    font-weight:bold;
				    background-color:#dedede;
				}
				div.title
				{
				    text-align:center;
				    font-size:xx-large;
				    font-weight:bold;
				    font-family:verdana, arial, sans-serif;
				    margin-left:8%;
				    margin-right:8%;
				}
				div.center
				{
				    display:block;
				    margin-left:auto;
				    margin-right:auto;
				    text-align:center;
				}
				div.intro
				{
				    text-align:left;
				    font-size:normal;
				    font-family:verdana, arial, sans-serif;
				    margin-left:12%;
				    margin-right:12%;
				    padding-top:1em;
				}
				div.appnote
				{
				    margin-left:0%;
				    margin-top:1em;
				}
				div.tabletitle
				{
				    text-align:left;
				    font-size:x-large;
				    font-weight:bold;
				    font-family:verdana, arial, sans-serif;
				    margin-top:2em;
				    border-top:solid 2px gray;
				    border-bottom:solid 2px gray;
				    padding-bottom:0.25em;
				    padding-top:0.25em;
				}
			</style>

			<head>
				<title>Tabular Presentation of the <xsl:value-of
						select="/cc:PP/cc:PPReference/cc:ReferenceTable/cc:PPTitle"/></title>
			</head>
			<body>
				<h1 class="title"> Tabular Presentation of the <br/><i><xsl:value-of
							select="/cc:PP/cc:PPReference/cc:ReferenceTable/cc:PPTitle"/></i>
				</h1>
				<div class="center">
					<xsl:choose>
					<xsl:when test="not (//cc:pp-preferences/cc:suppress-niap-logo)">
						<img src="images/niaplogo.png" alt="NIAP Logo"/> 
					</xsl:when>
					<xsl:otherwise>
			<br/><br/><br/><br/>    <!-- <img src="images/cclogo.png" alt="Common Criteria Logo"/> -->
					</xsl:otherwise>
					</xsl:choose>		
					<p/>Version: <xsl:value-of select="//cc:ReferenceTable/cc:PPVersion"/>
					<p/><xsl:value-of select="//cc:ReferenceTable/cc:PPPubDate"/>
<!--					<p/><xsl:if test="//cc:ReferenceTable/cc:dateTimeStamp">
						<xsl:value-of select="current-dateTime()"/> 
					</xsl:if>  -->
					<p/><b><xsl:value-of select="//cc:PPAuthor"/></b>
				</div>
				<h2>Revision History</h2>
				<div class="center">
					<table class="revisionhistory">
						<tr class="header">
							<th>Version</th>
							<th>Date</th>
							<th>Comment</th>
						</tr>
						<xsl:for-each select="cc:RevisionHistory[@role=$release]/cc:entry">
							<tr>
								<td>
									<xsl:value-of select="cc:version"/>
								</td>
								<td>
									<xsl:value-of select="cc:date"/>
								</td>
								<td>
									<xsl:value-of select="cc:subject"/>
								</td>
							</tr>
						</xsl:for-each>
					</table>
				</div>

				<br/>
				<h2>Introduction</h2>

				<div class="intro"> This document presents the Security Functional Requirements and
					Security Assurance Requirements from the <i><xsl:value-of
							select="/cc:PP/cc:PPReference/cc:ReferenceTable/cc:PPTitle"/></i>. This
					tabular representation is provided for those audiences whose interest primarily
					lies in those portions of that document. The Protection Profile itself remains
					the only complete and authoritative representation, and includes discussion of
					assumptions, threats, and objectives. </div>
				<br/>

				<div class="tabletitle"> Security Functional Requirements </div>
				<table>
					<thead>
						<td>ID</td>
						<td>Requirement</td>
						<td>Assurance Activity</td>
					</thead>

					<xsl:apply-templates select="/cc:PP//cc:f-element"/>
					<xsl:apply-templates select="//cc:man-sfrs//cc:f-element"/>
					<xsl:if test="//cc:modified-sfrs//cc:f-element"><tr><td colspan="3">Modified SFRs</td></tr></xsl:if>
					<xsl:apply-templates select=".//cc:modified-sfrs//cc:f-element"/>
					<xsl:if test="//cc:opt-sfrs//cc:f-element"><tr><td colspan="3">Optional SFRs</td></tr></xsl:if>
					<xsl:apply-templates select=".//cc:opt-sfrs//cc:f-element"/>
					<xsl:if test="//cc:sel-sfrs//cc:f-element"><tr><td colspan="3">Selection-based SFRs</td></tr></xsl:if>
					<xsl:apply-templates select=".//cc:sel-sfrs//cc:f-element"/>
					<xsl:if test="//cc:obj-sfrs//cc:f-element"><tr><td colspan="3">Objective SFRs</td></tr></xsl:if>
					<xsl:apply-templates select=".//cc:obj-sfrs//cc:f-element"/>
					<xsl:if test="//cc:impl-dep-sfrs//cc:f-element"><tr><td colspan="3">Implementation-dependent SFRs</td></tr></xsl:if>
					<xsl:apply-templates select=".//cc:imp-dep-sfrs//cc:f-element"/>

					
					<xsl:for-each select="//cc:base-pp[.//f-element]">
					  <tr><td colspan="3"><xsl:value-of select="@id"/></td></tr>
					  <xsl:if test="cc:modified-sfrs//cc:f-element"><tr><td colspan="3">Modified SFRs</td></tr></xsl:if>
					  <xsl:apply-templates select=".//cc:modified-sfrs//cc:f-element"/>
					  <xsl:if test="cc:additional-sfrs//cc:f-element"><tr><td colspan="3">Additional SFRs</td></tr></xsl:if>
					  <xsl:apply-templates select=".//cc:additional-sfrs//cc:f-element"/>
					</xsl:for-each>
				</table>
				<div class="tabletitle"> Security Assurance Requirements </div>
				<table>
					<thead>
						<td>ID</td>
						<td>Requirement</td>
						<td>Assurance Activity</td>
					</thead>

					<xsl:apply-templates select="//cc:a-element"/>
				</table>
				<div class="tabletitle">Glossary</div>
				<xsl:apply-templates select="//cc:glossary"/>
			</body>
		</html>
	</xsl:template>


	<xsl:template match="cc:f-element | cc:a-element">
	  <xsl:variable name="reqid"><xsl:apply-templates select="." mode="getId"/></xsl:variable>
	  <xsl:variable name="componentid" select="translate(../@id,$lower,$upper)"/>
	  <tr>
	    <td id="{$reqid}">
	      <a class="abbr" href="#{$reqid}">
		<xsl:value-of select="$reqid"/>
	      </a>
	    </td>
	    <td>
	      <xsl:apply-templates select="cc:title"/>
	      <br/>
	      <xsl:choose>
		<xsl:when test="../@status='objective'">
		  <br/>
		  <i>
		    <b>This is currently an objective requirement. 
		    <xsl:if test="../@targetdate">
		      It is targeted for <xsl:value-of select="../@targetdate"/>.
		    </xsl:if></b>
		  </i>
		  <br/>
		</xsl:when>
		<xsl:when test="../@status='optional'">
		  <div class="statustag">
		    <p/>
		    <i>
		      <b>This is an optional requirement. It may be required by Extended
		      Packages of this Protection Profile.</b>
		    </i>
		  </div>
		</xsl:when>
		
		<xsl:when test="../@status='sel-based'">
		  <br/>
		  <b>
		    <i>This is a selection-based requirement. Its inclusion depends upon
		    selection in <xsl:for-each select="cc:selection-depends">
		    <xsl:value-of select="translate(@req, $lower, $upper)"/>
		    <xsl:if test="position() != last()"
			    ><xsl:text>, </xsl:text></xsl:if>
		    </xsl:for-each>. </i>
		  </b>
		  <br/>
		</xsl:when>
	      </xsl:choose>
	      
	      <xsl:apply-templates select="cc:note[@role='application']"/>
	    </td>
	    <td>
	      <xsl:apply-templates select="cc:aactivity"/>
	    </td>
	  </tr>
	</xsl:template>

	<xsl:template match="cc:title">
		<xsl:apply-templates/>
	</xsl:template>


	<xsl:template match="cc:f-component | cc:a-component">
		<xsl:variable name="family" select="substring(@id,1,7)"/>
		<xsl:variable name="component" select="substring(@id,1,9)"/>
		<xsl:variable name="SFRID" select="@id"/>
		<div class="comp">
			<h4>
				<xsl:value-of select="concat(translate(@id, $lower, $upper), ' ')"/>
				<xsl:value-of select="@name"/>
			</h4>
			<xsl:apply-templates/>
		</div>
	</xsl:template>


	<!-- getting rid of XHTML namespace -->
	<xsl:template match="xhtml:*">
		<xsl:element name="{local-name()}">
			<xsl:apply-templates select="node()|@*"/>
		</xsl:element>
	</xsl:template>


	<xsl:template match="cc:aactivity">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>


	<xsl:template match="cc:glossary">
	  <table style="width: 100%;">
	    <xsl:for-each select="cc:entry">
              <tr>
		<td>
		  <xsl:apply-templates select="cc:term"/>
		</td>
		<td>
		  <xsl:apply-templates select="cc:description"/>
		</td>
              </tr>
	    </xsl:for-each>
	  </table>
	</xsl:template>
	<xsl:template match="cc:glossary/cc:entry/cc:term/cc:abbr">
	  <span id="abbr_{text()}"><xsl:value-of select="@title"/> (<abbr><xsl:value-of select="text()"
          /></abbr>)</span>
	</xsl:template>
	<xsl:template
	    match="cc:abbr[contains(concat('|', translate(@class, ' ', '|'), '|'), '|expanded|')]">
	<xsl:value-of select="@title"/> (<xsl:copy><xsl:apply-templates select="@*|node()"/></xsl:copy>) </xsl:template>
	

</xsl:stylesheet>
