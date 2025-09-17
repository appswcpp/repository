<?xsml version="!.0" encoding="utf-8"?>
<!--

FILE: ext-comp-defs.xsl

Contains transforms for extended component definitions

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
     xmlns="http://w3.org/1999/xhthml"
     xmlns:cc="https://niap-ccevs.org/cc/v1"
     xmlns:sec="https://niap-ccevs.org/cc/v1/section"
     version="1.0">

  <xsl:import href="debug.xsl"/>
<!-- ####################### -->
  <xsl:template name="ext-comp-defs"><xsl:if test="//cc:ext-comp-def">
    
    <h1 id="ext-comp-defs" class="indexable" data-level="A">Extended Component Definitions</h1>
	This appendix contains the definitions for all extended requirements specified in the <xsl:call-template name="doctype-short"/>.

    <h2 id="ext-comp-defs-bg" class="indexable" data-level="2">Extended Components Table</h2>

	All extended components specified in the <xsl:call-template name="doctype-short"/> are listed in this table:

<table class="sort_kids_">
  <caption data-sortkey="#0"><b><xsl:call-template name="ctr-xsl">
          <xsl:with-param name="ctr-type">Table</xsl:with-param>
          <xsl:with-param name="id" select="t-ext-comp_map"/>
	 </xsl:call-template>: Extended Component Definitions</b></caption>
  <tr data-sortkey="#1">
    <th>Functional Class</th><th>Functional Components</th> </tr>
<!-- section is compatible with the new section styles b/c the new section style is not allowed to 
     for sections that directly contain f-components and a-components -->
<xsl:call-template name="RecursiveGrouping"><xsl:with-param name="list" select="//*[cc:ext-comp-def]"/></xsl:call-template>
</table>
    <h2 id="ext-comp-defs-bg" class="indexable" data-level="2">Extended Component Definitions</h2>
    <span class="sort_kids_">
    <xsl:call-template name="RecursiveGrouping">
      <xsl:with-param name="list" select="//*[cc:ext-comp-def]"/>
      <xsl:with-param name="fake_mode" select="'sections'"/>
    </xsl:call-template>
    </span>
<!--
    <xsl:variable name="alltitles"><xsl:for-each select="//*[./cc:ext-comp-def]/@title"><xsl:sort/><xsl:value-of select="."/>@@</xsl:for-each></xsl:variable>
    
    <xsl:call-template name="extcompdef_no_repeats">
      <xsl:with-param name="titles" select="$alltitles"/>
    </xsl:call-template> -->
    
  </xsl:if></xsl:template>

  <!-- ####################### -->
  <!-- ####################### -->
<!--
  <xsl:template name="extcompdef_no_repeats">
    <xsl:param name="titles"/>

    <xsl:variable name="first" select="substring-before($titles,'@@')"/>
    <xsl:variable name="rest" select="substring-after($titles,'@@')"/>

    <xsl:if test="not(contains($rest, concat($first, '@@')))">
      <xsl:call-template name="handle_ext_comp_def">
	<xsl:with-param name="title" select="$first"/>
      </xsl:call-template>
    </xsl:if>

    <xsl:if test="not($rest='')">
      <xsl:call-template name="extcompdef_no_repeats">
	<xsl:with-param name="titles" select="$rest"/>
      </xsl:call-template>
    </xsl:if>
    
  </xsl:template>
-->
<!-- ####################### -->
<!-- ####################### -->
  <xsl:template name="handle_ext_comp_def">
    <xsl:param name="title"/>

      <!-- <xsl:variable name="classtitle" select="substring-before(substring-after($title, 'Class: '), '(')"/> -->
      <xsl:variable name="classid" select="substring-after(substring-before($title, ')'), '(')"/>

      <span data-sortkey="{$title}">
      
      <h3 id="ext-comp-{$classid}" class="indexable" data-level="3">
        <xsl:value-of select="$title"/>
	<!-- Class <xsl:value-of select="concat($classid, ' - ', $classtitle)"/> -->
      </h3>
      <xsl:choose>
	<xsl:when test="//*[@title=$title]/cc:class-description"><xsl:apply-templates select="//*[@title=$title]/cc:class-description/node()"/></xsl:when>
	<xsl:otherwise>This <xsl:call-template name="doctype-short"/> defines the following extended components as part of the
	 <xsl:value-of select="$classid"/> class originally defined by CC Part 2:
	</xsl:otherwise>
      </xsl:choose>
      
      <xsl:for-each select="//*[@title=$title]/cc:ext-comp-def">
      <xsl:variable name="famId"><xsl:value-of select="translate(@fam-id,$upper,$lower)"/></xsl:variable>
      <h3 id="ext-comp-{@fam-id}" class="indexable" data-level="4">
          <xsl:value-of select="@fam-id"/> <xsl:text> </xsl:text><xsl:value-of select="@title"/></h3>
      <div style="margin-left: 1em;">
      <xsl:choose>
        <xsl:when test="cc:fam-behavior">
		
          <h4>Family Behavior</h4>
          <div> <xsl:apply-templates select="cc:fam-behavior"/> </div>

	  <h4>Component Leveling</h4>
          <!-- Select all f-components that are not new and not a modified-sfr -->
          <xsl:variable name="dcount"
            select="count(//cc:f-component[starts-with(@cc-id, $famId) and not(@notnew)][not(ancestor::cc:modified-sfrs) and (cc:comp-lev)])"/>
          <svg xmlns="http://www.w3.org/2000/svg" style="{concat('max-height: ', 20*$dcount+10, 'px;')}">
              <xsl:call-template name="drawbox">
                <xsl:with-param name="ybase" select="20*floor($dcount div 2)"/>
                <xsl:with-param name="boxtext" select="@fam-id"/>
              </xsl:call-template>
              <xsl:for-each select="//cc:f-component[starts-with(@cc-id, $famId)and not(@notnew)][not(ancestor::cc:modified-sfrs) and (cc:comp-lev)]">
                <xsl:variable name="box_text"><!--
                  --><xsl:value-of select="substring-after(@cc-id, '.')"/><!--
                  --><xsl:if test="@iteration">/<xsl:value-of select="@iteration"/></xsl:if></xsl:variable>
                <xsl:call-template name="drawbox">
                  <xsl:with-param name="ybase" select="( position() - 1)* 20"/>
                  <xsl:with-param name="boxtext" select="$box_text"/>
                  <xsl:with-param name="xbase" select="230"/>
                  <xsl:with-param name="ymid" select="20*floor($dcount div 2)"/>
                </xsl:call-template>
              </xsl:for-each>
          </svg>
<!--          </xsl:element> -->
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="cc:mod-def"/>
        </xsl:otherwise>
      </xsl:choose>

	<!-- All Component descriptions --> 
      <xsl:for-each select="//cc:f-component[starts-with(@cc-id, $famId) and not(@notnew)][not(ancestor::cc:modified-sfrs) and (cc:comp-lev)]">
         <xsl:variable name="upId"><xsl:apply-templates select="." mode="getId"/></xsl:variable>
         <p><xsl:value-of select="$upId"/>,
             <xsl:value-of select="@name"/>,
             <xsl:apply-templates select="cc:comp-lev" mode="reveal"/>
         </p>
      </xsl:for-each>
	    
      <!-- Individual Management, Audit, and Component definitions -->
      <xsl:for-each select="//cc:f-component[starts-with(@cc-id, $famId) and not(@notnew)][not(ancestor::cc:modified-sfrs) and (cc:comp-lev)]">
         <xsl:variable name="upId"><xsl:apply-templates select="." mode="getId"/></xsl:variable>
         <h4>Management: <xsl:value-of select="$upId"/></h4>
         <p><xsl:if test="not(cc:management)">There are no management functions foreseen.</xsl:if>
		    <xsl:if test="cc:management=''">There are no management functions foreseen.</xsl:if>  
            <xsl:apply-templates select="cc:management" mode="reveal"/>
         </p>

         <h4>Audit: <xsl:value-of select="$upId"/></h4>
         <p><xsl:if test="not(cc:audit)">There are no audit events foreseen.</xsl:if>
	    <xsl:if test="cc:audit=''">There are no audit events foreseen.</xsl:if>  
            <xsl:apply-templates select="cc:audit" mode="reveal"/>
         </p>
         <h4><xsl:value-of select="$upId"/><xsl:text> </xsl:text><xsl:value-of select="@name"/></h4>
         <div style="margin-left: 1em;">
           <table class="ecd_heir_dep" style="width: 100%"><tr>
             <td style="whitespace: nowrap">Hierarchical to:</td>
	     <td style="width: 100%"><xsl:if test="not(cc:heirarchical-to)">No other components.</xsl:if>
             <xsl:apply-templates select="cc:heirarchical-to" mode="reveal"/></td>
	   </tr><tr style="background-color: inherit">
	   <td>Dependencies to:</td>
	   <td><xsl:if test="not(cc:dependencies)">No dependencies.</xsl:if>
           <xsl:apply-templates select="cc:dependencies" mode="reveal"/></td>
	 </tr></table>


         <xsl:for-each select="cc:f-element">
            <xsl:variable name="reqid"><xsl:apply-templates select="." mode="getId"/></xsl:variable>
            <h4  id="ext-comp-{$reqid}" >
              <xsl:value-of select="translate($reqid, $lower,$upper)"/>
            </h4>
                 <xsl:choose>
                    <xsl:when test="cc:ext-comp-def-title">
                       <xsl:apply-templates select="cc:ext-comp-def-title/cc:title"/>
                    </xsl:when>
                    <xsl:when test="document('SFRs.xml')//cc:sfr[@cc-id=$reqid]">
                       <xsl:apply-templates select="document('SFRs.xml')//cc:sfr[@cc-id=$reqid]/cc:title"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:if test="cc:title//@id">
<xsl:message>* Warning: Since <xsl:value-of select="$reqid"/> has an 'id' attribute in a descendant node in the title, you probably need to define an alternative 'ext-comp-def-title'.
                       </xsl:message></xsl:if>
                       <xsl:apply-templates select="cc:title"/>
                    </xsl:otherwise>
                </xsl:choose>
         </xsl:for-each>
	 </div>
      </xsl:for-each>
      </div>
    </xsl:for-each>
  </span>
  </xsl:template>
  
  <!-- ####################### -->

  
<!-- ####################### -->
 <xsl:template name="RecursiveGrouping">
  <xsl:param name="list"/>
  <xsl:param name="fake_mode" select="'table'"/>

  <!-- Selecting the title as group identifier and the group itself-->
  <xsl:variable name="group-identifier" select="$list[1]/@title"/>
  <xsl:variable name="group" select="$list[@title=$group-identifier]"/>

  <xsl:choose><xsl:when test="$fake_mode='table'">
  <!-- Do some work for the group -->
  <tr data-sortkey="{$group-identifier}"> <td><xsl:value-of select="$group-identifier"/></td>
       <td>
         <xsl:for-each select="//*[@title=$group-identifier]/cc:ext-comp-def"><xsl:sort select="@fam-id"/>
           <xsl:value-of select="translate(@fam-id,lower,upper)"/><xsl:text> </xsl:text><xsl:value-of select="@title"/><br/>
         </xsl:for-each>
       </td>
  </tr>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="handle_ext_comp_def">
      <xsl:with-param name="title" select="$group-identifier"/>
    </xsl:call-template>
  </xsl:otherwise></xsl:choose>

    <!-- If there are other groups left, calls itself -->
    <xsl:if test="count($list)>count($group)">
      <xsl:call-template name="RecursiveGrouping">
        <xsl:with-param name="list" select="$list[not(@title=$group-identifier)]"/>
        <xsl:with-param name="fake_mode" select="$fake_mode"/>
      </xsl:call-template>
    </xsl:if>
 </xsl:template>

<!-- ####################### -->
<!-- ####################### -->
  <xsl:template match="cc:consistency-rationale//cc:_">
    <xsl:param name="base"/>
    <xsl:if test="$base=''">
      <xsl:message>Unable to figure out the base name for the '_' wildcard at:
      <xsl:call-template name="genPath"/>
      This usually happens when an '_' element is buried in html. It must be right under
      consistency-rationale (sorry).
     </xsl:message>
    </xsl:if>
    <xsl:value-of select="$base"/>
  </xsl:template>

  <!-- ####################### -->
  <!--                         -->
  <!-- ####################### -->
  <xsl:template name="drawbox">
    <xsl:param name="ybase"/>
    <xsl:param name="boxtext"/>
    <xsl:param name="xbase">0</xsl:param>
    <xsl:param name="ymid"/>
    <xsl:variable name="width"><xsl:choose><xsl:when test="$xbase='0'">150</xsl:when>
      <xsl:otherwise><xsl:value-of select="string-length($boxtext)*12"/></xsl:otherwise></xsl:choose></xsl:variable>


    <xsl:element name="text">
      <xsl:attribute name="x"><xsl:value-of select="$xbase + 4"/></xsl:attribute>
      <xsl:attribute name="fill">black</xsl:attribute>
      <xsl:attribute name="font-size">15</xsl:attribute>
      <xsl:attribute name="y"><xsl:value-of select="$ybase + 24"/></xsl:attribute>
      <xsl:value-of select="$boxtext"/>
    </xsl:element>
    <xsl:element name="rect">
      <xsl:attribute name="x"><xsl:value-of select="$xbase + 2"/></xsl:attribute>
      <xsl:attribute name="y"><xsl:value-of select="$ybase + 11"/></xsl:attribute> 
      <xsl:attribute name="width"><xsl:value-of select="$width"/></xsl:attribute>
      <xsl:attribute name="height">16</xsl:attribute>
      <xsl:attribute name="fill">none</xsl:attribute>
      <xsl:attribute name="stroke">black</xsl:attribute>
    </xsl:element>
    <xsl:if test="$xbase>0">
      <xsl:element name="line">
        <xsl:attribute name="x1">152</xsl:attribute> <!-- 2 more than the width above -->
        <xsl:attribute name="y1"><xsl:value-of select="$ymid + 17"/></xsl:attribute>
        <xsl:attribute name="x2"><xsl:value-of select="$xbase + 1"/></xsl:attribute>
        <xsl:attribute name="y2"><xsl:value-of select="$ybase + 17"/></xsl:attribute>
        <xsl:attribute name="stroke">black</xsl:attribute>
      </xsl:element>
    </xsl:if>

  </xsl:template>

  <!-- Hide this when we stumble on it -->
  <xsl:template match="cc:ext-comp-def|cc:ext-comp-def-title"/>
  <xsl:template match="cc:consistency-rationale|cc:comp-lev|cc:management|cc:audit|cc:heirarchical-to|cc:dependencies"/>
  <xsl:template match="cc:ext-comp-extra-pat"/>

  <xsl:template match="cc:*" mode="reveal">
     <xsl:apply-templates/>
  </xsl:template>



</xsl:stylesheet>

