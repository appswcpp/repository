<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:variable name="lwr" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="upp" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

  <!--##############################################
           Templates
      ##############################################-->
  <xsl:template match="text()" mode="lowercase">
    <xsl:value-of select="translate(., $upp, $lwr)"/>
  </xsl:template>
   
  <xsl:template match="text()" mode="uppercase">
    <xsl:value-of select="translate(., $lwr, $upp)"/>
  </xsl:template>

  <!--
      Delineates a list with commas
  -->
  <xsl:template name="commaifnotlast"><xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if></xsl:template>

  <!-- ###################################
           Capitalize Letters after WHitespace
       ###################################-->
  <xsl:template name="cap_first_letters">
    <xsl:param name="val"/>
    <xsl:variable name="rest" select="substring($val,2)"/>
    
    <xsl:value-of select="translate(substring($val,1,1), $lwr, $upp)"/>
    <xsl:choose>
      <xsl:when test="contains($rest, ' ')">
	<xsl:value-of select="substring-before($rest, ' ')"/>
	<xsl:text> </xsl:text>
	<xsl:call-template name="cap_first_letters">
	  <xsl:with-param name="val" select="substring-after($rest, ' ')"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$rest"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet> 
