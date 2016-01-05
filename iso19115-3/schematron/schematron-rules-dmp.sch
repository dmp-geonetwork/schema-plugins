<?xml version="1.0" encoding="UTF-8"?><sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
   <sch:title xmlns="http://www.w3.org/2001/XMLSchema" xml:lang="en">Schematron validation for Version 3.0 of Australian Defence Metadata profile of ISO 19115-1:2014 standard</sch:title>
   
   <sch:ns prefix="gml" uri="http://www.opengis.net/gml/3.2"/>
   <sch:ns prefix="srv" uri="http://standards.iso.org/iso/19115/-3/srv/2.0"/>
   <sch:ns prefix="cit" uri="http://standards.iso.org/iso/19115/-3/cit/1.0"/>
   <sch:ns prefix="gex" uri="http://standards.iso.org/iso/19115/-3/gex/1.0"/>
   <sch:ns prefix="mco" uri="http://standards.iso.org/iso/19115/-3/mco/1.0"/>
   <sch:ns prefix="mdb" uri="http://standards.iso.org/iso/19115/-3/mdb/1.0"/>
   <sch:ns prefix="mex" uri="http://standards.iso.org/iso/19115/-3/mex/1.0"/>
   <sch:ns prefix="mmi" uri="http://standards.iso.org/iso/19115/-3/mmi/1.0"/>
   <sch:ns prefix="mrc" uri="http://standards.iso.org/iso/19115/-3/mrc/1.0"/>
   <sch:ns prefix="mrd" uri="http://standards.iso.org/iso/19115/-3/mrd/1.0"/>
   <sch:ns prefix="mri" uri="http://standards.iso.org/iso/19115/-3/mri/1.0"/>
   <sch:ns prefix="mrl" uri="http://standards.iso.org/iso/19115/-3/mrl/1.0"/>
   <sch:ns prefix="mrs" uri="http://standards.iso.org/iso/19115/-3/mrs/1.0"/>
   <sch:ns prefix="mcc" uri="http://standards.iso.org/iso/19115/-3/mcc/1.0"/>
   <sch:ns prefix="lan" uri="http://standards.iso.org/iso/19115/-3/lan/1.0"/>
   <sch:ns prefix="gco" uri="http://standards.iso.org/iso/19115/-3/gco/1.0"/>
	 <sch:ns prefix="mdq" uri="http://standards.iso.org/iso/19157/-2/mdq/1.0"/>
	 <sch:ns prefix="dmp" uri="http://www.defence.gov.au/dmp"/>
   <sch:ns prefix="geonet" uri="http://www.fao.org/geonetwork"/>
   <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
   <sch:ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema"/>

	 <!-- Some rules taken from GA profile version 1.0 schematrons and converted to ISO19115-1:2014 and ISO19115-3:2015 -->
	      
	 <!-- ============================================================================================================ -->
	 <!-- Assert that metadataIdentifier (at least one) is present -->
	 <!-- ============================================================================================================ -->
   <sch:diagnostics>
      <sch:diagnostic id="rule.dmp.mdb.metadataidentifierpresent-failure-en" xml:lang="en">The metadata identifier is not present.</sch:diagnostic>
      
    
      <sch:diagnostic id="rule.dmp.mdb.metadataidentifierpresent-success-en" xml:lang="en">The metadata identifier is present
      "<sch:value-of select="normalize-space($mdid)"/>"
      .</sch:diagnostic>
      
  </sch:diagnostics>
   <sch:pattern id="rule.dmp.mdb.metadataidentifierpresent">
      <sch:title xml:lang="en">Metadata identifier must be present.</sch:title>
      
    
      <sch:rule context="//mdb:metadataIdentifier[1]/mcc:MD_Identifier">
      
         <sch:let name="mdid" value="mcc:code/gco:CharacterString"/>
         <sch:let name="hasMdid" value="normalize-space($mdid) != ''"/>
      
         <sch:assert test="$hasMdid" diagnostics="rule.dmp.mdb.metadataidentifierpresent-failure-en"/>
      
         <sch:report test="$hasMdid" diagnostics="rule.dmp.mdb.metadataidentifierpresent-success-en"/>
      </sch:rule>
  </sch:pattern>

	 <!-- ============================================================================================================ -->
	 <!-- Assert that metadataProfile with title and edition for DMP profile are present -->
	 <!-- ============================================================================================================ -->
   <sch:diagnostics>
      <sch:diagnostic id="rule.dmp.mdb.metadataprofilepresent-failure-en" xml:lang="en">The metadata profile information (mdb:metadataProfile) is not present or may be incorrect - looking for title: 'Australian Defence Metadata Profile of ISO 19115-1:2014' and edition/version: 'Version 3.0, November 25, 2015'.</sch:diagnostic>
      
    
      <sch:diagnostic id="rule.dmp.mdb.metadataprofilepresent-success-en" xml:lang="en">The metadata profile information is present: "<sch:value-of select="normalize-space($title)"/>" with "<sch:value-of select="normalize-space($edition)"/>".</sch:diagnostic>
      
  </sch:diagnostics>
   <sch:pattern id="rule.dmp.mdb.metadataprofilepresent">
      <sch:title xml:lang="en">Metadata profile information must be present and correctly filled out.</sch:title>
      
    
      <sch:rule context="//mdb:metadataProfile/cit:CI_Citation">
      
         <sch:let name="title" value="cit:title/gco:CharacterString"/>
         <sch:let name="hasTitle" value="normalize-space($title) = 'Australian Defence Metadata Profile of ISO 19115-1:2014'"/>
         <sch:let name="edition" value="cit:edition/gco:CharacterString"/>
         <sch:let name="hasEdition" value="normalize-space($edition) = 'Version 3.0, November 25, 2015'"/>
      
         <sch:assert test="$hasTitle and $hasEdition" diagnostics="rule.dmp.mdb.metadataprofilepresent-failure-en"/>
      
         <sch:report test="$hasTitle and $hasEdition" diagnostics="rule.dmp.mdb.metadataprofilepresent-success-en"/>
      </sch:rule>
  </sch:pattern>
	 <!-- ============================================================================================================ -->
	 <!-- Assert that the Metadata Constraint Information is present -->
	 <!-- ============================================================================================================ -->
   <sch:diagnostics>
	 		<sch:diagnostic id="rule.dmp.mco.metadataconstraintspresent-failure-en" xml:lang="en">Metadata Constraint elements not present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.dmp.mco.metadataconstraintspresent-success-en" xml:lang="en">Metadata Constraint elements are present.</sch:diagnostic>


	 		<sch:diagnostic id="rule.dmp.mco.metadatasecurityconstraintspresent-failure-en" xml:lang="en">Metadata Security Constraint elements not present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.dmp.mco.metadatasecurityconstraintspresent-success-en" xml:lang="en">Metadata Security Constraint elements are present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.dmp.mco.securityconstraintsclassificationpresent-failure-en" xml:lang="en">Classification code not present in Security Constraints.</sch:diagnostic>
	 		<sch:diagnostic id="rule.dmp.mco.securityconstraintsclassificationpresent-success-en" xml:lang="en">Classification code is present in Security Constraints.</sch:diagnostic>
   </sch:diagnostics>
   <sch:pattern id="rule.dmp.mco.securityconstraints">
	 		<sch:title>Constraint Information must be present and correctly filled out.</sch:title>
			<sch:rule context="//mdb:MD_Metadata">
				<sch:assert test="mdb:metadataConstraints/*" diagnostics="rule.dmp.mco.metadataconstraintspresent-failure-en"/>
				<sch:report test="mdb:metadataConstraints/*" diagnostics="rule.dmp.mco.metadataconstraintspresent-success-en"/>

				<sch:assert test="mdb:metadataConstraints/dmp:DMP_SecurityConstraints" diagnostics="rule.dmp.mco.metadatasecurityconstraintspresent-failure-en"/>
				<sch:report test="mdb:metadataConstraints/dmp:DMP_SecurityConstraints" diagnostics="rule.dmp.mco.metadatasecurityconstraintspresent-success-en"/>
			</sch:rule>
			<sch:rule context="//dmp:DMP_SecurityConstraints/mco:classification">
				<sch:assert test="normalize-space(mco:MD_ClassificationCode/@codeList) and normalize-space(mco:MD_ClassificationCode/@codeListValue)" diagnostics="rule.dmp.mco.securityconstraintsclassificationpresent-failure-en"/>
				<sch:report test="normalize-space(mco:MD_ClassificationCode/@codeList) and normalize-space(mco:MD_ClassificationCode/@codeListValue)" diagnostics="rule.dmp.mco.securityconstraintsclassificationpresent-success-en"/>
			</sch:rule>
  </sch:pattern>
	 <!-- ============================================================================================================ -->
	 <!-- Assert that the Data Identification Information is present -->
	 <!-- ============================================================================================================ -->
   <sch:diagnostics>
	 		<sch:diagnostic id="rule.dmp.mri.identificationinformationpresent-failure-en" xml:lang="en">Data Identification Information element not present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.dmp.mri.identificationinformationpresent-success-en" xml:lang="en">Data Identification Information element is present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.dmp.mri.pointofcontactpresent-failure-en" xml:lang="en">MD_DataIdentification/pointOfContact information not present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.dmp.mri.maintenanceinformationpresent-failure-en" xml:lang="en">MD_DataIdentification/ resourceMaintenance/ MD_MaintenanceInformation not present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.dmp.mri.resourceformatpresent-failure-en" xml:lang="en">MD_DataIdentification/ resourceFormat/ MD_Format not present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.dmp.mri.resourceconstraintspresent-failure-en" xml:lang="en">MD_DataIdentification/ resourceConstraints information not present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.dmp.mri.topiccategorypresent-failure-en" xml:lang="en">MD_DataIdentification/ topicCategory not present or empty.</sch:diagnostic>
	 		<sch:diagnostic id="rule.dmp.mri.securityconstraintspresent-failure-en" xml:lang="en">MD_DataIdentification/ resourceConstraints/ DMP_SecurityConstraints not present.</sch:diagnostic>
   </sch:diagnostics>
   <sch:pattern id="rule.dmp.mri.identificationinformation">
	 		<sch:title>Identification Information must be present and correctly filled out.</sch:title>
			<sch:rule context="//mdb:MD_Metadata">
				<sch:assert test="mdb:identificationInfo/mri:MD_DataIdentification" diagnostics="rule.dmp.mri.identificationinformationpresent-failure-en"/>
				<sch:report test="mdb:identificationInfo/mri:MD_DataIdentification" diagnostics="rule.dmp.mri.identificationinformationpresent-success-en"/>
			</sch:rule>
			<sch:rule context="//mri:MD_DataIdentification[parent::mdb:identificationInfo[parent::mdb:MD_Metadata]]">
      	<sch:assert test="count(mri:pointOfContact[descendant::text()])>0" diagnostics="rule.dmp.mri.pointofcontactpresent-failure-en"/>
      	<sch:report test="count(mri:pointOfContact[descendant::text()])>0" diagnostics="rule.dmp.mri.pointofcontactpresent-failure-en"/>

      	<sch:assert test="mri:resourceMaintenance/mmi:MD_MaintenanceInformation" diagnostics="rule.dmp.mri.maintenanceinformationpresent-failure-en"/> 
      	<sch:report test="mri:resourceMaintenance/mmi:MD_MaintenanceInformation" diagnostics="rule.dmp.mri.maintenanceinformationpresent-failure-en"/> 

      	<sch:assert test="mri:resourceFormat/mrd:MD_Format" 										 diagnostics="rule.dmp.mri.resourceformatpresent-failure-en"/>
      	<sch:report test="mri:resourceFormat/mrd:MD_Format" 										 diagnostics="rule.dmp.mri.resourceformatpresent-failure-en"/>

      	<sch:assert test="mri:resourceConstraints/*"														 diagnostics="rule.dmp.mri.resourceconstraintspresent-failure-en"/>
      	<sch:report test="mri:resourceConstraints/*"														 diagnostics="rule.dmp.mri.resourceconstraintspresent-failure-en"/>

      	<sch:assert test="normalize-space(mri:topicCategory)"		diagnostics="rule.dmp.mri.topiccategorypresent-failure-en"/>
      	<sch:report test="normalize-space(mri:topicCategory)"		diagnostics="rule.dmp.mri.topiccategorypresent-failure-en"/>

      	<sch:assert test="mri:resourceConstraints/dmp:DMP_SecurityConstraints"	diagnostics="rule.dmp.mri.securityconstraintspresent-failure-en"/>
      	<sch:report test="mri:resourceConstraints/dmp:DMP_SecurityConstraints"	diagnostics="rule.dmp.mri.securityconstraintspresent-failure-en"/>

    </sch:rule>
  </sch:pattern>
	<!-- ============================================================================================================ -->
  <!-- Assert that Data Identification has extent element if scope is 'dataset'  -->
	<!-- ============================================================================================================ -->
  <sch:diagnostics>
	 		<sch:diagnostic id="rule.dmp.gex.extentinformationpresent-failure-en" xml:lang="en">MD_DataIdentification/ extent information not present.</sch:diagnostic>
  </sch:diagnostics>
  <sch:pattern id="rule.dmp.gex.identificationinformation">
	 	<sch:title>Identification Information must have an extent if metadataScope is dataset.</sch:title>
		<sch:rule context="//mdb:MD_Metadata[mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue=('dataset','')]">
      	<sch:assert test="count(mdb:identificationInfo/*/mri:extent/gex:EX_Extent/*)>0"		diagnostics="rule.dmp.gex.extentinformationpresent-failure-en"/>
      	<sch:report test="count(mdb:identificationInfo/*/mri:extent/gex:EX_Extent/*)>0"		diagnostics="rule.dmp.gex.extentinformationpresent-failure-en"/>
    </sch:rule>
  </sch:pattern>
	<!-- ============================================================================================================ -->
  <!-- Assert that DMP Security Constraints has required mandatory descendent elements  -->
	<!-- ============================================================================================================ -->
  <sch:diagnostics>
	 	<sch:diagnostic id="rule.dmp.mco.securityconstraintspresent-failure-en" xml:lang="en">MD_ClassificationCode not present or missing code list values.</sch:diagnostic>
	 	<sch:diagnostic id="rule.dmp.mco.securityconstraintspresent-success-en" xml:lang="en">MD_ClassificationCode is present.</sch:diagnostic>
  </sch:diagnostics>
  <sch:pattern rule="rule.dmp.mco.securityconstraints">
    <sch:title>Security Constraints has required/mandatory descendent elements.</sch:title>
    <sch:rule context="//dmp:DMP_SecurityConstraints/mco:classification">
      <sch:assert test="normalize-space(mco:MD_ClassificationCode/@codeList) and normalize-space(mco:MD_ClassificationCode/@codeListValue)" diagnostics="rule.dmp.mco.securityconstraintspresent-failure-en"/>
      <sch:report test="normalize-space(mco:MD_ClassificationCode/@codeList) and normalize-space(mco:MD_ClassificationCode/@codeListValue)" diagnostics="rule.dmp.mco.securityconstraintspresent-success-en"/>
    </sch:rule>
  </sch:pattern>
</sch:schema>
