<?xml version="1.0" encoding="utf-8"?>
<!--
    Audit Events XSL
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cc="https://niap-ccevs.org/cc/v1"
  xmlns:sec="https://niap-ccevs.org/cc/v1/section"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:htm="http://www.w3.org/1999/xhtml"
  version="1.0">

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:audit-table[cc:depends]">
      <!-- This is the same as the audit-events template below, just with a different name.
           The other one should disappear eventually. -->
      <div class="dependent"> The following audit events are included if:
         <ul> <xsl:for-each select="cc:depends">
            <li>
            <xsl:if test="@on='selection'">
              <xsl:for-each select="cc:uid">  
                <xsl:variable name="uid" select="text()"/>
                "<xsl:apply-templates select="//cc:selectable[@id=$uid]"/>"
              </xsl:for-each>
               is selected from 
              <xsl:variable name="uid" select="cc:uid[1]/text()"/>
              <xsl:apply-templates select="//cc:f-element[.//cc:selectable/@id=$uid]" mode="getId"/>
            </xsl:if> 
            <xsl:if test="@on='implements'">
              the TOE implements 
              <xsl:variable name="rid" select="cc:ref-id"/>
              "<xsl:value-of select="//cc:feature[@id=$rid]/@title"/>"
            </xsl:if>
            </li>
        </xsl:for-each> </ul><br/>
        <xsl:call-template name="audit-table"/>
      </div>        
  </xsl:template>    

	
  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <!--  <xsl:template match="cc:audit-events[cc:depends]"> -->
  <!--     <div class="dependent"> The following audit events are included if: -->
  <!--        <ul> <xsl:for-each select="cc:depends"> -->
  <!--           <li> -->
  <!--           <xsl:if test="@on='selection'"> -->
  <!--             <xsl:for-each select="cc:ref-id">   -->
  <!--               <xsl:variable name="uid" select="text()"/> -->
  <!--               "<xsl:apply-templates select="//cc:selectable[@id=$uid]"/>" -->
  <!--             </xsl:for-each> -->
  <!--              is selected from  -->
  <!--             <xsl:variable name="uid" select="cc:ref-id[1]/text()"/> -->
  <!--             <xsl:apply-templates select="//cc:f-element[.//cc:selectable/@id=$uid]" mode="getId"/> -->
  <!--           </xsl:if>  -->
  <!--           <xsl:if test="@on='implements'"> -->
  <!--             the TOE implements  -->
  <!--             <xsl:for-each select="cc:ref-id"> -->
  <!--                <xsl:variable name="ref-id" select="text()"/> -->
  <!--                <xsl:if test="position()!=1">, </xsl:if> -->
  <!--                "<xsl:value-of select="//cc:feature[@id=$ref-id]/@title"/>" -->
  <!--             </xsl:for-each> -->
  <!--           </xsl:if> -->
  <!--           </li> -->
  <!--       </xsl:for-each> </ul><br/> -->
  <!--       <xsl:call-template name="audit-events"/> -->
  <!--     </div>         -->
  <!-- </xsl:template> -->

  <xsl:template match="/cc:PP//cc:f-component|/cc:Package//cc:f-component" mode="compute-fcomp-status">
      <xsl:if test="not(@status)">mandatory</xsl:if><xsl:value-of select="@status"/>
  </xsl:template>
 
  <xsl:template match="/cc:Module//cc:f-component" mode="compute-fcomp-status"><xsl:choose>
    <xsl:when test="ancestor::cc:sel-sfrs">sel-based</xsl:when>
    <xsl:when test="ancestor::cc:opt-sfrs">optional</xsl:when>
    <xsl:when test="ancestor::cc:obj-sfrs">objective</xsl:when>
    <xsl:when test="ancestor::cc:man-sfrs">mandatory</xsl:when>
    <xsl:when test="ancestor::cc:base-pp">base-based</xsl:when>
    <xsl:when test="ancestor::cc:impl-dep-sfrs">feat-based</xsl:when>
    <xsl:otherwise><xsl:message>Detected unknown status of f-compoenent in mandatory <xsl:apply-templates mode="getId" select="."/></xsl:message></xsl:otherwise>
  </xsl:choose></xsl:template>

  <!-- ############### -->
  <!-- This template for audit tables is invoked from XML. --> 
  <!-- This one gets called for the main audit table in FAU_GEN.1 -->
  <!-- ############### -->
  <xsl:template match="cc:audit-table" name="audit-table">
    <xsl:param name="thistable" select="@table"/>


    <xsl:variable name="nicename"><xsl:choose>
      <xsl:when test="@title"><xsl:value-of select="@title"/></xsl:when>
      <xsl:otherwise>Auditable Events for <xsl:value-of select="document('boilerplates.xml')//cc:*[@tp=$thistable]/@nice"/> Requirements</xsl:otherwise>
    </xsl:choose></xsl:variable>

    <table class="sort_kids_" border="1">
      <!--      <xsl:if test="not(node())">-->
      <caption data-sortkey="#0"><xsl:call-template name="ctr-xsl">
        <xsl:with-param name="ctr-type" select="'Table'"/>
	<xsl:with-param name="id"><xsl:choose><xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when><xsl:otherwise><xsl:value-of select="concat('t-audit-',$thistable)"/></xsl:otherwise></xsl:choose></xsl:with-param>
      </xsl:call-template>: <xsl:value-of select="$nicename"/></caption>
      <!--      </xsl:if>-->
      <!--<xsl:apply-templates/>-->
      <tr data-sortkey="#1">
      <th>Requirement</th><th>Auditable Events</th><th>Additional Audit Record Contents</th></tr>
      <xsl:for-each select="//cc:f-component[cc:audit-event]|//cc:f-component[@id=//cc:audit-event[not(parent::cc:external-doc)]/@affects]">
	<!-- <xsl:for-each select="//cc:f-component[cc:audit-event[(@table=$thistable) or (not(@table) and ($fcompstatus=$thistable))]]"> -->
	<!-- <xsl:variable name="fcomp" select="."/> -->
	<xsl:variable name="fcompstatus"><xsl:apply-templates select="." mode="compute-fcomp-status"/></xsl:variable>
	<xsl:if test="cc:audit-event[(@table=$thistable) or (not(@table) and ($fcompstatus=$thistable))]">
	  <xsl:variable name="rowspan"
			select="1+count(cc:audit-event[(@table=$thistable) or (not(@table) and ($fcompstatus=$thistable))])"/>
	  <xsl:variable name="myid"><xsl:apply-templates select="." mode="getId"/></xsl:variable>
          <tr data-sortkey="{$myid}">
            <td rowspan="{$rowspan}">
	      <xsl:value-of select="$myid"/>
	    </td>      <!-- SFR name -->
	    <td style="display:none"></td>
	    <!-- <td>fake</td> -->
	  </tr>
	  <!-- Fake row so that the CSS color alternator doesn't get thrown off-->
	  <tr style="display:none;" data-sortkey="{$myid}#"><td/></tr>



          <!-- The audit event is included in this table only if
                 - The audit event's expressed table attribute matches this table
                 - Or the table attribute is not expressed and the audit event's default audit attribute matches this table.
                 - The default table for an audit event is the same as the status attribute of the enclosing f-component.  -->
            <!-- <xsl:if test="(@table=$thistable) or (not(@table) and ($fcompstatus=$thistable))"> -->
  	    <xsl:apply-templates select="cc:audit-event[(@table=$thistable) or (not(@table) and ($fcompstatus=$thistable))]" mode="kg-intable">
	      <xsl:with-param name="sortkey" select="$myid"/>
	    </xsl:apply-templates>
	</xsl:if>
      </xsl:for-each>
  
	  <!-- Removed 20250113: rmc. This should never have existed as it supported the ability
	       of PPs to add or modify audit events in external documents such as packages.
           If a PP author needs to eliminate audit events, it can be done in FAU_GEN.1trough a selection
		   or by iterating the Package SFR. -->
      <!-- Goes through each external document -->
	  <!-- This needs to handle the case where there are no events rmc, 11/13/23 -->
	  <!-- Also, there we should not be including auditable events from another document. -->
	  <!-- For now the kludge is to do this only for PPs and cPPs until it can be deleted. -->
	  <!--
	 <xsl:if test="ancestor::cc:PP or ancestor::cc:cPP">
		<xsl:for-each select="//cc:*[@id=//cc:external-doc[//cc:audit-event/@table=$thistable]/@ref]">
			<tr data-sortkey="{@id}__{@ref}">
			<td colspan="3">
				From <xsl:apply-templates select="." mode="make_xref"/>
			</td>
			</tr>

			<xsl:variable name="listy">
				<xsl:for-each select="//cc:audit-event[@table=$thistable and parent::cc:external-doc/@ref=current()/@id]/@ref-cc-id">
					<xsl:value-of select="."/>,</xsl:for-each>
			</xsl:variable>
			<xsl:call-template name="external-gatherer">
				<xsl:with-param name="listy" select="$listy"/>
				<xsl:with-param name="table" select="$thistable"/>
				<xsl:with-param name="ext_id" select="@id"/>
			</xsl:call-template>
		</xsl:for-each>   
	</xsl:if>
-->
    </table>
  </xsl:template>

  <xsl:template name="external-gatherer">
    <xsl:param name="listy"/>
    <xsl:param name="table"/>
    <xsl:param name="ext_id"/>


    <xsl:if test="string-length($listy)>0">
      <xsl:variable name="ccid"       select="substring-before($listy, ',')"/>
      <xsl:variable name="restoflist" select="substring-after($listy,',')"/>
      <xsl:variable name="needle"     select="concat(',',$ccid,',')"/>
      <xsl:variable name="haystack"   select="concat(',',$restoflist)"/>
      <xsl:if test="not(contains($haystack,$needle))">
	<xsl:call-template name="make-external-audit-events-rows">
	  <xsl:with-param name="table" select="$table"/>
	  <xsl:with-param name="ccid" select="$ccid"/>
	  <xsl:with-param name="ext_id" select="$ext_id"/>
	</xsl:call-template>
      </xsl:if>
      <xsl:call-template name="external-gatherer">
	<xsl:with-param name="listy"  select="$restoflist"/>
	<xsl:with-param name="table"  select="$table"/>
	<xsl:with-param name="ext_id" select="$ext_id"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
	
  <xsl:template name="make-external-audit-events-rows">
    <xsl:param name="table"/>
    <xsl:param name="ccid"/>
    <xsl:param name="ext_id"/>

    <xsl:variable name="rowspan"
		  select="count(//cc:external-doc[@ref=$ext_id]/cc:audit-event[@ref-cc-id=$ccid and @table=$table])+1"/>
    
    <tr data-sortkey="{$ccid}">
      <td rowspan="{$rowspan}"><xsl:value-of select="$ccid"/></td><td style="display:none"/>
    </tr>
    
    <xsl:for-each select="//cc:external-doc[@ref=$ext_id]/cc:audit-event[@ref-cc-id=$ccid and @table=$table]">
      <xsl:apply-templates select="." mode="kg-intable">
	<xsl:with-param name="sortkey" select="$ccid"/>
      </xsl:apply-templates>
    </xsl:for-each>
    
  </xsl:template>
  
  <xsl:template match="cc:audit-event[not (cc:audit-event-descr)]" mode="kg-intable">
    <xsl:param name="sortkey"/>
    
    <tr data-sortkey="{$sortkey}.1"><td>No events specified</td><td>N/A</td></tr>
  </xsl:template>
  
  <xsl:template match="cc:audit-event[cc:audit-event-descr]" mode="kg-intable">
    <xsl:param name="sortkey"/>
    <xsl:variable name="mysortkey" select="concat($sortkey,'.',count(./preceding-sibling::*))"/>
    
    <tr data-sortkey="{$mysortkey}">
      <td><xsl:choose>
	<!-- When audit events are individually selectable -->
        <xsl:when test="@type='optional'">
	   <b>[selection: </b><i> <xsl:apply-templates select="cc:audit-event-descr"/>, None</i><b>]</b> 
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="cc:audit-event-descr"/>
        </xsl:otherwise>
      </xsl:choose></td>
      <td><xsl:apply-templates select="." mode="audit-add-info"/></td>
    </tr>
  </xsl:template>

  <!-- The following templates are for the 'additional information' cell in the audit table. -->
  <xsl:template match="cc:audit-event[count(cc:audit-event-info)=1]" mode="audit-add-info">
    <xsl:apply-templates select="cc:audit-event-info"/>
  </xsl:template>

  <!-- The following templates are for the 'additional information' cell in the audit table. -->
  <xsl:template match="cc:audit-event[count(cc:audit-event-info)>1]" mode="audit-add-info">
    <ul>
      <xsl:for-each select="cc:audit-event-info">
	<li><xsl:apply-templates select="."/></li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <!-- <xsl:template match="cc:audit-event[cc:audit-event-info[@type='optional']]" mode="audit-add-info"> -->
  <!--   <b>[selection: </b>  <i><xsl:apply-templates select="cc:audit-event-info"/>, No additional information</i><b>]</b> -->
  <!-- </xsl:template> -->
  
  <!-- <xsl:template match="cc:audit-event[cc:audit-event-info[not(@type='optional')]]" mode="audit-add-info"> -->
  <!--   <xsl:apply-templates select="cc:audit-event-info"/> -->
  <!-- </xsl:template> -->
  
  <xsl:template match="cc:audit-event[not(cc:audit-event-info)]" mode="audit-add-info">
    No additional information
  </xsl:template>

  <xsl:template match="cc:audit-event-info[@type='optional']">
    <b>[selection: </b>  <i><xsl:apply-templates/>, No additional information</i><b>]</b>
  </xsl:template>

  <xsl:template match="cc:audit-event-info[not(@type='optional')]">
    <xsl:apply-templates/>
  </xsl:template>
  
   
  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <!--  <xsl:template match="cc:audit-events" name="audit-events"> -->
  <!--   <xsl:variable name="table" select="@table"/> -->
  <!--   <xsl:apply-templates/> -->
  <!--   <table class="" border="1"> -->
  <!--   <tr><th>Requirement</th> -->
  <!--       <th>Auditable Events</th> -->
  <!--       <th>Additional Audit Record Contents</th></tr> -->
  <!--   <xsl:for-each select="//cc:f-component"> -->
  <!--     <tr> -->
  <!--        <td><xsl:apply-templates select="." mode="getId"/></td> -->
  <!--        <xsl:choose> -->
  <!--           <xsl:when test="not(cc:audit-event[cc:table/@known=$table]|cc:audit-event[cc:table/@other=$table])"> -->
  <!--             <td>No events specified.</td><td>N/A</td> -->
  <!--           </xsl:when> -->
  <!--           <xsl:otherwise> -->
  <!--             <xsl:apply-templates select="cc:audit-event[cc:table/@known=$table]|cc:audit-event[cc:table/@other=$table]" mode="intable"/> -->
  <!--           </xsl:otherwise> -->
  <!--        </xsl:choose> -->
  <!--     </tr> -->
  <!--   </xsl:for-each> -->
  <!--   </table> -->
  <!-- </xsl:template> -->

  <!-- ############### -->
  <!--                 -->
  <!-- ############### -->
  <xsl:template match="cc:audit-event" mode="intable">
    <td>
       <xsl:if test="@type='optional'">[OPTIONAL]</xsl:if>
       <xsl:apply-templates select="cc:description"/>
    </td>
    <td><xsl:if test="not(cc:add-info)">-</xsl:if>
             <xsl:apply-templates select="cc:add-info"/>
    </td>
  </xsl:template>
	



</xsl:stylesheet>
