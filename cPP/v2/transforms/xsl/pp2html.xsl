<?xml version="1.0" encoding="utf-8"?>
<!--
    Stylesheet for Protection Profile Schema
    Based on original work by Dennis Orth
    Subsequent modifications in support of US NIAP

    FILE: pp2html.xsl
    This is the entry point for Protection Profiles.
    It is also used as a library for modules (but not for the SD or the
    simplified and table forms). 
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cc="https://niap-ccevs.org/cc/v1"
  xmlns:sec="https://niap-ccevs.org/cc/v1/section"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:htm="http://www.w3.org/1999/xhtml"
  version="1.0">

  <!-- ############### -->
  <!--     INCLUDES     -->
  <!-- ############### -->
  <xsl:import href="ext-comp-defs.xsl"/>
  <xsl:import href="ppcommons.xsl"/>
  <xsl:import href="boilerplates.xsl"/>
  <xsl:import href="debug.xsl"/>
  <xsl:import href="use-case.xsl"/>
  <xsl:import href="audit.xsl"/>

 
  <!-- ############### -->
  <!--  PARAMETERS     -->
  <!-- ############### -->
  <xsl:param name="appendicize" select="''"/>
  <xsl:param name="release" select="''"/>
  <xsl:param name="work-dir" select="'../../output'"/>


  <!-- ############### -->
  <!--  SETTINGS       -->
  <!-- ############### -->
  <!-- very important, for special characters and umlauts iso8859-1-->
  <xsl:output method="xml" encoding="UTF-8"/>

 <!-- ############### -->
  <!--  TEMPLATES      -->
  <!-- ############### -->

  <!-- ############### -->
  <xsl:template match="/">
    <xsl:call-template name="sanity-checks"/>
    <!-- Start with !doctype preamble for valid (X)HTML document. -->
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;&#xa;</xsl:text>
    <html xmlns="http://www.w3.org/1999/xhtml">
      <xsl:call-template name="head"/>
      <body onLoad="init()">
        <xsl:call-template name="body-begin"/>
        <xsl:apply-templates select="cc:*"/>
      </body>
    </html>
  </xsl:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:PP|cc:Package">
    <xsl:apply-templates select="cc:section|sec:*"/>
    <!-- this handles the first appendices -->
    <xsl:call-template name="first-appendix"/>
    <xsl:if test="$appendicize='on'">
      <xsl:call-template name="app-reqs">
         <xsl:with-param name="type" select="'sel-based'"/>
         <xsl:with-param name="level" select="'A'"/>
         <xsl:with-param name="sublevel" select="'2'"/>
      </xsl:call-template>
    </xsl:if>
    <!-- This line means, match the first, which will handle adding the prolog and then handle all the ext-comp-defs-->
    <xsl:call-template name="ext-comp-defs"/>
    <xsl:apply-templates select="cc:appendix[not(cc:bibliography) and not(cc:after_bib)]"/>
    <xsl:apply-templates select="//cc:rule[not(preceding::cc:rule or ancestor::cc:rule)]"/>
<!--    <xsl:call-template name="rules-appendix"/>  -->
    <xsl:call-template name="use-case-appendix"/>  
    <xsl:call-template name="acronyms"/>
    <xsl:call-template name="bibliography"/>
    <xsl:apply-templates select="cc:appendix[cc:after_bib]"/>
  </xsl:template>
  
  <!-- <xsl:template match="//cc:rule[not(preceding::cc:rule or ancestor::cc:rule)]"> -->
  <xsl:template match="cc:appendix[@title='Validation Guidelines' and @id]">
    <xsl:call-template name="rules-appendix"><xsl:with-param name="id" select="@id"/></xsl:call-template>
  </xsl:template>
  <xsl:template match="cc:appendix[@title='Validation Guidelines' and not(@id)]">
    <xsl:call-template name="rules-appendix"/>
  </xsl:template>

  <xsl:template name="rules-appendix">
    <xsl:param name="id" select="'appendix-rules'"/>

<!--  <xsl:template name="rules-appendix"><xsl:if test="//cc:rule">-->
     <h1 id="{$id}" class="indexable" data-level="A">Validation Guidelines</h1>
     	This appendix contains "rules" specified by the PP Authors that indicate whether certain selections
	  require the making of other selections in order for a Security Target to be valid. For example, selecting 
	  "HMAC-SHA-3-384" as a supported keyed-hash algorithm would require that "SHA-3-384" be selected
	  as a hash algorithm.<p/>
	  This appendix contains only such "rules" as have been defined by the PP Authors, and does not necessarily
	  represent all such dependencies in the document.<p/>
     <xsl:for-each select="//cc:rule">
       <h2 id="{@id}">
         Rule #<xsl:number count="cc:rule" level="any"/>
       </h2>
       <div>  <xsl:apply-templates select="cc:description"/></div>
       <xsl:apply-templates select="cc:*" mode="use-case"/>
     </xsl:for-each>
  </xsl:template>

  <xsl:template match="cc:and" mode="use-case" name="use-case-and">
    <xsl:apply-templates mode="use-case"/>
  </xsl:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <!--  <xsl:template match="cc:or" mode="rule"> -->
  <!--   <table class="uc_table_or" style="border: 1px solid black"> -->
  <!--     <tr> <td class="or_cell" rowspan="{count(cc:*)+1}">OR</td><td style="display:none"></td></tr> -->
  <!--     <xsl:for-each select="cc:*"> -->
  <!--       <tr><td style="width: 99%"><xsl:apply-templates select="." mode="use-case"/></td></tr> -->
  <!--     </xsl:for-each> -->
  <!--   </table> -->
  <!-- </xsl:template> -->

  <xsl:template match="cc:if" mode="use-case">
    <table class="uc_table_or" style="border: 1px solid black">
      <tr> <td class="or_cell" rowspan="{count(cc:*)+1}">IF</td><td style="display:none"></td></tr>
      <xsl:for-each select="cc:*">
        <tr><td style="width: 99%"><xsl:apply-templates select="." mode="use-case"/></td></tr>
      </xsl:for-each>
    </table>
  </xsl:template>
	
  <xsl:template match="cc:then" mode="use-case">
    <table class="uc_table_or" style="border: 1px solid black">
      <tr> <td class="or_cell" rowspan="{count(cc:*)+1}">THEN</td><td style="display:none"></td></tr>
      <xsl:for-each select="cc:*">
        <tr><td style="width: 99%"><xsl:apply-templates select="." mode="use-case"/></td></tr>
      </xsl:for-each>
    </table>
  </xsl:template>
	
	
  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template name="bibliography">
    <h1 id="appendix-bibliography" class="indexable" data-level="A">Bibliography</h1>
    <table>
      <caption><xsl:call-template name="ctr-xsl">
               <xsl:with-param name="ctr-type">Table</xsl:with-param>
	       <xsl:with-param name="id" select="'t-biblio'"/>
	      </xsl:call-template>: Bibliography</caption>	
	      <tr class="header"> <th>Identifier</th> <th>Title</th> </tr>
      <xsl:apply-templates mode="hook" select="."/>
	  <xsl:choose>
	  
		<!-- CC:2022 -->
		<xsl:when test="//cc:CClaimsInfo[@cc-version='cc-2022r1']">
			<xsl:variable name="errver">
				<xsl:value-of select="//cc:CClaimsInfo/@cc-errata"/>
			</xsl:variable>
			<xsl:for-each select="//cc:bibliography/cc:entry|document('boilerplates.xml')//*[@id='cc2022-docs']/cc:entry|document('boilerplates.xml')//*[@id='cc2022-cem']/cc:entry|document('boilerplates.xml')//*[@id='cc2022-err']/cc:entry">
				<xsl:sort/>
				
				<!-- Test for errata entries and select the right one -->
				<xsl:choose>
				<xsl:when test="@id='bibERRv10'">
					<xsl:if test="$errver='v1.0'">
						<tr>
							<td><span id="{@id}">[<xsl:value-of select="cc:tag"/>]</span></td>
							<td><xsl:apply-templates select="cc:description"/></td>
						</tr>
					</xsl:if>
				</xsl:when>
				
				<xsl:when test="@id='bibERRv11'">
					<xsl:if test="$errver='v1.1'">
						<tr>
							<td><span id="{@id}">[<xsl:value-of select="cc:tag"/>]</span></td>
							<td><xsl:apply-templates select="cc:description"/></td>
						</tr>
					</xsl:if>
				</xsl:when>

				<!-- Non errata entries -->
				<xsl:otherwise>
					<tr>
						<td><span id="{@id}">[<xsl:value-of select="cc:tag"/>]</span></td>
						<td><xsl:apply-templates select="cc:description"/></td>
					</tr>
				</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:when>
		
		<!-- CC 3.5 -->
		<xsl:otherwise>
			<xsl:for-each select="//cc:bibliography/cc:entry|document('boilerplates.xml')//*[@id='cc-docs']/cc:entry">
				<xsl:sort/>
				<tr>
					<td><span id="{@id}">[<xsl:value-of select="cc:tag"/>]</span></td>
					<td><xsl:apply-templates select="cc:description"/></td>
				</tr>
			</xsl:for-each>
		</xsl:otherwise>
		</xsl:choose>
    </table>
  </xsl:template>


  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
<!--  <xsl:template name="make-section">
    <xsl:param name="title"/>
    <xsl:param name="id"/>
    <xsl:param name="depth" select="count(ancestor-or-self::cc:section) + count(ancestor-or-self::sec:*)+count(ancestor::cc:appendix)"/>
    <xsl:message>Making a section of <xsl:value-of select="concat($title, ' ',$depth)"/>
 gg
    <xsl:value-of select="count(ancestor-or-self::cc:section) + count(ancestor-or-self::sec:*)+count(ancestor::cc:appendix)"/>
    </xsl:message>
    <xsl:element name="h{$depth}">
      <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
      <xsl:attribute name="class">indexable,h<xsl:value-of select="$depth"/></xsl:attribute>
      <xsl:attribute name="data-level"><xsl:value-of select="$depth"/></xsl:attribute>
      <xsl:value-of select="$title"/>
    </xsl:element>
    <xsl:apply-templates mode="hook" select="."/>
    <xsl:apply-templates />
  </xsl:template>-->


  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template name="defs-with-notes">
    <xsl:variable name="class" select="local-name()"/>
    <dt class="{$class} defined" id="{@name}">
      <xsl:value-of select="@name"/>
    </dt>
    <dd>
      <xsl:apply-templates select="cc:description"/>
      <xsl:apply-templates select="cc:appnote"/>
    </dd>
 </xsl:template>
	
	
  <!-- ############### -->
  <!--                 -->
  <xsl:template match="cc:assumptions|cc:OSPs|cc:SOs|cc:SOEs">
    <xsl:choose> 
	<xsl:when test="cc:*[cc:description]">
        <dl>
          <xsl:for-each select="cc:*[cc:description]">
            <xsl:call-template name="defs-with-notes"/>
          </xsl:for-each>
        </dl>
    </xsl:when>
	<xsl:otherwise>
      This document does not define any additional <xsl:value-of select="local-name()"/>.
    </xsl:otherwise> </xsl:choose>
  </xsl:template>

  <!-- Eat the threat-addr tags -->
  <xsl:template match="cc:threat-addr"/>

 <!-- For standard rationale, threats are handled here as always, and          
       there are objective-refer tags in each threat tag.  -->
  <!-- For direct rationale, threats are mapped to SFRs in the threats section  -->
  <!--   using the addressed-by tag (with no objective-refer tags) -->
  <xsl:template match="cc:threats">
    <xsl:choose> 
	<xsl:when test="cc:threat">
        <dl>
			<xsl:for-each select="cc:threat">
 
				<xsl:variable name="class" select="local-name()"/>
				<dt class="{$class} defined" id="{@name}">
					<xsl:apply-templates select="." mode="get-representation"/>
				</dt>

				<xsl:if test="cc:description">
					<dd>
					  <xsl:apply-templates select="cc:description"/>
					</dd>
				</xsl:if>
				
				<xsl:if test="not(cc:description) and cc:from">
					<dd>
						This threat from the above Base PP also applies to the functionality defined in this PP-Module.
					</dd>
				</xsl:if>

<!--			<xsl:call-template name="defs-with-notes"/>   -->

			<!-- This should be true only for Direct Rationale -->
			<!-- Uncomment this to display the SFRs with the threats -->
			<!-- Otherwise they are displayed in the TOE SFR Rationale section -->
<!--			<xsl:if test="cc:addressed-by">
				<p/><dd><b>Addressed by these SFRs:</b></dd>
				<xsl:for-each select="cc:addressed-by">
					<dd><xsl:apply-templates select="."/>: <xsl:apply-templates select="following-sibling::cc:rationale[1]"/></dd>
				</xsl:for-each>  
			</xsl:if>  -->
          </xsl:for-each>
 	    </dl>
    </xsl:when>
	<xsl:otherwise>
      This document does not define any additional threats.
    </xsl:otherwise> 
	</xsl:choose>
  </xsl:template>
  
  
  
  <!-- ############### -->
  <!-- Handle's the sections that appear if the optional 
       appendices appear (i.e. if this is the release version -->
  <!-- ############### -->
  <xsl:template match="cc:if-opt-app">
    <xsl:if test="$appendicize='on'">
      <xsl:apply-templates/>
    </xsl:if>
  </xsl:template>

   <!-- ############### -->
  <xsl:template match="cc:include-pkg[@short]" mode="show">
    <xsl:element name="a">
       <xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
       <xsl:value-of select="@name"/>
       <xsl:if test="@short"> (<xsl:value-of select="@short"/>)</xsl:if>
       Package, version <xsl:value-of select="@version"/>
    </xsl:element> Conformant</xsl:template>

  
  <!-- ############### -->
  <xsl:template match="cc:include-pkg[cc:git]" mode="show">
    <xsl:variable name="path" select="concat($work-dir, '/', @id, '.xml')"/>
    <a href="{@url}">
       <xsl:value-of select="document($path)//cc:PPTitle"/>, 
       version <xsl:value-of select="document($path)//cc:PPVersion"/>
    </a> Conformant</xsl:template>

  <!-- ############### -->
  <!--                 -->
<!--
   <xsl:template match="cc:threat|cc:assumption|cc:OSP" mode="get-representation">
      <xsl:value-of select="@name"/>
   </xsl:template>
-->
  <xsl:template match="cc:threat|cc:assumption|cc:OSP" mode="get-representation">
    <xsl:value-of select="@name"/>
  </xsl:template>



  <!-- ############### -->
  <!--                 -->
  <xsl:template match="cc:*[@title='Security Objectives Rationale' and @id]">
    <xsl:call-template name="sec_obj_rat">
      <xsl:with-param name="id" select="@id"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="cc:*[@title='Security Objectives Rationale' and not(@id)]|sec:Security_Objectives_Rationale">
    <xsl:call-template name="sec_obj_rat">
      <xsl:with-param name="id" select="Security_Objectives_Rationale"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="sec:*[@title='Security Objectives Rationale']">
    <xsl:call-template name="sec_obj_rat">
      <xsl:with-param name="id" select="local_name()"/>
    </xsl:call-template>
  </xsl:template>

<!-- Security Objectives Rationale Table -->

  <xsl:template name="sec_obj_rat">
    <xsl:param name="id"/>

	<xsl:choose>
	<xsl:when test="//cc:CClaimsInfo[@cc-approach='direct-rationale']">
		<h2 id="{$id}" class="indexable,h2" data-level="2">Security Objectives Rationale</h2>   
		This section describes how the assumptions and organizational 
		security policies map to operational environment security objectives.
	</xsl:when>
	<xsl:otherwise>
		<h2 id="{$id}" class="indexable,h2" data-level="2">Security Objectives Rationale</h2>   
		This section describes how the assumptions, threats, and organizational 
		security policies map to the security objectives.
	</xsl:otherwise>
	</xsl:choose>
	
    <table>
      <caption><xsl:call-template name="ctr-xsl">
               <xsl:with-param name="ctr-type">Table</xsl:with-param>
	       <xsl:with-param name="id" select="'t-sec-obj-rat'"/>
	      </xsl:call-template>: Security Objectives Rationale</caption>
	<xsl:choose>
	<xsl:when test="//cc:CClaimsInfo[@cc-approach='direct-rationale']">
      <tr class="header">
        <td>Assumption or OSP</td>
        <td>Security Objectives</td>
        <td>Rationale</td>
      </tr>
	</xsl:when>
	<xsl:otherwise>
      <tr class="header">
        <td>Threat, Assumption, or OSP</td>
        <td>Security Objectives</td>
        <td>Rationale</td>
      </tr>
	</xsl:otherwise>
	</xsl:choose>
	
      <xsl:for-each 
          select="//cc:threat/cc:objective-refer | //cc:OSP/cc:objective-refer | //cc:assumption/cc:objective-refer">
        <tr>
          <xsl:if test="not(name(preceding-sibling::cc:*[1])='objective-refer')">
            <xsl:attribute name="class">major-row</xsl:attribute>
            <xsl:variable name="rowspan" select="count(../cc:objective-refer)"/>
            <td rowspan="{$rowspan}">
	      <xsl:call-template name="underscore_breaker">
		<xsl:with-param name="valu"><xsl:apply-templates select=".." mode="get-representation"/></xsl:with-param></xsl:call-template>
            </td>
          </xsl:if>
          <td>
	    <xsl:call-template name="underscore_breaker">
	      <xsl:with-param name="valu" select="@ref"/>
	    </xsl:call-template>
	</td>
          <td><xsl:apply-templates select="cc:rationale"/></td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template name="underscore_breaker" mode="underscore_breaker" match="@*">
    <xsl:param name="valu" select="."/>
    <xsl:if test="string-length($valu) > 0">
      <xsl:variable name="before" select="substring-before($valu, '_')"/>
      <xsl:variable name="after"  select="substring-after($valu, '_')"/>
      <xsl:choose><xsl:when test="string-length($before)+string-length($after) = 0">
	<xsl:value-of select="$valu"/>
      </xsl:when><xsl:otherwise>
      <xsl:value-of select="substring-before($valu,'_')"/>_&#8203;<!--
      --><xsl:call-template name="underscore_breaker"><xsl:with-param name="valu" select="substring-after($valu,'_')"/></xsl:call-template>
      </xsl:otherwise></xsl:choose>
    </xsl:if>
  </xsl:template>

  
  <!-- ############### -->
  <!--                 -->
  <!-- Handle Mandatory SARs -->
  <xsl:template match="cc:a-component[not(@status='optional')]">
    <div class="comp" id="{translate(@cc-id, $lower, $upper)}">
      <h4>
        <xsl:value-of select="concat(translate(@cc-id, $lower, $upper), ' ')"/>
        <xsl:value-of select="@name"/>
      </h4>
      <xsl:apply-templates/><!-- a-elements don't output anything here -->
      <xsl:variable name="comp" select="."/>
      <xsl:for-each select="document('boilerplates.xml')//cc:empty[@id='a-group']/cc:a-stuff">
         <xsl:variable name="type" select="@type"/>
         <h4> <xsl:apply-templates/> elements: </h4>
         <xsl:apply-templates select="$comp/cc:a-element[@type=$type]" mode="a-element"/>
      </xsl:for-each>
      <xsl:if test="not( (/cc:Module or //cc:cPP) and $release = 'final' )"><xsl:call-template name="f-comp-activities"/></xsl:if>
<!--      <xsl:call-template name="f-comp-activities"/>  -->
    </div>
  </xsl:template>

<!-- Handle Optional SARs that belong in Appendix A.1 -->
<!-- This should only happen when status="optional" -->
  <xsl:template match="cc:a-component[@status='optional']" mode="a-comp-to-appendix">
    <xsl:variable name="full_id"><xsl:apply-templates select="." mode="getId"/></xsl:variable>

    <div class="comp" id="{$full_id}">
      <h4><xsl:value-of select="concat($full_id, ' ', @name)"/></h4>

		<!-- Optional SAR -->
      <xsl:if test="@status='optional'">
			<div class="statustag">
				<b><i>This SAR is optional and may be claimed at the ST-Author's discretion.</i></b>
			</div>
          </xsl:if>
        <xsl:apply-templates/>
			  <xsl:variable name="comp" select="."/>
      <xsl:for-each select="document('boilerplates.xml')//cc:empty[@id='a-group']/cc:a-stuff">
         <xsl:variable name="type" select="@type"/>
         <h4> <xsl:apply-templates/> elements: </h4>
         <xsl:apply-templates select="$comp/cc:a-element[@type=$type]" mode="a-element"/>
      </xsl:for-each> 
      <xsl:if test="not( (/cc:Module or //cc:cPP) and $release = 'final' )"><xsl:call-template name="f-comp-activities"/></xsl:if>
<!--     <xsl:call-template name="f-comp-activities"/>  -->
    </div>
  </xsl:template>

<!-- Should never happen, so eat them -->
  <xsl:template match="cc:a-component[not(@status='optional')]" mode="a-comp-to-appendix"/>
  <xsl:template match="cc:a-component[@status='optional']"/>

  <!-- ########################################
       Consume invisible f-component
       ######################################## -->
  <xsl:template match="cc:f-component[@status='invisible']"/>
  
  <!-- ######################################## 
         This template handles f-components for PPs
         and packages when not appendisizing (i.e. NOT RELEASE)
       ######################################## -->
  <xsl:template match="cc:f-component[not(/cc:Module or @status='invisible')]">
    <xsl:variable name="full_id"><xsl:apply-templates select="." mode="getId"/></xsl:variable>

    <div class="comp" id="{$full_id}">
      <h4><xsl:value-of select="concat($full_id, ' ', @name)"/></h4>
      <xsl:if test="@status='objective'">
        <div class="statustag">
          <i><b> This is an objective component.
          <xsl:if test="@targetdate">
            It is scheduled to be mandatory for products entering evaluation after
            <xsl:value-of select="@targetdate"/>.
          </xsl:if>
          </b></i>
        </div>
      </xsl:if>
      <xsl:if test="@status='sel-based'">
        <div class="statustag">
          <b><i>This is a selection-based component. Its inclusion depends upon selection from
	  <xsl:call-template name="handle_thing_with_depends"/>
          </i></b>
        </div>
      </xsl:if>
      <xsl:if test="@status='feat-based'">
        <div class="statustag">
          <i><b>This is an implementation-based component.
                Its inclusion in depends on whether the TOE implements one or more of the following features:
                <ul>
                  <xsl:for-each select="cc:depends/@*">
                    <xsl:variable name="ref-id" select="."/>
                      <li><a href="#{$ref-id}"><xsl:value-of select="//cc:feature[@id=$ref-id]/@title"/></a></li>
                  </xsl:for-each>
                </ul>
                as described in Appendix A.3: Implementation-based Requirements.
               <xsl:if test="cc:depends/cc:optional"><p>This component may also be included in the ST as if optional.</p></xsl:if>
			   <xsl:if test="cc:depends/cc:objective"><p>This component may also be included in the ST as if optional, but may be mandatory in the future.</p></xsl:if>
        </b></i>
        </div>
      </xsl:if>
      <xsl:if test="@status='optional'">
        <div class="statustag">
          <i><b>This is an optional component. However, applied modules or packages might redefine it as mandatory.</b></i>
        </div>
      </xsl:if>
     <xsl:apply-templates/>
     <xsl:call-template name="f-comp-activities"/>
    </div>
  </xsl:template>

	<!-- This template never seems to match -->
  <xsl:template match="/cc:Module//cc:f-component">
    <xsl:apply-templates select="." mode="appendicize-nofilter"/>
  </xsl:template>

  <!-- ############### -->
  <!--  Handle depends -->
  <!-- ############### -->
  <xsl:template name="handle_thing_with_depends">
    <xsl:for-each select="//cc:f-component/cc:f-element[.//cc:selectable[@id=current()/cc:depends[not(cc:external-doc)]/@*]]">
      <xsl:apply-templates select="." mode="getId"/>
      <xsl:call-template name="commaifnotlast"/>
    </xsl:for-each>
	
	<!-- Case where selectable is in a modified-sfr of a Module -->
	<!-- There might not be an alement, but there must be a base-sfr-spec -->
    <xsl:for-each select="//cc:base-sfr-spec[.//cc:selectable[@id=current()/cc:depends[not(cc:external-doc)]/@*]]">
      <xsl:apply-templates select="." mode="getId"/>
      <xsl:call-template name="commaifnotlast"/>
    </xsl:for-each>
	
    <!-- This is a little broken -->
    <xsl:for-each select="cc:depends[cc:external-doc]">
      <xsl:variable name="doc_id" select="cc:external-doc/@ref"/>
      <xsl:variable name="path" select="concat($work-dir,'/',$doc_id,'.xml')"/>
work-dir of external doc = <xsl:value-of select="$work-dir"/>
      <xsl:for-each select="@*">
	<xsl:variable name="refId" select="."/>
	<xsl:apply-templates mode="make_xref" select="document($path)//cc:f-element[.//@id=$refId]"/><xsl:call-template name="commaifnotlast"/>
      </xsl:for-each>
      from 
      <xsl:call-template name="make_xref"><xsl:with-param name="id" select="$doc_id"/></xsl:call-template></xsl:for-each>.
      <xsl:if test="cc:depends/cc:optional"><p>This component may also be included in the ST as if optional.</p></xsl:if>
      <xsl:if test="cc:depends/cc:objective"><p>This component may also be included in the ST as if optional, but may be mandatory in the future.</p></xsl:if>
  </xsl:template>

  <!-- ############### -->
  <!--  F-components for release l      -->
  <!-- ############### -->
  
  <!-- This template is executed for modules, but non-mandatory 
	SFRs have already been filtered out elsewhere. rmc 11/8/23 -->
  <xsl:template match="cc:f-component" mode="appendicize">
  <!-- in appendicize mode, don't display objective/sel-based/optional/feat-based in main body-->
  <!-- Except when in an additional-sfrs element in a module rmc, 11/8/23 -->
  <!-- or when in the impl-dep-sfrs section of a module main body, 11/13/23 --> 
  <!-- Added the not draft test (20231229) to stop dulpicate addnl-sfrs in the non-release build.
       Not sure why this works. -->
    <xsl:if test="((not(@status))or ancestor::cc:additional-sfrs or ancestor::cc:impl-dep-sfrs) and ($release!='draft')">
      <xsl:apply-templates select="." mode="appendicize-nofilter" />
    </xsl:if>
  </xsl:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:f-component" mode="appendicize-nofilter">
    <xsl:variable name="full_id"><xsl:apply-templates select="." mode="getId"/></xsl:variable>
    
    <div class="comp" id="{$full_id}">
      <h4><xsl:value-of select="concat($full_id, ' ', @name)"/></h4>

		<!-- Objective SFRs with a target date -->
      <xsl:if test="(@status='objective' or ancestor::cc:obj-sfrs) and @targetdate">
        <div class="statustag">
          <i><b>
              This objective component is scheduled to be mandatory for
              products entering evaluation after
              <xsl:value-of select="@targetdate"/>.
          </b></i>
          </div>
      </xsl:if>
      
		<!-- Objective SFRs in the Additional SFRs section of a PP-Module -->
		<xsl:if test="@status='objective' and ancestor::cc:additional-sfrs">
			<div class="statustag">
				<i><b>
					This is an objective component. In the future it will become mandatory. 
				</b></i>
			</div>
		</xsl:if>
      
		<!-- Optional requirements. We need to decide whether use-case-based requirements 
			belong here or in with sel-based. Now they can go either way.
			Same with dependencies on other SFRs. -->
      <xsl:if test="@status='optional' or @status='feat-based' or ancestor::cc:opt-sfrs or ancestor::cc:impl-dep-sfrs">
          <xsl:if test="//cc:usecase[.//@id = current()/cc:depends/@*]">
            <div class="statustag">
              <b><i>This component must be included in the ST if any of the following use cases are selected:</i></b><br/>
              <ul>
                <xsl:for-each select="//cc:usecase[.//@id = current()/cc:depends/@*]">
                  <li><b><i> <a href="#{@id}"><xsl:value-of select="@title"/></a></i></b></li>
                </xsl:for-each>
              </ul>
            </div>
          </xsl:if>

		  <!-- For feat-based SFRs -->
          <xsl:if test="//cc:feature[.//@id = current()/cc:depends/@*]">
            <div class="statustag">
              <b><i>This component must be included in the ST if the TOE implements any of the following features:</i></b><br/>
              <ul>
                <xsl:for-each select="//cc:feature[.//@id = current()/cc:depends/@*]">
                  <li><b><i> <a href="#{@id}"><xsl:value-of select="@title"/></a></i></b></li>
                </xsl:for-each>
              </ul>
            </div>
          </xsl:if>
		            
	  <xsl:if test="//cc:f-component[.//@id = current()/cc:depends/@*]">
            <div class="statustag">
               <p/><b><i>This component must be included in the ST if any of the following SFRs are included:</i></b><br/>
               <ul>
                 <xsl:for-each select="//cc:f-component[.//@id = current()/cc:depends/@*]">
			<li><b><i><a href="#{@id}"><xsl:apply-templates select="." mode="getId"/></a></i></b></li>
                 </xsl:for-each>
               </ul>
             </div>
           </xsl:if>
        </xsl:if>
        
		<!-- Optional SFRs in the Additional SFRs section of a PP-Module -->
		<xsl:if test="@status='optional' and ancestor::cc:additional-sfrs">
			<div class="statustag">
				<b><i>This component is optional and may be claimed at the ST-Author's discretion.</i></b>
			</div>
		</xsl:if>

		<!-- Selection-based SFRs. All cases. -->        
      <xsl:if test="@status='sel-based' or ancestor::cc:sel-sfrs">
        <div class="statustag">
	  <xsl:if test="//cc:selectable[@id = current()/cc:depends/@*]|current()/cc:depends/cc:external-doc">
          <b><i>The inclusion of this selection-based component depends upon selection in
           <xsl:for-each select="//cc:f-element[.//@id = current()/cc:depends[not(cc:external-doc)]/@*]">
                <xsl:apply-templates select="." mode="getId"/>
                <xsl:call-template name="commaifnotlast"/>
           </xsl:for-each>
           <xsl:variable name="fcomp" select="."/>
           <!-- Go through the referenced bases -->
           <xsl:for-each select="//cc:base-pp[@id=current()//cc:external-doc/@ref]|//cc:include-pkg[@id=current()//cc:external-doc/@ref]">
             <xsl:variable name="path" select="concat($work-dir,'/',@id,'.xml')"/>
             <xsl:for-each select="document($path)//cc:f-element[.//@id=$fcomp/cc:depends[cc:external-doc/@ref=current()/@id]/@*]">
               <xsl:apply-templates select="." mode="make_xref"/>
             </xsl:for-each>
             from <xsl:apply-templates select="." mode="make_xref"/>
           </xsl:for-each>.
           </i></b>
		</xsl:if>
           <xsl:if test="//cc:usecase[.//@id = current()/cc:depends/@*]">
             <p/><b><i>This component must also be included in the ST if any of the following use cases are selected:</i></b><br/>
             <ul>
               <xsl:for-each select="//cc:usecase[.//@id = current()/cc:depends/@*]">
                 <li><b><i><a href="#{@id}"><xsl:value-of select="@title"/></a></i></b></li>
               </xsl:for-each>
             </ul>
           </xsl:if>
           <xsl:if test="//cc:feature[.//@id = current()/cc:depends/@*]">
             <p/><b><i>This component must be included in the ST if the TOE implements any of the following features:</i></b><br/>
             <ul>
               <xsl:for-each select="//cc:feature[.//@id = current()/cc:depends/@*]">
                 <li><b><i><a href="#{@id}"><xsl:value-of select="@title"/></a></i></b></li>
               </xsl:for-each>
             </ul>
           </xsl:if>
                      
	  <xsl:if test="//cc:f-component[@id = current()/cc:depends/@*]">
               <p/><b><i>This component must be included in the ST if any of the following SFRs are included:</i></b><br/>
               <ul>
                 <xsl:for-each select="//cc:f-component[@id = current()/cc:depends/@*]">
			<li><b><i><xsl:apply-templates select="." mode="getId"/></i></b></li>
                 </xsl:for-each>
               </ul>
           </xsl:if>
           <xsl:if test="cc:depends/cc:optional">
				<p><i><b>This component may also be included in the ST as if optional.</b></i></p>
           </xsl:if>
           <xsl:if test="cc:depends/cc:objective">
				<p><i><b>This component may also be included in the ST as if optional, but may be mandatory in the future.</b></i></p>
           </xsl:if>
          </div>
      </xsl:if>
        <xsl:apply-templates/>
      <xsl:if test="not( (/cc:Module or //cc:cPP) and $release = 'final' )"><xsl:call-template name="f-comp-activities"/></xsl:if>
    </div>
  </xsl:template>


  <!--########################################-->
  <!--########################################-->
  <xsl:template match="cc:f-element" >
    <div class="element">
      <xsl:variable name="reqid"><xsl:apply-templates select="." mode="getId"/></xsl:variable>
      <div class="reqid" id="{$reqid}">
        <a href="#{$reqid}" class="abbr"><xsl:value-of select="$reqid"/></a>
      </div>
      <div class="reqdesc">
        <xsl:apply-templates select="cc:title"/>
        <xsl:apply-templates select="cc:note"/>
	
        <xsl:if test="//cc:rule[.//cc:ref-id/text()=current()//@id]">
	  <xsl:if test="not(cc:note)">
	    <br/><span class="note-header">Application Note: </span>
	  </xsl:if>
          <div class="validationguidelines_label">Validation Guidelines:</div>
<!--          <p/>Selections in this requirement involve the following rule(s):<br/> -->
          <xsl:apply-templates select="//cc:rule[.//cc:ref-id/text()=current()//@id]" mode="use-case"/>
	</xsl:if>
      </div>
    </div>
  </xsl:template>
  <!--########################################-->
  <!--########################################-->
  <xsl:template match="cc:rule" mode="use-case">
	  <p/><b><a href="#{@id}">Rule #<xsl:number count="cc:rule" level="any"/></a></b>
	  <xsl:choose> <xsl:when test="cc:description">:
      <xsl:apply-templates select="cc:description"/><br/>
<!--      <div class="activity_pane hide"> <div class="activity_pane_header">
      <a onclick="toggle(this);return false;" href="#">
        <span class="activity_pane_label">Rule Definition </span>
        <span class="toggler"/>
      </a>
    </div>
    <div class="activity_pane_body">
      <i> <xsl:apply-templates select="cc:or" mode="use-case"/> </i>
    </div> </div>-->
      </xsl:when> <xsl:otherwise>
    <!--    <xsl:apply-templates mode="use-case"/> -->
      </xsl:otherwise> </xsl:choose>
  </xsl:template>

 <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
   <xsl:template match="cc:a-element" mode="a-element">
    <div class="element">
      <xsl:variable name="type"><xsl:value-of select="@type"/></xsl:variable>
      <xsl:variable name="reqid"><xsl:apply-templates select="." mode="getId"/></xsl:variable>
      <div class="reqid" id="{$reqid}">
        <a href="#{$reqid}" class="abbr">
          <xsl:value-of select="$reqid"/>
        </a>
      </div>
      <div class="reqdesc">
        <xsl:apply-templates select="cc:title"/>
        <xsl:apply-templates select="cc:note"/>
      </div>
    </div>
  </xsl:template>


  <!-- ############### -->
  <!--                 -->
  <xsl:template match="cc:foreword">
    <div class="foreword">
      <h1 style="text-align: center">Foreword</h1>
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  <!-- ############### -->
  <!--                 -->
  <xsl:template match="cc:title">
    <xsl:apply-templates/>
    <xsl:apply-templates mode="post_title"/>
  </xsl:template>

 <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:note/cc:aactivity">
    Evaluation Activity Note:<br/>
    <xsl:apply-templates/>
  </xsl:template> 


 

  <!-- ############### -->
  <!-- These items are just consumed without output when processed by 'apply-templates' in default mode.      -->
  <xsl:template match="cc:appendix[@title='Optional Requirements']"/>
  <xsl:template match="cc:appendix[@title='Selection-Based Requirements']"/>
  <xsl:template match="cc:appendix[@title='Objective Requirements']"/>
  <xsl:template match="cc:a-element"/>
  <xsl:template match="cc:ext-comp-def|cc:ext-comp-def-title"/>
  <xsl:template match="cc:consistency-rationale|cc:comp-lev|cc:management|cc:audit|cc:heirarchical-to|cc:dependencies"/>
  <xsl:template match="cc:ext-comp-extra-pat"/>
 
 <!-- ############### -->
  <!--                 --> 
  <!-- Note: In the worksheet branch the ref-id of a depends tag is an attribute, but at some point that changed to a tag in the master.
       Of course, nobody tells me this so it took a while to debug.   -->
  <!-- TODO: Check the logic behind the ref-id: it only supports one ref-id right now.-->
  <!-- Reworked this so it would display in the section where the festures are defined rather than in the appendix. -->
    <xsl:template name="handle-features">
<!--		<xsl:call-template name="imple_text"/>  -->
       <xsl:for-each select="//cc:implements/cc:feature">
          <xsl:variable name="fid"><xsl:value-of select="@id"/></xsl:variable>
<!--          <xsl:variable name="oneIfApp">0<xsl:if test="$appendicize='on'">1</xsl:if></xsl:variable>  -->
<!--          <xsl:variable name="level" select="2+$oneIfApp"/>  -->

          <xsl:variable name="level" select="3"/> 

          <h3 class="indexable" data-level="{$level}" id="{@id}"><xsl:value-of select="@title"/></h3>
          <xsl:apply-templates select="cc:description"/><br/>
  	  <!-- First just output the name of the SFR associated with each feature.  -->
          <p>
	  If this feature is implemented by the TOE, the following requirements must be claimed in the ST:
            <ul> <xsl:for-each select="//cc:f-component[cc:depends/@*=$fid]"> 
	       <li><b><xsl:apply-templates select="." mode="getId"/></b></li>
	    </xsl:for-each></ul>
          </p> 
   <!--       
		<xsl:variable name="full_id"><xsl:apply-templates select="." mode="getId"/></xsl:variable>

    <div class="comp" id="{$full_id}">
      <h4><xsl:value-of select="concat($full_id, ' ', @name)"/></h4>
   
	-->  
          
	  <!-- Then each SFR in full. Note if an SFR is invoked by two features it will be listed twice. -->  
<!--          <xsl:if test="$appendicize='on'">
             <xsl:for-each select="//cc:f-component/cc:depends[@*=$fid]/../..">
                <h3 id="{@id}-impl" class="indexable" data-level="{$level+1}"><xsl:value-of select="@title" /></h3>
                <xsl:apply-templates select="cc:f-component[cc:depends/@*=$fid]" mode="appendicize-nofilter"/>
             </xsl:for-each>
          </xsl:if>   -->
        </xsl:for-each>
    </xsl:template>


  
  <xsl:template match="cc:implements">
	<xsl:call-template name="handle-features"/>
  </xsl:template>

  <!-- ############### -->
  <!--                 -->
  <!-- Edited to add references for these generated audit tables:
    - strictly optional = "at-optional"
    - objective = "at-objective"
    - sel based = "at-sel-based"
    - impl-dep = "at-impl-dep"  -->
    <xsl:template name="first-appendix">
        <xsl:choose>
            <xsl:when test="$appendicize='on'">
                <xsl:call-template name="opt_appendix"/>
                <xsl:call-template name="app-reqs">
                    <xsl:with-param name="type" select="'optional'"/>
                </xsl:call-template>

                <xsl:call-template name="app-reqs">
                    <xsl:with-param name="type" select="'objective'"/>
                </xsl:call-template>
            
                <xsl:call-template name="app-reqs">
                    <xsl:with-param name="type" select="'feat-based'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
				<!-- I don't think this code is ever reached. -->
                <h1 id="impl-reqs" class="indexable" data-level="A">Implementation-dependent Requirements</h1>
                Implementation-dependent Requirements <xsl:call-template name="imple_text"/>
                <xsl:call-template name="handle-features"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

  <!-- ############### -->
  <!--   Appendix Requirements               -->
  <!-- ############### -->
  <xsl:template name="app-reqs">
    <xsl:param name="type"/>
    <xsl:param name="level" select="2"/>
    <xsl:param name="sublevel" select="3"/>
 
 <!--   <xsl:choose><xsl:when test="//cc:hide-empty-req-appendices"/><xsl:otherwise>-->
    <xsl:variable name="levelname"><xsl:choose>
      <xsl:when test="$level='A'">h1</xsl:when>
      <xsl:otherwise>h2</xsl:otherwise>
    </xsl:choose></xsl:variable>
    <xsl:variable name="nicename" select="document('boilerplates.xml')//cc:*[@tp=$type]/@nice"/>
 
    <xsl:element name="{$levelname}">
       <xsl:attribute name="id"><xsl:value-of select="concat($type,'-reqs')"/></xsl:attribute>
       <xsl:attribute name="class">indexable</xsl:attribute>
       <xsl:attribute name="data-level"><xsl:value-of select="$level"/></xsl:attribute>
       <xsl:value-of select="$nicename"/>  Requirements
    </xsl:element>
    <xsl:apply-templates select="document('boilerplates.xml')//cc:*[@tp=$type]/cc:description"/>
    <xsl:choose>
      <xsl:when test="count(//cc:f-component[@status=$type])=0 and count(//cc:a-component[@status=$type])=0">
         <p>This <xsl:call-template name="doctype-short"/> does not define any 
            <xsl:value-of select="$nicename"/> requirements.</p>
      </xsl:when>
      <xsl:otherwise> 
         <xsl:if test="//cc:pp-preferences/cc:audit-events-in-sfrs">
           <xsl:element name="h{$sublevel}">
              <xsl:attribute name="id"><xsl:value-of select="concat($type,'-reqs-audit')"/></xsl:attribute>
              <xsl:attribute name="class">indexable</xsl:attribute>
              <xsl:attribute name="data-level"><xsl:value-of select="$sublevel"/></xsl:attribute>
              Auditable Events for <xsl:value-of select="$nicename"/>  Requirements
           </xsl:element>
           
	    <xsl:choose>
	      <xsl:when test="//*[cc:f-component/@status=$type]//cc:audit-event">
		<xsl:if test="/cc:Package">
		  <xsl:apply-templates select="document('boilerplates.xml')//cc:*[@tp=$type]/cc:audit-table-explainer"/>
		</xsl:if>
		<xsl:call-template name="audit-table">
                  <xsl:with-param name="thistable" select="$type"/>
		</xsl:call-template>
	      </xsl:when>
	      <xsl:otherwise>
		This document does not define any audit events for <xsl:value-of select="$nicename"/>  Requirements.
	      </xsl:otherwise>
	    </xsl:choose>
        </xsl:if>
<!--        <xsl:choose>
          <xsl:when test="$type='feat-based'"><xsl:call-template name="handle-features"/></xsl:when>
          <xsl:otherwise>   -->
		  
		  <!-- Handle optional SARs -->
		  <xsl:for-each select="//*[cc:a-component/@status = $type]">
              <xsl:element name="h{$sublevel}">
                <xsl:attribute name="id"><xsl:value-of select="concat(@id,'-',$type)"/></xsl:attribute>
                <xsl:attribute name="class">indexable</xsl:attribute>
                <xsl:attribute name="data-level"><xsl:value-of select="$sublevel"/></xsl:attribute>
                <xsl:value-of select="@title"/>
              </xsl:element>
     <!--         <h3 id="{@id}-obj" class="indexable" data-level="3"><xsl:value-of select="@title" /></h3 -->
              <xsl:apply-templates select="cc:a-component[@status=$type]" mode="a-comp-to-appendix"/>
            </xsl:for-each>
		  
		    <!-- Handle SFRs that belong in Appendixes -->
            <xsl:for-each select="//*[cc:f-component/@status = $type]">
              <xsl:element name="h{$sublevel}">
                <xsl:attribute name="id"><xsl:value-of select="concat(@id,'-',$type)"/></xsl:attribute>
                <xsl:attribute name="class">indexable</xsl:attribute>
                <xsl:attribute name="data-level"><xsl:value-of select="$sublevel"/></xsl:attribute>
                <xsl:value-of select="@title"/>
              </xsl:element>
     <!--         <h3 id="{@id}-obj" class="indexable" data-level="3"><xsl:value-of select="@title" /></h3 -->
              <xsl:apply-templates select="cc:f-component[@status=$type]" mode="appendicize-nofilter"/>
            </xsl:for-each>
			
<!--          </xsl:otherwise>   -->
<!--        </xsl:choose>   -->
     </xsl:otherwise>
   </xsl:choose>
   <!-- </xsl:otherwise></xsl:choose> -->
 </xsl:template> 

 <!-- ############### -->
  <!--                 -->

  <xsl:template match="cc:appendix">
    <h1 id="{@id}" class="indexable" data-level="A"><xsl:value-of select="@title"/></h1> 
      <!-- insert SFRs for "special" appendices, if @id is one of the "special" ones-->
    <xsl:apply-templates select="." mode="hook"/>
    <xsl:apply-templates/>
  </xsl:template> 

  <!-- ######################### -->
  <!-- ######################### -->
  <xsl:template match="cc:section[cc:f-component]">
    <xsl:param name="lmod" select="'0'"/>

    <xsl:call-template name="section-with-fcomp">
      <xsl:with-param name="title" select="@title"/>
      <xsl:with-param name="id" select="@id"/>
      <xsl:with-param name="lmod" select="$lmod"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="sec:*[cc:f-component and @title]">
    <xsl:param name="lmod" select="'0'"/>

     <xsl:call-template name="section-with-fcomp">
      <xsl:with-param name="title" select="@title"/>
      <xsl:with-param name="id" select="local-name()"/>
      <xsl:with-param name="lmod" select="$lmod"/>
    </xsl:call-template>
  </xsl:template>
 
  <xsl:template match="sec:*[cc:f-component and not(@title)]">
    <xsl:param name="lmod" select="'0'"/>

    <xsl:call-template name="section-with-fcomp">
      <xsl:with-param name="title" select="translate(local-name(),'_',' ')"/>
      <xsl:with-param name="id" select="local-name()"/>
      <xsl:with-param name="lmod" select="$lmod"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="section-with-fcomp">
    <xsl:param name="title"/>
    <xsl:param name="id"/> 
    <xsl:param name="lmod"/>
    <xsl:variable name="level" select="$lmod+count(ancestor::*)"/>
    <!-- the "if" statement is to not display  headers when there are no
    subordinate mandatory components to display in the main body (when in "appendicize" mode) -->
	<!-- rmc 11/8/23: added ancestor condition to display headers when in additional-sfrs section -->
	<!-- The header needs to be displayed also for feat-based SFRs in the body of a Module as well -->
    <xsl:if test="$appendicize!='on' or .//cc:f-component[not(@status)] or ancestor::cc:additional-sfrs or ancestor::cc:impl-dep-sfrs">
      <xsl:element name="h{$level}">
        <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
        <xsl:attribute name="class">indexable</xsl:attribute>
        <xsl:attribute name="data-level"><xsl:value-of select="$lmod+count(ancestor::*)"/></xsl:attribute>
        <xsl:value-of select="$title" />
      </xsl:element>
      <xsl:apply-templates mode="hook" select="."/>
    	  <!-- rmc 11/8/23: added ancestor condition -->
      <xsl:if test="$appendicize = 'on' or ancestor::cc:additional-sfrs or ancestor::cc:impl-dep-sfrs">
        <xsl:apply-templates mode="appendicize" />
      </xsl:if>
      <xsl:if test="$appendicize != 'on'">
        <xsl:apply-templates />
      </xsl:if>
    </xsl:if>
  </xsl:template>


  <!-- ######################### -->
  <!-- Standard approach version of SFR Rationale Section -->
  <!-- ######################### -->
  <xsl:template match="cc:*[@id='obj_map']" mode="hook" name="obj-req-map">
    <p>The following rationale provides justification for each security objective for the TOE, 
    showing that the SFRs are suitable to meet and achieve the security objectives:<br/>
      <table>
        <caption><xsl:call-template name="ctr-xsl">
               <xsl:with-param name="ctr-type">Table</xsl:with-param>
	       <xsl:with-param name="id" select="'t-obj_map'"/>
		</xsl:call-template>: SFR Rationale</caption>
        <tr><th>Objective</th><th>Addressed by</th><th>Rationale</th></tr>
        <xsl:for-each select="//cc:SO/cc:addressed-by">
          <tr>
	   <xsl:if test="not(preceding-sibling::cc:addressed-by)">

             <xsl:attribute name="class">major-row</xsl:attribute>
             <xsl:variable name="rowspan" select="count(../cc:addressed-by)"/>
             <td rowspan="{$rowspan}">
               <xsl:apply-templates mode="underscore_breaker" select="../@name"/><br/>
             </td>
           </xsl:if>
           <td><xsl:apply-templates/></td>
           <td><xsl:apply-templates select="following-sibling::cc:rationale[1]"/></td>
          </tr><xsl:text>&#xa;</xsl:text> 
       
        </xsl:for-each>
      </table>
    </p>
  </xsl:template>

  <!-- ######################### -->
  <!-- Direct Rationale approach version of SFR Rationale Section -->
  <!-- ######################### -->
  <xsl:template match="cc:*[@id='obj_map']" mode="hook" name="threat-req-map">
    <p>The following rationale provides justification for each SFR for the TOE, 
    showing that the SFRs are suitable to address the specified threats:<br/>
    <table>
        <caption><xsl:call-template name="ctr-xsl">
				<xsl:with-param name="ctr-type">Table</xsl:with-param>
				<xsl:with-param name="id" select="'t-obj_map'"/>
			</xsl:call-template>: SFR Rationale</caption>
        <tr><th>Threat</th><th>Addressed by</th><th>Rationale</th></tr>
			
        <xsl:for-each select="//cc:threat/cc:addressed-by">
			<tr>
				<xsl:if test="not(preceding-sibling::cc:addressed-by)">
					<xsl:attribute name="class">major-row</xsl:attribute>
					<xsl:variable name="rowspan" select="count(../cc:addressed-by)"/>
					<td rowspan="{$rowspan}">
						<xsl:call-template name="underscore_breaker">
							<xsl:with-param name="valu"><xsl:apply-templates select=".." mode="get-representation"/></xsl:with-param>
						</xsl:call-template>
					</td>
				</xsl:if>

				<td><xsl:apply-templates/></td>

				<td><xsl:apply-templates select="following-sibling::cc:rationale[1]"/></td>
			</tr><xsl:text>&#xa;</xsl:text> 
        </xsl:for-each>
		
      </table>
    </p>
  </xsl:template>


  <!-- ############### -->
  <!--                 -->
  <xsl:template match="cc:ctr">
    <xsl:variable name="ctrtype"><xsl:choose>
        <xsl:when test="@ctr-type"><xsl:value-of select="@ctr-type"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@pre"/></xsl:otherwise></xsl:choose>
    </xsl:variable>
    <xsl:variable name="id"><xsl:choose>
      <xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="generate-id(.)"/></xsl:otherwise>
    </xsl:choose></xsl:variable>

    
    <span class="ctr" data-myid="{$id}" data-counter-type="ct-{$ctrtype}" id="{$id}">
      <xsl:apply-templates select="." mode="getPre"/><xsl:text> </xsl:text>
      <span class="counter"><xsl:value-of select="$id"/></span>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template name="ctr-xsl">
      <xsl:param name="ctr-type"/>
      <xsl:param name="id"/>

    <xsl:if test="$id=''">
      <xsl:message terminate="yes">Detected that a ctr's _id_ attribute is empty</xsl:message>
    </xsl:if>
    <span class="ctr" data-myid="{$id}" data-counter-type="ct-{$ctr-type}" id="{$id}">
<!--      <xsl:apply-templates select="." mode="getPre"/> -->
      <xsl:value-of select="$ctr-type"/><xsl:text> </xsl:text>
      <span  class="counter"><xsl:value-of select="$id"/></span>
<!--      <xsl:apply-templates/>-->
    </span>
  </xsl:template>
	
  <!-- ############### -->
  <!--                 -->
  <xsl:template match="cc:figure">
    <div class="figure" id="figure-{@id}">
      <img id="{@id}" src="{@entity}" width="{@width}" height="{@height}"/>
      <br/>
      <xsl:call-template name="make_ctr">
        <xsl:with-param name="id" select="@id"/>
        <xsl:with-param name="type" select="'ct-figure'"/>
        <xsl:with-param name="prefix"><xsl:apply-templates select="." mode="getPre"/></xsl:with-param>
      </xsl:call-template>:
      <xsl:value-of select="@title"/>
    </div>
  </xsl:template>


  <xsl:template name="make_ctr">
    <xsl:param name="id"/>
    <xsl:param name="type"/>
    <xsl:param name="prefix"/>

    <span class="ctr" data-myid="{$id}" data-counter-type="{$type}">
        <xsl:value-of select="$prefix"/> 
        <span class="counter"><xsl:value-of select="$id"/></span>
      </span>
  </xsl:template>



  <!-- ############### -->
  <!--                 -->
  <xsl:template match="cc:equation">
    <table><tr>
      <td id="{@id}">$$<xsl:apply-templates/>$$</td>
      <td style="vertical-align: middle; padding-left: 100px"><!--
          -->(<xsl:call-template name="make_ctr">
          <xsl:with-param name="id" select="@id"/>
          <xsl:with-param name="type" select="'equation'"/>
          <xsl:with-param name="prefix" select="''"/>
        </xsl:call-template>)</td>
    </tr></table>
  </xsl:template>


  <!-- ############### -->
  <!--                 -->
  <!-- <xsl:template match="cc:figure|cc:ctr" mode="getPre" name="getPre"> -->
  <xsl:template match="cc:figure|cc:ctr" mode="getPre" >
     <xsl:choose>
      <xsl:when test="@pre"><xsl:value-of select="@pre"/></xsl:when>
      <xsl:when test="local-name()='figure'"><xsl:text>Figure </xsl:text></xsl:when>
      <xsl:when test="@ctr-type"><xsl:value-of select="@ctr-type"/></xsl:when>
      <xsl:otherwise>Table </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


   <!-- ############## -->
  <xsl:template match="//sec:*[@title='Security Functional Requirements']">
    <xsl:call-template name="sfr"><xsl:with-param name="id" select="local-name()"/></xsl:call-template>
  </xsl:template>

  <xsl:template match="//cc:*[@title='Security Functional Requirements']">
    <xsl:call-template name="sfr"/>
  </xsl:template>

   <xsl:template match="/sec:Security_Functional_Requirements">
    <xsl:call-template name="sfr"><xsl:with-param name="id" select="Security_Functional_Requirements"/></xsl:call-template>
   </xsl:template>
  
  <xsl:template name="sfr">
     <xsl:param name="id" select="@id"/>
     <h2 id="{$id}" class="indexable" data-level="2">Security Functional Requirements</h2>
    <xsl:if test="/cc:*/@boilerplates='yes' and not(@boilerplate='no')">
       The Security Functional Requirements included in this section
       are derived from Part 2 of the Common Criteria for Information
       Technology Security Evaluation, <xsl:call-template name="verrev"/>,
       with additional extended functional components.
     </xsl:if>
     <xsl:apply-templates/>
	 	 
	 <!-- SFR Rationale Section for standard approach -->
	 <xsl:if test="/cc:PP and not(//cc:CClaimsInfo[@cc-approach='direct-rationale'])">
       <h3 id="obj-req-map" class="indexable" data-level="3">TOE Security Functional Requirements Rationale</h3>
       <xsl:call-template name="obj-req-map"/>
     </xsl:if>

	<!-- SFR Rationale Section for Direct Rationale approach -->
	 <xsl:if test="/cc:PP and //cc:CClaimsInfo[@cc-approach='direct-rationale']">
		<h3 id="obj-req-map" class="indexable" data-level="3">TOE Security Functional Requirements Rationale</h3>
		<!-- Determine whether to use the <addressed-by> or <threat-addr> mechanism -->
			<xsl:call-template name="threat-req-map"/>
     </xsl:if>
  </xsl:template>
	
</xsl:stylesheet>


