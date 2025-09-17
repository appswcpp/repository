<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:x="http://www.w3.org/1999/XSL/Transform"
  xmlns:cc="https://niap-ccevs.org/cc/v1"
  xmlns:htm="http://www.w3.org/1999/xhtml"
  xmlns:h="http://www.w3.org/1999/xhtml"
  xmlns:sec="https://niap-ccevs.org/cc/v1/section">

  <!--##############################################
           Includes
      ##############################################-->
  <xsl:import href="js-content.xsl"/>
  <xsl:import href="css-content.xsl"/>
  <xsl:import href="make-ref.xsl"/>
  <xsl:import href="debug.xsl"/>
  <xsl:import href="sanity_checks.xsl"/>
  <xsl:import href="functions.xsl"/>

  <!--##############################################
           Parameters
      ##############################################-->
  <!-- Variable for selecting how much debugging we want -->
  <xsl:param name="debug" select="'v'"/>

  <!--##############################################
           Constants
      ##############################################-->
  <!-- #Adds 3 non-breaking spaces -->
  <xsl:variable name="space3">&#160;&#160;&#160;</xsl:variable>

  <xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

  <xsl:variable name="title"><xsl:choose>
      <xsl:when test="//cc:PPTitle"><xsl:value-of select="//cc:PPTitle"/></xsl:when>
      <xsl:otherwise>PP-Module for <!--
      --><xsl:call-template name="cap_first_letters">
      <xsl:with-param name="val"><x:apply-templates mode="get_product_plural" select="/cc:Module"/></xsl:with-param>
      </xsl:call-template></xsl:otherwise>
  </xsl:choose></xsl:variable>

  <!--##############################################
           Templates
      ##############################################-->
 
 <!-- ############################################################
           Gets the ID for the f-component or f-element
       ############################################################-->
 <xsl:template match="cc:f-component|cc:f-element|cc:f-component-decl|cc:base-sfr-spec" mode="getId">
    <xsl:variable name="iter"><xsl:choose>
      <xsl:when test="local-name()='f-component'"><xsl:value-of select="@iteration"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="../@iteration"/></xsl:otherwise>
    </xsl:choose></xsl:variable>
    <xsl:variable name="baseID"><xsl:choose>
      <xsl:when test="local-name()='f-component'"><xsl:value-of select="@cc-id"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="../@cc-id"/></xsl:otherwise>
    </xsl:choose></xsl:variable>
    <xsl:value-of select="translate($baseID, $lower, $upper)"/>
    <xsl:if test="local-name()='f-element'">.<xsl:value-of select="count(preceding-sibling::cc:f-element)+1"/></xsl:if>
    <xsl:if test="not($iter='')">/<xsl:value-of select="$iter"/></xsl:if>
  </xsl:template>

  <!-- ############################################################
           Gets the ID for the a-component or a-element
       ############################################################-->
  <xsl:template match="cc:a-component|cc:a-element" mode="getId">
    <xsl:variable name="baseID"><xsl:choose>
      <xsl:when test="name()='a-component'"><xsl:value-of select="@cc-id"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="../@cc-id"/></xsl:otherwise>
    </xsl:choose></xsl:variable>
    <xsl:value-of select="translate($baseID, $lower, $upper)"/>
    <xsl:if test="name()='a-element'">.<xsl:value-of select="count(preceding-sibling::cc:a-element[@type=current()/@type])+1"/><xsl:value-of select="@type"/></xsl:if>
  </xsl:template>

  <!-- ############################################################
           Gets the ID for a selectable 
       ############################################################-->
  <xsl:template match="cc:selectable[@id]" mode="getId">
    <xsl:value-of select="@id"/>
  </xsl:template> 
  <xsl:template match="cc:selectable" mode="getId"><!--
-->_s_<xsl:number count="//cc:selectable" level="any"/>
  </xsl:template> 

  <xsl:template match="cc:assignable[@id]" mode="getId">
    <xsl:value-of select="@id"/>
  </xsl:template> 
  <xsl:template match="cc:assignable" mode="getId"><!--
-->_a_<xsl:number count="//cc:assignable" level="any"/>
  </xsl:template> 

  <xsl:template match="cc:test[@id]" mode="getId">
    <xsl:value-of select="@id"/>
  </xsl:template> 
  <xsl:template match="cc:test[not(@id)]" mode="getId"><!--
-->_t_<xsl:number count="//cc:test" level="any"/>
  </xsl:template> 

  
  <!-- ############### -->
  <!-- ############### -->
  <xsl:template name="f-comp-activities">
     <xsl:if test=".//cc:aactivity">
       <div class="activity_pane hide">
         <div class="activity_pane_header">
           <a onclick="toggle(this);return false;" href="#">
            <span class="activity_pane_label"> Evaluation Activities </span>
            <span class="toggler"/>
	   </a>
         </div>
         <div class="activity_pane_body">
          <xsl:apply-templates select="." mode="handle-activities"/>
        </div>
       </div>
    </xsl:if>
  </xsl:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  
   <!-- For Component-level EAs -->
   <x:template name="collect-cat">
    <x:param name="cat"/>

    <x:if test=".//cc:aactivity[not(@level='element') and not(ancestor::cc:management-function)]/cc:*[local-name()=$cat]">
	  <x:if test="$cat!='CustomEA'">
		<div class="eacategory"><x:value-of select="$cat"/></div>
	  </x:if>
      <div class="ea">
		<x:choose>
		<x:when test="$cat='CustomEA'">
			<x:apply-templates select=".//cc:aactivity[not(@level='element') and not(ancestor::cc:management-function)]/cc:CustomEA" mode="comp-ea"/>		
		</x:when>
		<x:otherwise>
			<x:apply-templates select=".//cc:aactivity[not(@level='element') and not(ancestor::cc:management-function)]/cc:*[$cat=local-name()]" mode="comp-ea"/>
		</x:otherwise>
		</x:choose>
      </div>
    </x:if>
  </x:template>

<!-- Component-level no-tests EAs -->
<xsl:template match="cc:no-tests">
   <xsl:choose>
	<xsl:when test=".=''">
		TODO: You need to explain the lack of EAs for this component!!!!
	</xsl:when>
	<xsl:otherwise>
		<xsl:apply-templates/><br/><br/>
	</xsl:otherwise>
   </xsl:choose>
</xsl:template>

<!-- Element-level and Management function no-tests EAs -->
<xsl:template match="cc:no-tests" mode="single-cat">
    <xsl:choose>
		<xsl:when test=".='' and not(ancestor::cc:management-function)">
			TODO: You need to explain the lack of EAs for this element!!!!<br/><br/>
		</xsl:when>
		<xsl:when test=".='' and ancestor::cc:management-function">
			TODO: You need to explain the lack of EAs for this mnagement function!!!!<br/><br/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates/><br/><br/>
		</xsl:otherwise>
	</xsl:choose>
  </xsl:template>

  <!-- Component-level TSS EAs -->
  <xsl:template match="cc:TSS" mode="comp-ea">
    <xsl:choose>
		<xsl:when test=".=''">
			There are no additional TSS evaluation activities for this component.<br/>
		</xsl:when>
		<xsl:otherwise>
			<div class="ea"><xsl:apply-templates/></div>
		</xsl:otherwise>
	</xsl:choose>
  </xsl:template>
  
  <!-- Element-level & Managament Function TSS EAs -->
  <xsl:template match="cc:TSS" mode="single-cat">
	<div class="eacategory"><xsl:value-of select="local-name()"/></div>
    <xsl:choose>
		<xsl:when test=".='' and not(ancestor::cc:management-function)">
			There are no additional TSS evaluation activities for this element.<br/><br/>
		</xsl:when>
		<xsl:when test=".='' and ancestor::cc:management-function">
			There are no additional TSS evaluation activities for this management function.<br/><br/>
		</xsl:when>
		<xsl:otherwise>
			<div class="ea"><xsl:apply-templates/></div>
		</xsl:otherwise>
	</xsl:choose>
  </xsl:template>

 <!-- Component-level Guidance EAs -->
  <xsl:template match="cc:Guidance" mode="comp-ea">
    <xsl:choose>
		<xsl:when test=".=''">
			There are no additional Guidance evaluation activities for this component.<br/>
		</xsl:when>
		<xsl:otherwise>
			<div class="ea"><xsl:apply-templates/></div>
		</xsl:otherwise>
	</xsl:choose>
  </xsl:template>

 <!-- Element-level & Managament Function Guidance EAs -->
  <xsl:template match="cc:Guidance" mode="single-cat">
	<div class="eacategory"><xsl:value-of select="local-name()"/></div>
    <xsl:choose>
		<xsl:when test=".='' and not(ancestor::cc:management-function)">
			There are no additional Guidance evaluation activities for this element.<br/><br/>
		</xsl:when>
		<xsl:when test=".='' and ancestor::cc:management-function">
			There are no additional Guidance evaluation activities for this management function.<br/><br/>
		</xsl:when>
		<xsl:otherwise>
			<div class="ea"><xsl:apply-templates/></div>
		</xsl:otherwise>
	</xsl:choose>
  </xsl:template>
  
<!-- Component-level KMD EAs -->
  <xsl:template match="cc:KMD" mode="comp-ea">
    <xsl:choose>
		<xsl:when test=".=''">
			There are no additional KMD evaluation activities for this component.<br/>
		</xsl:when>
		<xsl:otherwise>
			<div class="ea"><xsl:apply-templates/></div>
		</xsl:otherwise>
	</xsl:choose>
  </xsl:template>

<!-- Element-level & Managament Function KMD EAs -->
  <xsl:template match="cc:KMD" mode="single-cat">
	<div class="eacategory"><xsl:value-of select="local-name()"/></div>
    <xsl:choose>
		<xsl:when test=".='' and not(ancestor::cc:management-function)">
			There are no additional KMD evaluation activities for this element.<br/><br/>
		</xsl:when>
		<xsl:when test=".='' and ancestor::cc:management-function">
			There are no additional KMD evaluation activities for this management function.<br/><br/>
		</xsl:when>
		<xsl:otherwise>
			<div class="ea"><xsl:apply-templates/></div>
		</xsl:otherwise>
	</xsl:choose>
  </xsl:template>


<!-- Component-level CustomEAs -->
  <xsl:template match="cc:CustomEA" mode="comp-ea">
	<div class="eacategory"><xsl:value-of select="@name"/></div>
    <xsl:choose>
		<xsl:when test=".=''">
			There are no <xsl:value-of select="@name"/> evaluation activities for this component.<br/>
		</xsl:when>
		<xsl:otherwise>
			<div class="ea"><xsl:apply-templates/></div>
		</xsl:otherwise>
	</xsl:choose>
  </xsl:template>

<!-- Element-level & Managament Function CustomEA EAs -->
  <xsl:template match="cc:CustomEA" mode="single-cat">
	<div class="eacategory"><xsl:value-of select="@name"/></div>
    <xsl:choose>
		<xsl:when test=".='' and not(ancestor::cc:management-function)">
			There are no <xsl:value-of select="@name"/> evaluation activities for this element.<br/><br/>
		</xsl:when>
		<xsl:when test=".='' and ancestor::cc:management-function">
			There are no <xsl:value-of select="@name"/> evaluation activities for this management function.<br/><br/>
		</xsl:when>
		<xsl:otherwise>
			<div class="ea"><xsl:apply-templates/></div>
		</xsl:otherwise>
	</xsl:choose>
  </xsl:template>


<!-- Component-level Test EAs -->
 <xsl:template match="cc:Tests" mode="comp-ea">
    <xsl:choose>
		<xsl:when test=".=''">
			There are no test activities for this component.<br/>
		</xsl:when>
		<xsl:otherwise>
			<div class="ea"><xsl:apply-templates/></div>
		</xsl:otherwise>
	</xsl:choose>
  </xsl:template>

<!-- Element-level & Managament Function Test EAs -->
 <xsl:template match="cc:Tests" mode="single-cat">
	<div class="eacategory"><xsl:value-of select="local-name()"/></div>
    <xsl:choose>
		<xsl:when test=".='' and not(ancestor::cc:management-function)">
			There are no test activities for this element.<br/><br/>
		</xsl:when>
		<xsl:when test=".='' and ancestor::cc:management-function">
			There are no test activities for this management function.<br/><br/>
		</xsl:when>
		<xsl:otherwise>
			<div class="ea"><xsl:apply-templates/></div>
		</xsl:otherwise>
	</xsl:choose>
  </xsl:template>
  

  <!-- ############### -->
<!--  <xsl:template match="cc:TSS|cc:Guidance|cc:KMD|cc:Tests" mode="single-cat">
    <div class="eacategory"><xsl:value-of select="local-name()"/></div>
    <div class="ea"><xsl:apply-templates/></div>
  </xsl:template>
-->

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:management-function/cc:aactivity"  mode="manact">
    <b>Function<xsl:if test="cc:also">s</xsl:if><xsl:text> </xsl:text>
    <xsl:apply-templates select=".." mode="make_xref"/>
       <xsl:for-each select="cc:also"><xsl:variable name="ref-id" select="@ref-id"/><!--
         -->/<xsl:apply-templates select="//cc:management-function[$ref-id=@id]" mode="make_xref"/></xsl:for-each>
       <xsl:if test="not(../cc:M)"> [CONDITIONAL] </xsl:if>
       </b><br/>
       <xsl:apply-templates mode="single-cat"/>
       <h:br/>
  </xsl:template>
  
  
  <!-- ############### -->
  <xsl:template match="cc:management-function/cc:app-note//cc:_">
    <xsl:apply-templates select="ancestor::cc:management-function[1]" mode="make_xref"/>        
    <xsl:choose>
      <xsl:when test="count(ancestor::cc:app-note[1]/cc:also)=1">
        <xsl:variable name="ref" select="ancestor::cc:app-note[1]/cc:also/@ref-id"/>
        and <xsl:apply-templates select="//cc:*[@id=$ref]" mode="make_xref"/>
      </xsl:when>
      <xsl:when test="count(ancestor::cc:app-note[1]/cc:also)>1">
	<xsl:for-each select="ancestor::cc:app-note[1]/cc:also">
          <xsl:variable name="ref" select="@ref-id"/>
          , <xsl:if test="position() = last()">and </xsl:if>
	  <xsl:apply-templates select="//cc:*[@id=$ref]" mode="make_xref"/>
	</xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <!-- ############### -->
  <xsl:template match="cc:management-function/cc:aactivity/cc:_">
    <xsl:choose>
      <xsl:when test="ancestor::cc:management-function[1]/cc:also">
        <xsl:for-each select="ancestor::cc:*[1]/cc:also">
          <xsl:variable name="ref" select="@ref-id"/>
          <xsl:apply-templates mode="getId" select="//cc:management-function[@ref=@ref-id]"/>,
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates select="ancestor::cc:management-function[1]" mode="make_xref"/>    
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <x:template name="get-endnote-label">
    <x:number count="//cc:endnote" level="any"/>
  </x:template>


  <x:template match="cc:endnote">
    <!-- <x:variable name="label"><x:call-template name="get-endnote-label"/></x:variable> -->
    <!-- <a class="endnoteref" href="#_endnote_{$label}"><sup><x:value-of select="$label"/></sup></a> -->
  </x:template>

  <x:template match="cc:endnote" mode="revealendnote">
  </x:template>
  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
   <x:template match="cc:f-component | cc:a-component" mode="handle-activities">  
	<!-- Display component name -->
        <x:if test=".//cc:aactivity[not(@level='element')]">
          <div class="component-activity-header"><x:apply-templates select="." mode="getId"/></div>
          <x:apply-templates
            select=".//cc:aactivity[not(@level='element')]/node()[not(self::cc:TSS or self::cc:Guidance or self::cc:KMD or self::cc:CustomEA or self::cc:Tests)]"/>
          <x:call-template name="collect-cat"><x:with-param name="cat" select="'TSS'"/></x:call-template>	    
          <x:call-template name="collect-cat"><x:with-param name="cat" select="'Guidance'"/></x:call-template>	    
          <x:call-template name="collect-cat"><x:with-param name="cat" select="'KMD'"/></x:call-template>	
		  <x:call-template name="collect-cat"><x:with-param name="cat" select="'CustomEA'"/></x:call-template>	
          <x:call-template name="collect-cat"><x:with-param name="cat" select="'Tests'"/></x:call-template>	    
        </x:if>
   	<x:for-each select=".//cc:aactivity[@level='element']">
          <!-- Display the element name -->
	  <div class="element-activity-header"><x:apply-templates select=".." mode="getId"/></div>
          <x:apply-templates mode="single-cat"/>
	</x:for-each>
	<x:if test=".//cc:management-function/cc:aactivity">
	  
	  <div class="management_function_activities">
	    The following EAs correspond to specific management functions.
	    <x:for-each select=".//cc:management-function[./cc:aactivity]">
	      <div class="management_function_ea">
		<x:apply-templates select="cc:aactivity" mode="manact"/>
	      </div>
	    </x:for-each>
	  </div>
	</x:if>

   </x:template>
 


  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:tech-terms">
    <xsl:param name="num" select="2"/>
    <div class="no-link">
    <h2 id='glossary' class='indexable' data-level='{$num}'>Terms</h2>
The following sections list Common Criteria and technology terms used in this document.
    <h3 id="cc-terms" class="indexable" data-level="{$num+1}">Common Criteria Terms</h3>
    <table>
      <xsl:variable name="ignore_list" select="concat(',',//cc:suppress,',')"/>
      <xsl:for-each select="//cc:cc-terms/cc:term[text()]|document('boilerplates.xml')//cc:cc-terms/cc:term[text()]">
        <xsl:sort select="translate(@full, $upper, $lower)"/>
        <xsl:if test="not(contains($ignore_list, concat(',',@full,',')))">
          <xsl:call-template name="glossary-entry"/>
        </xsl:if>
      </xsl:for-each>
    </table>
    <h3 id="tech-terms" class="indexable" data-level="{$num+1}">Technical Terms</h3>
    <table style="width: 100%">
      <xsl:for-each select="cc:term[text()]">
        <xsl:sort select="@full"/>
        <xsl:call-template name="glossary-entry"/>
      </xsl:for-each>
    </table>
    </div>
  </xsl:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template name="glossary-entry">
      <tr>
        <xsl:variable name="term_id"><xsl:value-of select="translate(@full,' ','_')"/></xsl:variable>
        <td><div id="{$term_id}">
            <xsl:choose>
                <xsl:when test="@abbr"><xsl:value-of select="@full"/> (<xsl:value-of select="@abbr"/>)</xsl:when>
                <xsl:otherwise><xsl:value-of select="@full"/></xsl:otherwise>
            </xsl:choose>
        </div></td>
        <td><xsl:apply-templates/></td>
      </tr><xsl:text>&#xa;</xsl:text>
  </xsl:template>



  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="sec:*|cc:section">
    <xsl:apply-templates select="." mode="make_header"/>
    <xsl:apply-templates select="." mode="hook"/>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template name="compute-level">
    <xsl:value-of 
      select="count(ancestor-or-self::cc:section|ancestor-or-self::sec:*|ancestor::cc:base-pp|ancestor::cc:appendix|ancestor::cc:man-sfrs|ancestor::cc:obj-sfrs|ancestor::cc:opt-sfrs|ancestor::cc:impl-dep-sfrs|ancestor::cc:additional-sfrs|ancestor::cc:modified-sfrs)"/>
  </xsl:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->

  <xsl:template mode="make_header" match="cc:section">
    <xsl:param name="level"><xsl:call-template name="compute-level"/></xsl:param>
    <xsl:variable name="ID"><xsl:value-of select="@id"/><!--
    --><xsl:if test="not(@id)">_sec_<xsl:number count="//cc:section" level="any"/></xsl:if><!--
    --></xsl:variable>

    <xsl:call-template name="make_header">
      <xsl:with-param name="title" select="@title"/>
      <xsl:with-param name="id"    select="$ID"/>
      <xsl:with-param name="level" select="$level"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template mode="make_header" match="sec:*[@title]">
    <xsl:param name="level"><xsl:call-template name="compute-level"/></xsl:param>

    <xsl:call-template name="make_header">
      <xsl:with-param name="title" select="@title"/>
      <xsl:with-param name="id"    select="local-name()"/>
      <xsl:with-param name="level" select="$level"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template mode="make_header" match="sec:*[not(@title)]">
    <xsl:param name="level"><xsl:call-template name="compute-level"/></xsl:param>

   <xsl:call-template name="make_header">
      <xsl:with-param name="title" select="translate(local-name(),'_',' ')"/>
      <xsl:with-param name="id"    select="local-name()"/>
      <xsl:with-param name="level" select="$level"/>
    </xsl:call-template>
  </xsl:template>


  <xsl:template name="make_header">
    <xsl:param name="level" select="1"/>
    <xsl:param name="title"/>
    <xsl:param name="id"/>

    <xsl:element name="h{$level}">
      <xsl:attribute name="class">indexable</xsl:attribute>
      <xsl:attribute name="data-level"><xsl:value-of select="$level"/></xsl:attribute>
      <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
      <xsl:value-of select="$title"/>
    </xsl:element>
  </xsl:template>


  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:xref[@to]">
    <xsl:variable name="to" select="@to"/>
    <xsl:choose>
      <xsl:when test="//cc:*[@id=$to]|//sec:*[local-name()=$to]">
        <xsl:apply-templates select="//cc:*[@id=$to]|//sec:*[local-name()=$to]" mode="make_xref">
          <xsl:with-param name="format" select="@format"/>
        </xsl:apply-templates>
      </xsl:when>
     <xsl:otherwise> 
        <xsl:message> Failed to find a reference to <xsl:value-of select="@to"/>.</xsl:message>
        <a href="#{@to}" class="dynref" data-format="{@format}"></a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:xref[@g]">
     <xsl:call-template name="make_ctr_ref">
      <xsl:with-param name="id" select="@g"/>
      <xsl:with-param name="prefix" select="@pre"/>
    </xsl:call-template>
  </xsl:template>

  <!-- ################################################### -->
  <!-- Refs to all the pre-defined auto-generated tables   -->
  <!-- ################################################### -->
  <xsl:template match="cc:xref[@g='t-audit-optional' or @g='t-audit-objective' or 
				@g='t-audit-sel-based' or @g='t-audit-impl-dep' or @g='t-audit-mandatory']">
    <xsl:call-template name="make_ctr_ref">
      <xsl:with-param name="id" select="@g"/>
      <xsl:with-param name="prefix" select="'Table '"/>
    </xsl:call-template>
  </xsl:template>

<!--
<xsl:template match="cc:xref[@g='t-audit-mandatory']">
    <xsl:call-template name="make_ctr_ref">
      <xsl:with-param name="id" select="'t-audit-mandatory'"/>
      <xsl:with-param name="prefix" select="'Table '"/>
    </xsl:call-template>
  </xsl:template>
-->	
	
  <xsl:template match="cc:xref[@g='CC']">
      <a href="#bibCC">[CC]</a>
  </xsl:template>

  <xsl:template match="cc:xref[@g='CEM']">
      <a href="#bibCEM">[CEM]</a>
  </xsl:template>


  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:testlist">
    <span class="testlist-"><ul>
      <xsl:apply-templates/>
    </ul>
    </span>
  </xsl:template>

  
  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:test">
    <xsl:variable name="id"><xsl:apply-templates mode="getId" select="."/></xsl:variable>
    
    <li class="test-">
      <a id="{$id}" class="defined" href="#{$id}">
	<!-- <xsl:apply-templates mode="make_xref" select="."/> -->
      </a>
      <xsl:if test="cc:applies-if or cc:depends">[conditional, <xsl:call-template name="depends-explainer"><xsl:with-param name="words" select="'to be performed if'"/></xsl:call-template>]</xsl:if>:
      <xsl:apply-templates/>
    </li>
  </xsl:template>
  
  <!-- ############### -->
  <!--                 -->
<!-- ############### -->
<xsl:template match="cc:test-obj">
<div class="test-obj"><b>Objective:</b> <xsl:apply-templates/> </div>
  </xsl:template>
  
  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:evidence">
    <div class="evidence"><b>Evidence:</b> <xsl:apply-templates/> </div>
  </xsl:template>

   <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template name="references">
    <h1 id="biblio" class="indexable" data-level="A">References</h1>
    <table>
      <tr class='header'><th>Identifier</th><th>Title</th></tr>
      <xsl:apply-templates select="//cc:bibliography"/>
    </table>
  </xsl:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:componentsneeded">
    <table>
      <tr class='header'><th>Component</th><th>Explanation</th></tr>
      <xsl:apply-templates select="//cc:componentneeded"/>
    </table>
  </xsl:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:componentneeded">
    <tr>
        <td class="componentneeded" id="{cc:componentid}"><xsl:apply-templates select="cc:componentid"/></td>
        <td>
            <xsl:apply-templates select="cc:notes"/><br/>
            <xsl:if test=".//cc:depends"><xsl:call-template name="depends-explainer"><xsl:with-param name="words" select="'Required if:'"/></xsl:call-template></xsl:if>
        </td>
    </tr>
  </xsl:template>
  
 
  <!-- Component needed IDs should not be linked since they are in another document -->
  <xsl:template match="cc:componentid">
    <span class="no-link">
        <xsl:apply-templates/>
    </span>
  </xsl:template>


  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:cc-entry">
<tr><td><span id='bibCC'> [CC] </span></td><td>Common Criteria for Information Technology Security Evaluation - <ul>
            <li><a href='http://www.commoncriteriaportal.org/files/ccfiles/CCPART1V3.1R5.pdf'>Part
                1: Introduction and General Model</a>, CCMB-2017-04-001, Version 3.1 Revision 5,
              April 2017.</li>
            <li><a href='http://www.commoncriteriaportal.org/files/ccfiles/CCPART2V3.1R5.pdf'>Part
                2: Security Functional Components</a>, CCMB-2017-04-002, Version 3.1 Revision 5,
              April 2017.</li>
            <li><a href='http://www.commoncriteriaportal.org/files/ccfiles/CCPART3V3.1R5.pdf'>Part
                3: Security Assurance Components</a>, CCMB-2017-04-003, Version 3.1 Revision 5,
              April 2017.</li>
          </ul></td></tr>
  </xsl:template>


  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:steplist">
    <ul>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <!-- Steps in a steplist -->
  <xsl:template match="cc:step">
    <li>
      <b>Step <xsl:for-each select="ancestor::cc:step"><xsl:value-of
            select="count(preceding-sibling::cc:step) + 1"/>.</xsl:for-each><xsl:value-of
          select="count(preceding-sibling::cc:step) + 1"/>: </b>
      <xsl:apply-templates/>
    </li>
  </xsl:template>

  <!-- Overloaded abbr here-->
  <xsl:template match="cc:abbr[@to]">
    <xsl:variable name="target" select="@to"/>
    <xsl:variable name="full" select="//cc:term[$target=@abbr]/@full|document('boilerplates.xml')//cc:cc-terms/cc:term[$target=@abbr]/@full"/>    
    <xsl:choose>
      <xsl:when test="//cc:term[$target=@abbr]/@full|document('boilerplates.xml')//cc:cc-terms/cc:term[$target=@abbr]/@full">
	<a class="abbr" href="#abbr_{@to}">
	  <abbr title="{$full}"><xsl:value-of select="@to"/></abbr>
	</a>
      </xsl:when>
      <xsl:otherwise>
	<xsl:message>Failed to find the abbreviation: <xsl:value-of select="@to"/> </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


 
  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:choice//cc:selectables">
     <ul>
       <xsl:for-each select="cc:selectable">
	       <li><xsl:apply-templates/></li>
	       <!--	<xsl:choose>
	     <xsl:when test="position() = 1"><xsl:apply-templates/></xsl:when>
         <xsl:when test="position() = last()"> or <xsl:apply-templates/></xsl:when>
         <xsl:otherwise>, <xsl:apply-templates/></xsl:otherwise>
    </xsl:choose>   -->
     </xsl:for-each>
	  </ul>
  </xsl:template>
  
  <!-- -->
  <!-- Selectables template -->
  <!-- -->
  <xsl:template match="cc:selectables">[<b>selection</b>
	  <xsl:if test="@onlyone or @choose-one-of"><b>, choose one of</b></xsl:if><xsl:text>: </xsl:text>
    <!-- Selections are always 'atleastone -->
<!--    <xsl:if test="@atleastone">, at least one of</xsl:if>:  -->
    <xsl:choose>
    <xsl:when test="@linebreak='yes' or .//cc:selectables">
      <ul><xsl:for-each select="cc:selectable">
        <li style="{@style}"><xsl:apply-templates select="." mode="handle_sel"/></li>
      </xsl:for-each></ul>
    </xsl:when>
    <xsl:otherwise>
      <xsl:for-each select="cc:selectable|cc:not-selectable">
	<xsl:apply-templates mode="handle_sel" select="."/><xsl:call-template name="commaifnotlast"/>
<!--	<xsl:text> </xsl:text>   -->
      </xsl:for-each>
    </xsl:otherwise>
 </xsl:choose>]</xsl:template>

 <xsl:template mode="handle_sel" match="cc:selectable|cc:not-selectable">
    <xsl:variable name="id"><xsl:apply-templates mode="getId" select="."/></xsl:variable>
    <span class="{local-name()}-content" id="{$id}"><xsl:apply-templates/></span>
 </xsl:template>

 <xsl:template match="cc:deprecated">!DEPRECATED!</xsl:template>
<!--
    <xsl:when test="@linebreak='no'">
      <xsl:for-each select="cc:selectable">
        <xsl:variable name="id"><xsl:apply-templates mode="getId" select="."/></xsl:variable>
        <i id="{$id}"><xsl:apply-templates/></i><xsl:call-template name="commaifnotlast"/></xsl:for-each></xsl:when>
    - If the selection has a nested selection - -
    <xsl:when test=".//cc:selectables">
      <ul><xsl:for-each select="cc:selectable">
        <xsl:variable name="id"><xsl:apply-templates mode="getId" select="."/></xsl:variable>
        <li style="{@style}"><i id="{$id}"><xsl:apply-templates/></i><xsl:call-template name="commaifnotlast"/></li>
      </xsl:for-each></ul></xsl:when>-->



  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
<!-- Should we include a referencable value? Probably
     Make it an ID seems like it might be too big.
     But making it a number seems difficult given that we just can't count
     the assignables cause they appear in the document in a diffirent order 
     We could clean it up in the Python.
  -->
  <xsl:template match="cc:assignable"><!--
  -->[<b>assignment</b>: 
     <xsl:element name="span"><xsl:attribute name="class">assignable-content</xsl:attribute>
       <xsl:if test="@id"><xsl:attribute name="id">
         <xsl:value-of select="@id"/>
       </xsl:attribute></xsl:if><xsl:apply-templates/></xsl:element>]</xsl:template>

  <xsl:template match="cc:int[@hide]" priority="1"/>

  <xsl:template match="cc:int[@lte and @gte]">
       between <xsl:value-of select="concat(@gte,' and ',@lte)"/>, inclusive
  </xsl:template>

  <xsl:template match="cc:int[@gte and not(@lte)]">
       greater than or equal to <xsl:value-of select="@gte"/>
  </xsl:template>

  <xsl:template match="cc:int[@lte and not(@gte)]">
       less than or equal to <xsl:value-of select="@lte"/>
  </xsl:template>

<!--



  <xsl:element name="sup"><xsl:attribute name="class">a_id</xsl:attribute>
       <xsl:if test="@id"><xsl:attribute name="id">
         <xsl:value-of select="@id"/>
       </xsl:attribute></xsl:if>A13</xsl:element></xsl:template>a-->

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:refinement"><span class="refinement"><xsl:apply-templates/></span></xsl:template>

  <xsl:template match="cc:app-note">
    <p><xsl:apply-templates/></p>
  </xsl:template>	
  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:note[@id]">
    <div class="appnote" id="{@id}">
      <xsl:call-template name="handle-note"/>
    </div>
  </xsl:template>

  <xsl:template match="cc:note">
    <div class="appnote">
      <xsl:call-template name="handle-note"/>
    </div>
  </xsl:template>

  <xsl:template name="handle-note-header">
    <span class="note-header">
      <xsl:call-template name="cap_first_letters"><xsl:with-param name="val" select="@role"/></xsl:call-template>
      Note:
    </span>
  </xsl:template>
 
  <xsl:template name="handle-note">
    <xsl:call-template name="handle-note-header"/>
     <span class="note">
        <xsl:apply-templates/>
        <xsl:if test= "../cc:title/cc:management-function-set[not (@notes-in-table='yes')]//cc:app-note">
          <br/><br/>
          <b>Function-specific Application Notes:</b><br/><br/>
	  <xsl:apply-templates select="../cc:title/cc:management-function-set//cc:app-note"/>
        </xsl:if>
      </span>
  </xsl:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:management-function-set">
    <table class="mfs" style="width: 100%;">
      <tr class="header">
        <td>#</td>
        <td>Management Function</td>
        <xsl:apply-templates select="./cc:manager"/>
		
		<!-- If notes are to be displayed in the table, we need another column -->
		<xsl:if test="@notes-in-table='yes'">
			<td>Application Notes</td>
		</xsl:if>
		
      </tr><xsl:text>&#xa;</xsl:text>
      <xsl:apply-templates select="./cc:management-function"/>
    </table>
  </xsl:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="/cc:PP" mode="get_title">
    <xsl:value-of select="//cc:PPTitle"/>
  </xsl:template>

  
  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="/cc:Module" mode="get_title">
    PP-Module for <xsl:call-template name="cap_first_letters"><xsl:with-param name="val">
    <x:apply-templates mode="get_product_plural" select="/cc:Module"/></xsl:with-param></xsl:call-template>
  </xsl:template>

  
  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="/cc:Module" mode="get_product"><xsl:value-of select="@target-product"/></xsl:template>
  <xsl:template match="/cc:Module[@target-products]" mode="get_product_plural"><xsl:value-of select="@target-product"/></xsl:template>
  <xsl:template match="/cc:Module[not(@target-products)]" mode="get_product_plural"><xsl:apply-templates mode="get_product" select="."/>s</xsl:template>
  
  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:manager">
    <td> <xsl:apply-templates/> </td>
  </xsl:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:management-function[@id]" mode="getId">
    <xsl:value-of select="@id"/>
  </xsl:template>
  <xsl:template match="cc:management-function[not(@id)]" mode="getId"><!--
    -->_mf_<xsl:number count="//cc:management-function" level="any"/><!--
    --></xsl:template>
  
  
  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:management-function">
    <xsl:variable name="mf_num"><xsl:number count="//cc:management-function" level="any"/></xsl:variable>
    <xsl:variable name="mf_id"><xsl:apply-templates select="." mode="getId"/></xsl:variable>
    <tr id="{$mf_id}">
		<td><xsl:value-of select="concat(ancestor::cc:management-function-set/@ctr-prefix,$mf_num)"/></td>
		<td style="text-align:left">
			<xsl:apply-templates select="cc:text"/>
		</td>
		<xsl:variable name="manfunc" select="."/>
		<xsl:for-each select="../cc:manager">
			<xsl:variable name="id" select="@cid"/>
			<td>
				<xsl:choose>
					<!-- If we have something for that role -->
					<xsl:when test="$manfunc/*[@ref=$id]">
						<xsl:call-template name="make-management-value">
							<xsl:with-param name="type"><xsl:value-of select="name($manfunc/*[@ref=$id])"/></xsl:with-param>
						</xsl:call-template>

<!--
						The schema allows only for <depends> tags here, so I don't know what 
						this is all about. 
						
						<xsl:choose>
							<xsl:when test="$manfunc/*[@ref=$id]/node()">
								<xsl:apply-templates select="$manfunc/*[@ref=$id]/."/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="make-management-value">
									<xsl:with-param name="type"><xsl:value-of select="name($manfunc/*[@ref=$id])"/></xsl:with-param>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
-->					
						
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="make-management-value">
							<xsl:with-param name="type"><xsl:value-of select='../@default'/></xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</xsl:for-each>
		<xsl:if test="//cc:management-function-set[@notes-in-table='yes'] and cc:app-note">
			<td style="text-align:left">
				<xsl:apply-templates select="cc:app-note"/>
			</td>
		</xsl:if>
	</tr><xsl:text>&#xa;</xsl:text>
  </xsl:template>


  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template name="make-management-value">
    <xsl:param name="type"/>
    <xsl:choose>
      <xsl:when test="$type='O'"><div>O<span class="tooltiptext">Optional/Conditional</span></div></xsl:when>
      <xsl:when test="$type='M'"><div>M<span class="tooltiptext">Mandatory</span></div></xsl:when>
      <xsl:when test="$type='NA'"><div>-<span class="tooltiptext">N/A</span></div></xsl:when>
      <xsl:when test="$type='X'"><div>X<span class="tooltiptext">Not permitted</span></div></xsl:when>
      <xsl:otherwise><xsl:message>DONTKNOWWHATIT IS:<xsl:value-of select="$type"/></xsl:message></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

   <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:keycol[not(@assign)]">[<b>selection</b>
  <ul>
    <xsl:for-each select="../../cc:selectable">
      <xsl:variable name="id"><xsl:apply-templates mode="getId" select="."/></xsl:variable>
      <li style="{@style}"><i id="{$id}"><xsl:apply-templates select="cc:key"/></i><xsl:call-template name="commaifnotlast"/></li>
    </xsl:for-each></ul>]
  </xsl:template>

  <xsl:template match="cc:keycol[@assign]">
    [<b>assignment</b>:
    <span class="assignable-content"><xsl:apply-templates/></span>]
  </xsl:template>

  


  <xsl:template match="cc:reqtext"><xsl:apply-templates/></xsl:template>

   <xsl:template match="cc:selectcol">
    [<b>selection</b>: 
    <xsl:element name="span"><xsl:attribute name="class">selectable-content</xsl:attribute>
       <xsl:if test="@id"><xsl:attribute name="id">
         <xsl:value-of select="@id"/>
       </xsl:attribute></xsl:if><xsl:apply-templates/></xsl:element>]</xsl:template>
    

  <xsl:template match="cc:assigncol">
    [<b>assignment</b>: 
    <xsl:element name="span"><xsl:attribute name="class">assignable-content</xsl:attribute>
       <xsl:if test="@id"><xsl:attribute name="id">
         <xsl:value-of select="@id"/>
       </xsl:attribute></xsl:if><xsl:apply-templates/></xsl:element>]</xsl:template>

  <xsl:template match="cc:description">
    <span class="description"><xsl:apply-templates/></span>
  </xsl:template>
  
  <xsl:template match="cc:reqtext">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="cc:tabularize">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="cc:selectables[cc:tabularize]">
    <xsl:apply-templates select="cc:tabularize"/>
  </xsl:template>

  <!-- The post_title mode is a hook that runs after the initial title transform. -->
  <xsl:template match="node()" mode="post_title">
     <xsl:apply-templates mode="post_title"/>
  </xsl:template>
  
 

  <xsl:template match="cc:tabularize" mode="tabular">
    <tr><xsl:apply-templates mode="tabular"/></tr><xsl:text>&#xa;</xsl:text>
  </xsl:template>
  
  <xsl:template match="cc:reqtext" mode="tabular"/>

  <xsl:template match="cc:key|cc:col" mode="tabular">
    <td><xsl:apply-templates/></td>
  </xsl:template>
  
  <xsl:template match="cc:keycol|cc:assigncol|cc:textcol|cc:selectcol" mode="tabular">
    <th><xsl:apply-templates/></th>
  </xsl:template>

  <xsl:template match="cc:textcol"/>

  <xsl:template match="cc:selectables[cc:tabularize]/cc:selectable" mode="tabular">
    <tr><xsl:apply-templates mode="tabular"/></tr><xsl:text>&#xa;</xsl:text>
  </xsl:template>
  
  <xsl:template match="cc:selectables[cc:tabularize]" mode="post_title" priority="2">
<!--    <p>
      The rows of
      <xsl:call-template name="make_ctr_ref">
	<xsl:with-param name="id" select="cc:tabularize/@id"/>
	<xsl:with-param name="prefix" select="'Table'"/>
      </xsl:call-template>
      provide the allowable values for completion of the assignments and selections for
      <xsl:apply-templates select="ancestor::cc:f-element[1]" mode="getId"/>.
    </p>-->
    <table>
      <caption><xsl:call-template name="ctr-xsl">
	<xsl:with-param name="ctr-type" select="'Table'"/>
	<xsl:with-param name="id" select="cc:tabularize/@id"/>
	</xsl:call-template>: <xsl:value-of select="cc:tabularize/@title"/>
      </caption>
      <xsl:apply-templates mode="tabular"/>
    </table>
  </xsl:template>


  <!--
      Template that makes a tool tip. Uses javascript
  -->
  <xsl:template name="make-tool-tip">
    <xsl:param name="tip"/>
    <span class="tooltiptext"><xsl:value-of select="$tip"/></span>
  </xsl:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:bibliography/cc:entry">
    <tr>
      <xsl:variable name='id'><xsl:value-of select="@id"/></xsl:variable>
      <xsl:for-each select="cc:*">
	<td><xsl:choose><xsl:when test="not(preceding-sibling::*)"><span id="{$id}"/>[<xsl:apply-templates/>]</xsl:when><xsl:otherwise><xsl:apply-templates/></xsl:otherwise></xsl:choose></td>
      </xsl:for-each>
    </tr><xsl:text>&#xa;</xsl:text>
  </xsl:template>



  <!--
       Change all htm tags to tags with no namespace.
       This should help the transition from output w/ polluted
       namespace to output all in htm namespace. For right now
       this is what we have.
	   
	   Side-effect appears to be drawing a box around platform-dependent tests
	   because using class "dependent". Isn't that special.
  -->
  <xsl:template match="htm:*[./cc:depends]">
    <div class="dependent"><xsl:call-template name="depends-explainer"/>
       <div class="dependent-content">
          <xsl:call-template name="handle-html"/>
      </div>        
    </div>        
  </xsl:template>

  <!-- Maybe this will draw boxes around platform-dependent tests.
       It's worth a try -->
  <xsl:template match="cc:test[./cc:depends]">
    <div class="dependent"><xsl:call-template name="depends-explainer"/>
       <div class="dependent-content">
          <xsl:call-template name="handle-html"/>
      </div>        
    </div>        
  </xsl:template>


  <xsl:template name="depends-explainer">
    <xsl:param name="words" select="'The following content should be included if:'"/>

    <xsl:choose>
      <!-- When it depends on a choice -->
      <xsl:when test="//cc:choice[@prefix]//@id=current()//cc:depends/@*">
         <xsl:value-of select="//cc:choice[.//@id=current()//cc:depends/@*]/@prefix"/><xsl:text> </xsl:text>
         <xsl:for-each select="cc:depends/@*">
            <xsl:if test="position()!=1">,<xsl:text> </xsl:text></xsl:if>
            <xsl:apply-templates select="//cc:selectable[./@id=current()]" mode="make_xref"/>
         </xsl:for-each>
      </xsl:when>
      <!--If we're not looking at a row. Not sure where @hide comes from -->
      <!-- <xsl:when test="cc:depends[not(@hide)] and not(self::htm:tr)"><xsl:value-of select="$words"/> -->
      <xsl:when test="not(self::htm:tr)"><xsl:value-of select="$words"/>
      <ul> <xsl:for-each select="cc:depends"><li>
        <xsl:variable name="uid" select="@*[1]"/>
         <xsl:choose>
	   <xsl:when test="cc:external-doc">
	     <xsl:variable name="ref" select="cc:external-doc/@ref"/>
	     <xsl:variable name="path" select="concat($work-dir,'/',$ref,'.xml')"/>
             <xsl:for-each select="@*"><xsl:if test="position()!=1">,<xsl:text> </xsl:text></xsl:if><span class="no-link-sel"><xsl:apply-templates select="document($path)//cc:selectable[@id=current()]" mode="make_xref"/></span>
             </xsl:for-each>
             is selected from 
             <xsl:apply-templates select="document($path)//cc:f-element[.//cc:selectable/@id=$uid]" mode="getId"/> from  <xsl:apply-templates select="//*[@id=$ref]" mode="make_xref"/> 
	   </xsl:when><xsl:when test="//cc:f-element//cc:selectable/@id=$uid">
             <xsl:for-each select="@*"><xsl:if test="position()!=1">,<xsl:text> </xsl:text></xsl:if><xsl:apply-templates select="//cc:selectable[@id=current()]" mode="make_xref"/>
             </xsl:for-each>
             is selected from 
             <xsl:apply-templates select="//cc:f-element[.//cc:selectable/@id=$uid]" mode="getId"/>
           </xsl:when> <xsl:when test="//cc:selectable[@id=$uid]">For 
             <xsl:for-each select="@*">
               <xsl:if test="position()!=1">/</xsl:if>
             <xsl:apply-templates select="//cc:selectable[./@id=current()]"/>
             </xsl:for-each> TOEs
         </xsl:when><xsl:otherwise>
           the TOE implements 
           <xsl:for-each select="@*">
             <xsl:if test="position()!=1">, </xsl:if>
             "<xsl:value-of select="//cc:feature[@id=current()]/@title"/>"
           </xsl:for-each>
         </xsl:otherwise></xsl:choose>
              <!-- This is a module piece... -->
      </li></xsl:for-each> </ul>
      </xsl:when></xsl:choose>
 </xsl:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <!-- <xsl:template match="htm:p[not(node())]"> -->
  <!--   <xsl:message>Eating empty paragraph element</xsl:message> -->
  <!-- </xsl:template> -->
  
  <xsl:template match="htm:*" name="handle-html">
     <xsl:element name="{local-name()}">
      <!-- Copy all the attributes -->
      <xsl:for-each select="@*">
	<xsl:copy/>
      </xsl:for-each>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- Consume all comments -->
  <xsl:template match="comment()"/>

  <!-- Consume all processing-instructions -->
  <xsl:template match="processing-instruction()"/>

  <!-- Consume all of the following -->
  <xsl:template match="cc:audit-event|cc:depends|cc:ref-id|cc:class-description|cc:provides|cc:requires|cc:readable"/>

  <!--
      Recursively copy and unwrap unmatched things (elements, attributes, text)
  -->
  <xsl:template match="@*|node()"><xsl:copy><xsl:apply-templates select="@*|node()"/></xsl:copy></xsl:template>

  <!--
       By default, quietly unwrap all cc elements that are otherwise unmatched
  -->
  <xsl:template match="cc:*">
    <xsl:if test="contains($debug,'vv')">
      <xsl:message> Unmatched CC tag: <xsl:call-template name="genPath"/></xsl:message>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>



  <!--
      Templates associated with debugging follow.
  -->
<!--  <xsl:template match="cc:comment[@level='critical']">
    <xsl:if test="$release!='draft'">
      <xsl:message terminate="yes"> Must fix elements must be fixed before a release version can be
        generated: <xsl:value-of select="text()"/>
      </xsl:message>
    </xsl:if>
  </xsl:template>a-->
  <xsl:template match="cc:comment" mode="getId">
     <xsl:choose><xsl:when test="@id"></xsl:when><xsl:otherwise>Comment-<xsl:number count="//cc:comment" level="any"/>-</xsl:otherwise></xsl:choose>
  </xsl:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:comment">
    <xsl:variable name="id"><xsl:apply-templates select="." mode="getId"/></xsl:variable>

    <span style="{@style}" class="comment {@class}" id="{$id}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

    <!-- <xsl:choose> -->
    <!--   <xsl:when test="@linebreak='yes'"> -->
    <!--     <xsl:element name="div"> -->
    <!--       <xsl:attribute name="style">background-color: beige; color:<xsl:value-of select="@color" -->
    <!--         /></xsl:attribute> -->
    <!--     </xsl:element> -->
    <!--   </xsl:when> -->
    <!--   <xsl:otherwise> -->
    <!--     <xsl:element name="span"> -->
    <!--       <xsl:attribute name="style">background-color: beige; color:<xsl:value-of select="@color" -->
    <!--         /></xsl:attribute> -->
    <!--       <xsl:value-of select="text()"/> -->
    <!--     </xsl:element> -->
    <!--   </xsl:otherwise> -->
    <!-- </xsl:choose> -->

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template name="head">
    <head>
      <meta content="text/html;charset=utf-8" http-equiv="Content-Type"></meta>
	<meta content="utf-8" http-equiv="encoding"></meta>
	<title><xsl:value-of select="$title"/></title>
        <xsl:call-template name="pp_js"/>
        <style type="text/css">
        <xsl:call-template name="pp_css"/>
	</style>
      </head>
  </xsl:template>


  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template name="body-begin">
    <xsl:if test="//cc:comment">
      <div id="commmentbox-">
	<xsl:for-each select="//cc:comment">
	  <xsl:variable name="id"><xsl:apply-templates select="." mode="getId"/></xsl:variable>
	  <a href="#{$id}">Comment: <xsl:value-of select="$id"/></a><br/>
	</xsl:for-each>
      </div>
    </xsl:if>
      
    
    <h1 class="title" style="page-break-before:auto;"><xsl:value-of select="$title"/></h1>
    <noscript>
      <h1 style="text-align:center; border-style: dashed; border-width: medium; border-color: red;"
          >This page is best viewed with JavaScript enabled!</h1>
    </noscript>
    <div class="center">
		<xsl:choose>
		<xsl:when test="not (//cc:pp-preferences/cc:suppress-niap-logo)">
			<img src="images/niaplogo.png" alt="NIAP Logo"/> 
		</xsl:when>
		<xsl:otherwise>
			<br/><br/><br/><br/>    <!-- <img src="images/cclogo.png" alt="Common Criteria Logo"/> -->
		</xsl:otherwise>
		</xsl:choose>		
		<br/>
	<!-- Might think about getting rid of this and just making it part of the foreword -->
      Version: <xsl:value-of select="//cc:ReferenceTable/cc:PPVersion"/><br/>
      <xsl:value-of select="//cc:ReferenceTable/cc:PPPubDate"/><br/>
<!--   	  <p/><xsl:if test="//cc:ReferenceTable/cc:dateTimeStamp">
			<xsl:value-of select="current-dateTime()"/>
		</xsl:if>  -->
      <b><xsl:value-of select="//cc:PPAuthor"/></b><br/>
    </div>
    <xsl:apply-templates select="//cc:foreword"/>

    <h2 style="page-break-before:always;">Revision History</h2>
    <table>
     <tr class="header">
       <th>Version</th>
       <th>Date</th>
       <th>Comment</th>
     </tr>
     <xsl:for-each select="//cc:RevisionHistory/cc:entry">
       <tr>
         <td> <xsl:value-of select="cc:version"/> </td>
         <td> <xsl:value-of select="cc:date"/> </td>
         <td> <xsl:apply-templates select="cc:subject"/> </td>
       </tr><xsl:text>&#xa;</xsl:text>
     </xsl:for-each>
    </table>
    <xsl:apply-templates select="//cc:release-notes"/>
    <h2>Contents</h2>
    <div class="toc" id="toc"/>
  </xsl:template>

  <!-- ############### -->
  <!--            -->
  <xsl:template match="cc:no-link">
    <span class="no-link">
        <xsl:apply-templates/>
    </span>
  </xsl:template>


  <!-- ############### -->
  <!--            -->
  <xsl:template name="acronyms">
    <h1 id="acronyms" class="indexable" data-level="A">Acronyms</h1>
    <xsl:call-template name="acronym-table"/>
  </xsl:template>


  <!-- ############### -->
  <!--            -->
  <xsl:template name="acronym-table">
    <table>
  		<caption>
			<xsl:call-template name="ctr-xsl">
                <xsl:with-param name="ctr-type">Table</xsl:with-param>
				<xsl:with-param name="id" select="'t-acronyms'"/>
			</xsl:call-template>: Acronyms
		</caption>
      <tr class="header">
        <th>Acronym</th>
        <th>Meaning</th>
      </tr>
      <xsl:variable name="ignore_list" select="concat(',',//cc:suppress,',')"/>

      <xsl:for-each select="//cc:term[@abbr]|document('boilerplates.xml')//cc:cc-terms/cc:term[@abbr]">
        <xsl:sort select="translate(@abbr,$lower, $upper)"/>

        <xsl:if test="not(contains($ignore_list, concat(',',@full,',')))">
        <tr>
            <td>
              <xsl:element name="span">
                 <xsl:attribute name="class">term</xsl:attribute>
                 <xsl:attribute name="id">abbr_<xsl:value-of select="@abbr"/></xsl:attribute>
		 <xsl:apply-templates select="@plural" mode="passthru-data-attr"/>
		 <xsl:apply-templates select="@lower"  mode="passthru-data-attr"/>
                 <xsl:value-of select="@abbr"/>
              </xsl:element>
            </td>
            <td><span id="long_abbr_{@abbr}"><xsl:value-of select="@full"/></span></td>
       </tr><xsl:text>&#10;</xsl:text>
	</xsl:if>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template match="@*" mode="passthru-data-attr">
    <xsl:attribute name="data-{name()}"><xsl:value-of select="."/></xsl:attribute>
  </xsl:template>
  
  <!-- ############### -->
  <!--                 -->
  <xsl:template match="@*|node()">
    <!-- <xsl:message>Unmatched element caught by identity transform: <xsl:value-of select ="name()"/></xsl:message> -->
    <!-- identity transform - useful for debugging -->
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- ############### -->
  <!--                 -->
  <xsl:template match="@*|node()" mode="appendicize">
      <!-- if no template matches when the mode is set to appendicize,
       default to a template without the mode set.  this may default
       to calling the identity transform above -->
      <xsl:apply-templates select="current()" />
  </xsl:template>


</xsl:stylesheet>
