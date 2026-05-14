<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:cc="https://niap-ccevs.org/cc/v1"
		>
  <xsl:import href="file:///home/kevin/commoncriteria/transforms/xsl/ppcommons.xsl"/>
  <xsl:template match="comment()">
    <xsl:variable name="content" select="."/>
    <xsl:if test="not(starts-with($content,'~$#'))">
      <xsl:copy/>
    </xsl:if>
   </xsl:template>

   <xsl:template match="cc:f-element">
     <xsl:comment>~$# <xsl:apply-templates select="." mode="getId"/></xsl:comment>
     <xsl:copy><xsl:apply-templates select="@*|node()"/></xsl:copy>
   </xsl:template>
   
   <!-- IdentityTransform -->
   <xsl:template match="/ | @* | node()">
         <xsl:copy>
               <xsl:apply-templates select="@* | node()" />
         </xsl:copy>
   </xsl:template>
   
</xsl:stylesheet>
