<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exslt="http://exslt.org/common" xmlns:geonet="http://www.fao.org/geonetwork"
  xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:srv="http://www.isotc211.org/2005/srv"
  xmlns:gmd="http://www.isotc211.org/2005/gmd" version="2.0"
  exclude-result-prefixes="srv gco gmd exslt geonet">

  <xsl:import href="process-utility.xsl"/>

  <!-- Process parameters and variables-->
  <xsl:param name="mode" select="'process'"/>
  <xsl:param name="setExtent" select="'0'"/>
  <xsl:param name="setAndReplaceExtent" select="'0'"/>
  <xsl:param name="setCRS" select="'0'"/>
  <xsl:param name="setDynamicGraphicOverview" select="'0'"/>

  <xsl:variable name="setExtentMode" select="geonet:parseBoolean($setExtent)"/>
  <xsl:variable name="setAndReplaceExtentMode" select="geonet:parseBoolean($setAndReplaceExtent)"/>
  <xsl:variable name="setCRSMode" select="geonet:parseBoolean($setCRS)"/>
  <xsl:variable name="setDynamicGraphicOverviewMode"
    select="geonet:parseBoolean($setDynamicGraphicOverview)"/>


  <!-- Load the capabilities document if one oneline resource contains a protocol set to WMS 
    TODO : if many capabilities document set ?
  -->
  <xsl:variable name="onlineNodes"
    select="//gmd:CI_OnlineResource[contains(gmd:protocol/gco:CharacterString, 'OGC:WMS') and normalize-space(gmd:linkage/gmd:URL)!='']"/>
  <xsl:variable name="wmsServiceUrl" select="$onlineNodes/gmd:linkage/gmd:URL[normalize-space()!='']"/>
  <xsl:variable name="layerName" select="$onlineNodes/gmd:name/gco:CharacterString"/>
  <xsl:variable name="capabilitiesDoc">
    <xsl:if test="$onlineNodes">
      <xsl:copy-of select="geonet:get-wms-capabilities($wmsServiceUrl, '1.1.1')"/>
    </xsl:if>
  </xsl:variable>




  <xsl:template name="list-add-info-from-wms">
    <suggestion process="add-info-from-wms"/>
  </xsl:template>


  <!-- Analyze the metadata record and return available suggestion
    for that process -->
  <xsl:template name="analyze-add-info-from-wms">
    <xsl:param name="root"/>

    <xsl:variable name="onlineResources"
      select="$root//gmd:CI_OnlineResource[contains(gmd:protocol/gco:CharacterString, 'OGC:WMS') 
                                            and normalize-space(gmd:linkage/gmd:URL)!='']"/>

    <!-- Check if server is up and new value are available 
     <xsl:variable name="capabilities"
      select="geonet:get-wms-capabilities(gmd:linkage/gmd:URL, '1.1.1')"/>
-->
    <xsl:if test="$onlineResources">
      <suggestion process="add-info-from-wms" category="onlineSrc" target="gmd:extent">
        <name xml:lang="en">WMS service (<xsl:value-of select="$onlineResources/gmd:linkage/gmd:URL"
          />) is defined in online resource section. Run to update extent, CRS or graphic overview
          from this WMS service for layer named "<xsl:value-of
            select="$onlineResources/gmd:name/gco:CharacterString"/>".</name>
        <!-- TODO : for services or no layer name-->
        <operational>true</operational>
        <params>{ setExtent:{type:'boolean', defaultValue:'<xsl:value-of select="$setExtent"/>'},
          setAndReplaceExtent:{type:'boolean', defaultValue:'<xsl:value-of
            select="$setAndReplaceExtent"/>'}, setCRS:{type:'boolean', defaultValue:'<xsl:value-of
            select="$setCRS"/>'}, setDynamicGraphicOverview:{type:'boolean',
            defaultValue:'<xsl:value-of select="$setDynamicGraphicOverview"/>'} }</params>
      </suggestion>
    </xsl:if>

  </xsl:template>


  <!-- Processing templates -->
  <!-- Do a copy of every nodes and attributes -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Remove geonet:* elements. -->
  <xsl:template match="geonet:*" priority="2"/>


  <!-- Here set extent and graphicOverview -->
  <xsl:template
    match="gmd:identificationInfo/gmd:MD_DataIdentification|
        gmd:identificationInfo/*[@gco:isoType='gmd:MD_DataIdentification']|
        gmd:identificationInfo/srv:SV_ServiceIdentification|
        gmd:identificationInfo/*[@gco:isoType='srv:SV_ServiceIdentification']"
    priority="2">

    <xsl:variable name="srv"
      select="local-name(.)='SV_ServiceIdentification'
            or @gco:isoType='srv:SV_ServiceIdentification'"/>
    <xsl:message>srv:<xsl:value-of select="$srv"/></xsl:message>


    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <!-- Copy all elements from AbstractMD_IdentificationType-->
      <xsl:copy-of
        select="gmd:citation|
        gmd:abstract|
        gmd:purpose|
        gmd:credit|
        gmd:status|
        gmd:pointOfContact|
        gmd:resourceMaintenance|
        gmd:graphicOverview
        "/>

      <!-- TODO graphic overview-->
      <xsl:if test="$setDynamicGraphicOverviewMode and $wmsServiceUrl!=''">
        <gmd:graphicOverview>
          <gmd:MD_BrowseGraphic>
            <gmd:fileName>
              <gco:CharacterString>
                <xsl:variable name="wmsBbox" select="$capabilitiesDoc//Layer[Name=$layerName]/LatLonBoundingBox"/>
                <xsl:value-of
                  select="geonet:get-wms-thumbnail-url($wmsServiceUrl, '1.1.1', $layerName, 
                              concat($wmsBbox/@minx, ',', $wmsBbox/@miny, ',', $wmsBbox/@maxx, ',', $wmsBbox/@maxy))"
                />
              </gco:CharacterString>
            </gmd:fileName>
            <gmd:fileDescription>
              <gco:CharacterString><xsl:value-of select="$layerName"/></gco:CharacterString>
            </gmd:fileDescription>
          </gmd:MD_BrowseGraphic>
        </gmd:graphicOverview>
      </xsl:if>

      <xsl:copy-of
        select="gmd:resourceFormat|
                gmd:descriptiveKeywords|
                gmd:resourceSpecificUsage|
                gmd:resourceConstraints|
                gmd:aggregationInfo
                "/>

      <!-- Data -->
      <xsl:copy-of
        select="gmd:spatialRepresentationType|
                gmd:spatialResolution|
                gmd:language|
                gmd:characterSet|
                gmd:topicCategory|
                gmd:environmentDescription
                "/>

      <!-- Service -->
      <xsl:copy-of
        select="srv:serviceType|
                srv:serviceTypeVersion|
                srv:accessProperties|
                srv:restrictions|
                srv:keywords
                "/>

      <!-- Keep existing extent and compute
            from WMS service -->

      <!-- replace or add extent. Default mode is add. 
            All extent element are processed and if a geographicElement is found,
            it will be removed. Description, verticalElement and temporalElement 
            are preserved.
            
            GeographicElement element having BoundingPolygon are preserved.
      -->
      <xsl:choose>
        <xsl:when test="$setExtentMode">
          <xsl:for-each select="srv:extent|gmd:extent">

            <xsl:choose>
              <xsl:when
                test="gmd:EX_Extent/gmd:temporalElement or gmd:EX_Extent/gmd:verticalElement
                or gmd:EX_Extent/gmd:geographicElement[gmd:EX_BoundingPolygon]">
                <xsl:copy>
                  <xsl:copy-of select="gmd:EX_Extent"/>
                </xsl:copy>
              </xsl:when>
              <xsl:when test="$setAndReplaceExtentMode"/>
              <xsl:otherwise>
                <xsl:copy>
                  <xsl:copy-of select="gmd:EX_Extent"/>
                </xsl:copy>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="srv:extent|gmd:extent"/>
        </xsl:otherwise>
      </xsl:choose>

      <!-- New extent position is after existing ones. -->
      <xsl:if test="$setExtentMode">
        <xsl:for-each
          select="//gmd:CI_OnlineResource[contains(gmd:protocol/gco:CharacterString, 'OGC:WMS')]">
          <xsl:call-template name="add-extent-for-wms">
            <xsl:with-param name="srv" select="$srv"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:if>

      <!-- End of data -->
      <xsl:copy-of select="gmd:supplementalInformation"/>

      <!-- End of service -->
      <xsl:copy-of select="srv:*
                "/>

      <!-- Note: When applying this stylesheet
            to an ISO profil having a new substitute for
            MD_Identification, profil specific element copy.
            -->
      <xsl:for-each
        select="*[namespace-uri()!='http://www.isotc211.org/2005/gmd' 
              and namespace-uri()!='http://www.isotc211.org/2005/srv']">
        <xsl:copy-of select="."/>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="gmd:MD_Metadata|*[@gco:isoType='gmd:MD_Metadata']">
    <xsl:copy>
      <xsl:copy-of
        select="gmd:fileIdentifier
        |gmd:language
        |gmd:characterSet
        |gmd:parentIdentifier
        |gmd:hierarchyLevel
        |gmd:hierarchyLevelName
        |gmd:contact
        |gmd:dateStamp
        |gmd:metadataStandardName
        |gmd:metadataStandardVersion
        |gmd:dataSetURI
        |gmd:locale
        |gmd:spatialRepresentationInfo
        |gmd:referenceSystemInfo
        "/>

      <!-- Set spatial ref-->
      <xsl:if test="$setCRSMode and $capabilitiesDoc//SRS">
        <gmd:referenceSystemInfo>
          <gmd:MD_ReferenceSystem>
            <xsl:for-each-group select="$capabilitiesDoc//SRS" group-by=".">
              <xsl:call-template name="RefSystemTypes">
                <xsl:with-param name="srs" select="current-grouping-key()"/>
              </xsl:call-template>
            </xsl:for-each-group>
          </gmd:MD_ReferenceSystem>
        </gmd:referenceSystemInfo>
      </xsl:if>

      <xsl:copy-of select="gmd:metadataExtensionInfo
        "/>

      <xsl:apply-templates select="gmd:identificationInfo"/>

      <xsl:copy-of
        select="gmd:contentInfo
        |gmd:distributionInfo
        |gmd:dataQualityInfo
        |gmd:portrayalCatalogueInfo
        |gmd:metadataConstraints
        |gmd:applicationSchemaInfo
        |gmd:metadataMaintenance
        |gmd:series
        |gmd:describes
        |gmd:propertyType
        |gmd:featureType
        |gmd:featureAttribute
        "/>


      <xsl:for-each
        select="*[namespace-uri()!='http://www.isotc211.org/2005/gmd' and namespace-uri()!='http://www.fao.org/geonetwork']">
        <xsl:copy-of select="."/>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="RefSystemTypes">
    <xsl:param name="srs"/>
    <gmd:referenceSystemIdentifier>
      <gmd:RS_Identifier>
        <gmd:code>
          <gco:CharacterString>
            <xsl:value-of select="$srs"/>
          </gco:CharacterString>
        </gmd:code>
      </gmd:RS_Identifier>
    </gmd:referenceSystemIdentifier>
  </xsl:template>



  <!-- Utility templates -->
  <xsl:template name="add-extent-for-wms">
    <xsl:param name="srv" select="false()"/>
    <xsl:param name="status" select="false()"/>

    <xsl:variable name="layerName" select="gmd:name/gco:CharacterString/text()"/>
    <xsl:apply-templates select="$capabilitiesDoc//Layer[Name=$layerName]"
      mode="create-bbox-for-wms">
      <xsl:with-param name="srv" select="$srv"/>
    </xsl:apply-templates>
  </xsl:template>


  <!-- Create a bounding box -->
  <xsl:template mode="create-bbox-for-wms" match="Layer">
    <xsl:param name="srv" select="false()"/>

    <xsl:for-each select="LatLonBoundingBox">
      <xsl:choose>
        <xsl:when test="$srv">
          <srv:extent>
            <xsl:copy-of select="geonet:make-iso-extent(@minx, @miny, @maxx, @maxy, '')"/>
          </srv:extent>
        </xsl:when>
        <xsl:otherwise>
          <gmd:extent>
            <xsl:copy-of select="geonet:make-iso-extent(@minx, @miny, @maxx, @maxy, '')"/>
          </gmd:extent>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
