<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cc="https://niap-ccevs.org/cc/v1"
  xmlns:sec="https://niap-ccevs.org/cc/v1/section"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:htm="http://www.w3.org/1999/xhtml"
  version="1.0">

  <xsl:variable name="doctype"><xsl:value-of select="local-name(/cc:*)"/></xsl:variable>
  <!-- Eat all unmatched sections for cc and hook -->
  <xsl:template match="cc:*|sec:*" mode="hook"/>

  <!-- Eat all individual ones that turn off boilerplating -->
  <xsl:template match="//cc:*[@boilerplate='no']" priority="1.0" mode="hook"/>

  <xsl:template match="/cc:*[@boilerplate='yes']//*[@title='Implicitly Satisfied Requirements']|/cc:*[@boilerplate='yes']//sec:Implicitly_Satisfied_Requirements" mode="hook">
	<xsl:choose>
		<xsl:when test="//cc:CClaimsInfo[@cc-version='cc-2022r1']">
			<p>This appendix lists requirements that should be considered satisfied by products
			successfully evaluated against this <xsl:call-template name="doctype-short"/>. These requirements are not featured
			explicitly as SFRs and should not be included in the ST. They are not included as 
			standalone SFRs because it would increase the time, cost, and complexity of evaluation.
			This approach is permitted by <a href="#bibCC">[CC]</a> Part 1, 8.3 Dependencies between components.</p>
			<p>This information benefits systems engineering activities which call for inclusion of particular
			security controls. Evaluation against the <xsl:call-template name="doctype-short"/> provides evidence that these controls are present 
			and have been evaluated.</p>
		</xsl:when>
		<xsl:otherwise>
			<p>This appendix lists requirements that should be considered satisfied by products
			successfully evaluated against this <xsl:call-template name="doctype-short"/>. These requirements are not featured
			explicitly as SFRs and should not be included in the ST. They are not included as 
			standalone SFRs because it would increase the time, cost, and complexity of evaluation.
			This approach is permitted by <a href="#bibCC">[CC]</a> Part 1, 8.2 Dependencies between components.</p>
			<p>This information benefits systems engineering activities which call for inclusion of particular
			security controls. Evaluation against the <xsl:call-template name="doctype-short"/> provides evidence that these controls are present 
			and have been evaluated.</p>
		</xsl:otherwise>
	</xsl:choose></xsl:template>

  
  <xsl:template mode="hook"
    match="/cc:*[@boilerplate='yes']//*[@title='Terms']|/cc:*//sec:Terms[not(@boilerplate='no') and not(@title)]"> 
    The following sections list Common Criteria and technology terms used in this document.
  </xsl:template>


  <xsl:template name="doctype-short" match="cc:doctype-short">
	<xsl:choose>
		<xsl:when test="$doctype='Package'">Functional Package</xsl:when>
                <xsl:when test="$doctype='Module'">PP-Module</xsl:when>
		<xsl:otherwise>PP</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="doctype-long"  match="cc:doctype-long">
	<xsl:choose>
		<xsl:when test="$doctype='Package'">Functional Package</xsl:when>
                <xsl:when test="$doctype='Module'">Protection Profile Module</xsl:when>
		<xsl:otherwise>Protection Profile</xsl:otherwise>
	</xsl:choose>
</xsl:template>
	

<!-- Eat the CClaimsInfo element if it not to be displayed -->
<xsl:template match="//cc:CClaimsInfo[@display='no']"/>

<xsl:template match="//cc:CClaimsInfo[not(@display='no')]">
    <!-- Display if display attribute is not no. Otherwise the info is used but not displayed. -->
	<dl>
		<dt>Conformance Statement</dt><p/>
		<dd>An ST must claim <xsl:value-of select="//cc:CClaimsInfo/cc:cc-st-conf"/> conformance 
		 to this <xsl:call-template name="doctype-short"/>.</dd>
		<p/>
			<dd>The evaluation methods used for evaluating the TOE are a combination of the workunits 
			defined in <a href="#bibCEM">[CEM]</a> as well as the Evaluation Activities for ensuring that individual SFRs 
			and SARs have a sufficient level of supporting evidence in the Security Target and guidance 
			documentation and have been sufficiently tested by the laboratory as part of completing 
			ATE_IND.1. Any functional packages this PP claims similarly contain their own Evaluation 
			Activities that are used in this same manner.
			</dd>
<!--		<dd><xsl:value-of select="document('boilerplates.xml')//cc:empty[@id='cc2022-conf-stmt']"/></dd>  -->
		<dt>CC Conformance Claims</dt><p/>
		<dd>This <xsl:call-template name="doctype-short"/> is conformant to 
			Part 2 (<xsl:value-of select="//cc:CClaimsInfo/cc:cc-pt2-conf"/>) 
			
			<xsl:if test="not (//cc:Package)">
			and Part 3 (<xsl:value-of select="//cc:CClaimsInfo/cc:cc-pt3-conf"/>)
			</xsl:if>
			
			<xsl:choose>
			<xsl:when test="//cc:CClaimsInfo[@cc-version='cc-2022r1']">
				of Common Criteria CC:2022, Revision 1<!--
				--><xsl:if test="//cc:CClaimsInfo[@cc-errata='v1.0']"> as corrected and interpreted in <a href="#bibERRv10">[ERR]</a>, Version 1.0</xsl:if><!--
				--><xsl:if test="//cc:CClaimsInfo[@cc-errata='v1.1']"> as corrected and interpreted in <a href="#bibERRv11">[ERR]</a>, Version 1.1</xsl:if>.
			</xsl:when>
			<xsl:otherwise>
				of Common Criteria Version 3.1, Revision 5.
			</xsl:otherwise>
			</xsl:choose></dd>
			
		<dt>PP Claim</dt><p/>
			<dd><xsl:choose>
				<xsl:when test="//cc:CClaimsInfo/cc:cc-pp-conf=''">
					This <xsl:call-template name="doctype-short"/> does not claim conformance to 
					any Protection Profile.
				</xsl:when>
				<xsl:otherwise>
					This PP claims conformance to the following Protection Profiles:
					<ul>
					<xsl:for-each select="//cc:CClaimsInfo/cc:cc-pp-conf/cc:PP-cc-ref">
						<li><xsl:value-of select="."/></li>
					</xsl:for-each>
					</ul>
				</xsl:otherwise>
				</xsl:choose>
			</dd><p/>
			
			<xsl:choose>
			<xsl:when test="//cc:CClaimsInfo/cc:cc-pp-config-with=''">
					<dd>There are no PPs or PP-Modules that are allowed in a PP-Configuration 
					with this <xsl:call-template name="doctype-short"/>.</dd>
			</xsl:when>
			<xsl:otherwise>
				<dd>The following PPs and PP-Modules are allowed to be specified in a 
					PP-Configuration with this <xsl:call-template name="doctype-short"/>:
					<ul>
					<xsl:for-each select="//cc:CClaimsInfo/cc:cc-pp-config-with/cc:*">
						<li><xsl:value-of select="."/></li>
					</xsl:for-each>
					</ul>
				</dd>
			</xsl:otherwise>
			</xsl:choose>
			
		<dt>Package Claim</dt><p/>
			<xsl:choose>
			<xsl:when test="//cc:CClaimsInfo/cc:cc-pkg-claim=''">
					<dd>This <xsl:call-template name="doctype-short"/> is not conformant to any 
						Functional or Assurance Packages.</dd>
			</xsl:when>
			<xsl:otherwise>
				<dd><ul>
				<xsl:if test="count(//cc:cc-pkg-claim/cc:FP-cc-ref)='0'"> 
					<li>This <xsl:call-template name="doctype-short"/> does not conform to any 
						functional packages.</li>
				</xsl:if>
				<xsl:for-each select="//cc:CClaimsInfo/cc:cc-pkg-claim/cc:FP-cc-ref">
					<li>This <xsl:call-template name="doctype-short"/> is 
					    <xsl:value-of select="."/><xsl:text> </xsl:text><xsl:value-of select="@conf"/>.</li>
				</xsl:for-each>

				<xsl:if test="count(//cc:cc-pkg-claim/cc:AP-cc-ref)='0'"> 
					<li>This <xsl:call-template name="doctype-short"/> does not conform to any 
						assurance packages.</li>
				</xsl:if>
				<xsl:for-each select="//cc:CClaimsInfo/cc:cc-pkg-claim/cc:AP-cc-ref">
					<li>This <xsl:call-template name="doctype-short"/> is 
					    <xsl:value-of select="."/><xsl:text> </xsl:text><xsl:value-of select="@conf"/>.</li>
				</xsl:for-each>
				</ul></dd><p/>
				<dd>
					<xsl:value-of select="document('boilerplates.xml')//cc:empty[@id='cc2022-ppclaim-bp-pp']"/>
				</dd>
			</xsl:otherwise>
			</xsl:choose>

		<xsl:if test="//cc:CClaimsInfo/cc:cc-eval-methods">
			<dt>Evaluation Methods</dt><p/>
			<dd>This <xsl:call-template name="doctype-short"/> incorporates evaluation activies 
				from the following Evaluation Methods documents:
				<ul>
					<xsl:for-each select="//cc:CClaimsInfo/cc:cc-eval-methods/cc:EM-cc-ref">
						<li><xsl:value-of select="."/></li>
					</xsl:for-each>
				</ul>
			</dd>
		</xsl:if>

		<xsl:if test="//cc:CClaimsInfo/cc:cc-claims-addnl-info">
			<dt>Additional Information</dt><p/>
			<dd><xsl:value-of select="//cc:CClaimsInfo/cc:cc-claims-addnl-info"/>
			</dd>
		</xsl:if>
	</dl>

</xsl:template>



 <!-- ############## -->
   <xsl:template  name="verrev">
		<xsl:choose>
			<xsl:when test="//cc:CClaimsInfo[@cc-version='cc-2022r1']">CC:2022 Rev. 1</xsl:when>
			<xsl:otherwise>Version 3.1, Revision 5</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
  <!-- ############## -->
  <xsl:template name="format-of-document">
    <section title="Format of this Document" id="docformat">
      <secref linkend="req"/> contains baseline requirements  which must be implemented in the product 
        and included in any Security Target (ST)
        that claims conformance to this <xsl:call-template name="doctype-long"/> (<xsl:call-template name="doctype-short"/>).
        There are three other types of requirements that can be included in an ST
        claiming conformance to this <xsl:call-template name="doctype-short"/>:
        <htm:ul>
          <htm:li>
            <appref linkend="optional"/> contains requirements that may optionally be included in the ST, 
            but inclusion is at the discretion of the ST author.
          </htm:li>
          <htm:li>
        <appref linkend="sel-based"/> contains requirements based on selections
        in the requirements in <secref linkend="req"/>: if certain selections are
        made, then the corresponding requirements in that appendix must be included.
        </htm:li>
        <htm:li>
        <appref linkend="objective"/> contains requirements that will
        be included in the baseline requirements in future versions of this <xsl:call-template name="doctype-long"/>. Earlier adoption by vendors is
        encouraged and may influence acquisition decisions.
        Otherwise, these are treated the same as Optional Requirements.
        </htm:li>
        </htm:ul>
  </section>
  </xsl:template>

   <xsl:template mode="hook" name="secrectext"
        match="/cc:PP[@boilerplate='yes']//*[@title='Security Requirements' and not(@boilerplate='no')]|/cc:PP//sec:Security_Requirements[not(@boilerplate='no')]"
       >
      This chapter describes the security requirements which have to be fulfilled by the product under evaluation.
     Those requirements comprise functional components from Part 2 and assurance components from Part 3 of 
       <xsl:call-template name="citeCC"/>.
       <xsl:apply-templates select="document('boilerplates.xml')//*[@title='Security Requirements']"/>
   </xsl:template>
   <!-- TODO: Review this -->
   <xsl:template match="/cc:Module//cc:*[@title='Security Requirements']|/cc:Package//sec:Security_Functional_Requirements|//cc:Package//cc:*[@title='Security Functional Requirements']" mode="hook">
      This chapter describes the security requirements which have to be fulfilled by the product under evaluation.
      Those requirements comprise functional components from Part 2 of <xsl:call-template name="citeCC"/>.
 
       <xsl:apply-templates select="document('boilerplates.xml')//*[@title='Security Requirements']"/>
  </xsl:template>

  <!-- ################################################## 

       ################################################## -->
  <xsl:template name="citeCC"><a href="#bibCC">[CC]</a></xsl:template>


  <!-- ################################################## 

       ################################################## -->
  <xsl:template match="/cc:Module//*[@title='TOE Security Functional Requirements']|/cc:Module//sec:TOE_Security_Functional_Requirements[not(@title)]" mode="hook">
    <xsl:choose>
      <xsl:when test="cc:*[@title='TOE Security Functional Requirements']">
The following section describes the SFRs that must be satisfied by any TOE that claims conformance to this PP-Module.
These SFRs must be claimed regardless of which PP-Configuration is used to define the TOE.
      </xsl:when>
      <xsl:otherwise>
This PP-Module does not define any mandatory SFRs that apply regardless of the PP-Configuration.
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="/cc:PP//*[./cc:OSPs]" mode="hook">
<!--   <xsl:if test="not(.//cc:OSP)">
   <p>    This PP defines no Organizational Security Policies.</p>
   </xsl:if>  -->
  </xsl:template>

  <xsl:template match="/cc:Module//*[./cc:SOs]" mode="hook">
   <!-- <xsl:if test="not(.//cc:SO)">
   <p>    This PP-Module defines no additional Security Objectives.</p>
   </xsl:if>  -->
  </xsl:template>


  <xsl:template match="/cc:Module//*[./cc:OSPs]" mode="hook">
	<xsl:choose>
		<xsl:when test="@boilerplate='no'"/>
		<xsl:otherwise>
   <p>An organization deploying the TOE is
      expected to satisfy the organizational security policy listed below in addition to all
      organizational security policies defined by the claimed Base-PP. </p>
        </xsl:otherwise>
	</xsl:choose>
<!--
   <xsl:if test="not(.//cc:OSP)">
   <p>    This PP-Module defines no additional Organizational Security Policies.</p>
   </xsl:if>-->
  </xsl:template>


<!-- #################### -->
  <xsl:template match="/cc:Module//*[@title='Assumptions']|/cc:Module//sec:Assumptions[not(@title)]" mode="hook">
    <xsl:choose>
      <xsl:when test="@boilerplate='no'"/>
      <xsl:when test=".//cc:assumption">
These assumptions are made on the Operational Environment (OE) in order to be able to ensure that the
security functionality specified in the PP-Module can be provided by the TOE.
If the TOE is placed in an OE that does not meet these assumptions, the TOE may no longer be able to
provide all of its security functionality.
      </xsl:when>
<!--      <xsl:otherwise>
This PP-Module defines no additional assumptions.
      </xsl:otherwise>-->
    </xsl:choose>
  </xsl:template>

<!-- #################### -->
  <xsl:template match="/cc:Module//cc:*[@title='Security Objectives for the Operational Environment']" mode="hook">
    <xsl:choose>
      <xsl:when test=".//cc:SOEs">
The OE of the TOE implements technical and procedural measures to assist the TOE in correctly providing its security functionality (which is defined by the security objectives for the TOE).
The security objectives for the OE consist of a set of statements describing the goals that the OE should achieve.
This section defines the security objectives that are to be addressed by the IT domain or by non-technical or procedural means.
The assumptions identified in Section 3 are incorporated as security objectives for the environment.
      </xsl:when>
      <xsl:otherwise>
This PP-Module does not define any objectives for the OE.
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="sel-based-reqs" match="//cc:ref[@to='sel-based-reqs']"><!--
    --><a href="#sel-based-reqs" class='dynref'/><!-- 
  --></xsl:template>


  <xsl:template name="ref-obj-reqs" match="//cc:ref[@to='obj-reqs']">
    <a href="#objective-reqs" class='dynref'/>
  </xsl:template>


  <xsl:template name="ref-impl-reqs" match="//cc:ref[@to='impl-reqs']">
    <a href="#feat-based-reqs" class='dynref'/>
  </xsl:template>

  <xsl:template name="ref-strict-optional" match="//cc:ref[@to='ref-strict-optional']"><!--
    --><a href="#optional-reqs" class='dynref'/><!--
  --></xsl:template>

  <xsl:template name="opt_appendix">
    <h1 id="opt-app" class="indexable" data-level="A">Optional Requirements</h1>
    As indicated in the introduction to this <xsl:call-template name="doctype-short"/>, the baseline requirements (those that must be
	  performed by the TOE) are contained in the body of this <xsl:call-template name="doctype-short"/>.
    This appendix contains three other types of optional requirements:<br/><br/>

   The first type, defined in Appendix <xsl:call-template name="ref-strict-optional"/>, are strictly optional requirements.
   If the TOE meets any of these requirements the vendor is encouraged to claim the associated SFRs
	  in the ST, but doing so is not required in order to conform to this <xsl:call-template name="doctype-short"/>.<br/><br/>

  The second type, defined in Appendix <xsl:call-template name="ref-obj-reqs"/>, are objective requirements. These describe security functionality that is not yet 
	  widely available in commercial technology. 
   Objective requirements are not currently mandated by this <xsl:call-template name="doctype-short"/>, but will be mandated in
	  the future. Adoption by vendors is encouraged, but claiming these SFRs is not required in order to conform to this
	  <xsl:call-template name="doctype-short"/>.<br/><br/>

  The third type, defined in Appendix <xsl:call-template name="ref-impl-reqs"/>, are Implementation-dependent requirements.
	If the TOE implements the product features associated with the listed SFRs, either the SFRs must be claimed
	or the product features must be disabled in the evaluated configuration. 
  </xsl:template>

  <xsl:template name="imple_text">
		Appendix <xsl:call-template name="ref-impl-reqs"/> defines requirements that must be claimed in the ST  
		if the TOE implements particular product features. 
		For this technology type, the following product features require the claiming of additional SFRs:
  </xsl:template>
  


</xsl:stylesheet>
