<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cc="https://niap-ccevs.org/cc/v1"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:htm="http://www.w3.org/1999/xhtml"
  version="1.0">

<!--
    Stylesheet library for Protection Profile Schema
    Handles use-cases.
-->

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:usecases">
    <dl>
      <xsl:for-each select="cc:usecase">
        <dt id="{@id}"> [USE CASE <xsl:value-of select="position()"/>] <xsl:value-of select="@title"/> </dt>
        <dd>
          <xsl:apply-templates select="cc:description"/>
          <xsl:if test="cc:config"><p>
            For changes to included SFRs, selections, and assignments required for this use case, see <a href="#appendix-{@id}" class="dynref"></a>.
          </p></xsl:if>
        </dd>
      </xsl:for-each>
    </dl>
  </xsl:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template name="use-case-appendix">
    <xsl:param name="appid" select="use-case-appendix"/>


    <xsl:if test="//cc:usecase/cc:config">
      <h1 id="{$appid}" class="indexable" data-level="A">Use Case Templates</h1>
      <xsl:for-each select="//cc:usecase">
        <h2 id="appendix-{@id}" class="indexable" data-level="2"><xsl:value-of select="@title"/></h2>
	<xsl:choose><xsl:when test="cc:config">
		The configuration for <i><a href="#{@id}" class="dynref"></a></i> modifies
		the base requirements as follows:<br/>
          <xsl:for-each select="cc:config">
	    <xsl:call-template name="use-case-and"/>
	  </xsl:for-each>
        </xsl:when><xsl:otherwise>
		The use case <i><a href="#{@id}" class="dynref"></a></i> makes no changes to the base requirements.

	</xsl:otherwise></xsl:choose>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>


  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:and" mode="use-case" name="use-case-and">
    <xsl:apply-templates mode="use-case"/>
  </xsl:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
   <xsl:template match="cc:or" mode="use-case">
    <table class="uc_table_or" style="border: 1px solid black">
      <tr> <td class="or_cell" rowspan="{count(cc:*)+1}">DECISION <xsl:apply-templates select="." mode="or_path"/></td><td style="display:none"></td></tr>
      <xsl:for-each select="cc:*">
	<tr><td style="width: 99%">
	  <div class="choicelabel">CHOICE <xsl:apply-templates mode="choice-path" select="."/></div>
	<xsl:apply-templates select="." mode="use-case"/></td></tr>
      </xsl:for-each>
    </table>
  </xsl:template>
 
  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:config"  mode="choice-path"/>
  <xsl:template match="cc:*" mode="choice-path">
    <xsl:if test="parent::cc:or"><xsl:apply-templates mode="or_path" select=".."/><xsl:value-of select="count(preceding-sibling::cc:*)+1"/></xsl:if>
  </xsl:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <!-- <xsl:template match="cc:or/cc:*"/> -->

  <xsl:template match="cc:or" mode="or_path">
    <xsl:number count="cc:or" level="any" format="A"/>
  </xsl:template>

  
  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="*" mode="handle-ancestors">
    <xsl:message>Definitely shouldn't be here</xsl:message>
  </xsl:template>


  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:*[@id]" mode="handle-ancestors">
    <xsl:param name="prev-id"/>
    <xsl:param name="not"/>

    <xsl:variable name="sclass">uc_sel<xsl:if test="ancestor::cc:management-function"> uc_mf</xsl:if></xsl:variable>
    <!-- if the anscestor is in a PP-->
    <xsl:if test="ancestor::cc:f-component[@status='optional' or @status='objective'] and not(ancestor::cc:f-component//@id=$prev-id)">
      <div class="uc_inc_fcomp">
      Include <xsl:apply-templates select="ancestor::cc:f-component" mode="make_xref"/> in ST.</div>
    </xsl:if>
    <!-- If the ancestor is an f-element and the previous one doesn't have the same f-element -->
    <xsl:if test="ancestor::cc:f-element and not(ancestor::cc:f-element//@id=$prev-id)">
      <div class="uc_from_fel">
      From <xsl:apply-templates select="ancestor::cc:f-element" mode="make_xref"/>:</div>
    </xsl:if>
    <xsl:if test="ancestor::cc:management-function and not(ancestor::cc:management-function//@id=$prev-id)">
      <xsl:choose>
        <xsl:when test="ancestor::cc:management-function/cc:M">
          <div class="uc_mf">From <xsl:apply-templates select="ancestor::cc:management-function" mode="make_xref"/>:</div>
        </xsl:when>
        <xsl:otherwise>
          <div class="uc_mf">Include <xsl:apply-templates select="ancestor::cc:management-function" mode="make_xref"/>
          in the ST and :</div>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$not='1'">
         <xsl:for-each select="ancestor::cc:selectable">
          <xsl:if test="not(.//@id=$prev-id)">
            <div class="{$sclass}">* select <xsl:apply-templates select="." mode="make_xref"/></div>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="ancestor-or-self::cc:selectable">
          <xsl:if test="not(.//@id=$prev-id)">
            <div class="{$sclass}">* select <xsl:apply-templates select="." mode="make_xref"/></div>
          </xsl:if>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template name="get-prev-id">
    <xsl:if test="not(parent::cc:or or preceding-sibling::cc:*[1][self::cc:or])">
      <xsl:value-of select="preceding-sibling::cc:*[1]/descendant-or-self::cc:ref-id"/>
    </xsl:if>
  </xsl:template>
  
  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:guidance|cc:restrict" mode="use-case">
    <xsl:variable name="ref-id" select="cc:ref-id[1]/text()"/>
    <xsl:variable name="sclass">uc_guide<xsl:if test="//cc:management-function//@id=$ref-id"> uc_mf</xsl:if></xsl:variable>

    <xsl:choose>
      <xsl:when test="//cc:assignable/@id=$ref-id">
        <xsl:apply-templates select="//cc:*[@id=$ref-id]" mode="handle-ancestors">
          <xsl:with-param name="prev-id"><xsl:call-template name="get-prev-id"/></xsl:with-param>
        </xsl:apply-templates>
 	<div class="{$sclass}">* for the <xsl:apply-templates select="//cc:assignable[@id=$ref-id]" mode="make_xref"/>, 
	<xsl:apply-templates/></div>
      </xsl:when>
      <xsl:otherwise>
	<xsl:message>Can't find assignable with ID of  <xsl:value-of select="$ref-id"/></xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

   <!-- ############### --> 
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:not[cc:ref-id/text()=//cc:threat/@id]" mode="use-case">
    <xsl:for-each select="cc:ref-id[text() = //cc:threat/@id]">
      <xsl:variable name="theid" select="text()"/>
      <xsl:apply-templates mode="make_xref" select="//cc:*[@id=$theid]"/> does not apply in this use case.
    </xsl:for-each>
  </xsl:template>
  

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:not" mode="use-case">
    <xsl:variable name="ref-id" select="cc:ref-id[1]/text()"/>
    <xsl:apply-templates select="//cc:*[@id=$ref-id]" mode="handle-ancestors">
       <xsl:with-param name="prev-id"><xsl:call-template name="get-prev-id"/></xsl:with-param>
       <xsl:with-param name="not" select="'1'"/>
    </xsl:apply-templates>
    <xsl:if test="$ref-id=//cc:module/@id">
      <div class="uc,not,module">Exclude the 
      <xsl:apply-templates select="//cc:module[@id=$ref-id]" mode="make_xref"/> module from the ST
      </div>
    </xsl:if>
    <xsl:if test="cc:ref-id/text()=//cc:selectable/@id">
      <div class="uc_not">Do not choose:
      <xsl:for-each select="cc:ref-id[text()=//cc:selectable/@id]">
	<!-- Not sure why this is a for -->
        <xsl:variable name="ref" select="text()"/>
        <div class="uc_not_sel">* <xsl:apply-templates select="//cc:selectable[@id=$ref]" mode="make_xref"/></div>
      </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>


  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:doc" mode="use-case">
    <xsl:variable name="docpath"><xsl:value-of select="concat($work-dir,'/',@ref)"/>.xml</xsl:variable>
    <xsl:variable name="docurl"><xsl:value-of select="//cc:*[@id=current()/@ref]/cc:url/text()"/></xsl:variable>
    <xsl:variable name="name"><xsl:value-of select="document($docpath)//cc:PPTitle"/><xsl:if test="not(document($docpath)//cc:PPTitle)">PP-Module for <xsl:value-of select="document($docpath)/cc:Module/@name"/></xsl:if></xsl:variable>


    <div class="uc_inc_pkg"> From the <a href="{$docurl}"><xsl:value-of select="$name"/></a>: </div>
    <xsl:for-each select="cc:ref-id">
      <xsl:call-template name="handle-ref-ext"> 
        <xsl:with-param name="ref-id" select="text()"/>
        <xsl:with-param name="root" select="document($docpath)/cc:*"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template name="handle-ref-ext">
    <xsl:param name="ref-id"/>
    <xsl:param name="root"/>

    <xsl:choose>
      <xsl:when test="$root//cc:selectable[@id=$ref-id]">
        <xsl:apply-templates select="$root//cc:*[@id=$ref-id]" mode="handle-ancestors">
          <xsl:with-param name="prev-id"><xsl:call-template name="get-prev-id"/></xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$root//cc:f-component[@id=$ref-id]">
        <div class="uc_inc_fcomp">Include <xsl:apply-templates select="$root//cc:*[@id=$ref-id]" mode="make_xref"/> in the ST </div>
      </xsl:when>
      <xsl:when test="$root//cc:management-function//@id=$ref-id">
        <xsl:apply-templates select="$root//cc:*[@id=$ref-id]" mode="handle-ancestors">
          <xsl:with-param name="prev-id"><xsl:call-template name="get-prev-id"/></xsl:with-param>
        </xsl:apply-templates>
        <div class="uc_mf">Include
        <xsl:apply-templates select="$root//cc:management-function[@id=$ref-id]" mode="make_xref"/>
        in the ST</div>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message> Failed to find <xsl:value-of select="$ref-id"/> in <xsl:call-template name="genPath"/></xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template> 
  
  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
<!--  <xsl:template match="cc:ref-id" mode="use-case">
    <xsl:call-template name="handle-ref">
      <xsl:with-param name="ref-id" select="text()"/>
    </xsl:call-template>
  </xsl:template>  -->

  
 <xsl:template match="cc:ref-id" mode="use-case">
   <xsl:variable name="ref-id-txt" select="text()"/>
   <xsl:choose>
      <xsl:when test="//cc:module[@id=$ref-id-txt]">
	<div class="uc,module"> Include the <xsl:apply-templates select="//cc:*[@id=$ref-id-txt]" mode="make_xref"/> module in the ST </div>
      </xsl:when>
      <xsl:when test="//cc:selectable[@id=$ref-id-txt]">
        <xsl:apply-templates select="//cc:*[@id=$ref-id-txt]" mode="handle-ancestors">
          <xsl:with-param name="prev-id"><xsl:call-template name="get-prev-id"/></xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="//cc:f-component[@id=$ref-id-txt]">
        <div class="uc_inc_fcomp">Include <xsl:apply-templates select="//cc:*[@id=$ref-id-txt]" mode="make_xref"/> in the ST </div>
      </xsl:when>
      <xsl:when test="//cc:management-function//@id=$ref-id-txt">
        <xsl:apply-templates select="//cc:*[@id=$ref-id-txt]" mode="handle-ancestors">
          <xsl:with-param name="prev-id"><xsl:call-template name="get-prev-id"/></xsl:with-param>
        </xsl:apply-templates>
        <div class="uc_mf">Include
        <xsl:apply-templates select="//cc:management-function[@id=$ref-id-txt]" mode="make_xref"/>
        in the ST</div>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message> Failed to find <xsl:value-of select="$ref-id-txt"/> in <xsl:call-template name="genPath"/> (use case or rule)</xsl:message>
        <xsl:if test="./@alt">
          <b><i><xsl:value-of select="./@alt"/></i></b>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
 
  
  
  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template name="handle-ref">
    <xsl:param name="ref-id" select="text()"/>
    <xsl:choose>
      <xsl:when test="//cc:selectable[@id=$ref-id]">
        <xsl:apply-templates select="//cc:*[@id=$ref-id]" mode="handle-ancestors">
          <xsl:with-param name="prev-id"><xsl:call-template name="get-prev-id"/></xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="//cc:f-component[@id=$ref-id]">
        <div class="uc_inc_fcomp">Include <xsl:apply-templates select="//cc:*[@id=$ref-id]" mode="make_xref"/> in the ST </div>
      </xsl:when>
      <xsl:when test="//cc:management-function//@id=$ref-id">
        <xsl:apply-templates select="//cc:*[@id=$ref-id]" mode="handle-ancestors">
          <xsl:with-param name="prev-id"><xsl:call-template name="get-prev-id"/></xsl:with-param>
        </xsl:apply-templates>
        <div class="uc_mf">Include
        <xsl:apply-templates select="//cc:management-function[@id=$ref-id]" mode="make_xref"/>
        in the ST</div>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message> Failed to find <xsl:value-of select="$ref-id"/> in <xsl:call-template name="genPath"/></xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template> 
</xsl:stylesheet>


