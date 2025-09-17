<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
		xmlns:rng="http://relaxng.org/ns/structure/1.0"
		version="1.0"
		extension-element-prefixes="rng a">

  <xsl:param name="title">Common Criteria Protection Profile Schema Documentation</xsl:param>
  <xsl:param name="target"/>

  <xsl:output encoding="utf-8" indent="yes"/>

  <!-- ################################################## -->
  <xsl:template match="rng:grammar">
  <html>
    <head>
      <title><xsl:value-of select="$title"/></title>
      <link rel="stylesheet" href="https://storage.googleapis.com/code.getmdl.io/1.0.6/material.indigo-pink.min.css"/>
      <script src="https://storage.googleapis.com/code.getmdl.io/1.0.6/material.min.js"></script>
      <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons"/>
      <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700" type="text/css"/>
      <script type="text/javascript">
	function hideOrShow(divnod){
          var cn=divnod.getElementsByTagName('code')[0]; 
          var but=divnod.getElementsByTagName('div')[0].getElementsByTagName('a')[0];
	  if(cn.style.display=='none'){
	    cn.style.display='block';
	    but.text='Hide Source';
          }
	  else{
	    cn.style.display='none';
	    but.text='Show Source';
	  }
	}
      </script>

      <style type="text/css">
        .material-icons {
          line-height: 2;
          }
       	.myButton {
       	background-color:#44c767;
       	-moz-border-radius:28px;
       	-webkit-border-radius:28px;
       	border-radius:28px;
       	border:1px solid #18ab29;
       	display:inline-block;
       	cursor:pointer;
       	color:#ffffff;
       	font-family:Arial;
       	font-size:17px;
       	padding:3px 25px;
       	text-decoration:none;
       	text-shadow:0px 1px 0px #2f6627;
       	}
       	.myButton:hover {
       	background-color:#5cbf2a;
       	}
       	.myButton:active {
       	position:relative;
       	top:1px;
       	}
       	.buttondiv{
       	  padding-top:8px;
       	}
       	.attrtab{
       	  border: thin solid black;
       	  border-collapse: collapse;
       	}
       	.attrtab td{
       	  padding: 5px;  
       	}
	.mdl-layout__drawer .mdl-navigation .mdl-navigation__link{
	   padding-top: 0em;
	   padding-left: 1em;
	   padding-bottom: 1em;
	   padding-right: 0em;
	}
      </style>
    </head>
    <body>
      <!-- The drawer is always open in large screens. The header is always shown,
  			 even in small screens. -->
      <div class="mdl-layout mdl-js-layout
        mdl-layout--fixed-header">
        <header class="mdl-layout__header">
          <div class="mdl-layout__header-row">
            <span class="mdl-layout-title">Common Criteria Protection Profile Schema Documentation</span>
            <div class="mdl-layout-spacer"></div>
          </div>
        </header>
        <div class="mdl-layout__drawer">
          <span class="mdl-layout-title">Index</span>
          <nav class="mdl-navigation">


	    <xsl:for-each select="//rng:element">
	      <xsl:sort select="@name|rng:name" order="ascending"/>
	      <a class="mdl-navigation__link">
		<xsl:attribute name="href">#<xsl:call-template name="makeid"><xsl:with-param name="node" select="."/></xsl:call-template></xsl:attribute>
		<xsl:value-of select="@name"/>
		</a>
	    </xsl:for-each>
            <hr></hr>
            <span class="mdl-layout-title">Patterns</span>
            <br></br>
	    <xsl:for-each select="//rng:define">
	      <xsl:sort select="@name|rng:name" order="ascending"/>
	      <a class="mdl-navigation__link">
		<xsl:attribute name="href">#<xsl:value-of select="@name"/></xsl:attribute>
		%<xsl:value-of select="@name"/>
		</a>
	    </xsl:for-each>
          </nav>
        </div>
        <main class="mdl-layout__content">
          <div class="page-content">
            <!-- Your content goes here -->
            <div style="padding-left:1em;padding-top:1em">
             	<h4>Grammar Documentation</h4>
             	<h5>Namespace: <xsl:value-of select="@ns"/></h5>
		<h5>Root Element: 
		<a>
		  <xsl:attribute name="href">
		    #<xsl:value-of select="/rng:grammar/rng:start/rng:element/@name"/>
		  </xsl:attribute>
		  <xsl:value-of select="/rng:grammar/rng:start/rng:element/@name"/> 
		</a>
		</h5>
             	<xsl:choose>
             	  <xsl:when test="$target">
             	    <xsl:apply-templates select="//rng:element[@name=$target or rng:name=$target]"/>
             	    <xsl:apply-templates select="//rng:define[@name=$target]"/>
             	  </xsl:when>
             	  <xsl:otherwise>
             	    <xsl:apply-templates select="//rng:element">
             	      <xsl:sort select="@name|rng:name" order="ascending"/>
             	    </xsl:apply-templates>
             	    <xsl:apply-templates select="//rng:define">
             	      <xsl:sort select="@name" order="ascending"/>
             	    </xsl:apply-templates>
             	  </xsl:otherwise>
             	</xsl:choose>
            </div>
          </div>
        </main>
      </div>
    </body>
  </html>
  </xsl:template>

  <!-- ################################################## -->
  <xsl:template match="rng:element">
    <xsl:variable name="name" select="@name|rng:name"/>
    <xsl:variable name="nsuri">
      <xsl:choose>
	<xsl:when test="ancestor::rng:div[@ns]">
	  <xsl:value-of select="ancestor::rng:div[@ns][1]/@ns"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="ancestor::rng:grammar[@ns][1]/@ns"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="nsprefix">
      <xsl:if test="$nsuri">
	<xsl:value-of select="name(namespace::*[.=$nsuri])"/>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="qname">
      <xsl:choose>
	<xsl:when test="not($nsprefix='')">
	  <xsl:value-of select="$nsprefix"/>:<xsl:value-of select="$name"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="$name"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <hr/>
      <h4>
	<xsl:attribute name="id"><xsl:call-template name="makeid"><xsl:with-param name="node" select="."/></xsl:call-template></xsl:attribute>
        <b>Element: </b><xsl:value-of select="$qname"/>
      </h4>

      <table role="element">
	    <xsl:if test="not($nsuri='')">
	      <tr>
		<td style="font-weight: bold">Namespace</td>
		<td><xsl:value-of select="$nsuri"/></td>
	      </tr>
	    </xsl:if>
	    <xsl:if test="a:documentation">
	      <tr>
		<td style="font-weight: bold">Documentation</td>
		<td>
		  <xsl:choose>
		    <xsl:when test="a:documentation">
		      <xsl:apply-templates select="a:documentation"/>
		    </xsl:when>
		    <xsl:otherwise>
		      <para></para>
		    </xsl:otherwise>
		  </xsl:choose>
		</td>
	      </tr>
	    </xsl:if>
	    <tr>
	      <td style="font-weight: bold">Content Model</td>
	      <td><xsl:apply-templates mode="content-model"/></td>
	    </tr>

	    <xsl:variable name="hasatts">
	      <xsl:apply-templates select="." mode="has-attributes"/>
	    </xsl:variable>
	    <xsl:if test="starts-with($hasatts, 'true')">
	      <tr>
		<td style="font-weight: bold">Attributes: </td>
		<table class="attrtab" border="1">
		  <tr>
		      <td style="font-weight: bold">Attribute</td>
		      <td style="font-weight: bold">Type</td>
		      <td style="font-weight: bold">Use</td>
		      <td style="font-weight: bold">Documentation</td>
		  </tr>
		    <xsl:variable name="nesting" select="count(ancestor::rng:element)"/>
		    <xsl:apply-templates select=".//rng:attribute[count(ancestor::rng:element)=$nesting+1] | .//rng:ref[count(ancestor::rng:element)=$nesting+1]" mode="attributes">
		      <xsl:with-param name="matched" select="."/>
		      <xsl:with-param name="optional"><xsl:value-of select="false()"/></xsl:with-param>
		    </xsl:apply-templates>
		</table>
	      </tr>
	    </xsl:if>
      </table>
      <div onClick="hideOrShow(this)">
	<div class="buttondiv"><a class="myButton">Show Source</a></div><br/>
      <code style="display: none">
	<xsl:apply-templates select="." mode='print-direct'/>
      </code>
      </div>
  </xsl:template>

  <!-- ################################################## -->
  <xsl:template match="rng:attribute" mode="attributes">
    <xsl:param name="matched"/>
    <xsl:param name="optional"/>
    <tr>
      <!-- Attribute name -->
      <td><xsl:value-of select="@name"/></td>
      <!-- Definition -->
      <td>
	<xsl:choose>
	  <xsl:when test="rng:data">
	    xsd:<xsl:value-of select="rng:data/@type"/>
	  </xsl:when>
	  <xsl:when test="rng:text">
	    TEXT
	  </xsl:when>
	  <xsl:when test="rng:choice">
	    Enumeration:<xsl:text> </xsl:text>
	    <xsl:for-each select="rng:choice/rng:value">
	      "<xsl:value-of select="."/>"
	      <xsl:if test="following-sibling::*"> | </xsl:if>
	    </xsl:for-each> 
	  </xsl:when>
	  <xsl:when test="rng:value">
	    "<xsl:value-of select="."/>"
	  </xsl:when>
	  <xsl:otherwise>TEXT</xsl:otherwise>
	</xsl:choose>
      </td>
      <!-- Use -->
      <td>
	<xsl:choose>
	  <xsl:when test="ancestor::rng:optional">Optional</xsl:when>
	  <xsl:when test="boolean($optional)">Optional</xsl:when>
	  <xsl:otherwise>Required</xsl:otherwise>
	</xsl:choose>
      </td>
      <!-- Documentation -->
      <td>
	    <xsl:apply-templates select="a:documentation[1]"/>
      </td>
    </tr>
  </xsl:template>

  <!-- ################################################## -->
  <xsl:template match="rng:ref" mode="attributes">
    <xsl:param name="matched"/>
    <xsl:param name="optional"/>
    <xsl:variable name="name" select="@name"/>
    <xsl:variable name="opt" select="count(ancestor::rng:optional) > 0"/>
    <xsl:apply-templates select="//rng:define[@name=$name]" mode="attributes">
      <xsl:with-param name="matched" select="$matched"/>
      <xsl:with-param name="optional" select="boolean($optional) or boolean($opt)"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- ################################################## -->
  <xsl:template match="rng:define" mode="attributes">
    <xsl:param name="matched"/>
    <xsl:param name="optional"/>
    <xsl:if test="not(count(matched)=count(matched|.))">
      <xsl:apply-templates select=".//rng:attribute[not(ancestor::rng:element)] | .//rng:ref[not(ancestor::rng:element)]" mode="attributes">
	<xsl:with-param name="matched" select="$matched|."/>
	<xsl:with-param name="optional" select="$optional or ancestor::rng:optional"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <!-- ################################################## -->
  <xsl:template match="rng:element" mode="has-attributes">
    <xsl:choose>
      <xsl:when test=".//rng:attribute[count(ancestor::rng:element)=count(current()/ancestor::rng:element) + 1]">true</xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates select=".//rng:ref[count(ancestor::rng:element)=count(current()/ancestor::rng:element) + 1]" mode="has-attributes"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ################################################## -->
  <xsl:template match="rng:ref" mode="has-attributes">
     <xsl:variable name="name" select="@name"/>
     <xsl:apply-templates select="//rng:define[@name=$name]" mode="has-attributes"/>
  </xsl:template>

  <!-- ################################################## -->
  <xsl:template match="rng:define" mode="has-attributes">
    <xsl:choose>
      <xsl:when test=".//rng:attribute[not(ancestor::rng:element)]">true</xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates select=".//rng:ref[not(ancestor::rng:element)]" mode="has-attributes"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ################################################## -->
  <xsl:template match="rng:*" mode="has-attributes">
    <xsl:apply-templates mode="has-attributes"/>
  </xsl:template>

  <!-- ################################################## -->
  <xsl:template match="*|node()" mode="has-attributes">
    <!-- suppress -->
  </xsl:template>

  <!-- ################################################## -->
  <xsl:template match="rng:define">
    <xsl:variable name="name" select="@name"/>
    <xsl:choose>
      <xsl:when test="following::rng:define[@name=$name and not(@combine)]">
	<xsl:apply-templates select="//rng:define[@name=$name and not(@combine)]" mode="define-base"/>
      </xsl:when>
      <xsl:when test="not(preceding::rng:define[@name=$name])">
	<xsl:apply-templates select="." mode="define-base"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- ################################################## -->
  <xsl:template match="rng:define" mode="define-base">
    <xsl:variable name="name" select="@name"/>
    <xsl:variable name="haselements">
      <xsl:apply-templates select="." mode="find-element">
	<xsl:with-param name="matched" select=".."/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="combined">
      <xsl:if test="@combine">
	<xsl:value-of select="following::rng:define[@name=$name]"/>
      </xsl:if>
      <xsl:if test="not(@combine)">
	<xsl:value-of select="//rng:define[@name=$name and @combine]"/>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="nsuri">
      <xsl:choose>
	<xsl:when test="ancestor::rng:div[@ns][1]">
	  <xsl:value-of select="ancestor::rng:div[@ns][1]/@ns"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="ancestor::rng:grammar[@ns][1]/@ns"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <hr/>
    <div>
      <xsl:attribute name="id"><xsl:value-of select="@name"/></xsl:attribute>
      <table>
        <h4><b>Pattern: </b><xsl:value-of select="@name"/></h4>
	<tr>
	  <td style="font-weight: bold">Namespace</td>
	  <td><xsl:value-of select="$nsuri"/></td>
	</tr>
	<xsl:if test="a:documentation">
	  <tr>
	    <td style="font-weight: bold">Documentation</td>
	    <td>
	      <xsl:if test="a:documentation">
		<xsl:apply-templates select="a:documentation"/>
	      </xsl:if>
	    </td>
	  </tr>
	</xsl:if>
	<xsl:if test="starts-with($haselements, 'true')">
	  <tr>
	    <td style="font-weight: bold">Content Model</td>
	    <td>
	      <xsl:apply-templates select="*" mode="content-model"/>
	      <xsl:if test="@combine">
		<xsl:apply-templates select="following::rng:define[@name=$name]" mode="define-combine"/>
	      </xsl:if>
	      <xsl:if test="not(@combine)">
		<xsl:apply-templates select="//rng:define[@name=$name and @combine]" mode="define-combine"/>
	      </xsl:if>
	    </td>
	  </tr>
	</xsl:if>
	<xsl:variable name="hasatts">
	  <xsl:apply-templates select="." mode="has-attributes"/>
	</xsl:variable>
	<xsl:if test="starts-with($hasatts, 'true')">
	  <tr>
	    <td style="font-weight: bold">Attributes:</td><br/>
	    <table class="attrtab" border="1"> 
	      <tr>
		<td style="font-weight: bold">Attribute</td>
		<td style="font-weight: bold">Type</td>
		<td style="font-weight: bold">Use</td>
		<td style="font-weight: bold">Documentation</td>
	      </tr>
	      <xsl:variable name="nesting" select="count(ancestor::rng:element)"/>
	      <xsl:apply-templates select=".//rng:attribute[count(ancestor::rng:element)=$nesting] | .//rng:ref[count(ancestor::rng:element)=$nesting]" mode="attributes">
		<xsl:with-param name="matched" select="."/>
	      </xsl:apply-templates>
	    </table>
	  </tr>
	</xsl:if>
      </table>

      <div onClick="hideOrShow(this)">
	<div class="buttondiv"><a class="myButton">Show Source</a></div><br/>
      <code style="display: none">
	<xsl:apply-templates select="." mode='print-direct'/>
      </code>
      </div>

    </div>
  </xsl:template>
  
  <!-- ################################################## -->
  <xsl:template match="rng:define" mode="define-combine">
    <xsl:choose>
      <xsl:when test="@combine='choice'">
	| (<xsl:apply-templates mode="content-model"/>)
      </xsl:when>
      <xsl:when test="@combine='interleave'">
	&amp; (<xsl:apply-templates mode="content-model"/>)
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- ################################################## -->
  <xsl:template match="rng:element" mode="makeid">
    <xsl:apply-templates select="ancestor::rng:element[1]" mode="makeid"/>.<xsl:value-of select="@name"/>
  </xsl:template>

  <!-- ################################################## -->
  <xsl:template match="rng:define" mode="makeid">
    <xsl:value-of select="@name"/>
  </xsl:template>

  <!-- ################################################## -->
  <xsl:template match="*" mode="makeid">
    <xsl:apply-templates select="ancestor::rng:element[1] | ancestor::rng:define[1]"/>
  </xsl:template>

  <!-- ################################################## -->
  <xsl:template name="makeid">
    <xsl:param name="node"/>
    <xsl:variable name="id"><xsl:apply-templates select="$node" mode="makeid"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="ancestor-or-self::rng:define"><xsl:value-of select="ancestor-or-self::rng:define[1]/@name"/><xsl:value-of select="$id"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="substring-after($id, '.')"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ================================================= -->
  <!-- CONTENT MODEL PATTERNS                            -->
  <!-- The following patterns construct a text           -->
  <!-- description of an element content model           -->
  <!-- ================================================= -->
  <!-- ################################################## -->
  <xsl:template match="rng:element" mode="content-model">
    <a>
      <xsl:attribute name="href">&#35;<xsl:call-template name="makeid"><xsl:with-param name="node" select="."/></xsl:call-template></xsl:attribute>
      <xsl:value-of select="@name"/>
    </a>
    <xsl:if test="not(parent::rng:choice) and (following-sibling::rng:element | following-sibling::rng:optional | following-sibling::rng:oneOrMore | following-sibling::rng:zeroOrMore)">,</xsl:if>
  </xsl:template>

  <!-- ################################################## -->
  <xsl:template match="rng:group" mode="content-model">
    (<xsl:apply-templates mode="content-model"/>)
  </xsl:template>

  <!-- ################################################## -->
  <xsl:template match="rng:optional" mode="content-model">
    <xsl:if test=".//rng:element | .//rng:ref[not(ancestor::rng:attribute)]">
      <xsl:apply-templates mode="content-model"/>?
      <xsl:if test="not(parent::rng:choice) and (following-sibling::rng:element | following-sibling::rng:optional | following-sibling::rng:oneOrMore | following-sibling::rng:zeroOrMore)">,</xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- ################################################## -->
  <xsl:template match="rng:oneOrMore" mode="content-model">
    (<xsl:apply-templates mode="content-model"/>)+
    <xsl:if test="not(parent::rng:choice) and (following-sibling::rng:element | following-sibling::rng:optional | following-sibling::rng:oneOrMore | following-sibling::rng:zeroOrMore)">,</xsl:if>
  </xsl:template>

  <!-- ################################################## -->
  <xsl:template match="rng:zeroOrMore" mode="content-model">
    (<xsl:apply-templates mode="content-model"/>)*
    <xsl:if test="not(parent::rng:choice) and (following-sibling::rng:element | following-sibling::rng:optional | following-sibling::rng:oneOrMore | following-sibling::rng:zeroOrMore)">,</xsl:if>
  </xsl:template>

  <!-- ################################################## -->
  <xsl:template match="rng:choice" mode="content-model">
    ( 
    <xsl:for-each select="*">
      <xsl:apply-templates select="." mode="content-model"/> 
      <xsl:if test="following-sibling::rng:*"> | </xsl:if>
    </xsl:for-each>
    )
  </xsl:template>

  <!-- ################################################## -->
  <xsl:template match="rng:value" mode="content-model">
    "<xsl:value-of select="."/>"
  </xsl:template>

  <!-- ################################################## -->
  <xsl:template match="rng:empty" mode="content-model">
    EMPTY
  </xsl:template>

  <!-- ################################################## -->
  <xsl:template match="rng:ref" mode="content-model">
    <xsl:variable name="haselement"><xsl:apply-templates select="." mode="find-element"/></xsl:variable>
    <xsl:choose>
    <xsl:when
	test="starts-with($haselement, 'true')">
	<!-- QQQ: FIX THIS -->
	<xsl:element name="a">
	  <xsl:attribute name="href">&#35;<xsl:value-of select="@name"/></xsl:attribute>
	  &#37;<xsl:value-of select="@name"/>
	</xsl:element>
	
	<!-- <link linkend="{@name}">%<xsl:value-of select="@name"/>;</link> -->
	<xsl:if test="not(parent::rng:choice) and (following-sibling::rng:element | following-sibling::rng:optional | following-sibling::rng:oneOrMore | following-sibling::rng:zeroOrMore)">, </xsl:if>
    </xsl:when>
    <xsl:otherwise>  %<xsl:value-of select="@name"/>  </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ################################################## -->
  <xsl:template match="rng:text" mode="content-model">
    TEXT
    <xsl:if test="not(parent::rng:choice) and (following-sibling::rng:element | following-sibling::rng:optional | following-sibling::rng:oneOrMore | following-sibling::rng:zeroOrMore)">, </xsl:if>
  </xsl:template>

  <!-- ################################################## -->
  <xsl:template match="rng:data" mode="content-model">
    xsd:<xsl:value-of select="@type"/>
  </xsl:template>

  <!-- ################################################## -->
  <xsl:template match="*" mode="content-model">
    <!-- suppress -->
  </xsl:template>

  <!-- ################################################## -->
  <xsl:template match="rng:define" mode="find-element">
    <xsl:param name="matched"/>
    <xsl:if test="not(count($matched | .)=count($matched))">
      <xsl:choose>
	<xsl:when test=".//rng:element|.//rng:text">
	  <xsl:value-of select="true()"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates select=".//rng:ref[not(ancestor::rng:attribute)]" mode="find-element">
	    <xsl:with-param name="matched" select="$matched | ."/>
	  </xsl:apply-templates>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!-- ################################################## -->
  <xsl:template match="rng:ref" mode="find-element">
    <xsl:param name="matched" select="."/>
    <xsl:variable name="ref" select="@name"/>
    <xsl:apply-templates select="//rng:define[@name=$ref]" mode="find-element">
      <xsl:with-param name="matched" select="$matched"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- ################################################## -->
  <xsl:template match="*" mode='print-direct'>
    <table>
      <xsl:choose>
	<xsl:when test="node()">


    <tr><td colspan="2">
    <!-- Begin Tag -->
    &lt;<span style="color:blue"><xsl:value-of select="name()"/></span><xsl:if test="@*">
    &#160;
    <xsl:for-each select="@*">
      <span style="color:green"><xsl:value-of select="name()"/></span>='<span style="color:purple"><xsl:value-of select="."/></span>'
    </xsl:for-each></xsl:if>&gt;
    </td></tr>
    
      <!-- Content -->
      <tr><td style="width: 5px"/><td>
      <xsl:apply-templates mode='print-direct'/>
    </td>
      </tr>
      
      <!-- End Tag -->
      <tr>
	<td colspan="2">&lt;/<span style="color:blue"><xsl:value-of select="name()"/></span>&gt;</td>
      </tr>

	</xsl:when>
	<xsl:otherwise>

	  <!-- Begin Tag -->
	  <tr><td>
	  &lt;<span style="color:blue"><xsl:value-of select="name()"/></span><xsl:if test="@*">
	  &#160;
	  <xsl:for-each select="@*">
	    <span style="color:green"><xsl:value-of select="name()"/></span>='<span style="color:purple"><xsl:value-of select="."/></span>'
	    </xsl:for-each></xsl:if>/&gt;
	  </td></tr>
	</xsl:otherwise>
      </xsl:choose>
    </table>

  </xsl:template>
</xsl:stylesheet>
