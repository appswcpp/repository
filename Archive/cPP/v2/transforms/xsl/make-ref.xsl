<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:cc="https://niap-ccevs.org/cc/v1"
   xmlns:sec="https://niap-ccevs.org/cc/v1/section"
   xmlns:htm="http://www.w3.org/1999/xhtml">


  <!-- ############################################# -->
  <!-- This files defines how to make cross-references
       to different items. -->
  <!-- ################################### -->

  <xsl:template name="make_xref">
    <xsl:param name="id"/>
    <xsl:choose><xsl:when test="//cc:*[@id=$id]">
      <xsl:apply-templates mode="make_xref" select="//cc:*[@id=$id]"/>
    </xsl:when><xsl:otherwise>
      Could not find a reference to <xsl:value-of select="@id"/>
    </xsl:otherwise></xsl:choose>
  </xsl:template>


  <!-- ############### -->
  <xsl:template name="selectable-nolink">
      <xsl:choose>
        <xsl:when test="cc:readable">
	  <xsl:apply-templates select="cc:readable/node()"/>
	</xsl:when>
<!--- We want snips in our selectable, but not snips that are descendants of subselectabls -->
        <xsl:when test="./cc:snip">
          <xsl:apply-templates select="descendant::cc:snip[1]"/>
          </xsl:when> 
        <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:selectable" mode="make_xref">
    <xsl:variable name="r-id"><xsl:apply-templates select="." mode="getId"/></xsl:variable>

    <xsl:choose><xsl:when test="$doctype=local-name(/cc:*)">
      <a href="#{$r-id}"><xsl:call-template name="selectable-nolink"/></a>
    </xsl:when><xsl:otherwise>
      <xsl:call-template name="selectable-nolink"/>
    </xsl:otherwise></xsl:choose>
  </xsl:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:module[@name]|cc:base-pp[@name]|cc:include-pkg[@name]" mode="make_xref">
      <a href="{cc:url/text()}"><xsl:value-of select="concat(@name, ', version ', @version) "/></a>
  </xsl:template>

  <xsl:template match="cc:module[not(@name)]" mode="make_xref">
    <xsl:variable name="url"><xsl:value-of select="translate(cc:url/text(),' ','')"/></xsl:variable>
    <xsl:variable name="path" select="concat('../../output/', @id, '.xml')"/>
    <xsl:variable name="name" select="document($path)/cc:Module/@name"/>

    <!-- cc:url/text() -->
    <a href="{$url}">
	<xsl:if test="not(starts-with($name,'PP-Module for '))">PP-Module for </xsl:if>
        <xsl:value-of select="$name"/>,
        version 
        <xsl:value-of select="document($path)//cc:PPVersion/text()"/>
      </a>
  </xsl:template> 
 
  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:base-pp[cc:git]|cc:include-pkg[cc:git]" mode="make_xref">
      <a href="{cc:url/text()}">
        <xsl:variable name="path" select="concat('../../output/', @id, '.xml')"/>
        <xsl:value-of select="document($path)//cc:PPTitle/text()"/>,
        version 
        <xsl:value-of select="document($path)//cc:PPVersion/text()"/>
      </a>
  </xsl:template> 
 
  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template name="make-readable-index">
    <xsl:param name="index"/>
    <xsl:variable name="lastchar" select="substring($index, string-length($index))"/>
    <xsl:variable name="last2char" select="substring($index, string-length($index)-1)"/>

    <xsl:value-of select="$index"/>
    <sup><xsl:choose>
      <xsl:when test="$last2char='11' or $last2char='12' or $last2char='13'">th</xsl:when>
      <xsl:when test="$lastchar='1'">st</xsl:when>
      <xsl:when test="$lastchar='2'">nd</xsl:when>
      <xsl:when test="$lastchar='3'">rd</xsl:when>
      <xsl:otherwise>th</xsl:otherwise>
    </xsl:choose></sup>
  </xsl:template> 


  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:f-element//cc:assignable" mode="make_xref">
    <a href="#{@id}">
<!--  This won't compile:  <xsl:variable name="index">
      <xsl:number count="ancestor::cc:f-element//cc:assignable" level="any"/>
    </xsl:variable>, so I'm using the following inefficient hack -->
     <xsl:call-template name="make-readable-index">
      <xsl:with-param name="index"><xsl:for-each select="ancestor::cc:f-element//cc:assignable">
        <xsl:if test="current()/@id=./@id"><xsl:value-of select="position()"/></xsl:if></xsl:for-each>
      </xsl:with-param></xsl:call-template>
    assignment</a>
  </xsl:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:management-function//cc:assignable" mode="make_xref">
    <a href="#{@id}">
<!--TODO: This seems really inefficient.-->
      <xsl:call-template name="make-readable-index">
        <xsl:with-param name="index"><xsl:for-each select="ancestor::cc:management-function//cc:assignable">
          <xsl:if test="current()/@id=./@id"><xsl:value-of select="position()"/></xsl:if></xsl:for-each>
        </xsl:with-param>
      </xsl:call-template>
    assignment</a>
 </xsl:template>


  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
   <xsl:template match="cc:section|sec:*" mode="make_xref">
    <xsl:param name="format" select="''"/>
    <xsl:variable name="target"><xsl:choose>
      <xsl:when test="namespace-uri()='https://niap-ccevs.org/cc/v1'">
        <xsl:value-of select="@id"/>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="local-name()"/></xsl:otherwise>
    </xsl:choose></xsl:variable>
    
    <a href="#{$target}" class="dynref">Section </a>
  </xsl:template>


  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:test" mode="make_xref">
    <xsl:param name="class" select="'dynref'"/>
    <xsl:variable name="target"><xsl:apply-templates mode="getId" select="."/></xsl:variable>
    
    <a href="#{$target}" class="{$class}"></a>
  </xsl:template>
  <!-- <xsl:number count="//cc:testlist" level="any"/>.<xsl:for-each select="ancestor::cc:test"><xsl:value-of -->
  <!--       select="count(preceding-sibling::cc:test) + 1"/>.</xsl:for-each><xsl:value-of -->
  <!--       select="count(preceding-sibling::cc:test) + 1"/> -->
  <!-- <xsl:template mode="testnumberer" match="cc:test[ancestor::cc:test]"> -->
    <!-- <xsl:apply-templates select="ancestor::cc:test[1]" mode="testnumberer"/>.<xsl:value-of select="count(preceding-sibling::cc:test) + 1"/></xsl:template> -->

  <xsl:template mode="testnumberer" match="cc:testlist">
    <xsl:number count="//cc:testlist" level="any"/>
  </xsl:template>
  
  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:appendix" mode="make_xref">
    <a href="#{@id}" class="dynref"></a>
  </xsl:template>
 
  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:bibliography/cc:entry" mode="make_xref">
     <a href="#{@id}">[<xsl:apply-templates select="cc:tag"/>]</a>
  </xsl:template>


  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:usecase" mode="make_xref">
    <a href="#{@id}" class="dynref"></a>
  </xsl:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:*" mode="make_xref">
    <xsl:message>Unable to make an xref for |<xsl:value-of select="name()"/>| <xsl:call-template name="genPath"/></xsl:message>
  </xsl:template>

  
  <xsl:template match="cc:tabularize" mode="make_xref">
    <xsl:call-template name="make_ctr_ref">
        <xsl:with-param name="id" select="@id"/>
        <xsl:with-param name="prefix" select="'Table '"/>
    </xsl:call-template>
  </xsl:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:ctr|cc:figure|cc:equation|cc:audit-table" mode="make_xref">
    <xsl:param name="eprefix"/> <!-- explicit prefix -->
    <xsl:param name="has-eprefix"/>

    <xsl:call-template name="make_ctr_ref">
      <xsl:with-param name="prefix"><xsl:choose>
        <xsl:when test="$has-eprefix='y'"><xsl:value-of select="$eprefix"/></xsl:when>
        <xsl:when test="local-name()='equation'">Eq. </xsl:when>
	<xsl:when test="local-name()='audit-table'">Table </xsl:when>
        <xsl:otherwise><xsl:apply-templates select="." mode="getPre"/></xsl:otherwise>
      </xsl:choose></xsl:with-param>
      <xsl:with-param name="id" select="@id"/>
    </xsl:call-template>
  </xsl:template>


  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template name="make_ctr_ref">
    <xsl:param name="id"/>
    <xsl:param name="prefix"/>

    <a onclick="showTarget('{$id}')" href="#{$id}" class="{$id}-ref" >
      <xsl:value-of select="$prefix"/><xsl:text> </xsl:text><span class="counter"><xsl:value-of select="$id"/></span>
    </a>
  </xsl:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <!-- Making a references is the same as getting they ID for these structures. -->
  <xsl:template match="cc:f-component-decl|cc:f-component|cc:f-element" mode="make_xref">
     <xsl:apply-templates mode="getId" select="."/>
  </xsl:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:management-function" name="management-function" mode="make_xref">
     <xsl:param name="nolink"  select="@nolink"/>
     <xsl:param name="prefix" select="ancestor::cc:management-function-set/@ctr-prefix"/>
     <xsl:param name="index"><xsl:number count="//cc:management-function" level="any"/></xsl:param>
     <xsl:variable name="mf_id"><xsl:apply-templates select="." mode="getId"/></xsl:variable>

     <xsl:choose>
       <xsl:when test="$nolink='y'">
         <xsl:value-of select="concat($prefix, $index)"/>
       </xsl:when>
       <xsl:otherwise>
        <a href="#{$mf_id}"><xsl:value-of select="concat($prefix, $index)"/></a>
       </xsl:otherwise>
     </xsl:choose>
  </xsl:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <!-- Making a references is the same as getting they ID for these structures. -->
  <xsl:template match="cc:threat|cc:assumption" mode="make_xref">
     <xsl:value-of select="@name"/>
  </xsl:template>

 
</xsl:stylesheet>
