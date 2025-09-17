<?xml version="1.0" encoding="utf-8"?>
<!--

FILE: module2sd.xsl

Transforms PP Modules into Support Documentation.
-->

<x:stylesheet xmlns:x="http://www.w3.org/1999/XSL/Transform"
	      xmlns:cc="https://niap-ccevs.org/cc/v1"
	      xmlns:sec="https://niap-ccevs.org/cc/v1/section"
	      xmlns="http://www.w3.org/1999/xhtml"
	      xmlns:h="http://www.w3.org/1999/xhtml"
	      version="1.0">

<!-- ################################################## -->
<!--                  Imports                           -->
<!-- ################################################## -->
  <x:import href="ppcommons.xsl"/>
  <x:import href="module-commons.xsl"/>


  <x:variable name="doctype" select="'SD'"/>

  <!-- Forces output to make XML and thus needs to be 
       HTMLized by another transformer  -->
  <x:output method="xml" encoding="UTF-8"/>

<!-- ################################################## -->
<!--                  Templates                         -->
<!-- ################################################## -->

  <x:template match="/"><x:apply-templates/></x:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
   <x:template match="/cc:*">
    <!-- Start with !doctype preamble for valid (X)HTML document. -->
    <html xmlns="http://www.w3.org/1999/xhtml">
      <x:call-template name="module-head"/>
      <body>
	<x:call-template name="meta-data"/>
	<x:call-template name="foreward"/>
	<x:call-template name="toc"/>
	<x:call-template name="intro"/>
	<x:call-template name="sfrs"/>
	<x:apply-templates select="/cc:*" mode="sars"/>
	<x:call-template name="sup-info"/>
	<x:call-template name="references"/>
      </body>
    </html>
  </x:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
<!--
  <x:template name="make-section">
    <x:param name="title"/>
    <x:param name="id"/>
    <x:param name="depth" 
      select="count(ancestor-or-self::cc:section) + count(ancestor-or-self::sec:*)+count(ancestor::cc:base-pp)"/>

    <x:element name="h{$depth}">
      <x:attribute name="id"><x:value-of select="$id"/></x:attribute>
      <x:attribute name="class">indexable,h<x:value-of select="$depth"/></x:attribute>
      <x:attribute name="data-level"><x:value-of select="$depth"/></x:attribute>
      <x:value-of select="$title"/>
    </x:element>
    <x:apply-templates select=".//cc:f-component"/>
  </x:template>
-->

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
 <x:template name="meta-data">
    <div style="text-align: center; margin-left: auto; margin-right: auto;">
      <h1 class="title" style="page-break-before:auto;">Supporting Document<br/>
        Mandatory Technical Document</h1>
		<x:choose>
		<x:when test="not (//cc:pp-preferences/cc:suppress-niap-logo)">
			<img src="images/niaplogo.png" alt="NIAP Logo"/> 
		</x:when>
		<x:otherwise>
			<br/><br/><br/><br/>    <!-- <img src="images/cclogo.png" alt="Common Criteria Logo"/> -->
		</x:otherwise>
		</x:choose>		
      <hr width="50%"/>
      <noscript><h1 style="text-align:center; border-style: dashed; border-width: medium; border-color: red;">This page is best viewed with JavaScript enabled!</h1></noscript><br/>
      <x:apply-templates select="/cc:*" mode="get_title"/><br/>
      Version: <x:value-of select="//cc:ReferenceTable/cc:PPVersion"/><br/>
      <x:value-of select="//cc:ReferenceTable/cc:PPPubDate"/><br/>
      <b><x:value-of select="//cc:PPAuthor"/></b>
      </div>
  </x:template>


  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
   <x:template name="toc">
    <h1>Table of Contents</h1>
    <div id="toc"/>
  </x:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
   <x:template name="module-head">
    <head> 
      <title>Supporting Document - <x:apply-templates select="/cc:*" mode="get_title"/></title>
      <style type="text/css">
	<x:call-template name="common_css"/>
      </style>
    </head>
  </x:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <x:template name="sup-info">
    <h1 id="sup-info" class="indexable" data-level="0">Required Supplementary Information</h1>
    <p>This Supporting Document has no required supplementary information beyond the ST, operational
guidance, and testing.</p>
  </x:template>


  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
   <x:template name="sfrs">
    <h1 id="sfr" class="indexable" data-level="0">Evaluation Activities for SFRs</h1>
    <p>The EAs presented in this section capture the actions the evaluator performs 
    to address technology specific aspects covering specific SARs (e.g. ASE_TSS.1, 
    ADV_FSP.1, AGD_OPE.1, and ATE_IND.1) – this is in addition to the CEM workunits 
    that are performed in Section <a href="#sar_aas" class="dynref"></a>.</p>
    
    <p>Regarding design descriptions (designated by the subsections labeled TSS, as 
    well as any required supplementary material that may be treated as proprietary), 
    the evaluator must ensure there is specific information that satisfies the EA. 
    For findings regarding the TSS section, the evaluator’s verdicts will be 
    associated with the CEM workunit ASE_TSS.1-1.
    Evaluator verdicts associated with the supplementary evidence will also be 
    associated with ASE_TSS.1-1, 
    since the requirement to provide such evidence is specified in ASE in the PP.</p>
    
    <p>For ensuring the guidance documentation provides sufficient information for 
    the administrators/users as it pertains to SFRs, the evaluator’s verdicts will 
    be associated with CEM workunits ADV_FSP.1-7, AGD_OPE.1-4, and AGD_OPE.1-5.</p>

    <p>Finally, the subsection labeled Tests is where the authors have determined 
    that testing of the product in the context of the associated SFR is necessary.
    While the evaluator is expected to develop tests, there may be instances where 
    it is more practical for the developer to construct tests, or where the 
    developer may have existing tests. 
    Therefore, it is acceptable for the evaluator to witness developer-generated 
    tests in lieu of executing the tests. 
    In this case, the evaluator must ensure the developer’s tests are executing both 
    in the manner declared by the developer and as mandated by the EA. 
    The CEM workunits that are associated with the EAs specified in this section 
    are: ATE_IND.1-3, ATE_IND.1-4, ATE_IND.1-5, ATE_IND.1-6, and ATE_IND.1-7.</p>
    <x:call-template name="handle-bases"/>
    <x:call-template name="handle-apply-to-all"/>
  </x:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
   <x:template name="handle-apply-to-all">
    <h2 class="indexable" data-level="1" id="man-sfrs">TOE SFR Evaluation Activities</h2>
    <x:choose>
      <x:when test="//cc:man-sfrs//cc:f-component[not(@status='invisible')]|/cc:PP//cc:f-component[not(@status)]">
        <x:for-each select="//cc:man-sfrs//cc:f-component[not(@status='invisible')]/..|/cc:PP//cc:f-component[not(@status)]/..">
          <x:apply-templates mode="make_header" select=".">
            <x:with-param name="level" select="'2'"/>
          </x:apply-templates>
          <x:apply-templates select="cc:f-component[not(@status) and /cc:PP]"/>
          <x:for-each select="cc:f-component[/cc:Module and not(@status='invisible')]">
	    <x:message>For eaching <x:value-of select="concat(@cc-id,' ',@iteration)"/></x:message>
	  </x:for-each>
          <x:apply-templates select="cc:f-component[/cc:Module and not(@status='invisible')]"/>
        </x:for-each>
      </x:when>
      <x:otherwise>The PP-Module does not define any mandatory requirements 
          (i.e. Requirements that are included in every configuration regardless of the PP-Bases selected).</x:otherwise>
    </x:choose>

    <h2 class="indexable" data-level="1" id="opt-sfrs">Evaluation Activities for Optional SFRs</h2>
    <x:choose>
      <x:when test="//cc:opt-sfrs//cc:f-component[not(@status='invisible')]|/cc:PP//cc:f-component[@status='optional']">
        <x:for-each select="//cc:opt-sfrs//cc:f-component[not(@status='invisible')]/..|/cc:PP//cc:f-component[@status='optional']/..">
          <x:apply-templates mode="make_header" select=".">
            <x:with-param name="level" select="'2'"/>
          </x:apply-templates>
          <x:apply-templates select="cc:f-component[@status='optional' and /cc:PP]"/>
          <x:apply-templates select="cc:f-component[not(@status='invisible')][/cc:Module]"/>
        </x:for-each>
      </x:when>
      <x:otherwise>The PP-Module does not define any optional requirements.</x:otherwise>
    </x:choose>

    <h2 class="indexable" data-level="1" id="sel-sfrs">Evaluation Activities for Selection-Based SFRs</h2>
     <x:choose>
      <x:when test="//cc:sel-sfrs//cc:f-component[not(@status='invisible')]|/cc:PP//cc:f-component[@status='sel-based']">
        <x:for-each select="//cc:sel-sfrs//cc:f-component[not(@status='invisible')]/..|/cc:PP//cc:f-component[@status='sel-based']/..">
          <x:apply-templates mode="make_header" select=".">
            <x:with-param name="level" select="'2'"/>
          </x:apply-templates>
          <x:apply-templates select="cc:f-component[@status='sel-based' and /cc:PP]"/>
          <x:apply-templates select="cc:f-component[not(@status='invisible')][/cc:Module]"/>
        </x:for-each>
      </x:when>
      <x:otherwise>The PP-Module does not define any selection-based requirements.</x:otherwise>
    </x:choose>

   <h2 class="indexable" data-level="1" id="obj-sfrs">Evaluation Activities for Objective SFRs</h2>  
     <x:choose>
      <x:when test="//cc:obj-sfrs//cc:f-component[not(@status='invisible')]|/cc:PP//cc:f-component[@status='objective']">
        <x:for-each select="//cc:obj-sfrs//cc:f-component[not(@status='invisible')]/..|/cc:PP//cc:f-component[@status='objective']/..">
          <x:apply-templates mode="make_header" select=".">
            <x:with-param name="level" select="'2'"/>
          </x:apply-templates>
          <x:apply-templates select="cc:f-component[not(@status='invisible')][@status='objective' and /cc:PP]"/>
          <x:apply-templates select="cc:f-component[not(@status='invisible') and /cc:Module]"/>
        </x:for-each>
      </x:when>
      <x:otherwise>The PP-Module does not define any objective requirements.</x:otherwise>
     </x:choose>
     
   <h2 class="indexable" data-level="1" id="impl-sfrs-">Evaluation Activities for Implementation-dependent SFRs</h2>  
     <x:choose>
      <x:when test="//cc:impl-dep-sfrs//cc:f-component[not(@status='invisible')]|/cc:PP//cc:f-component[@status='feat-based']">
        <x:for-each select="//cc:impl-dep-sfrs//cc:f-component[not(@status='invisible')]/..|/cc:PP//cc:f-component[@status='feat-based']/..">
          <x:apply-templates mode="make_header" select=".">
            <x:with-param name="level" select="'2'"/>
          </x:apply-templates>
          <x:apply-templates select="cc:f-component[not(@status='invisible')][@status='feat-based' and /cc:PP]"/>
          <x:apply-templates select="cc:f-component[not(@status='invisible') and /cc:Module]"/>
        </x:for-each>
      </x:when>
      <x:otherwise>The PP-Module does not define any implementation-dependent requirements.</x:otherwise>
    </x:choose>





 </x:template>



  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
   <x:template name="handle-bases">
    <!-- Run through all the base modules -->
	
    <x:for-each select="//cc:base-pp">
      <h2 class="indexable" data-level="1" id="aa-{@id}">
		<!-- <x:apply-templates mode="expanded" select="."/>  -->
		<x:value-of select="@name"/>
      </h2>
      The EAs defined in this section are only applicable in cases where the TOE claims conformance
      to a PP-Configuration that includes the <x:apply-templates select="." mode="short"/>.
     <x:call-template name="sub-sfrs">
	<x:with-param name="title">Modified</x:with-param>
	<x:with-param name="f-comps" select="cc:modified-sfrs"/>
	<x:with-param name="short" select="@id"/>
	<x:with-param name="none-msg">
	  The PP-Module does not modify any requirements when the 
	  <x:apply-templates select="." mode="short"/> is the base.
	</x:with-param>
      </x:call-template>
      
      <x:call-template name="sub-sfrs">
	<x:with-param name="title">Additional</x:with-param>
	<x:with-param name="f-comps" select="cc:additional-sfrs"/>
	<x:with-param name="short" select="@id"/>
	<x:with-param name="none-msg"/>
      </x:call-template>
    </x:for-each>
  </x:template>
  
	
  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
   <x:template name="sub-sfrs">
    <x:param name="f-comps"/>
    <x:param name="short"/>
    <x:param name="none-msg"/>
    <x:param name="title"/>

    <x:choose>
      <x:when test="($none-msg='') and (count($f-comps//cc:f-component[not(@status='invisible')])=0)"/>
      <x:otherwise>
        <x:element name="h3">
          <x:attribute name="class">indexable</x:attribute>
          <x:attribute name="data-level">2</x:attribute>
          <x:attribute name="id">qq-sfrs-<x:value-of select="$short"/>-<x:value-of select="$title"/></x:attribute>
          <x:value-of select="$title"/> SFRs
        </x:element>
        <x:choose>
          <x:when test="$f-comps//cc:f-component[not(@status='invisible')]"><x:apply-templates select="$f-comps" mode="sd_sections"/></x:when>
          <x:otherwise><x:value-of select="$none-msg"/></x:otherwise>
        </x:choose>
      </x:otherwise>
    </x:choose>
  </x:template>      



  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <x:template mode="sars" match="/cc:PP">
    <h1 id="sar_aas" class="indexable" data-level="0">Evaluation Activities for SARs</h1>
    <x:choose> <x:when test="//cc:a-component">
      <x:for-each select="//cc:a-component/..">
        <x:apply-templates mode="make_header" select=".">
          <x:with-param name="level" select="'1'"/>
        </x:apply-templates>
        <x:apply-templates select=".//cc:a-component"/>
      </x:for-each>
    </x:when> <x:otherwise>
        <p>This PP does not define any SARs.</p>
    </x:otherwise></x:choose>
  </x:template> 
  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
 
  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <x:template match="sec:*|cc:section" mode="sd_sections">

	<!-- Old way: use fragile template -->
    <!-- <x:if test="not(@title='Auditable Events for Additional SFRs')"> 
		<x:apply-templates select="." mode="make_header"/>   -->

	<!-- New way: Just use attributes -->
	<x:if test="not(contains(@title, 'Auditable Events'))"> 
		<x:apply-templates select="." mode="make_header">
			<x:with-param name="level" select="'3'"/>
		</x:apply-templates>	
		
		<x:apply-templates select="cc:f-component[not(@status='invisible')]|cc:a-component"/>
	</x:if>
  </x:template>


  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
   <x:template mode="sars" match="/cc:Module">
    <h1 id="sar_aas" class="indexable" data-level="0">Evaluation Activities for SARs</h1>
    <p>The PP-Module does not define any SARs beyond those defined within the
    <x:choose>
      <x:when test="count(//cc:base-pp)=1">
	base <x:apply-templates mode="short" select="//cc:base-pp"/> to which it must claim conformance.
	It is important to note that a TOE that is evaluated against the PP-Module is
	inherently evaluated against this Base-PP as well. 
	The <x:apply-templates mode="short" select="//cc:base-pp"/> 
        includes a number of Evaluation Activities associated with both SFRs and SARs.
	Additionally, the PP-Module includes a number of SFR-based Evaluation Activities 
	that similarly refine the SARs of the Base-PPs.
	The evaluation laboratory will evaluate the TOE against the Base-PP
      </x:when>
      <x:otherwise>
	base-PP to which it must claim conformance.
	It is important to note that a TOE that is evaluated against the PP-Module is
	inherently evaluated against the Base-PP as well.

	The Base-PP includes a number of Evaluation Activities associated with both SFRs and SARs.
	Additionally, the PP-Module includes a number of SFR-based Evaluation Activities 
	that similarly refine the SARs of the Base-PPs.
	The evaluation laboratory will evaluate the TOE against the chosen Base-PP
      </x:otherwise>
    </x:choose>
    and supplement that evaluation with the necessary SFRs that are taken from the PP-Module.
    </p>
  </x:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
   <x:template name="aaforsfrs">
    <h1 id="mandatory_aas" class="indexable" data-level="0">Evaluation Activities for SFRs</h1>
    <p>The EAs presented in this section capture the actions the evaluator performs to address technology
	    specific aspects covering specific SARs (e.g. ASE_TSS.1, ADV_FSP.1, AGD_OPE.1, and ATE_IND.1) – this is in
	    addition to the CEM workunits that are performed in <a href="#sar_aas" class="dynref"></a>.</p>

    <p>Regarding design descriptions (designated by the subsections labeled TSS, as well as any required supplementary
	    material that may be treated as proprietary), the evaluator must ensure there is specific information that
	    satisfies the EA. For findings regarding the TSS section, the evaluator’s verdicts will be associated with the
	    CEM workunit ASE_TSS.1-1. Evaluator verdicts associated with the supplementary evidence will also be associated 
	    with ASE_TSS.1-1, since the requirement to provide such evidence is specified in ASE in the PP. </p>

    <p>For ensuring the guidance documentation provides sufficient information for the administrators/users as it 
	    pertains to SFRs, the evaluator’s verdicts will be associated with CEM workunits ADV_FSP.1-7, AGD_OPE.1-4, 
	    and AGD_OPE.1-5.</p>

    <p>Finally, the subsection labeled Tests is where the authors have determined that testing of the product in the 
	    context of the associated SFR is necessary. While the evaluator is expected to develop tests, there may be 
	    instances where it is more practical for the developer to construct tests, or where the developer may have
	    existing tests. Therefore, it is acceptable for the evaluator to witness developer-generated tests in lieu of 
	    executing the tests. In this case, the evaluator must ensure the developer’s tests are executing both in the
	    manner declared by the developer and as mandated by the EA. The CEM workunits that are associated with the EAs
	    specified in this section are: ATE_IND.1-3, ATE_IND.1-4, ATE_IND.1-5, ATE_IND.1-6, and ATE_IND.1-7.</p>
    <x:apply-templates select="//*[@title='Security Requirements']|//sec:Security_Requirements"/>
  </x:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
   <x:template name="intro">
    <h1 id="introduction" class="indexable" data-level="0">Introduction</h1>
    <h2 id="scope" class="indexable" data-level="1">Technology Area and Scope of Supporting Document</h2>
    <p>The scope of the <x:apply-templates select="/cc:*" mode="get_title"/> is
    to describe the security functionality of 
    <x:apply-templates mode="get_product_plural" select="/cc:Module"/>
    products in terms of 
    [CC] and to define functional and assurance requirements for them.

    <x:if test="//cc:base-pp">
    The PP-Module is intended for use with the following Base-PP<x:if test="count(//cc:base-pp)>1">s</x:if>:
        <ul>
	  <x:for-each select="//cc:base-pp">

		<!-- Use the attributes (which are required) rather than the weird reference -->
		<li><x:value-of select="@name"/>, version <x:value-of select="@version"/>.</li>
		<!-- <li><x:apply-templates select="." mode="make_xref"/></li>  -->

	  </x:for-each>
	</ul>
    <br/>
    This SD is mandatory for evaluations of TOEs that claim conformance to a PP-Configuration that includes the PP-Module for :
    <x:variable name="products"><x:apply-templates mode="get_product_plural" select="/cc:Module"/></x:variable>

    
    <ul><li><x:value-of select="concat($products,', Version ', //cc:ReferenceTable/cc:PPVersion)"/></li></ul>
    As such it defines Evaluation Activities for the functionality described in the PP-Module as well as any impacts to the Evaluation Activities to the Base-PP(s) it modifies.
    </x:if>
    </p>
    <p> 
Although Evaluation Activities are defined mainly for the evaluators to follow, in general they also help developers to prepare for evaluation by identifying specific requirements for their TOE.
    The specific requirements in Evaluation Activities may in some cases clarify the meaning of Security
    Functional Requirements (SFR), and may identify particular requirements for the content of Security
    Targets (ST) (especially the TOE Summary Specification), user guidance documentation, and possibly
    supplementary information (e.g. for entropy analysis or cryptographic key management architecture).</p>

    <h2 id="structure" class="indexable" data-level="1">Structure of the Document</h2>
    <p>Evaluation Activities can be defined for both SFRs and Security Assurance Requirements (SAR),
    which are themselves defined in separate sections of the SD.</p>

    <p>If any Evaluation Activity cannot be successfully completed in an evaluation, then
    the overall verdict for the evaluation is a 'fail'.
    In rare cases there may be acceptable reasons why an Evaluation Activity
    may be modified or deemed not applicable for a particular TOE, 
    but this must be approved by the Certification Body for the evaluation.</p>

    <p>In general, if all Evaluation Activities (for both SFRs and SARs) are successfully
    completed in an evaluation then it would be expected that the overall verdict for 
    the evaluation is a ‘pass’.
    To reach a ‘fail’ verdict when the Evaluation Activities have been successfully 
    completed would require a specific justification from the evaluator as to why the 
    Evaluation Activities were not sufficient for that TOE.
    </p>
    <p>Similarly, at the more granular level of assurance components, if the Evaluation 
    Activities for an assurance component and all of its related SFR Evaluation 
    Activities are successfully completed in an evaluation then it would be expected 
    that the verdict for the assurance component is a ‘pass’.
    To reach a ‘fail’ verdict for the assurance component when these Evaluation 
    Activities have been successfully completed would require a specific justification 
    from the evaluator as to why the Evaluation Activities were not sufficient for that TOE. 
    </p>
    <x:apply-templates select="//cc:tech-terms">
      <x:with-param name="num" select="1"/>
    </x:apply-templates>
  </x:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
   <x:template name="foreward">
    <div class="foreword">
      <h1 style="text-align: center">Foreword</h1>
      <p>This is a Supporting Document (SD), intended to complement the Common Criteria version 3
      and the associated Common Evaluation Methodology for
      Information Technology Security Evaluation.</p>
      <p>SDs may be “Guidance Documents”, that highlight specific approaches 
      and application of the standard to areas where no mutual recognition of
      its application is required, and as such, are not of normative nature, 
      or “Mandatory Technical Documents”, whose application is mandatory for evaluations 
      whose scope is covered by that of the SD.
      The usage of the latter class is not only mandatory, but certificates
      issued as a result of their application are recognized under the CCRA.</p>

      <p><b>Technical Editor:</b><br/>
      National Information Assurance Partnership (NIAP)
      </p>

      <p><b style="page-break-before:always;">Document history:</b>
      <table>
	<tr class="header">
          <th>Version</th>
          <th>Date</th>
          <th style="align:left;">Comment</th>
	</tr>
	<x:for-each select="cc:RevisionHistory/cc:entry">
          <tr>
            <td><x:value-of select="cc:version"/></td>
            <td><x:value-of select="cc:date"/></td>
            <td><x:apply-templates select="cc:subject"/></td>
          </tr>
	</x:for-each>
      </table>
      </p>
      <p><b>General Purpose:</b><br/>
      The purpose of this SD is to define evaluation methods for the functional behavior of
      <x:apply-templates mode="get_product" select="/cc:Module"/>      
      products.
      </p>
      <p><b>Acknowledgments:</b><br/>
      This SD was developed with support from NIAP 
      <x:apply-templates mode="get_product_plural" select="/cc:Module"/>
      Technical Community members, with representatives from industry, government 
      agencies, Common Criteria Test Laboratories, and members of academia.
      </p>
    </div>
  </x:template>


  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
   <x:template match="cc:glossary">
    <table>
      <x:for-each select="cc:entry">
        <tr>
          <td><x:apply-templates select="cc:term"/></td>
          <td><x:apply-templates select="cc:description"/></td>
	</tr>
      </x:for-each>
    </table>
  </x:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
   <x:template match="cc:glossary/cc:entry/cc:term/cc:abbr">
    <span id="abbr_{text()}"><x:value-of select="@title"/> (<abbr><x:value-of select="text()"/></abbr>)</span>
  </x:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
   <x:template match="cc:f-component[not(@status='invisible')] | cc:a-component">
    <div class="comp" id="{translate(@id, $lower, $upper)}">
      <h4>
       	<x:apply-templates select="." mode="getId"/><x:text> </x:text>
	<x:value-of select="@name"/>
      </h4>
      <x:if test="ancestor::cc:modified-sfrs and not(.//cc:aactivity)">
	There is no change to the Base-PP EAs for this SFR when this PP-Module is claimed.
      </x:if>
      <span class="activity_pane_body">
	<x:apply-templates select="." mode="handle-activities"/>
      </span>
     </div>
   </x:template>


 <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
   <x:template name="bases">Base-PP<x:if test="/cc:PP/cc:module/cc:base-p[1]">s</x:if></x:template>

  <!-- We're explicity grabbing these all, so ground anytime we run into them -->
  <x:template match="cc:aactivity"/>

<!--
  <x:template match="cc:Guidance|cc:Tests|cc:TSS|cc:KMD" mode="gen-aa"/>

  <x:template match="cc:aactivity" mode="gen-aa">
    <x:apply-templates mode="gen-aa"/>
  </x:template>
-->
  <!-- Ground all extend component definitions-->
  <x:template match="cc:ext-comp-def"/>

</x:stylesheet>
