<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:cc="https://niap-ccevs.org/cc/v1"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:htm="http://www.w3.org/1999/xhtml"
		version="1.0">


  <xsl:template match="/">
    <abc>
      <xsl:apply-templates select="//cc:selection-depends/@ids"/>
    </abc>
  </xsl:template>

  <xsl:template match="@ids" name="split">
    <xsl:param name="pText" select="."/>

    <xsl:if test="string-length($pText) > 0">
      <xsl:variable name="vNextItem" select=
                    "substring-before(concat($pText, ','), ',')"/>

        Found: <xsl:value-of select="$vNextItem"/>

      <xsl:call-template name="split">
        <xsl:with-param name="pText" select=
                        "substring-after($pText, ',')"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>