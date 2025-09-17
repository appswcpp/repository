<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:x="http://www.w3.org/1999/XSL/Transform"
  xmlns:cc="https://niap-ccevs.org/cc/v1"
  xmlns:htm="http://www.w3.org/1999/xhtml"
  xmlns:h="http://www.w3.org/1999/xhtml"
  xmlns:sec="https://niap-ccevs.org/cc/v1/section">

  <xsl:import href="debug.xsl"/>
   <!--##############################################
        Template for universal sanity checks.
      ##############################################-->
   <xsl:template name="sanity-checks">
     <xsl:for-each select="//cc:raw-url">
       <xsl:if test="contains(text(), '/master/')">
	 <xsl:message>* Warning: A raw-url is referencing a master branch when it should be referencing a released branch: <xsl:value-of select="text()"/></xsl:message>
       </xsl:if>
     </xsl:for-each>
    <!--                                          if it has an aactivity or a sibling has a non-element-specific aactivity -->
    <xsl:for-each select="//h:s//cc:assignable|//h:s//cc:selectables">
      <xsl:message>* Error: Found a "<xsl:value-of select="local-name()"/>" element that is buried under stricken text:
        <xsl:call-template name="genPath"/>
      </xsl:message>
    </xsl:for-each>
    <xsl:for-each select="//cc:f-element[not(.//cc:aactivity or ..//cc:aactivity[not(@level='element' or parent::cc:management-function)])]">
      <xsl:if test="not(../@status='invisible')">

	<xsl:message>* Error: <xsl:value-of select="local-name()"/><xsl:text> </xsl:text><xsl:apply-templates select="." mode="getId"/>  appears not to have an associated evaluation activity.:
        <xsl:call-template name="genPath"/>
	</xsl:message>
      </xsl:if>
    </xsl:for-each>
<!--    <xsl:for-each select="//cc:TSS[.='']|//cc:Guidance[.='']|//cc:KMD[.='']|//cc:Tests[.='']">
      <xsl:message>* Error: Illegal empty <xsl:value-of select="local-name()"/> element at:
        <xsl:call-template name="genPath"/>
      </xsl:message>
    </xsl:for-each>  -->
    <xsl:if test="//cc:comment">
      <xsl:message>* Warning: This document still has at least one comment.</xsl:message>
    </xsl:if>
    <xsl:for-each select="//cc:depends/@*[not(../cc:external-doc)]">
       <xsl:if test="not(//*[@id=current()])">
        <xsl:message>* Error: Detected dangling id-reference to <xsl:value-of select="current()"/> from attribute
        <xsl:value-of select="name()"/>
	<xsl:call-template name="genPath"/>	
       <!--<xsl:message>
          Error: Detected an 'id' attribute in a 'depends' element which is not allowed.
          -->
       </xsl:message>
       </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="//cc:depends/@id">
       <xsl:message>* Error: Detected an 'id' attribute in a 'depends' element which is not allowed.
          <xsl:call-template name="genPath"/>
       </xsl:message>
    </xsl:for-each>
    <xsl:for-each select="//cc:title//cc:depends[not(parent::htm:tr)]|//cc:note//cc:depends">
       <xsl:message>* Warning: Potentially illegal 'depends' element.
          <xsl:call-template name="genPath"/>
       </xsl:message>
    </xsl:for-each>
    <xsl:for-each select="//@id">
       <xsl:variable name="id" select="."/>
       <xsl:if test="count(//*[@id=$id])>1">
         <xsl:message>* Error: Detected multiple elements with an id of '<xsl:value-of select="$id"/>'.</xsl:message>
       </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="//cc:ref-id[not(parent::cc:doc)]">
	<xsl:variable name="refid" select="text()"/>
        <xsl:if test="not(//cc:*[@id=$refid])">
          <xsl:message>* Error: Detected dangling ref-id to '<xsl:value-of select="$refid"/>'.
	  <xsl:call-template name="genPath"/>	
	  </xsl:message>
        </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="//@ref-id[not(ancestor::cc:con-mod)]">
      
	<xsl:variable name="refid" select="."/>
        <xsl:if test="not(//cc:*[@id=$refid])">
         <xsl:message>* Error: Detected dangling <xsl:value-of select="concat(name(),' to ',$refid)"/> 
         for a <xsl:value-of select="name()"/>
	  <xsl:call-template name="genPath"/>	
         </xsl:message>
        </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="//cc:con-mod/@ref">
      <xsl:variable name="refid" select="."/>
      <xsl:if test="not(//cc:f-component/@cc-id=$refid or //cc:*/@name=$refid or //cc:f-component/@id=$refid)">
	<xsl:message>* Error: Detected dangling ref to '<xsl:value-of select="$refid"/>'
        for a <xsl:value-of select="name()"/>.
	<xsl:call-template name="genPath"/>
        </xsl:message>
      </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="//cc:deprecated">
       <xsl:message>* Warning: Detected a deprecated tag. <xsl:call-template name="genPath"/> </xsl:message>
    </xsl:for-each>
    <xsl:for-each select="//htm:p[not(node())]">
      <xsl:message>* Warning: Detected an empty _p_ element.<xsl:call-template name="genPath"/> </xsl:message>
    </xsl:for-each>

    <xsl:if test="count(//cc:tech-terms)!=1">
      <xsl:message>* Warning: Detected <xsl:value-of select="count(//cc:tech-terms)"/> tech-term sections in this PP. There should be exactly 1 "tech-term" section.
      </xsl:message>
    </xsl:if>
    <xsl:if test="count(//sec:Conformance_Claims|//*[@title='Conformance Claims'])!=1">
      <xsl:message>* Warning: Detected <xsl:value-of select="count(//cc:tech-terms)"/> Conformance Claims sections in this PP. There should be exactly 1 "Conformance Claims" section.
      </xsl:message>
    </xsl:if>
    <xsl:if test="/cc:Module//cc:usecase/cc:config and not(//cc:*[@title='Use Case Templates'])">
      <xsl:message>* Warning: Specifying a 'config' in a 'usecase' in a module requires a 'Use Case Templates' appendix
      </xsl:message>
    </xsl:if>

    <xsl:if test="//cc:rule and not(//cc:appendix[@title='Validation Guidelines'])">
      <xsl:message>* Rules without a 'Validation Guidelines' appendix has been detected.</xsl:message>
    </xsl:if>


    <xsl:for-each select="//cc:replace[not(ancestor::cc:modified-sfrs)]">
      <xsl:message>* Warning: Detected a _replace_ element outside a modified-sfrs section. <xsl:call-template name="genPath"/> </xsl:message>
    </xsl:for-each>

    <xsl:for-each select="/cc:Module//cc:impl-dep-sfrs//cc:f-component[not(cc:depends/@*)]">
      <xsl:message>* Warning: <xsl:value-of select="@cc-id"/> in impl-dep-sfrs section is missing a _depends_ element. <xsl:call-template name="genPath"/> </xsl:message>
    </xsl:for-each>

    <xsl:for-each select="/cc:Module//cc:obj-sfrs//cc:f-component[not(cc:depends/cc:objective)]">
      <xsl:message>* Warning: <xsl:value-of select="@cc-id"/> in obj-sfrs section is missing a _depends_/_objective_ sub tree (We're transitioning to using depends and not sections). <xsl:call-template name="genPath"/> </xsl:message>
    </xsl:for-each>

    <xsl:for-each select="/cc:Module//cc:opt-sfrs//cc:f-component[not(cc:depends/cc:optional)]">
      <xsl:message>* Warning: <xsl:value-of select="@cc-id"/> in opt-sfrs section is missing a _depends_/_optional_ sub tree (We're transitioning to using depends and not sections). <xsl:call-template name="genPath"/> </xsl:message>
    </xsl:for-each>
    
    
  </xsl:template>


  <xsl:template match="/">
    <xsl:call-template name="sanity-checks"/>
  </xsl:template>
</xsl:stylesheet>
