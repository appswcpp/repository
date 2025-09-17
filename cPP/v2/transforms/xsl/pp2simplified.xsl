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
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>

	<xsl:template match="/cc:PP">
	    <!-- Start with !doctype preamble for valid (X)HTML document. -->
	    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;&#xa;</xsl:text>
		<html xmlns="http://www.w3.org/1999/xhtml">
		  <style type="text/css">
		    <xsl:call-template name="common_css"/>
		html {
			font-family: verdana, arial, helvetica, sans-serif;
		}
		h1 {
			text-align: center;
			font-size: x-large;
			margin-top: 2em; margin-bottom: 2em;
    }
		h2 {
			font-size: large;
      border-bottom: solid 1px gray;
      margin-top: 2em; margin-bottom: 1em;
		}
    table.revisionhistory {
			margin: auto; margin-top: 1em; border-collapse:collapse;
				font-size:14px;
		}
		th.revisionhistory  {
        border-bottom: 3px solid #dcdcdc;
        border-left: none;
        border-right: none;
        vertical-align: bottom;
				text-align: left;
        padding: 2px;
				padding-right: 20px;
    }
		td.revisionhistory  {
        border: 2px solid #dcdcdc;
        border-left: none;
        border-right: none;
        vertical-align: top;
				text-align: left;
        padding: 2px;
				padding-right: 20px;
    }

		div.componenttitle
		{
			text-align: left; font-size: large; font-weight:bold;
			margin-top: 1em;
			margin-left: 2.5em;
			margin-right: 3em;
			border: solid 2px gray;
      background-color: #dedede;
			padding: 0.25em;
		}
		table.elementstyle
		{
				text-align: left;
				font-size:14px;
				margin-left: 3.5em;
				margin-right: 6em;
				margin-bottom: 2em;
		}
		tr.elementstyle {
			vertical-align: top;

		}
		td.elementidstyle
		{
			font-weight: bold;
			padding-right: 1em;
			padding-top: 1em;
		}
		td.elementstyle {
			padding-top: 1em;
		}

    pre {
        white-space: pre-wrap;
        white-space: -moz-pre-wrap !important;
        word-wrap:break-word;
    }
		div.title
		{
			text-align: center; font-size: xx-large; font-weight:bold;
            font-family: verdana,arial,sans-serif;
			<!--border-bottom: solid 1px gray; -->
			margin-left: 8%; margin-right: 8%;
		}
		div.center	{ display: block; margin-left: auto; margin-right: auto; text-align:center; }
		div.intro
		{
			text-align: left; font-size: normal;
			margin-left: 12%; margin-right: 12%;
			padding-top: 1em;
		}

		div.sectiontitle
		{
			text-align: left; font-size: x-large; font-weight:bold;
			margin-top: 3em;
			border-top: solid 2px gray;
			border-bottom: solid 2px gray;
			padding-bottom: 0.25em; padding-top: 0.25em;
		}
	    div.appnote    { margin-left: 0%; margin-top: 1em; }


    	</style>

			<head>
				<xsl:choose>
					<xsl:when
						test="//cc:ReferenceTable/cc:PPTitle='Protection Profile for Application Software'">
						<title>Requirements for Vetting Mobile Apps from the Protection Profile for
							Application Software</title>
					</xsl:when>
					<xsl:otherwise>
						<title>Requirements from the <i><xsl:apply-templates
									select="cc:PPReference/cc:ReferenceTable/cc:PPTitle"
							/></i></title>
					</xsl:otherwise>
				</xsl:choose>
			</head>
			<body>
				<xsl:choose>
					<xsl:when
						test="//cc:ReferenceTable/cc:PPTitle='Protection Profile for Application Software'">
						<h1> Requirements for Vetting Mobile Apps from the
								<p/><i>Protection Profile for Application Software</i>
						</h1>
					</xsl:when>
					<xsl:otherwise>
						<h1> Requirements from the <br/><i><xsl:apply-templates
									select="cc:PPReference/cc:ReferenceTable/cc:PPTitle"/></i>
						</h1>
					</xsl:otherwise>
				</xsl:choose>

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
						<tr>
							<th class="revisionhistory">Version</th>
							<th class="revisionhistory">Date</th>
							<th class="revisionhistory">Comment</th>
						</tr>
						<xsl:for-each select="cc:RevisionHistory/cc:entry">
							<tr>
								<td class="revisionhistory">
									<xsl:value-of select="cc:version"/>
								</td>
								<td class="revisionhistory">
									<xsl:value-of select="cc:date"/>
								</td>
								<td class="revisionhistory">
									<xsl:apply-templates select="cc:subject"/>
								</td>
							</tr>
						</xsl:for-each>
					</table>
				</div>
				<h2>Introduction</h2>
				<div class="intro">
					<xsl:choose>
						<xsl:when
							test="//cc:ReferenceTable/cc:PPTitle='Protection Profile for Application Software'">
							<b>Purpose.</b> This document presents functional and assurance
							requirements found in the <i>Protection Profile for Application
								Software</i> which are appropriate for vetting mobile application
							software ("apps") <b>outside</b> formal Common Criteria (ISO/IEC 15408)
							evaluations. Common Criteria evaluation, facilitated in the U.S. by the
							National Information Assurance Partnership (NIAP), is required for IA
							and IA-enabled products in National Security Systems according to CNSS
							Policy #11. Such evaluations, including those for mobile apps, must use
							the complete Protection Profile. However, even apps without IA
							functionality may impose some security risks, and concern about these
							risks has motivated the vetting of such apps in government and industry. </xsl:when>
						<xsl:otherwise>
							<b>Purpose.</b> This document presents the functional
							and assurance requirements found in the <i><xsl:apply-templates
									select="cc:PPReference/cc:ReferenceTable/cc:PPTitle"/></i>.
							Common Criteria evaluation, facilitated in the U.S. by the National
							Information Assurance Partnership (NIAP), is required for IA and
							IA-enabled products in National Security Systems according to CNSS
							Policy #11. </xsl:otherwise>
					</xsl:choose>
					<p/>
					<b>Using this document.</b> This representation of the Protection Profile
					includes: <p/>
					<ul>
						<li><a href="#SFRs"><i>Security Functional Requirements</i></a> for use in
							evaluation. These are featured without the formal Assurance Activities
							specified in the Protection Profile, to assist the reader who is
							interested only in the requirements. <p/> It also includes, in tables
							shown later, particular types of security functional requirements that
							are not strictly required in all cases. These are:</li>
						<p/>
						<ul>
							<li><a href="#selbasedSFRs"><i>Selection-based Security Functional
										Requirements</i></a> which become required when certain
								selections are made inside the regular Security Functionality
								Requirements (as indicated by the <b>[selection:]</b>
								construct).</li>
							<li><a href="#objSFRs"><i>Objective Security Functional
									Requirements</i></a> which are highly desired but not yet
								widely-available in commercial technology.</li>
							<li><a href="#optSFRs"><i>Optional Security Functional
									Requirements</i></a> which are available for evaluation and
								which some customers may insist upon.</li>
						</ul> <p/>
						<li><a href="#SARs"><i>Security Assurance Requirements</i></a> which relate
							to developer support for the product under evaluation, development
							processes, and other non-functionality security relevant
							requirements.</li> </ul>
					<p/>
					<xsl:if
						test="//cc:ReferenceTable/cc:PPTitle='Protection Profile for Application Software'"
						> In addition to providing these security requirements for vetting apps,
						this document provides a basis for discussion and consideration of the
						vetting provided by commercially-available app stores. This document does
						not imply to Authorizing Officials that the vetting provided by
						commercially-available app stores is either adequate or inadequate for the
						context in which they must weigh risks. Rather, it is intended to help
						inform and support decision-making with regard to investment in app vetting
						processes. </xsl:if>
					<p/>
				</div>
				<br/>

				<div class="sectiontitle" id="SFRs"> Security Functional Requirements </div>
					<xsl:apply-templates select="//cc:f-component[not(@status) or @status='threshold']"/>
				<!-- <xsl:apply-templates select="//cc:f-component[not(@status='sel-based')]"/> -->

				<div class="sectiontitle" id="SARs"> Security Assurance Requirements </div>
				<table class="elementstyle">
					<xsl:choose>
						<xsl:when
							test="//cc:ReferenceTable/cc:PPTitle='Protection Profile for Application Software'">
							<xsl:apply-templates
								select="//cc:a-element[@id='alc_cmc.1.1c' or @id='ate_ind.1.2e' or @id='ava_van.1.1c' or @id='ava_van.1.2e']"
							/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="//cc:a-element"/>
						</xsl:otherwise>
					</xsl:choose>
				</table>

				<div class="sectiontitle" id="selbasedSFRs"> Selection-Based Security Functional
					Requirements </div>
					<xsl:apply-templates select="//cc:f-component[@status='sel-based']"/>


				<div class="sectiontitle" id="objSFRs"> Objective Security Functional Requirements </div>
					<xsl:apply-templates select="//cc:f-component[@status='objective']"/>

				<div class="sectiontitle" id="optSFRs"> Optional Security Functional Requirements </div>
				<xsl:apply-templates select="//cc:f-component[@status='optional']"/>

			</body>
		</html>
	</xsl:template>

	<xsl:template match="cc:f-component | cc:a-component">
		<xsl:variable name="componentid" select="translate(@id,$lower,$upper)"/>
		<div id="{$componentid}" class="componenttitle">
			<a class="abbr" href="#{$componentid}">
				<xsl:value-of select="@name"/>
			</a>
		</div>
		<table class="elementstyle">
			<xsl:apply-templates select=".//cc:f-element | .//cc:a-element"/>
		</table>
	</xsl:template>

	<xsl:template match="cc:f-element | cc:a-element">
	  <xsl:variable name="elementid" select="translate(@id,$lower,$upper)"/>
	  <tr class="elementstyle">
	    <td id="{$elementid}" class="elementidstyle">
	      <a class="abbr" href="#{$elementid}">
		<xsl:value-of select="$elementid"/>
	      </a>
	    </td>
	    <td class="elementstyle">
	      <xsl:apply-templates select="cc:title"/>
	      <br/>
	      <xsl:choose>
		<xsl:when test="@status='objective'">
		  <p/>
		  <i>
		    <b>This is currently an objective requirement.
		    <xsl:if test="../@targetdate">
		      It is targeted for <xsl:value-of select="../@targetdate"/>.
		    </xsl:if>
		    </b>
		  </i>
		  <br/>
		</xsl:when>
		<xsl:when test="@status='sel-based'">
		  <p/>
		  <b>
		    <i>This is a selection-based requirement. Its inclusion depends upon
		    selection in <xsl:for-each select="cc:selection-depends">
		    <xsl:value-of select="translate(@req, $lower, $upper)"/>
		    <xsl:if test="position() != last()"
			    ><xsl:text>, </xsl:text></xsl:if>
		    </xsl:for-each>. </i>
		  </b>
		  <br/>
		  <br/>
		</xsl:when>
	      </xsl:choose>

	      <xsl:apply-templates select="cc:note[@role='application']"/>
	    </td>
	  </tr>
	</xsl:template>

	<xsl:template match="cc:title">
		<xsl:apply-templates/>
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




</xsl:stylesheet>
