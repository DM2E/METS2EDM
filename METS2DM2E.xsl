<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:dcterms="http://purl.org/dc/terms/" xmlns:edm="http://www.europeana.eu/schemas/edm/"
	xmlns:dm2e="http://onto.dm2e.eu/schemas/dm2e/"
	xmlns:ore="http://www.openarchives.org/ore/terms/" xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#"
	xmlns:wgs84_pos="http://www.w3.org/2003/01/geo/wgs84_pos#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:bibo="http://purl.org/ontology/bibo/"
	xmlns:pro="http://purl.org/spar/pro/" xmlns:foaf="http://xmlns.com/foaf/0.1/"
	xmlns:mods="http://www.loc.gov/mods/v3" xmlns:mets="http://www.loc.gov/METS/"
	xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dv="http://dfg-viewer.de/"
	xmlns:crm="http://www.cidoc-crm.org/rdfs/cidoc_crm_v5.0.2_english_label.rdfs#"
	xmlns:ddb="http://www.deutsche-digitale-bibliothek.de/edm/" xmlns:mets2dm2e="http://www.ub.uni-frankfurt.de">

	<!--
	METS/MODS to DM2E/EDM/DDB-EDM v11.10
	 
	Copyright 2013-2016
	Licensed under the EUPL, Version 1.1 or – as soon they will be approved by the European Commission - subsequent  
	versions of the EUPL (the "Licence"); You may not use this work except in compliance with the Licence. 
	You may obtain a copy of the Licence at: 
	http://ec.europa.eu/idabc/eupl
	Unless required by applicable law or agreed to in writing, software distributed under the Licence is 
	distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
	See the Licence for the specific language governing permissions and limitations under the Licence.
	 
	 Marko Knepper
	 2015-07-19
	 Universitätsbibliothek JCS Frankfurt am Main
	 2016-06
	 Universitätsbibliothek Mainz
     m.knepper@ub.uni-mainz.de	-->

	<xsl:output method="xml" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
	<xsl:strip-space elements="*"/>
	<!-- Provider, example DM2E -->
	<xsl:param name="provider">DM2E</xsl:param>
	<!-- Dataprovider -->
	<xsl:param name="dprovider">Universitätsbibliothek JCS Frankfurt am Main</xsl:param>
	<!-- Dataprovider sameAs URI sequence e.g. ('http://d-nb.info/gnd/10096915-X',...) -->
	<xsl:param name="dproviderSameAs"
		select="('http://viaf.org/viaf/123368197','http://d-nb.info/gnd/10096915-X','http://ld.zdb-services.de/data/organisations/DE-30')"/>
	<!-- Dataprovider Bundesland, example http://d-nb.info/gnd/4024729-6, DDB only-->
	<xsl:param name="dprovider_bundesland">http://d-nb.info/gnd/4024729-6</xsl:param>
	<!-- Dataprovider Bundesland, example Hessen, DDB only-->
	<xsl:param name="dprovider_bundesland_label ">Hessen</xsl:param>
	<!-- Dataprovider is holding institution false()/true(), DM2E only - leave out for false -->
	<xsl:param name="isholding" select="false()"/>
	<!-- Current geographical location: authority, e.g. geonames, gnd - empty means unknown-->
	<xsl:param name="currentLocation-authority">gnd</xsl:param>
	<!-- Current geographical location: Authority URI, e.g. http://sws.geonames.org/, http://d-nb.info/gnd/ -->
	<xsl:param name="currentLocation-authorityURI">http://d-nb.info/gnd/</xsl:param>
	<!-- Current geographical location: URI, e.g. http://sws.geonames.org/2925533, http://d-nb.info/gnd/4018118-2  -->
	<xsl:param name="currentLocation-valueURI">http://d-nb.info/gnd/4018118-2</xsl:param>
	<!-- Current geographical location: corresponding label, e.g. Frankfurt am Main -->
	<xsl:param name="currentLocation-label">Frankfurt am Main</xsl:param>
	<!-- Current geographical location: Latitude WGS84, e.g. 50.11552 -->
	<xsl:param name="currentLocation-lat">50.11552</xsl:param>
	<!-- Current geographical location: Longitude WGS84, e.g. 8.68417 -->
	<xsl:param name="currentLocation-long">8.68417</xsl:param>
	<!-- ID root baseurl, examples http://data.dm2e.eu/data (URL only) -->
	<xsl:param name="root">http://data.dm2e.eu/data</xsl:param>
	<!-- Provider ID: example ub-ffm -->
	<xsl:param name="prov-id">ub-ffm</xsl:param>
	<!-- Collection ID: example sammlungen (URL only) -->
	<xsl:param name="coll-id">sammlungen</xsl:param>
	<!-- URI type: URL/local -->
	<xsl:param name="uri">URL</xsl:param>
	<!-- Transcription URLs e.g. http://senckenberg.ub.uni-frankfurt.de:8080/@ID/xml - @ID will be replaced by mets-ID, hasviewurixml will be tested for TEI -->
	<xsl:param name="hasviewurixml"/>
	<xsl:param name="hasviewurihtml"/>
	<xsl:param name="hasAnnotatableVersionAthtml"/>
	<!-- Default dc:type (DM2E only), examples http://onto.dm2e.eu/schemas/dm2e/Manuscript http://purl.org/ontology/bibo/Book -->
	<xsl:param name="itemtype">http://onto.dm2e.eu/schemas/dm2e/Manuscript</xsl:param>
	<!-- Default rights, examples http://creativecommons.org/publicdomain/mark/1.0/ http://www.europeana.eu/rights/rr-f/ -->
	<xsl:param name="def_rights">http://creativecommons.org/publicdomain/mark/1.0/</xsl:param>
	<!-- Default rights text, examples dcterms:rights rdf:resource="http://creativecommons.org/publicdomain/mark/1.0/deed.de DDB only-->
	<xsl:param name="def_rights_text"
		>http://creativecommons.org/publicdomain/mark/1.0/deed.de</xsl:param>
	<!-- Default metadata rights, examples http://creativecommons.org/publicdomain/zero/1.0/, DDB only -->
	<xsl:param name="def_m_rights">http://creativecommons.org/publicdomain/zero/1.0/</xsl:param>
	<!-- Data model: EDM/DM2E/DDB -->
	<xsl:param name="model">DM2E</xsl:param>
	<!-- Events: none/DDB -->
	<xsl:param name="events">none</xsl:param>
	<!-- Output level: volumes/pages/all (all TBD)-->
	<xsl:param name="level">pages</xsl:param>
	<!-- Identifier type urn/mods -->
	<xsl:param name="id_type">urn</xsl:param>
	<!-- URL type nbn-urn/url/uri -->
	<xsl:param name="url_type">nbn-urn</xsl:param>
	<!-- Build agents or concepts strategy: normal(build or use)/internal(build always, use sameAs)/external(normal with label)/literal(use or literal, no build) -->
	<xsl:param name="resources">internal</xsl:param>
	<!-- Include GND resources: none/include/prefer (prefer TBD) -->
	<xsl:param name="gndresources">include</xsl:param>
	<!-- Granularity of time year/second -->
	<xsl:param name="timegranularity">second</xsl:param>
	<!-- Output mode all/records/cortex -->
	<xsl:param name="outputmode">all</xsl:param>
	<!-- Default Language, example und, zxx -->
	<xsl:param name="def_language">zxx</xsl:param>
	<!-- Primary script of metadata ISO 15924, examples Latn, Hebr -->
	<xsl:param name="prim_script">Latn</xsl:param>
	<!-- Language of the metadata and the text parameters below RFC3066/RFC5646 , examples de, en, fr -->
	<xsl:param name="metalanguage">de</xsl:param>
	<!-- Text: Century, examples '. Jahrhundert', 'th century', 'ème siècle' -->
	<xsl:param name="textcentury">. Jh.</xsl:param>
	<!-- Text: Page, examples 'Seite', 'page', 'page' -->
	<xsl:param name="textpage">Seite</xsl:param>
	<!-- Text: of, examples 'aus', 'of', 'de' -->
	<xsl:param name="textof">aus</xsl:param>
	<!-- Text: Volume, examples 'Band', 'volume', 'tome' -->
	<xsl:param name="textvolume">Band</xsl:param>
	<!-- Text: in, examples 'In: ', 'Dans: ' -->
	<xsl:param name="textin">In: </xsl:param>

	<!-- Process file -->

	<xsl:template match="/">

		<xsl:message>
			<xsl:text>Processing </xsl:text>
			<xsl:value-of select="base-uri()"/>
		</xsl:message>

		<xsl:variable name="rdfoutput">
			<!-- Process records METS/MODS or MODS-->
			<xsl:choose>
				<xsl:when test="exists(//mets:mets)">
					<xsl:for-each select="//mets:mets">
						<xsl:call-template name="metspart">
							<xsl:with-param name="themetspart" select="."/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="//mods:mods">
						<xsl:call-template name="modspart">
							<xsl:with-param name="themodspart" select="."/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- Merge resources and sort for better human reading -->

		<xsl:variable name="mergedoutput">
			<xsl:for-each-group select="$rdfoutput/*" group-by="concat(name(),' ',@rdf:about)">
				<!-- Sorting for being better human readable, nice in many cases -->
				<xsl:sort
					select="string-join((substring-after(@rdf:about,'urn:nbn:'),substring-after(@rdf:about,'PPN'),@rdf:about,name()),' ')"/>
				<xsl:element name="{current-group()[1]/name()}">
					<xsl:attribute name="rdf:about">
						<xsl:value-of select="current-group()[1]/@rdf:about"/>
					</xsl:attribute>
					<xsl:for-each-group select="current-group()/*"
						group-by="string-join((name(),@mets2dm2e:order,@rdf:resource,@xml:lang,@rdf:datatype,.),' ')">
						<xsl:sort
							select="string-join((name(),@mets2dm2e:order,@rdf:resource,@xml:lang,@rdf:datatype,.),' ')"/>
						<xsl:element name="{current-group()[1]/name()}">
							<xsl:if test="current-group()[1]/@rdf:resource">
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="current-group()[1]/@rdf:resource"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test="current-group()[1]/@xml:lang">
								<xsl:attribute name="xml:lang">
									<xsl:value-of select="current-group()[1]/@xml:lang"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test="current-group()[1]/@rdf:datatype">
								<xsl:attribute name="rdf:datatype">
									<xsl:value-of select="current-group()[1]/@rdf:datatype"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:value-of select="."/>
						</xsl:element>
					</xsl:for-each-group>
				</xsl:element>
			</xsl:for-each-group>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$outputmode='all'">
				<!-- Simple RDF output of all data -->
				<xsl:call-template name="outputrdf">
					<xsl:with-param name="therdf">
						<xsl:copy-of select="$mergedoutput"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$outputmode='records'">
				<!-- CHO record list -->
				<xsl:element name="list">
					<xsl:for-each select="$mergedoutput/ore:Aggregation">
						<xsl:element name="record">
							<xsl:variable name="eachitem">
								<xsl:copy-of select="."/>
								<xsl:for-each select="./*/@rdf:resource">
									<xsl:copy-of select="../../../*[@rdf:about=current()]"/>
								</xsl:for-each>
								<xsl:for-each
									select="../edm:WebResource[@rdf:about=current()/*/@rdf:resource]/*/@rdf:resource">
									<xsl:if
										test="'edm:WebResource'!=../../../*[@rdf:about=current()]/name()">
										<xsl:copy-of select="../../../*[@rdf:about=current()]"/>
									</xsl:if>
								</xsl:for-each>
								<xsl:for-each
									select="../edm:Agent[@rdf:about=current()/edm:dataProvider/@rdf:resource]/*/@rdf:resource">
									<xsl:copy-of select="../../../*[@rdf:about=current()]"/>
								</xsl:for-each>
								<xsl:variable name="PCHOID"
									select="current()/edm:aggregatedCHO/@rdf:resource"/>
								<xsl:for-each
									select="../edm:ProvidedCHO[@rdf:about=$PCHOID]/*/@rdf:resource">
									<xsl:if
										test="'edm:ProvidedCHO'!=../../../*[@rdf:about=current()]/name()">
										<xsl:copy-of select="../../../*[@rdf:about=current()]"/>
									</xsl:if>
								</xsl:for-each>
								<xsl:for-each
									select="../edm:Event[@rdf:about=current()/../edm:ProvidedCHO[@rdf:about=$PCHOID]/edm:hasMet/@rdf:resource]/*/@rdf:resource">
									<xsl:copy-of select="../../../*[@rdf:about=current()]"/>
								</xsl:for-each>
							</xsl:variable>
							<xsl:call-template name="outputrdf">
								<xsl:with-param name="therecord" select="@rdf:about"/>
								<xsl:with-param name="therdf">
									<xsl:call-template name="deduplicaterdf">
										<xsl:with-param name="therdf" select="$eachitem"/>
									</xsl:call-template>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>
			</xsl:when>
			<xsl:when test="$outputmode='cortex'">
				<!-- CHO record list -->
				<xsl:element name="outputList">
					<xsl:for-each select="$mergedoutput/ore:Aggregation">
						<xsl:element name="cortex"
							xmlns="http://www.deutsche-digitale-bibliothek.de/cortex">
							<xsl:namespace name="institution"
								select="'http://www.deutsche-digitale-bibliothek.de/institution'"/>
							<xsl:namespace name="item"
								select="'http://www.deutsche-digitale-bibliothek.de/item'"/>
							<xsl:element name="properties">
								<xsl:element name="cortex-type">Kultur</xsl:element>
							</xsl:element>
							<xsl:element name="edm">
								<xsl:variable name="eachitem">
									<xsl:copy-of select="."/>
									<xsl:for-each select="./*/@rdf:resource">
										<xsl:copy-of select="../../../*[@rdf:about=current()]"/>
									</xsl:for-each>
									<xsl:for-each
										select="../edm:WebResource[@rdf:about=current()/*/@rdf:resource]/*/@rdf:resource">
										<xsl:if
											test="'edm:WebResource'!=../../../*[@rdf:about=current()]/name()">
											<xsl:copy-of select="../../../*[@rdf:about=current()]"/>
										</xsl:if>
									</xsl:for-each>
									<xsl:for-each
										select="../edm:Agent[@rdf:about=current()/edm:dataProvider/@rdf:resource]/*/@rdf:resource">
										<xsl:copy-of select="../../../*[@rdf:about=current()]"/>
									</xsl:for-each>
									<xsl:variable name="PCHOID"
										select="current()/edm:aggregatedCHO/@rdf:resource"/>
									<xsl:for-each
										select="../edm:ProvidedCHO[@rdf:about=$PCHOID]/*/@rdf:resource">
										<xsl:if
											test="'edm:ProvidedCHO'!=../../../*[@rdf:about=current()]/name()">
											<xsl:copy-of select="../../../*[@rdf:about=current()]"/>
										</xsl:if>
									</xsl:for-each>
									<xsl:for-each
										select="../edm:Event[@rdf:about=current()/../edm:ProvidedCHO[@rdf:about=$PCHOID]/edm:hasMet/@rdf:resource]/*/@rdf:resource">
										<xsl:copy-of select="../../../*[@rdf:about=current()]"/>
									</xsl:for-each>
								</xsl:variable>
								<xsl:call-template name="outputrdf">
									<xsl:with-param name="therecord" select="@rdf:about"/>
									<xsl:with-param name="therdf">
										<xsl:call-template name="deduplicaterdf">
											<xsl:with-param name="therdf" select="$eachitem"/>
										</xsl:call-template>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:element>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>
					<xsl:text>Unknown output mode, no output</xsl:text>
				</xsl:message>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<!-- Deduplication -->

	<xsl:template name="deduplicaterdf">
		<xsl:param name="therdf"/>
		<xsl:for-each-group select="$therdf/*" group-by="concat(name(),' ',@rdf:about)">
			<!-- Sorting for being better human readable, nice in many cases -->
			<xsl:copy-of select="current-group()[1]"/>
		</xsl:for-each-group>
	</xsl:template>

	<!-- Output rdf -->

	<xsl:template name="outputrdf">
		<xsl:param name="therecord"/>
		<xsl:param name="therdf"/>
		<xsl:message>
			<xsl:text>Generating rdf output... </xsl:text>
			<xsl:value-of select="$therecord"/>
		</xsl:message>
		<xsl:element name="rdf:RDF">
			<xsl:namespace name="dc" select="'http://purl.org/dc/elements/1.1/'"/>
			<xsl:namespace name="dcterms" select="'http://purl.org/dc/terms/'"/>
			<xsl:namespace name="edm" select="'http://www.europeana.eu/schemas/edm/'"/>
			<xsl:namespace name="ore" select="'http://www.openarchives.org/ore/terms/'"/>
			<xsl:namespace name="owl" select="'http://www.w3.org/2002/07/owl#'"/>
			<xsl:namespace name="rdf" select="'http://www.w3.org/1999/02/22-rdf-syntax-ns#'"/>
			<xsl:namespace name="rdfs" select="'http://www.w3.org/2000/01/rdf-schema#'"/>
			<xsl:namespace name="skos" select="'http://www.w3.org/2004/02/skos/core#'"/>
			<xsl:namespace name="wgs84_pos" select="'http://www.w3.org/2003/01/geo/wgs84_pos#'"/>
			<xsl:choose>
				<xsl:when test="$model='DM2E'">
					<xsl:namespace name="bibo" select="'http://purl.org/ontology/bibo/'"/>
					<xsl:namespace name="foaf" select="'http://xmlns.com/foaf/0.1/'"/>
					<xsl:namespace name="pro" select="'http://purl.org/spar/pro/'"/>
					<xsl:namespace name="dm2e" select="'http://onto.dm2e.eu/schemas/dm2e/'"/>
				</xsl:when>
				<xsl:when test="$model='DDB'">
					<xsl:namespace name="ddb" select="'http://www.deutsche-digitale-bibliothek.de/edm/'"/>
				</xsl:when>
			</xsl:choose>
			<xsl:if test="($model='DDB') or ($events='DDB')">
				<xsl:namespace name="crm"
					select="'http://www.cidoc-crm.org/rdfs/cidoc_crm_v5.0.2_english_label.rdfs#'"/>
			</xsl:if>
			<xsl:copy-of select="$therdf"/>
		</xsl:element>
	</xsl:template>

	<!-- find root -->

	<xsl:template name="findroot">
		<xsl:param name="themetspart" as="node()"/>
		<!-- $themetspart/mets:structLink/mets:smLink/@xlink:from -->
		<xsl:variable name="phys1"
			select="$themetspart/mets:structMap[@TYPE='PHYSICAL']/mets:div[@TYPE='physSequence']/mets:div[@TYPE='page'][1]/@ID"/>
		<xsl:variable name="log1"
			select="$themetspart/mets:structLink/mets:smLink[@xlink:to=$phys1]/@xlink:from"/>
		<xsl:variable name="ancestors1"
			select="$themetspart/mets:structMap[@TYPE='LOGICAL']//mets:div[@ID=$log1]/ancestor-or-self::mets:div[exists(index-of(('manuscript','volume','document','monograph','multivolume_work','multivolumework'),lower-case(@TYPE)))]/@ID"/>
		<xsl:variable name="ancestor1" select="$ancestors1[last()]"/>
		<xsl:choose>
			<xsl:when test="not($phys1)">
				<xsl:message>
					<xsl:text>No pages in physical structure - no record root detection.</xsl:text>
				</xsl:message>
			</xsl:when>
			<xsl:when test="not($ancestor1)">
				<xsl:message>
					<xsl:text>Warning: Record root detection failed. No page mapping.</xsl:text>
				</xsl:message>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>
					<xsl:text>Record root id: </xsl:text>
					<xsl:value-of select="$ancestor1"/>
					<xsl:text> (type </xsl:text>
					<xsl:value-of
						select="$themetspart/mets:structMap[@TYPE='LOGICAL']//mets:div[@ID=$ancestor1]/@TYPE"/>
					<xsl:text>)</xsl:text>
				</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:message>
			<xsl:text>Debug: direct pages </xsl:text>
			<xsl:value-of
				select="exists($themetspart/mets:structLink/mets:smLink[@xlink:from=$ancestor1])"/>
		</xsl:message>
		<xsl:value-of select="$ancestor1"/>
	</xsl:template>

	<!-- Templates for pages and structures -->

	<xsl:template name="physpart">
		<xsl:param name="themodspart" as="node()"/>
		<xsl:param name="theurl"/>
		<xsl:param name="thephyspart" as="node()"/>
		<xsl:param name="thefilespart" as="node()"/>
		<xsl:apply-templates select="$thephyspart/mets:*">
			<xsl:with-param name="themodspart" select="$themodspart"/>
			<xsl:with-param name="theurl" select="$theurl"/>
			<xsl:with-param name="thefilespart" select="$thefilespart"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template name="metspart">
		<xsl:param name="themetspart" as="node()"/>
		<xsl:message>
			<xsl:text>Processing METS by logical structure </xsl:text>
			<xsl:value-of
				select="string-join(($themetspart/mets:structMap[@TYPE='LOGICAL']/mets:div/@TYPE,$themetspart/mets:structMap[@TYPE='LOGICAL']/mets:div/@CONTENTIDS,$themetspart/mets:structMap[@TYPE='LOGICAL']/mets:div/@LABEL),' - ')"
			/>
		</xsl:message>
		<xsl:variable name="rootid">
			<xsl:call-template name="findroot">
				<xsl:with-param name="themetspart" select="$themetspart"/>
			</xsl:call-template>
		</xsl:variable>

		<!-- processing volumes -->
		<xsl:for-each
			select="$themetspart/mets:structMap[@TYPE='LOGICAL']//mets:div[exists(index-of(('manuscript','volume','document','monograph','multivolume_work','multivolumework','dspace object contents'),lower-case(@TYPE)))]">
			<xsl:message>
				<xsl:text>Debug: DMDID</xsl:text>
				<xsl:value-of select="current()/@DMDID"/>
				<xsl:text>, ADMID </xsl:text>
				<xsl:value-of select="current()/@ADMID"/>
			</xsl:message>
			<xsl:variable name="themodspart">
				<xsl:choose>
					<xsl:when test="current()/@DMDID">
						<xsl:copy-of
							select="$themetspart/mets:dmdSec[@ID=current()/@DMDID]/mets:mdWrap/mets:xmlData/mods:mods[1]/*"
						/>
					</xsl:when>
					<!-- Dspace -->
					<xsl:when test="current()/@ADMID">
						<xsl:copy-of
							select="$themetspart/mets:dmdSec[@ID=current()/@ADMID]/mets:mdWrap/mets:xmlData/mods:mods[1]/*"
						/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="theidentifier">
				<xsl:choose>
					<xsl:when test="$id_type='mods'">
						<xsl:value-of select="$themodspart/mods:recordInfo/mods:recordIdentifier"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$themodspart/mods:identifier[@type=$id_type][1]"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="string-length($theidentifier)=0">
					<xsl:message>
						<xsl:text>Warning: Empty </xsl:text>
						<xsl:value-of select="$id_type"/>
						<xsl:text> identifier, skipping...</xsl:text>
					</xsl:message>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="modspart">
						<xsl:with-param name="themodspart" select="$themodspart"/>
					</xsl:call-template>
					<xsl:variable name="ddbtype">
						<xsl:choose>
							<xsl:when
								test="exists(index-of(('manuscript','volume','document','monograph','multivolume_work','multivolumework'),lower-case($themetspart/mets:structMap[@TYPE='LOGICAL']/mets:div/@TYPE)))">
								<xsl:choose>
									<xsl:when
										test="exists(index-of(('manuscript','volume','document','monograph','multivolume_work','multivolumework'),lower-case(current()/mets:div[1]/@TYPE)))">
										<xsl:text>020</xsl:text>
									</xsl:when>
									<xsl:when
										test="exists(index-of(('manuscript','volume','document','monograph','multivolume_work','multivolumework'),lower-case(current()/../@TYPE)))">
										<xsl:text>007</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>021</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
						</xsl:choose>
					</xsl:variable>

					<xsl:element name="edm:ProvidedCHO">
						<xsl:attribute name="rdf:about"
							select="mets2dm2e:modsid($themodspart,'item')"/>
						<xsl:choose>
							<xsl:when test="$model='DM2E'">
								<xsl:element name="dc:type">
									<xsl:attribute name="rdf:resource">
										<xsl:value-of select="$itemtype"/>
									</xsl:attribute>
								</xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:element name="dc:type">
									<xsl:call-template name="languagetag">
										<xsl:with-param name="thelanguage" select="'en'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="$ddbtype='007'">
											<xsl:text>Volume</xsl:text>
										</xsl:when>
										<xsl:when test="$ddbtype='020'">
											<xsl:text>Multivolume work</xsl:text>
										</xsl:when>
										<xsl:when test="$ddbtype='021'">
											<xsl:text>Monograph</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>Document</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:element>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>

					<xsl:if test="$model='DDB'">
						<xsl:variable name="ddbhastype">
							<xsl:choose>
								<xsl:when test="$ddbtype='007'">
									<xsl:text>Band</xsl:text>
								</xsl:when>
								<xsl:when test="$ddbtype='020'">
									<xsl:text>Mehrbändiges Werk</xsl:text>
								</xsl:when>
								<xsl:when test="$ddbtype='021'">
									<xsl:text>Monografie</xsl:text>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<!--	<xsl:variable name="ddbhastypeuri"
							select="concat(mets2dm2e:uripath('concept','authority_ddb'),encode-for-uri($ddbtype))"/> -->
						<xsl:variable name="ddbhastypeuri"
							select="concat('http://ddb.vocnet.org/hierarchietyp/ht',encode-for-uri($ddbtype))"/>
						<xsl:element name="edm:ProvidedCHO">
							<xsl:attribute name="rdf:about"
								select="mets2dm2e:modsid($themodspart,'item')"/>
							<xsl:element name="ddb:hierarchyType">
								<xsl:value-of select="concat('htype_',$ddbtype)"/>
							</xsl:element>
							<!-- <xsl:value-of select="current()/@ID"/> 
								<xsl:text>pos</xsl:text>
								<xsl:number select="current()" format="0001" level="single"/> 
								<xsl:text>ord</xsl:text>
								<xsl:number value="current()/@ORDER" format="000000001"/> 

								<xsl:when
									test="$themodspart/mods:part/mods:detail/mods:number">
									<xsl:element name="ddb:hierarchyPosition">
										<xsl:text>part</xsl:text>
										<xsl:variable name="pnumber" select="translate($themodspart/mods:part/mods:detail/mods:number,'[]','')"/>
										<xsl:value-of select="substring('0000000',string-length($pnumber)+1)"/>
										<xsl:value-of select="$pnumber"/>
									</xsl:element>
								</xsl:when> -->
							<xsl:if test="count(../child::mets:div)>1">
								<xsl:element name="ddb:hierarchyPosition">
									<xsl:text>pos</xsl:text>
									<xsl:number select="current()" format="0000001" level="single"/>
								</xsl:element>
							</xsl:if>
							<xsl:element name="ddb:aggregationEntity">
								<xsl:text>false</xsl:text>
							</xsl:element>
							<xsl:element name="edm:hasType">
								<xsl:attribute name="rdf:resource" select="$ddbhastypeuri"/>
							</xsl:element>
						</xsl:element>
						<xsl:element name="skos:Concept">
							<xsl:attribute name="rdf:about">
								<xsl:value-of select="$ddbhastypeuri"/>
							</xsl:attribute>
							<xsl:element name="skos:prefLabel">
								<xsl:call-template name="languagetag">
									<xsl:with-param name="thelanguage" select="de"/>
								</xsl:call-template>
								<xsl:value-of select="$ddbhastype"/>
							</xsl:element>
						</xsl:element>
					</xsl:if>
					<xsl:variable name="thumbnail">
						<xsl:choose>
							<!-- page id handling not universal -->
							<xsl:when test="current()/mets:fptr[contains(@FILEID,'FRONTIMAGE')]">
								<xsl:value-of
									select="$themetspart/mets:fileSec//mets:file[@ID=current()/mets:fptr[contains(@FILEID,'FRONTIMAGE')]/@FILEID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"
								/>
							</xsl:when>
							<xsl:when test="exists(current()//mets:div[@TYPE='TitlePage'])">
								<xsl:value-of
									select="$themetspart/mets:fileSec//mets:file[@ID=$themetspart/mets:structMap[@TYPE='PHYSICAL']//mets:div[@ID=$themetspart/mets:structLink/mets:smLink[@xlink:from=current()//mets:div[@TYPE='TitlePage']/@ID][1]/@xlink:to]/mets:fptr[contains(@FILEID,'DEFAULT')]/@FILEID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"
								/>
							</xsl:when>
							<xsl:when test="exists(current()//mets:fptr)">
								<xsl:value-of
									select="$themetspart/mets:fileSec//mets:file[@ID=current()//mets:fptr[1]/@FILEID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"
								/>
							</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:if test="string-length($thumbnail)>0">
						<xsl:element name="ore:Aggregation">
							<xsl:attribute name="rdf:about">
								<xsl:value-of select="mets2dm2e:modsid($themodspart,'aggregation')"
								/>
							</xsl:attribute>
							<xsl:element name="edm:object">
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="$thumbnail"/>
								</xsl:attribute>
							</xsl:element>
						</xsl:element>
						<xsl:element name="edm:WebResource">
							<xsl:attribute name="rdf:about">
								<xsl:value-of select="$thumbnail"/>
							</xsl:attribute>
							<xsl:element name="dc:format">
								<xsl:text>image/jpeg</xsl:text>
							</xsl:element>
							<xsl:element name="edm:rights">
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="$def_rights"/>
								</xsl:attribute>
							</xsl:element>
							<xsl:if test="$model='DDB'">
								<xsl:element name="dcterms:rights">
									<xsl:attribute name="rdf:resource">
										<xsl:value-of select="$def_rights_text"/>
									</xsl:attribute>
								</xsl:element>
							</xsl:if>
						</xsl:element>
					</xsl:if>
					<xsl:variable name="theurl">
						<xsl:choose>
							<xsl:when
								test="$url_type='nbn-urn' and starts-with($themodspart/mods:identifier[@type='urn'][1],'urn:nbn:de')">
								<xsl:value-of
									select="concat('http://nbn-resolving.de/',$themodspart/mods:identifier[@type='urn'][1])"
								/>
							</xsl:when>
							<xsl:when
								test="$url_type='uri' and starts-with($themodspart/mods:identifier[@type='uri'][1],'http://')">
								<xsl:value-of select="$themodspart/mods:identifier[@type='uri'][1]"
								/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of
									select="$themetspart/mets:amdSec[@ID=current()/@ADMID]/mets:digiprovMD/mets:mdWrap/mets:xmlData/dv:links/dv:presentation"
								/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:if test="string-length($theurl)!=0">
						<xsl:element name="ore:Aggregation">
							<xsl:attribute name="rdf:about">
								<xsl:value-of select="mets2dm2e:modsid($themodspart,'aggregation')"
								/>
							</xsl:attribute>
							<xsl:element name="edm:isShownAt">
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="$theurl"/>
								</xsl:attribute>
							</xsl:element>
						</xsl:element>
						<xsl:element name="edm:WebResource">
							<xsl:attribute name="rdf:about">
								<xsl:value-of select="$theurl"/>
							</xsl:attribute>
							<xsl:element name="dc:format">
								<xsl:text>text/html</xsl:text>
							</xsl:element>
							<xsl:variable name="electronicorigininfo"
								select="$themodspart/mods:originInfo[contains(lower-case(mods:edition[1]),'electronic')]"/>
							<xsl:variable name="dctermscreated"
								select="subsequence(($electronicorigininfo/mods:dateCaptured,$electronicorigininfo/mods:dateIssued[@keyDate='yes']),1,1)"/>
							<xsl:if test="exists($dctermscreated)">
								<xsl:element name="dcterms:created">
									<xsl:value-of select="$dctermscreated"/>
								</xsl:element>
							</xsl:if>
							<xsl:element name="edm:rights">
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="$def_rights"/>
								</xsl:attribute>
							</xsl:element>
							<xsl:if test="$model='DDB'">
								<xsl:element name="dcterms:rights">
									<xsl:attribute name="rdf:resource">
										<xsl:value-of select="$def_rights_text"/>
									</xsl:attribute>
								</xsl:element>
							</xsl:if>
						</xsl:element>
						<xsl:if test="$model='DDB'">
							<xsl:element name="edm:WebResource">
								<xsl:attribute name="rdf:about">
									<xsl:value-of select="$theurl"/>
								</xsl:attribute>
								<xsl:element name="dc:type">
									<xsl:attribute name="rdf:resource">
										<xsl:value-of
											select="'http://ddb.vocnet.org/medientyp/mt003'"/>
									</xsl:attribute>
								</xsl:element>
							</xsl:element>
							<xsl:element name="skos:Concept">
								<xsl:attribute name="rdf:about"
									>http://ddb.vocnet.org/medientyp/mt003</xsl:attribute>
								<xsl:element name="skos:notation">mediatype_003</xsl:element>
							</xsl:element>
						</xsl:if>
						<xsl:if test="$level='pages' and $rootid=current()/@ID">
							<xsl:message>
								<xsl:text>Processing physical structure of id </xsl:text>
								<xsl:value-of select="$themodspart/mods:identifier[@type=$id_type]"/>
								<xsl:text> </xsl:text>
								<xsl:value-of
									select="$themodspart/mods:recordInfo/mods:recordIdentifier"/>
							</xsl:message>
							<xsl:call-template name="physpart">
								<xsl:with-param name="thephyspart"
									select="$themetspart/mets:structMap[@TYPE='PHYSICAL']/mets:div[@TYPE='physSequence']"/>
								<xsl:with-param name="thefilespart"
									select="$themetspart/mets:fileSec"/>
								<xsl:with-param name="themodspart" select="$themodspart"/>
								<xsl:with-param name="theurl" select="$theurl"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:if>
					<!-- table of contents -->
					<xsl:variable name="tableofcontents">
						<xsl:value-of
							select="normalize-unicode(string-join((data(current()/mets:div[empty(index-of(('manuscript','volume','document','monograph','multivolume_work','multivolumework'),lower-case(@TYPE)))]/@LABEL)),'; '),'NFC')"
						/>
					</xsl:variable>
					<xsl:if test="string-length($tableofcontents)>0">
						<xsl:message>
							<xsl:text>Creating table of contents...</xsl:text>
						</xsl:message>
						<xsl:element name="edm:ProvidedCHO">
							<xsl:attribute name="rdf:about">
								<xsl:value-of select="mets2dm2e:modsid($themodspart,'item')"/>
							</xsl:attribute>
							<xsl:element name="dcterms:tableOfContents">
								<xsl:value-of select="$tableofcontents"/>
							</xsl:element>
						</xsl:element>
					</xsl:if>
					<!-- logical structure of volume -->
					<xsl:if test="$level='all'">
						<xsl:for-each
							select="current()//mets:div[empty(index-of(('manuscript','volume','document','monograph','multivolume_work','multivolumework'),lower-case(@TYPE)))]">
							<xsl:message>
								<xsl:value-of select="./@LABEL"/>
							</xsl:message>
							<!-- TBD -->
						</xsl:for-each>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<!-- multivolume relations by logical structure -->
		<xsl:for-each
			select="$themetspart/mets:structMap[@TYPE='LOGICAL']//mets:div[exists(index-of(('manuscript','volume','document','monograph'),lower-case(@TYPE))) and exists(index-of(('multivolume_work','multivolumework'),lower-case(../@TYPE)))]">
			<xsl:variable name="thechildmodspart"
				select="$themetspart/mets:dmdSec[@ID=current()/@DMDID]/mets:mdWrap/mets:xmlData/mods:mods[1]"/>
			<xsl:variable name="theparentmodspart"
				select="$themetspart/mets:dmdSec[@ID=current()/../@DMDID]/mets:mdWrap/mets:xmlData/mods:mods[1]"/>
			<xsl:variable name="prevvolume">
				<xsl:value-of
					select="max(data(../mets:div[number(@ORDER) lt number(current()/@ORDER)]/@ORDER))"
				/>
			</xsl:variable>
			<xsl:variable name="theprecedingmodspart"
				select="$themetspart/mets:dmdSec[@ID=current()/../mets:div[@ORDER=$prevvolume]/@DMDID]/mets:mdWrap/mets:xmlData/mods:mods[1]"/>
			<xsl:variable name="childid">
				<xsl:choose>
					<xsl:when test="$id_type='mods'">
						<xsl:value-of
							select="$thechildmodspart/mods:recordInfo/mods:recordIdentifier"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$thechildmodspart/mods:identifier[@type=$id_type]">
								<xsl:value-of
									select="$thechildmodspart/mods:identifier[@type=$id_type][1]"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@CONTENTIDS"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="parentid">
				<xsl:choose>
					<xsl:when test="$id_type='mods'">
						<xsl:value-of
							select="$theparentmodspart/mods:recordInfo/mods:recordIdentifier"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$theparentmodspart/mods:identifier[@type=$id_type]">
								<xsl:value-of
									select="$theparentmodspart/mods:identifier[@type=$id_type][1]"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="../@CONTENTIDS"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="precedingid">
				<xsl:choose>
					<xsl:when test="$id_type='mods'">
						<xsl:value-of
							select="$theprecedingmodspart/mods:recordInfo/mods:recordIdentifier"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$theprecedingmodspart/mods:identifier[@type=$id_type]">
								<xsl:value-of
									select="$theprecedingmodspart/mods:identifier[@type=$id_type][1]"
								/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="../mets:div[@ORDER=$prevvolume]/@CONTENTIDS"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:message>
				<xsl:text>Found multivolume structure in logical structure map, child id: </xsl:text>
				<xsl:value-of select="$childid"/>
				<xsl:text>, parent id: </xsl:text>
				<xsl:value-of select="$parentid"/>
				<xsl:text>, preceding id: </xsl:text>
				<xsl:value-of select="$precedingid"/>
				<xsl:text>...</xsl:text>
			</xsl:message>
			<xsl:choose>
				<xsl:when test="string-length($childid)!=0 and string-length($parentid)!=0">
					<xsl:message>...and creating parent links</xsl:message>
					<xsl:if test="$model!='DM2E'">
						<xsl:element name="edm:ProvidedCHO">
							<xsl:attribute name="rdf:about">
								<xsl:value-of
									select="concat(mets2dm2e:uripath('item',$coll-id),$parentid)"/>
							</xsl:attribute>
							<xsl:element name="dcterms:hasPart">
								<xsl:attribute name="rdf:resource">
									<xsl:value-of
										select="concat(mets2dm2e:uripath('item',$coll-id),$childid)"
									/>
								</xsl:attribute>
							</xsl:element>
						</xsl:element>
					</xsl:if>
					<xsl:element name="edm:ProvidedCHO">
						<xsl:attribute name="rdf:about">
							<xsl:value-of
								select="concat(mets2dm2e:uripath('item',$coll-id),$childid)"/>
						</xsl:attribute>
						<xsl:element name="dcterms:isPartOf">
							<xsl:attribute name="rdf:resource">
								<xsl:value-of
									select="concat(mets2dm2e:uripath('item',$coll-id),$parentid)"/>
							</xsl:attribute>
						</xsl:element>
						<xsl:if test="../@LABEL">
							<xsl:element name="dc:description">
								<xsl:call-template name="languagetag"/>
								<xsl:attribute name="mets2dm2e:order" select="'B'"/>
								<xsl:value-of select="concat($textin,normalize-space(../@LABEL))"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="$thechildmodspart/mods:part/mods:detail/mods:number">
							<xsl:element name="dc:description">
								<xsl:call-template name="languagetag"/>
								<xsl:attribute name="mets2dm2e:order" select="'C'"/>
								<xsl:value-of
									select="concat($textvolume,' ',$thechildmodspart/mods:part/mods:detail/mods:number)"
								/>
							</xsl:element>
						</xsl:if>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:message>...and ignoring parent (missing id)</xsl:message>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="string-length($childid)!=0 and string-length($precedingid)!=0">
					<xsl:message>...and creating preceding link</xsl:message>
					<xsl:element name="edm:ProvidedCHO">
						<xsl:attribute name="rdf:about">
							<xsl:value-of
								select="concat(mets2dm2e:uripath('item',$coll-id),$childid)"/>
						</xsl:attribute>
						<xsl:element name="edm:isNextInSequence">
							<xsl:attribute name="rdf:resource">
								<xsl:value-of
									select="concat(mets2dm2e:uripath('item',$coll-id),$precedingid)"
								/>
							</xsl:attribute>
						</xsl:element>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:message>...and ignoring preceding (missing id)</xsl:message>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<!-- Template for mods parts -->

	<xsl:template name="CHOstandard">
		<xsl:param name="themodspart" as="node()"/>
		<xsl:param name="theaggid"/>
		<xsl:variable name="organizationclass">
			<xsl:choose>
				<xsl:when test="$model='DM2E'">
					<xsl:text>foaf:Organization</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>edm:Agent</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="($resources!='literal') or ($model='DDB')">
			<xsl:element name="ore:Aggregation">
				<xsl:attribute name="rdf:about">
					<xsl:value-of select="$theaggid"/>
				</xsl:attribute>
				<xsl:element name="edm:dataProvider">
					<xsl:attribute name="rdf:resource">
						<xsl:value-of
							select="concat(mets2dm2e:uripath('agent',$coll-id),encode-for-uri(translate($dprovider,' ,/&lt;&gt;','___')))"
						/>
					</xsl:attribute>
				</xsl:element>
			</xsl:element>
			<xsl:element name="{$organizationclass}">
				<xsl:attribute name="rdf:about">
					<xsl:value-of
						select="concat(mets2dm2e:uripath('agent',$coll-id),encode-for-uri(translate($dprovider,' ,/&lt;&gt;','___')))"
					/>
				</xsl:attribute>
				<xsl:element name="skos:prefLabel">
					<xsl:call-template name="languagetag"/>
					<xsl:value-of select="$dprovider"/>
				</xsl:element>
				<xsl:for-each select="$dproviderSameAs">
					<xsl:element name="owl:sameAs">
						<xsl:attribute name="rdf:resource">
							<xsl:value-of select="."/>
						</xsl:attribute>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
			<xsl:if test="$model='DDB'">
				<xsl:element name="{$organizationclass}">
					<xsl:attribute name="rdf:about">
						<xsl:value-of
							select="concat(mets2dm2e:uripath('agent',$coll-id),encode-for-uri(translate($dprovider,' ,/&lt;&gt;','___')))"
						/>
					</xsl:attribute>
					<xsl:element name="rdf:type">
						<xsl:attribute name="rdf:resource">
							<xsl:text>http://ddb.vocnet.org/sparte/sparte002</xsl:text>
						</xsl:attribute>
					</xsl:element>
					<xsl:element name="crm:P74_has_current_or_former_residence">
						<xsl:attribute name="rdf:resource" select="$dprovider_bundesland"/>
					</xsl:element>
				</xsl:element>
				<xsl:element name="skos:Concept">
					<xsl:attribute name="rdf:about"
						select="'http://ddb.vocnet.org/sparte/sparte002'"/>
					<xsl:element name="skos:notation">sec_02</xsl:element>
				</xsl:element>
				<xsl:element name="edm:Place">
					<xsl:attribute name="rdf:about" select="$dprovider_bundesland"/>
					<xsl:element name="skos:prefLabel">
						<xsl:value-of select="$dprovider_bundesland_label"/>
					</xsl:element>
				</xsl:element>
			</xsl:if>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="($resources='literal')">
				<xsl:element name="ore:Aggregation">
					<xsl:attribute name="rdf:about">
						<xsl:value-of select="$theaggid"/>
					</xsl:attribute>
					<xsl:element name="edm:provider">
						<xsl:value-of select="$provider"/>
					</xsl:element>
					<xsl:element name="edm:dataProvider">
						<xsl:value-of select="$dprovider"/>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="ore:Aggregation">
					<xsl:attribute name="rdf:about">
						<xsl:value-of select="$theaggid"/>
					</xsl:attribute>
					<xsl:element name="edm:provider">
						<xsl:attribute name="rdf:resource">
							<xsl:value-of
								select="concat(mets2dm2e:uripath('agent',$coll-id),encode-for-uri(translate($provider,' ,/&lt;&gt;','___')))"
							/>
						</xsl:attribute>
					</xsl:element>
				</xsl:element>
				<xsl:element name="{$organizationclass}">
					<xsl:attribute name="rdf:about">
						<xsl:value-of
							select="concat(mets2dm2e:uripath('agent',$coll-id),encode-for-uri(translate($provider,' ,/&lt;&gt;','___')))"
						/>
					</xsl:attribute>
					<xsl:element name="skos:prefLabel">
						<xsl:value-of select="$provider"/>
					</xsl:element>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="modspart">
		<xsl:param name="themodspart" as="node()"/>
		<xsl:message>
			<xsl:text>Processing DMD/MODS part </xsl:text>
			<xsl:value-of select="$themodspart/mods:recordInfo/mods:recordIdentifier"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="$themodspart/mods:identifier[@type=$id_type]"/>
		</xsl:message>
		<xsl:element name="edm:ProvidedCHO">
			<xsl:attribute name="rdf:about">
				<xsl:value-of select="mets2dm2e:modsid($themodspart,'item')"/>
			</xsl:attribute>
			<xsl:element name="edm:type">
				<xsl:text>TEXT</xsl:text>
			</xsl:element>
			<xsl:if test="not(exists($themodspart/mods:language/mods:languageTerm[@authority]))">
				<xsl:element name="dc:language">
					<xsl:value-of select="$def_language"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="($isholding) and ($model='DM2E')">
				<xsl:element name="dm2e:holdingInstitution">
					<xsl:attribute name="rdf:resource">
						<xsl:value-of
							select="concat(mets2dm2e:uripath('agent',$coll-id),encode-for-uri(translate($dprovider,' ,/&lt;&gt;','___')))"
						/>
					</xsl:attribute>
				</xsl:element>
			</xsl:if>
			<!--  
			<xsl:choose>
				<xsl:when test="$model='DM2E'">
					<xsl:element name="dc:type">
						<xsl:attribute name="rdf:resource">
							<xsl:value-of select="$itemtype"/>
						</xsl:attribute>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="dc:type">
						<xsl:text>Text</xsl:text>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
			-->
		</xsl:element>
		<xsl:if test="$currentLocation-authority != ''">
			<xsl:choose>
				<xsl:when test="$resources='internal'">
					<xsl:variable name="uri">
						<xsl:value-of
							select="concat(mets2dm2e:uripath('place',concat('authority_',$currentLocation-authority)),encode-for-uri(normalize-space(substring-after($currentLocation-valueURI,$currentLocation-authorityURI))))"
						/>
					</xsl:variable>
					<xsl:element name="edm:Place">
						<xsl:attribute name="rdf:about">
							<xsl:value-of select="$uri"/>
						</xsl:attribute>
						<xsl:element name="skos:prefLabel">
							<xsl:value-of select="$currentLocation-label"/>
						</xsl:element>
						<xsl:element name="owl:sameAs">
							<xsl:attribute name="rdf:resource">
								<xsl:value-of select="$currentLocation-valueURI"/>
							</xsl:attribute>
						</xsl:element>
						<xsl:element name="wgs84_pos:lat">
							<xsl:value-of select="$currentLocation-lat"/>
						</xsl:element>
						<xsl:element name="wgs84_pos:long">
							<xsl:value-of select="$currentLocation-long"/>
						</xsl:element>
					</xsl:element>
					<xsl:element name="edm:ProvidedCHO">
						<xsl:attribute name="rdf:about">
							<xsl:value-of select="mets2dm2e:modsid($themodspart,'item')"/>
						</xsl:attribute>
						<xsl:element name="edm:currentLocation">
							<xsl:attribute name="rdf:resource">
								<xsl:value-of select="$uri"/>
							</xsl:attribute>
						</xsl:element>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="($resources='external') or ($resources='literal')">
						<xsl:element name="edm:Place">
							<xsl:attribute name="rdf:about">
								<xsl:value-of select="$currentLocation-valueURI"/>
							</xsl:attribute>
							<xsl:element name="skos:prefLabel">
								<xsl:value-of select="$currentLocation-label"/>
							</xsl:element>
							<xsl:element name="wgs84_pos:lat">
								<xsl:value-of select="$currentLocation-lat"/>
							</xsl:element>
							<xsl:element name="wgs84_pos:long">
								<xsl:value-of select="$currentLocation-long"/>
							</xsl:element>
						</xsl:element>
					</xsl:if>
					<xsl:element name="edm:ProvidedCHO">
						<xsl:attribute name="rdf:about">
							<xsl:value-of select="mets2dm2e:modsid($themodspart,'item')"/>
						</xsl:attribute>
						<xsl:element name="edm:currentLocation">
							<xsl:attribute name="rdf:resource">
								<xsl:value-of select="$currentLocation-valueURI"/>
							</xsl:attribute>
						</xsl:element>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:element name="ore:Aggregation">
			<xsl:attribute name="rdf:about">
				<xsl:value-of select="mets2dm2e:modsid($themodspart,'aggregation')"/>
			</xsl:attribute>
			<xsl:element name="edm:aggregatedCHO">
				<xsl:attribute name="rdf:resource">
					<xsl:value-of select="mets2dm2e:modsid($themodspart,'item')"/>
				</xsl:attribute>
			</xsl:element>
			<xsl:element name="edm:rights">
				<xsl:attribute name="rdf:resource">
					<xsl:choose>
						<xsl:when test="$model='DDB'">
							<xsl:value-of select="$def_m_rights"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$def_rights"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:element>
			<xsl:if test="$model='DDB'">
				<xsl:element name="dcterms:rights">
					<xsl:attribute name="rdf:resource">
						<xsl:value-of select="$def_m_rights"/>
					</xsl:attribute>
				</xsl:element>
			</xsl:if>
			<xsl:if test="$model='DM2E'">
				<xsl:element name="dm2e:displayLevel">
					<xsl:attribute name="rdf:datatype">
						<xsl:text>http://www.w3.org/2001/XMLSchema#boolean</xsl:text>
					</xsl:attribute>
					<xsl:text>true</xsl:text>
				</xsl:element>
			</xsl:if>
		</xsl:element>
		<xsl:call-template name="CHOstandard">
			<xsl:with-param name="themodspart" select="$themodspart"/>
			<xsl:with-param name="theaggid" select="mets2dm2e:modsid($themodspart,'aggregation')"/>
		</xsl:call-template>
		<xsl:apply-templates select="$themodspart/mods:*"/>
	</xsl:template>

	<!-- mets elements -->

	<xsl:template match="mets:div[@TYPE='page']">
		<xsl:param name="themodspart" as="node()"/>
		<xsl:param name="theurl"/>
		<xsl:param name="thefilespart" as="node()"/>
		<xsl:variable name="prevpage" select="@ORDER - 1"/>
		<!-- page id handling not universal -->
		<xsl:variable name="webfileid" select="mets:fptr[contains(@FILEID,'DEFAULT')]/@FILEID"/>
		<xsl:if test="exists(../mets:div[@ORDER=$prevpage])">
			<xsl:variable name="prevwebfileid"
				select="../mets:div[@ORDER=$prevpage]/mets:fptr[contains(@FILEID,'DEFAULT')]/@FILEID"/>
			<xsl:element name="edm:ProvidedCHO">
				<xsl:attribute name="rdf:about">
					<xsl:value-of select="mets2dm2e:metsid($themodspart,'item',.)"/>
				</xsl:attribute>
				<xsl:element name="edm:isNextInSequence">
					<xsl:attribute name="rdf:resource">
						<xsl:value-of
							select="mets2dm2e:metsid($themodspart,'item',../mets:div[@ORDER=$prevpage])"
						/>
					</xsl:attribute>
				</xsl:element>
			</xsl:element>
		</xsl:if>
		<xsl:element name="edm:ProvidedCHO">
			<xsl:attribute name="rdf:about">
				<xsl:value-of select="mets2dm2e:metsid($themodspart,'item',.)"/>
			</xsl:attribute>
			<xsl:variable name="pagelabel">
				<xsl:choose>
					<xsl:when test="@LABEL">
						<xsl:value-of select="@LABEL"/>
					</xsl:when>
					<xsl:when test="@ORDERLABEL">
						<xsl:value-of select="concat($textpage,' ',@ORDERLABEL)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$textpage"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:element name="dc:title">
				<xsl:value-of select="$pagelabel"/>
			</xsl:element>
			<xsl:element name="dc:description">
				<xsl:call-template name="languagetag"/>
				<xsl:attribute name="mets2dm2e:order" select="'D'"/>
				<xsl:value-of select="concat($pagelabel,' ',$textof,': ')"/>
				<xsl:variable name="thetitelinfo"
					select="$themodspart/mods:titleInfo[not(@type) and not(@usage) and not(@script!=$prim_script)]"/>
				<xsl:if test="$thetitelinfo/mods:nonSort/text()">
					<xsl:value-of select="normalize-space($thetitelinfo/mods:nonSort)"/>
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:value-of select="normalize-space($thetitelinfo/mods:title)"/>
			</xsl:element>
			<xsl:element name="edm:type">
				<xsl:text>TEXT</xsl:text>
			</xsl:element>
			<xsl:element name="dcterms:isPartOf">
				<xsl:attribute name="rdf:resource">
					<xsl:value-of select="mets2dm2e:modsid($themodspart,'item')"/>
				</xsl:attribute>
			</xsl:element>
			<xsl:choose>
				<xsl:when test="$model='DM2E'">
					<xsl:element name="bibo:number">
						<xsl:attribute name="rdf:datatype">
							<xsl:text>http://www.w3.org/2001/XMLSchema#unsignedInt</xsl:text>
						</xsl:attribute>
						<xsl:number count="mets:div[@TYPE='page']"/>
					</xsl:element>
					<xsl:element name="dc:type">
						<xsl:attribute name="rdf:resource">
							<xsl:text>http://onto.dm2e.eu/schemas/dm2e/Page</xsl:text>
						</xsl:attribute>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="dc:type">
						<xsl:call-template name="languagetag">
							<xsl:with-param name="thelanguage" select="'en'"/>
						</xsl:call-template>
						<xsl:text>Page</xsl:text>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="not(exists($themodspart/mods:language/mods:languageTerm[@authority]))">
				<xsl:element name="dc:language">
					<xsl:value-of select="$def_language"/>
				</xsl:element>
			</xsl:if>
			<xsl:for-each select="$themodspart/mods:language/mods:languageTerm[@authority]">
				<xsl:element name="dc:language">
					<xsl:value-of select="mets2dm2e:rfclanguage(.)"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
		<xsl:if test="$model!='DM2E'">
			<xsl:element name="edm:ProvidedCHO">
				<xsl:attribute name="rdf:about">
					<xsl:value-of select="mets2dm2e:modsid($themodspart,'item')"/>
				</xsl:attribute>
				<xsl:element name="dcterms:hasPart">
					<xsl:attribute name="rdf:resource">
						<xsl:value-of select="mets2dm2e:metsid($themodspart,'item',.)"/>
					</xsl:attribute>
				</xsl:element>
			</xsl:element>
		</xsl:if>
		<xsl:element name="ore:Aggregation">
			<xsl:attribute name="rdf:about">
				<xsl:value-of select="mets2dm2e:metsid($themodspart,'aggregation',.)"/>
			</xsl:attribute>
			<xsl:element name="edm:aggregatedCHO">
				<xsl:attribute name="rdf:resource">
					<xsl:value-of select="mets2dm2e:metsid($themodspart,'item',.)"/>
				</xsl:attribute>
			</xsl:element>
			<xsl:element name="edm:isShownBy">
				<xsl:attribute name="rdf:resource">
					<xsl:value-of
						select="$thefilespart//mets:file[@ID=$webfileid]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"
					/>
				</xsl:attribute>
			</xsl:element>
			<xsl:element name="edm:object">
				<xsl:attribute name="rdf:resource">
					<xsl:value-of
						select="$thefilespart//mets:file[@ID=$webfileid]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"
					/>
				</xsl:attribute>
			</xsl:element>
			<xsl:if test="$model='DM2E'">
				<xsl:element name="dm2e:hasAnnotatableVersionAt">
					<xsl:attribute name="rdf:resource">
						<xsl:value-of
							select="$thefilespart//mets:file[@ID=$webfileid]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"
						/>
					</xsl:attribute>
				</xsl:element>
				<xsl:element name="dm2e:displayLevel">
					<xsl:attribute name="rdf:datatype">
						<xsl:text>http://www.w3.org/2001/XMLSchema#boolean</xsl:text>
					</xsl:attribute>
					<xsl:text>false</xsl:text>
				</xsl:element>
			</xsl:if>
			<xsl:element name="edm:rights">
				<xsl:attribute name="rdf:resource">
					<xsl:choose>
						<xsl:when test="$model='DDB'">
							<xsl:value-of select="$def_m_rights"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$def_rights"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:element>
			<xsl:if test="$model='DDB'">
				<xsl:element name="dcterms:rights">
					<xsl:attribute name="rdf:resource">
						<xsl:value-of select="$def_m_rights"/>
					</xsl:attribute>
				</xsl:element>
			</xsl:if>
		</xsl:element>
		<xsl:element name="edm:WebResource">
			<xsl:attribute name="rdf:about">
				<xsl:value-of
					select="$thefilespart/mets:fileGrp[@USE='DEFAULT']/mets:file[@ID=$webfileid]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"
				/>
			</xsl:attribute>
			<xsl:element name="dc:format">
				<xsl:text>image/jpeg</xsl:text>
			</xsl:element>
			<xsl:element name="edm:rights">
				<xsl:attribute name="rdf:resource">
					<xsl:value-of select="$def_rights"/>
				</xsl:attribute>
			</xsl:element>
			<xsl:if test="$model='DDB'">
				<xsl:element name="dcterms:rights">
					<xsl:attribute name="rdf:resource">
						<xsl:value-of select="$def_rights_text"/>
					</xsl:attribute>
				</xsl:element>
			</xsl:if>
		</xsl:element>
		<xsl:call-template name="CHOstandard">
			<xsl:with-param name="themodspart" select="$themodspart"/>
			<xsl:with-param name="theaggid" select="mets2dm2e:metsid($themodspart,'aggregation',.)"
			/>
		</xsl:call-template>
		<!-- Extension for external transcriptions -->
		<xsl:if test="$hasviewurixml">
			<xsl:variable name="uri" select="replace($hasviewurixml,'@ID',@ID)"/>
			<xsl:if test="document($uri)/*:TEI">
				<xsl:message select="concat($uri,' is TEI')"/>

				<xsl:element name="ore:Aggregation">
					<xsl:attribute name="rdf:about">
						<xsl:value-of select="mets2dm2e:metsid($themodspart,'aggregation',.)"/>
					</xsl:attribute>
					<xsl:element name="edm:hasView">
						<xsl:attribute name="rdf:resource">
							<xsl:value-of select="$uri"/>
						</xsl:attribute>
					</xsl:element>
				</xsl:element>
				<xsl:element name="edm:WebResource">
					<xsl:attribute name="rdf:about">
						<xsl:value-of select="$uri"/>
					</xsl:attribute>
					<xsl:element name="dc:format">
						<xsl:text>text/xml</xsl:text>
					</xsl:element>
					<xsl:element name="edm:rights">
						<xsl:attribute name="rdf:resource">
							<xsl:value-of select="'http://www.europeana.eu/rights/rr-f/'"/>
						</xsl:attribute>
					</xsl:element>
					<xsl:if test="$model='DDB'">
						<xsl:element name="dcterms:rights">
							<xsl:attribute name="rdf:resource">
								<xsl:value-of
									select="'http://www.europeana.eu/portal/rights/rr-f.html'"/>
							</xsl:attribute>
						</xsl:element>
					</xsl:if>
				</xsl:element>

				<xsl:if test="$hasviewurihtml">
					<xsl:variable name="uri" select="replace($hasviewurihtml,'@ID',@ID)"/>
					<xsl:element name="ore:Aggregation">
						<xsl:attribute name="rdf:about">
							<xsl:value-of select="mets2dm2e:metsid($themodspart,'aggregation',.)"/>
						</xsl:attribute>
						<xsl:element name="edm:hasView">
							<xsl:attribute name="rdf:resource">
								<xsl:value-of select="$uri"/>
							</xsl:attribute>
						</xsl:element>
					</xsl:element>
					<xsl:element name="edm:WebResource">
						<xsl:attribute name="rdf:about">
							<xsl:value-of select="$uri"/>
						</xsl:attribute>
						<xsl:element name="dc:format">
							<xsl:text>text/html</xsl:text>
						</xsl:element>
						<xsl:element name="edm:rights">
							<xsl:attribute name="rdf:resource">
								<xsl:value-of select="'http://www.europeana.eu/rights/rr-f/'"/>
							</xsl:attribute>
						</xsl:element>
						<xsl:if test="$model='DDB'">
							<xsl:element name="dcterms:rights">
								<xsl:attribute name="rdf:resource">
									<xsl:value-of
										select="'http://www.europeana.eu/portal/rights/rr-f.html'"/>
								</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:element>
				</xsl:if>
				<xsl:if test="$hasAnnotatableVersionAthtml">
					<xsl:variable name="uri"
						select="replace($hasAnnotatableVersionAthtml,'@ID',@ID)"/>
					<xsl:element name="ore:Aggregation">
						<xsl:attribute name="rdf:about">
							<xsl:value-of select="mets2dm2e:metsid($themodspart,'aggregation',.)"/>
						</xsl:attribute>
						<xsl:element name="dm2e:hasAnnotatableVersionAt">
							<xsl:attribute name="rdf:resource">
								<xsl:value-of select="$uri"/>
							</xsl:attribute>
						</xsl:element>
					</xsl:element>
					<xsl:element name="edm:WebResource">
						<xsl:attribute name="rdf:about">
							<xsl:value-of select="$uri"/>
						</xsl:attribute>
						<xsl:element name="dc:format">
							<xsl:text>text/html</xsl:text>
						</xsl:element>
						<xsl:element name="edm:rights">
							<xsl:attribute name="rdf:resource">
								<xsl:value-of select="'http://www.europeana.eu/rights/rr-f/'"/>
							</xsl:attribute>
						</xsl:element>
						<xsl:if test="$model='DDB'">
							<xsl:element name="dcterms:rights">
								<xsl:attribute name="rdf:resource">
									<xsl:value-of
										select="'http://www.europeana.eu/portal/rights/rr-f.html'"/>
								</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:element>
				</xsl:if>
			</xsl:if>

		</xsl:if>

	</xsl:template>

	<!-- mods elements -->

	<xsl:template match="mods:recordInfo[$id_type='mods']">
		<xsl:element name="edm:ProvidedCHO">
			<xsl:attribute name="rdf:about">
				<xsl:value-of select="mets2dm2e:modsid(..,'item')"/>
			</xsl:attribute>
			<xsl:element name="dc:identifier">
				<xsl:value-of select="mods:recordIdentifier"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template match="mods:identifier[@type=$id_type and $id_type!='mods']">
		<xsl:element name="edm:ProvidedCHO">
			<xsl:attribute name="rdf:about">
				<xsl:value-of select="mets2dm2e:modsid(..,'item')"/>
			</xsl:attribute>
			<xsl:element name="dc:identifier">
				<xsl:value-of select="."/>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template match="mods:titleInfo[not(@type)]">
		<!-- mods:title : mods:subtitle / mods:note[@type = 'statement of responsibility] -->
		<xsl:variable name="titleclass">
			<xsl:choose>
				<!-- for the time beeing only one dc:title -->
				<xsl:when test="@script!=$prim_script">dcterms:alternative</xsl:when>
				<xsl:otherwise>dc:title</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="edm:ProvidedCHO">
			<xsl:attribute name="rdf:about">
				<xsl:value-of select="mets2dm2e:modsid(..,'item')"/>
			</xsl:attribute>
			<xsl:element name="{$titleclass}">
				<xsl:choose>
					<xsl:when test="count(../mods:language/mods:languageTerm[@authority])=1">
						<xsl:call-template name="languagetag">
							<xsl:with-param name="thelanguage">
								<xsl:value-of
									select="../mods:language/mods:languageTerm[@authority]"/>
								<xsl:if test="exists(@script)">
									<xsl:text>-</xsl:text>
									<xsl:value-of select="@script"/>
								</xsl:if>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when
						test="count(../mods:language/mods:languageTerm[@authority])>1 and exists(@script)">
						<xsl:call-template name="languagetag">
							<xsl:with-param name="thelanguage" select="concat('mul-',@script)"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when
						test="count(../mods:language/mods:languageTerm[@authority])=0 and exists(@script)">
						<xsl:call-template name="languagetag">
							<xsl:with-param name="thelanguage"
								select="concat($def_language,'-',@script)"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
				<xsl:if test="mods:nonSort/text()">
					<xsl:value-of select="normalize-space(normalize-unicode(mods:nonSort,'NFC'))"/>
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:value-of select="normalize-space(normalize-unicode(mods:title,'NFC'))"/>
				<xsl:if test="mods:subTitle/text()">
					<xsl:text> : </xsl:text>
					<xsl:value-of select="normalize-space(normalize-unicode(mods:subTitle,'NFC'))"/>
				</xsl:if>
				<xsl:if test="../mods:note[@type = 'statement of responsibility']/text()">
					<xsl:text> / </xsl:text>
					<xsl:value-of
						select="normalize-space(normalize-unicode(../mods:note[@type = 'statement of responsibility'][1],'NFC'))"
					/>
				</xsl:if>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template match="mods:note[not(@type='statement of responsibility')]">
		<xsl:element name="edm:ProvidedCHO">
			<xsl:attribute name="rdf:about">
				<xsl:value-of select="mets2dm2e:modsid(..,'item')"/>
			</xsl:attribute>
			<xsl:element name="dc:description">
				<xsl:call-template name="languagetag"/>
				<xsl:attribute name="mets2dm2e:order" select="'G'"/>
				<xsl:value-of select="normalize-unicode(.,'NFC')"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template match="mods:abstract[@type='content']">
		<xsl:element name="edm:ProvidedCHO">
			<xsl:attribute name="rdf:about">
				<xsl:value-of select="mets2dm2e:modsid(..,'item')"/>
			</xsl:attribute>
			<xsl:element name="dc:description">
				<xsl:call-template name="languagetag"/>
				<xsl:attribute name="mets2dm2e:order" select="'F'"/>
				<xsl:value-of select="normalize-unicode(.,'NFC')"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template match="mods:tableOfContents">
		<xsl:element name="edm:ProvidedCHO">
			<xsl:attribute name="rdf:about">
				<xsl:value-of select="mets2dm2e:modsid(..,'item')"/>
			</xsl:attribute>
			<xsl:element name="dc:description">
				<xsl:call-template name="languagetag"/>
				<xsl:attribute name="mets2dm2e:order" select="'E'"/>
				<xsl:value-of select="normalize-unicode(.,'NFC')"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template match="mods:titleInfo[@type]">
		<xsl:element name="edm:ProvidedCHO">
			<xsl:attribute name="rdf:about">
				<xsl:value-of select="mets2dm2e:modsid(..,'item')"/>
			</xsl:attribute>
			<xsl:element name="dcterms:alternative">
				<xsl:if test="mods:nonSort/text()">
					<xsl:value-of select="normalize-space(normalize-unicode(mods:nonSort,'NFC'))"/>
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:value-of select="normalize-space(normalize-unicode(mods:title,'NFC'))"/>
				<xsl:if test="mods:subTitle/text()">
					<xsl:text> : </xsl:text>
					<xsl:value-of select="normalize-space(normalize-unicode(mods:subTitle,'NFC'))"/>
				</xsl:if>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template match="mods:physicalDescription">
		<xsl:element name="edm:ProvidedCHO">
			<xsl:attribute name="rdf:about">
				<xsl:value-of select="mets2dm2e:modsid(..,'item')"/>
			</xsl:attribute>
			<xsl:element name="dc:format">
				<xsl:call-template name="languagetag"/>
				<xsl:value-of
					select="normalize-unicode(string-join((mods:extent,mods:note),'; '),'NFC')"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template match="mods:location">
		<xsl:if test="mods:shelfLocator and $model='DM2E'">
			<xsl:element name="edm:ProvidedCHO">
				<xsl:attribute name="rdf:about">
					<xsl:value-of select="mets2dm2e:modsid(..,'item')"/>
				</xsl:attribute>
				<xsl:element name="dm2e:shelfmarkLocation">
					<xsl:value-of select="mods:shelfLocator[1]"/>
				</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mods:originInfo[not(contains(lower-case(mods:edition[1]),'electronic'))]">
		<xsl:variable name="urievent">
			<xsl:value-of
				select="concat(mets2dm2e:uripath('event',($coll-id,mets2dm2e:recordid(..))),'published')"
			/>
		</xsl:variable>
		<!-- some data have multiple -->
		<xsl:for-each select="mods:publisher">
			<xsl:variable name="uripublisher">
				<xsl:variable name="position">
					<xsl:number select="."/>
				</xsl:variable>
				<xsl:value-of
					select="concat(mets2dm2e:uripath('agent',($coll-id,mets2dm2e:recordid(../..))),$position,'_',encode-for-uri(translate(.,' ,/&lt;&gt;','___')))"
				/>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$resources='literal'">
					<xsl:element name="edm:ProvidedCHO">
						<xsl:attribute name="rdf:about" select="mets2dm2e:modsid(../..,'item')"/>
						<xsl:element name="dc:publisher">
							<xsl:choose>
								<xsl:when test="$model='DDB'">
									<xsl:value-of
										select="normalize-unicode(concat(string-join(../mods:place/mods:placeTerm[@type='text'],', '),' : ',.),'NFC')"
									/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="normalize-unicode(.,'NFC')"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="edm:ProvidedCHO">
						<xsl:attribute name="rdf:about" select="mets2dm2e:modsid(../..,'item')"/>
						<xsl:element name="dc:publisher">
							<xsl:attribute name="rdf:resource" select="$uripublisher"/>
						</xsl:element>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="($resources!='literal') or ($events='DDB')">
				<xsl:element name="edm:Agent">
					<xsl:attribute name="rdf:about" select="$uripublisher"/>
					<xsl:element name="skos:prefLabel">
						<xsl:value-of select="normalize-unicode(.,'NFC')"/>
					</xsl:element>
				</xsl:element>
			</xsl:if>
			<xsl:if test="$events='DDB'">
				<xsl:element name="edm:Event">
					<xsl:attribute name="rdf:about" select="$urievent"/>
					<xsl:element name="crm:P11_had_participant">
						<xsl:attribute name="rdf:resource" select="$uripublisher"/>
					</xsl:element>
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
		<xsl:if test="mods:dateIssued[@keyDate='yes']/text()">
			<xsl:call-template name="modsdate">
				<xsl:with-param name="thedate" select="mods:dateIssued[@keyDate='yes']"/>
				<xsl:with-param name="classname" select="'dcterms:issued'"/>
				<xsl:with-param name="eclass" select="'edm:ProvidedCHO'"/>
				<xsl:with-param name="eID" select="mets2dm2e:modsid(..,'item')"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="mods:dateCreated[not(@point) or (@keyDate='yes')]/text()">
			<xsl:call-template name="modsdate">
				<xsl:with-param name="thedate"
					select="mods:dateCreated[not(@point) or (@keyDate='yes')][1]"/>
				<xsl:with-param name="classname" select="'dcterms:created'"/>
				<xsl:with-param name="eclass" select="'edm:ProvidedCHO'"/>
				<xsl:with-param name="eID" select="mets2dm2e:modsid(..,'item')"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="mods:dateCreated[@point='start']/text()">
			<xsl:call-template name="modsdate">
				<xsl:with-param name="thedate">
					<xsl:value-of select="mods:dateCreated[@point='start']"/>
					<xsl:if test="mods:dateCreated[@point='end']/text()">
						<xsl:text>-</xsl:text>
						<xsl:value-of select="mods:dateCreated[@point='end']"/>
					</xsl:if>
				</xsl:with-param>
				<xsl:with-param name="classname" select="'dcterms:created'"/>
				<xsl:with-param name="eclass" select="'edm:ProvidedCHO'"/>
				<xsl:with-param name="eID" select="mets2dm2e:modsid(..,'item')"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="$events='DDB'">
			<xsl:element name="edm:ProvidedCHO">
				<xsl:attribute name="rdf:about">
					<xsl:value-of select="mets2dm2e:modsid(..,'item')"/>
				</xsl:attribute>
				<xsl:element name="edm:hasMet">
					<xsl:attribute name="rdf:resource" select="$urievent"/>
				</xsl:element>
			</xsl:element>
			<xsl:element name="edm:Event">
				<xsl:attribute name="rdf:about" select="$urievent"/>
				<xsl:element name="edm:hasType">
					<xsl:attribute name="rdf:resource"
						select="'http://terminology.lido-schema.org/lido00228'"/>
				</xsl:element>
			</xsl:element>
			<xsl:if test="mods:dateIssued[@keyDate='yes']/text()">
				<xsl:call-template name="modsdate">
					<xsl:with-param name="thedate" select="mods:dateIssued[@keyDate='yes']"/>
					<xsl:with-param name="classname" select="'edm:occuredAt'"/>
					<xsl:with-param name="eclass" select="'edm:Event'"/>
					<xsl:with-param name="eID" select="$urievent"/>
					<xsl:with-param name="forcetimespan" select="true()"/>
				</xsl:call-template>
				<xsl:if test="$model='DDB'">
					<xsl:call-template name="ddbtime">
						<xsl:with-param name="thedate" select="mods:dateIssued[@keyDate='yes']"/>
						<xsl:with-param name="eID" select="$urievent"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:if>
			<xsl:for-each select="mods:place[mods:placeTerm[@type='text']]">
				<xsl:if test="not(lower-case(mods:placeTerm[@type='text'])='[s.l.]')">
					<xsl:call-template name="modsplace">
						<xsl:with-param name="thename" select="."/>
						<xsl:with-param name="classname" select="'edm:happenedAt'"/>
						<xsl:with-param name="eclass" select="'edm:Event'"/>
						<xsl:with-param name="eID" select="$urievent"/>
						<xsl:with-param name="rID" select="mets2dm2e:recordid(../..)"/>
						<xsl:with-param name="forceagent" select="true()"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>	
		<xsl:choose>
			<xsl:when test="$model='DM2E'">
				<xsl:for-each select="mods:place[mods:placeTerm[@type='text']]">
					<xsl:if test="not(lower-case(mods:placeTerm[@type='text'])='[s.l.]')">
						<xsl:call-template name="modsplace">
							<xsl:with-param name="thename" select="."/>
							<xsl:with-param name="classname" select="'dm2e:publishedAt'"/>
							<xsl:with-param name="eID" select="mets2dm2e:modsid(../..,'item')"/>
							<xsl:with-param name="rID" select="mets2dm2e:recordid(../..)"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="$model='DDB'"/>
			<xsl:otherwise>
				<xsl:for-each select="mods:place[mods:placeTerm[@type='text']]">
					<xsl:if test="not(lower-case(mods:placeTerm[@type='text'])='[s.l.]')">
						<xsl:call-template name="modsplace">
							<xsl:with-param name="thename" select="."/>
							<xsl:with-param name="classname" select="'dcterms:spatial'"/>
							<xsl:with-param name="eID" select="mets2dm2e:modsid(../..,'item')"/>
							<xsl:with-param name="rID" select="mets2dm2e:recordid(../..)"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:element name="edm:ProvidedCHO">
			<xsl:attribute name="rdf:about" select="mets2dm2e:modsid(..,'item')"/>
			<xsl:variable name="theplaces"
				select="string-join((mods:place/mods:placeTerm[@type='text']),', ')"/>
			<xsl:variable name="therest"
				select="string-join((mods:publisher,mods:dateIssued,mods:edition),', ')"/>
			<xsl:choose>
				<xsl:when test="(string-length($theplaces)>0) and (string-length($therest)>0)">
					<xsl:element name="dc:description">
						<xsl:call-template name="languagetag"/>
						<xsl:attribute name="mets2dm2e:order" select="'A'"/>
						<xsl:value-of
							select="normalize-unicode(concat($theplaces,' : ',$therest),'NFC')"/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="string-length($theplaces)>0">
					<xsl:element name="dc:description">
						<xsl:call-template name="languagetag"/>
						<xsl:attribute name="mets2dm2e:order" select="'A'"/>
						<xsl:value-of select="normalize-unicode($theplaces,'NFC')"/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="string-length($therest)>0">
					<xsl:element name="dc:description">
						<xsl:call-template name="languagetag"/>
						<xsl:attribute name="mets2dm2e:order" select="'A'"/>
						<xsl:value-of select="normalize-unicode($therest,'NFC')"/>
					</xsl:element>
				</xsl:when>
			</xsl:choose>
		</xsl:element>
	</xsl:template>

	<xsl:template match="mods:language[exists(mods:languageTerm[@authority])]">
		<xsl:element name="edm:ProvidedCHO">
			<xsl:attribute name="rdf:about">
				<xsl:value-of select="mets2dm2e:modsid(..,'item')"/>
			</xsl:attribute>
			<xsl:element name="dc:language">
				<xsl:value-of select="mets2dm2e:rfclanguage(mods:languageTerm[@authority])"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template
		match="mods:name[(mods:role/mods:roleTerm[@authority='marcrelator']='aut') or (lower-case(mods:role/mods:roleTerm[@type='text'])='author')]">
		<xsl:choose>
			<xsl:when test="$model='DM2E'">
				<xsl:call-template name="modsagent">
					<xsl:with-param name="thename" select="."/>
					<xsl:with-param name="classname" select="'pro:author'"/>
					<xsl:with-param name="eID" select="mets2dm2e:modsid(..,'item')"/>
					<xsl:with-param name="rID" select="mets2dm2e:recordid(..)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="modsagent">
					<xsl:with-param name="thename" select="."/>
					<xsl:with-param name="classname" select="'dc:creator'"/>
					<xsl:with-param name="eID" select="mets2dm2e:modsid(..,'item')"/>
					<xsl:with-param name="rID" select="mets2dm2e:recordid(..)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="$events='DDB'">
			<xsl:call-template name="modsagentcreateevent">
				<xsl:with-param name="thename" select="."/>
				<xsl:with-param name="rID" select="mets2dm2e:recordid(..)"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mods:name[mods:role/mods:roleTerm[@authority='marcrelator']='edt']">
		<xsl:choose>
			<xsl:when test="$model='DM2E'">
				<xsl:call-template name="modsagent">
					<xsl:with-param name="thename" select="."/>
					<xsl:with-param name="classname" select="'bibo:editor'"/>
					<xsl:with-param name="eID" select="mets2dm2e:modsid(..,'item')"/>
					<xsl:with-param name="rID" select="mets2dm2e:recordid(..)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="modsagent">
					<xsl:with-param name="thename" select="."/>
					<xsl:with-param name="classname" select="'dc:contributor'"/>
					<xsl:with-param name="eID" select="mets2dm2e:modsid(..,'item')"/>
					<xsl:with-param name="rID" select="mets2dm2e:recordid(..)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="$events='DDB'">
			<xsl:call-template name="modsagentcreateevent">
				<xsl:with-param name="thename" select="."/>
				<xsl:with-param name="rID" select="mets2dm2e:recordid(..)"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template
		match="mods:name[index-of(('asn','cmm'),mods:role/mods:roleTerm[@authority='marcrelator'])>0]">
		<xsl:call-template name="modsagent">
			<xsl:with-param name="thename" select="."/>
			<xsl:with-param name="classname" select="'dc:contributor'"/>
			<xsl:with-param name="eID" select="mets2dm2e:modsid(..,'item')"/>
			<xsl:with-param name="rID" select="mets2dm2e:recordid(..)"/>
		</xsl:call-template>
		<xsl:if test="$events='DDB'">
			<xsl:call-template name="modsagentcreateevent">
				<xsl:with-param name="thename" select="."/>
				<xsl:with-param name="rID" select="mets2dm2e:recordid(..)"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mods:name[mods:role/mods:roleTerm[@authority='marcrelator']='scr']">
		<xsl:choose>
			<xsl:when test="$model='DM2E'">
				<xsl:call-template name="modsagent">
					<xsl:with-param name="thename" select="."/>
					<xsl:with-param name="classname" select="'dm2e:copyist'"/>
					<xsl:with-param name="eID" select="mets2dm2e:modsid(..,'item')"/>
					<xsl:with-param name="rID" select="mets2dm2e:recordid(..)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="modsagent">
					<xsl:with-param name="thename" select="."/>
					<xsl:with-param name="classname" select="'dc:contributor'"/>
					<xsl:with-param name="eID" select="mets2dm2e:modsid(..,'item')"/>
					<xsl:with-param name="rID" select="mets2dm2e:recordid(..)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="$events='DDB'">
			<xsl:call-template name="modsagentcreateevent">
				<xsl:with-param name="thename" select="."/>
				<xsl:with-param name="rID" select="mets2dm2e:recordid(..)"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template
		match="mods:name[index-of(('asn','cmm','act'),mods:role/mods:roleTerm[@authority='marcrelator'])>0]">
		<xsl:call-template name="modsagent">
			<xsl:with-param name="thename" select="."/>
			<xsl:with-param name="classname" select="'dc:contributor'"/>
			<xsl:with-param name="eID" select="mets2dm2e:modsid(..,'item')"/>
			<xsl:with-param name="rID" select="mets2dm2e:recordid(..)"/>
		</xsl:call-template>
		<xsl:if test="$events='DDB'">
			<xsl:call-template name="modsagentcreateevent">
				<xsl:with-param name="thename" select="."/>
				<xsl:with-param name="rID" select="mets2dm2e:recordid(..)"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template
		match="mods:name[index-of(('cmp','aud'),mods:role/mods:roleTerm[@authority='marcrelator'])>0]">
		<xsl:call-template name="modsagent">
			<xsl:with-param name="thename" select="."/>
			<xsl:with-param name="classname" select="'dc:creator'"/>
			<xsl:with-param name="eID" select="mets2dm2e:modsid(..,'item')"/>
			<xsl:with-param name="rID" select="mets2dm2e:recordid(..)"/>
		</xsl:call-template>
		<xsl:if test="$events='DDB'">
			<xsl:call-template name="modsagentcreateevent">
				<xsl:with-param name="thename" select="."/>
				<xsl:with-param name="rID" select="mets2dm2e:recordid(..)"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mods:subject">
		<xsl:choose>
			<xsl:when test="mods:name">
				<xsl:call-template name="modsagent">
					<xsl:with-param name="thename" select="mods:name"/>
					<xsl:with-param name="classname" select="'dc:subject'"/>
					<xsl:with-param name="eID" select="mets2dm2e:modsid(..,'item')"/>
					<xsl:with-param name="rID" select="mets2dm2e:recordid(..)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="modsconcept">
					<xsl:with-param name="thesubject" select="."/>
					<xsl:with-param name="PCHO" select=".."/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- multivolume relation by mods:relatedItem -->
	<xsl:template
		match="mods:relatedItem[(@type='host') and (($id_type='mods' and exists(mods:recordInfo/mods:recordIdentifier) or ($id_type!='mods' and exists(mods:identifier[@type=$id_type]))))]">
		<xsl:message>
			<xsl:text>Found multivolume structure in mods part...</xsl:text>
		</xsl:message>
		<xsl:message>
			<xsl:text>...and creating parent links</xsl:text>
		</xsl:message>
		<xsl:if test="$model!='DM2E'">
			<xsl:element name="edm:ProvidedCHO">
				<xsl:attribute name="rdf:about">
					<xsl:value-of select="mets2dm2e:modsid(.,'item')"/>
				</xsl:attribute>
				<xsl:element name="dcterms:hasPart">
					<xsl:attribute name="rdf:resource">
						<xsl:value-of select="mets2dm2e:modsid(..,'item')"/>
					</xsl:attribute>
				</xsl:element>
			</xsl:element>
		</xsl:if>
		<xsl:element name="edm:ProvidedCHO">
			<xsl:attribute name="rdf:about">
				<xsl:value-of select="mets2dm2e:modsid(..,'item')"/>
			</xsl:attribute>
			<xsl:element name="dcterms:isPartOf">
				<xsl:attribute name="rdf:resource">
					<xsl:value-of select="mets2dm2e:modsid(.,'item')"/>
				</xsl:attribute>
			</xsl:element>
			<xsl:if test="mods:titleInfo[not(@type) and not(@script!=$prim_script)]/mods:title">
				<xsl:variable name="thetitelinfo"
					select="mods:titleInfo[not(@type) and not(@usage) and not(@script!=$prim_script)]"/>
				<xsl:variable name="intitle">
					<xsl:value-of select="$textin"/>
					<xsl:if test="$thetitelinfo/mods:nonSort/text()">
						<xsl:value-of
							select="normalize-space(normalize-unicode($thetitelinfo/mods:nonSort,'NFC'))"/>
						<xsl:text> </xsl:text>
					</xsl:if>
					<xsl:value-of
						select="normalize-space(normalize-unicode($thetitelinfo/mods:title,'NFC'))"
					/>
				</xsl:variable>
				<xsl:element name="dc:description">
					<xsl:call-template name="languagetag"/>
					<xsl:attribute name="mets2dm2e:order" select="'B'"/>
					<xsl:value-of select="$intitle"/>
				</xsl:element>
				<xsl:if test="not(../mods:titleInfo[not(@type)])">
					<xsl:element name="dc:title">
						<xsl:call-template name="languagetag"/>
						<xsl:value-of
							select="string-join(($intitle,concat($textvolume,' ',../mods:part/mods:detail/mods:number)),' ; ')"
						/>
					</xsl:element>
				</xsl:if>
			</xsl:if>
			<xsl:if test="../mods:part/mods:detail/mods:number">
				<xsl:element name="dc:description">
					<xsl:call-template name="languagetag"/>
					<xsl:attribute name="mets2dm2e:order" select="'C'"/>
					<xsl:value-of
						select="concat($textvolume,' ',../mods:part/mods:detail/mods:number)"/>
				</xsl:element>
			</xsl:if>
		</xsl:element>
	</xsl:template>

	<xsl:template match="*"/>

	<!-- procedures -->

	<xsl:template name="modsdate">
		<xsl:param name="thedate"/>
		<xsl:param name="classname"/>
		<xsl:param name="eclass"/>
		<xsl:param name="eID"/>
		<xsl:param name="forcetimespan" as="xs:boolean" select="false()"/>
		<xsl:variable name="thekeydate" select="substring($thedate,1,4)"/>
		<xsl:variable name="theenddate">
			<xsl:choose>
				<xsl:when test="substring(substring-after($thedate,'-'),1,4)">
					<xsl:value-of select="substring(substring-after($thedate,'-'),1,4)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$thekeydate"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when
				test="contains($thekeydate,'XX') or ($timegranularity='second') or ($theenddate!=$thekeydate) or $forcetimespan">
				<xsl:variable name="begindate">
					<xsl:choose>
						<xsl:when test="$timegranularity='year'">
							<xsl:value-of select="translate($thekeydate,'X','0')"/>
						</xsl:when>
						<xsl:when test="$timegranularity='second'">
							<xsl:value-of
								select="concat(translate($thekeydate,'X','0'),'-01-01T00:00:00')"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="enddate">
					<xsl:choose>
						<xsl:when test="$timegranularity='year'">
							<xsl:value-of select="translate($theenddate,'X','9')"/>
						</xsl:when>
						<xsl:when test="$timegranularity='second'">
							<xsl:value-of
								select="concat(translate($theenddate,'X','9'),'-12-31T23:59:59')"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="uridate">
					<xsl:value-of
						select="concat(mets2dm2e:uripath('timespan',()),translate($begindate,':','-'),'_',translate($enddate,':','-'))"
					/>
				</xsl:variable>
				<xsl:variable name="label">
					<xsl:choose>
						<xsl:when test="$thekeydate!=$theenddate">
							<xsl:value-of select="$thekeydate"/>
							<xsl:text> - </xsl:text>
							<xsl:value-of select="$theenddate"/>
						</xsl:when>
						<xsl:when test="contains($thekeydate,'XX')">
							<xsl:value-of
								select="concat(number(substring-before($thekeydate,'XX'))+1,$textcentury)"
							/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$thekeydate"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:element name="edm:TimeSpan">
					<xsl:attribute name="rdf:about">
						<xsl:value-of select="$uridate"/>
					</xsl:attribute>
					<xsl:element name="skos:prefLabel">
						<xsl:call-template name="languagetag"/>
						<xsl:value-of select="$label"/>
					</xsl:element>
					<xsl:element name="edm:begin">
						<xsl:if test="$model='DM2E' and $timegranularity='second'">
							<xsl:attribute name="rdf:datatype">
								<xsl:text>http://www.w3.org/2001/XMLSchema#dateTime</xsl:text>
							</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="$begindate"/>
					</xsl:element>
					<xsl:element name="edm:end">
						<xsl:if test="$model='DM2E' and $timegranularity='second'">
							<xsl:attribute name="rdf:datatype">
								<xsl:text>http://www.w3.org/2001/XMLSchema#dateTime</xsl:text>
							</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="$enddate"/>
					</xsl:element>
				</xsl:element>
				<xsl:element name="{$eclass}">
					<xsl:attribute name="rdf:about">
						<xsl:value-of select="$eID"/>
					</xsl:attribute>
					<xsl:element name="{$classname}">
						<xsl:attribute name="rdf:resource">
							<xsl:value-of select="$uridate"/>
						</xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{$eclass}">
					<xsl:attribute name="rdf:about">
						<xsl:value-of select="$eID"/>
					</xsl:attribute>
					<xsl:element name="{$classname}">
						<xsl:value-of select="$thekeydate"/>
					</xsl:element>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="ddbtime">
		<xsl:param name="thedate"/>
		<xsl:param name="eclass" select="'edm:Event'"/>
		<xsl:param name="eID"/>
		<xsl:variable name="ddbtimeliste"
			select="('dat00055','dat00054','dat00053','dat00052','dat00051','dat00050','dat00049','dat00048','dat00047','dat00046','dat00043','dat00040','dat00037','dat00034','dat00031','dat00028','dat00025','dat00020','dat00015','dat00004','dat00001')"/>
		<xsl:variable name="theddbtime">
			<xsl:choose>
				<xsl:when test="(string-length($thedate)=3) or (number(substring($thedate,1,1))>2)">
					<xsl:number value="number(substring($thedate,1,1))+1"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:number value="number(substring($thedate,1,2))+1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="uritime"
			select="concat('http://ddb.vocnet.org/zeitvokabular/',$ddbtimeliste[number($theddbtime)])"/>
		<xsl:element name="{$eclass}">
			<xsl:attribute name="rdf:about" select="$eID"/>
			<xsl:element name="edm:occuredAt">
				<xsl:attribute name="rdf:resource" select="$uritime"/>
			</xsl:element>
		</xsl:element>
		<xsl:element name="edm:TimeSpan">
			<xsl:attribute name="rdf:about" select="$uritime"/>
			<xsl:element name="skos:notation">
				<xsl:text>time_6</xsl:text>
				<xsl:number value="$theddbtime" format="01"/>
				<xsl:text>00</xsl:text>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template name="modsplace">
		<xsl:param name="thename" as="node()"/>
		<xsl:param name="classname"/>
		<xsl:param name="eclass" select="'edm:ProvidedCHO'"/>
		<xsl:param name="eID"/>
		<xsl:param name="rID"/>
		<xsl:param name="forceagent" as="xs:boolean" select="false()"/>
		<xsl:variable name="displayplace">
			<xsl:value-of select="normalize-unicode($thename/mods:placeTerm[@type='text'],'NFC')"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="($resources='literal') and not($forceagent)">
				<xsl:element name="{$eclass}">
					<xsl:attribute name="rdf:about" select="$eID"/>
					<xsl:element name="{$classname}">
						<xsl:call-template name="languagetag"/>
						<xsl:value-of select="$displayplace"/>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="uriplace">
					<xsl:variable name="position">
						<xsl:number select="$thename"/>
					</xsl:variable>
					<xsl:value-of
						select="concat(mets2dm2e:uripath('place',($coll-id,$rID)),$position,'_',encode-for-uri(normalize-space(translate($displayplace,' ,/&lt;&gt;','___'))))"
					/>
				</xsl:variable>
				<xsl:element name="edm:Place">
					<xsl:attribute name="rdf:about">
						<xsl:value-of select="$uriplace"/>
					</xsl:attribute>
					<xsl:element name="skos:prefLabel">
						<xsl:call-template name="languagetag"/>
						<xsl:value-of select="$displayplace"/>
					</xsl:element>
				</xsl:element>
				<xsl:element name="{$eclass}">
					<xsl:attribute name="rdf:about">
						<xsl:value-of select="$eID"/>
					</xsl:attribute>
					<xsl:element name="{$classname}">
						<xsl:attribute name="rdf:resource">
							<xsl:value-of select="$uriplace"/>
						</xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="modsagentcreateevent">
		<xsl:param name="thename" as="node()"/>
		<xsl:param name="rID"/>
		<xsl:variable name="urievent"
			select="concat(mets2dm2e:uripath('event',($coll-id,mets2dm2e:recordid(..))),'created')"/>
		<xsl:element name="edm:ProvidedCHO">
			<xsl:attribute name="rdf:about">
				<xsl:value-of select="mets2dm2e:modsid($thename/..,'item')"/>
			</xsl:attribute>
			<xsl:element name="edm:hasMet">
				<xsl:attribute name="rdf:resource" select="$urievent"/>
			</xsl:element>
		</xsl:element>
		<xsl:element name="edm:Event">
			<xsl:attribute name="rdf:about" select="$urievent"/>
			<xsl:element name="edm:hasType">
				<xsl:attribute name="rdf:resource"
					select="'http://terminology.lido-schema.org/lido00012'"/>
			</xsl:element>
		</xsl:element>
		<xsl:call-template name="modsagent">
			<xsl:with-param name="thename" select="$thename"/>
			<xsl:with-param name="classname" select="'crm:P11_had_participant'"/>
			<xsl:with-param name="eclass" select="'edm:Event'"/>
			<xsl:with-param name="eID" select="$urievent"/>
			<xsl:with-param name="rID" select="mets2dm2e:recordid($thename/..)"/>
			<xsl:with-param name="forceagent" select="true()"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="modsagent">
		<xsl:param name="thename" as="node()"/>
		<xsl:param name="classname"/>
		<xsl:param name="eclass" select="'edm:ProvidedCHO'"/>
		<xsl:param name="eID"/>
		<xsl:param name="rID"/>
		<xsl:param name="forceagent" as="xs:boolean" select="false()"/>
		<xsl:variable name="ddbsubject" select="($model='DDB') and ($classname='dc:subject')"/>
		<xsl:variable name="displayname">
			<xsl:choose>
				<xsl:when test="$thename/mods:displayForm">
					<xsl:value-of select="normalize-unicode($thename/mods:displayForm,'NFC')"/>
				</xsl:when>
				<xsl:when test="$thename/mods:namePart[not(@type)]">
					<xsl:value-of
						select="normalize-unicode($thename/mods:namePart[not(@type)][1],'NFC')"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="labelclass">
			<xsl:choose>
				<xsl:when test="$thename/@script!=$prim_script">
					<xsl:text>skos:altLabel</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>skos:prefLabel</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="agentclass">
			<xsl:choose>
				<xsl:when test="($model='DM2E') and ($thename/@type='personal')"
					>foaf:Person</xsl:when>
				<xsl:when test="($model='DM2E') and ($thename/@type='corporate')"
					>foaf:Organization</xsl:when>
				<xsl:otherwise>edm:Agent</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="gnddata">
			<xsl:if
				test="($thename/@authorityURI='http://d-nb.info/gnd/') and ($gndresources!='none')">
				<xsl:copy-of
					select="document(concat($thename/@valueURI,'/about/rdf'))/rdf:RDF/rdf:Description/*"
				/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="uri">
			<xsl:choose>
				<xsl:when test="$thename/@valueURI">
					<xsl:value-of
						select="concat(mets2dm2e:uripath('agent',concat('authority_',$thename/@authority)),encode-for-uri(substring-after($thename/@valueURI,$thename/@authorityURI)))"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="name-id">
						<xsl:choose>
							<xsl:when test="$thename/@altRepGroup">
								<xsl:value-of select="$thename/@altRepGroup"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="position">
									<xsl:number select="$thename"/>
								</xsl:variable>
								<xsl:value-of
									select="concat($position,'_',encode-for-uri(translate($displayname,' ,/&lt;&gt;','___')))"
								/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:value-of
						select="concat(mets2dm2e:uripath('agent',($coll-id,$rID)),$name-id)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="($thename/@valueURI) and ($resources!='internal')">
				<xsl:element name="{$eclass}">
					<xsl:attribute name="rdf:about">
						<xsl:value-of select="$eID"/>
					</xsl:attribute>
					<xsl:element name="{$classname}">
						<xsl:attribute name="rdf:resource">
							<xsl:value-of select="$thename/@valueURI"/>
						</xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:when test="($resources='literal') and not($forceagent)">
				<!-- and not ($thename/@script!=$prim_script) -->
				<xsl:element name="{$eclass}">
					<xsl:attribute name="rdf:about">
						<xsl:value-of select="$eID"/>
					</xsl:attribute>
					<xsl:element name="{$classname}">
						<xsl:value-of select="$displayname"/>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{$eclass}">
					<xsl:attribute name="rdf:about">
						<xsl:value-of select="$eID"/>
					</xsl:attribute>
					<xsl:element name="{$classname}">
						<xsl:attribute name="rdf:resource">
							<xsl:value-of select="$uri"/>
						</xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if
			test="($thename/@valueURI) and (($resources='external') or ($resources='literal') or $ddbsubject)">
			<xsl:element name="{$agentclass}">
				<xsl:attribute name="rdf:about">
					<xsl:value-of select="$thename/@valueURI"/>
				</xsl:attribute>
				<xsl:element name="{$labelclass}">
					<xsl:value-of select="$displayname"/>
				</xsl:element>
			</xsl:element>
		</xsl:if>
		<xsl:if
			test="($resources='internal') or (not($thename/@valueURI) and (($resources!='literal') or $forceagent or $ddbsubject))">
			<xsl:element name="{$agentclass}">
				<xsl:attribute name="rdf:about">
					<xsl:value-of select="$uri"/>
				</xsl:attribute>
				<xsl:element name="{$labelclass}">
					<xsl:if test="$thename/@script">
						<xsl:call-template name="languagetag">
							<xsl:with-param name="thelanguage"
								select="concat('und-',$thename/@script)"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:value-of select="$displayname"/>
				</xsl:element>
				<xsl:if test="$thename/@valueURI">
					<xsl:element name="owl:sameAs">
						<xsl:attribute name="rdf:resource">
							<xsl:value-of select="$thename/@valueURI"/>
						</xsl:attribute>
					</xsl:element>
					<xsl:copy-of select="$gnddata/owl:sameAs"/>
				</xsl:if>
			</xsl:element>
		</xsl:if>
		<xsl:if test="$ddbsubject">
			<xsl:element name="{$eclass}">
				<xsl:attribute name="rdf:about">
					<xsl:value-of select="$eID"/>
				</xsl:attribute>
				<xsl:element name="dcterms:subject">
					<xsl:attribute name="rdf:resource">
						<xsl:choose>
							<xsl:when test="($thename/@valueURI) and not($resources='internal')">
								<xsl:value-of select="$thename/@valueURI"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$uri"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<xsl:template name="modsconcept">
		<xsl:param name="thesubject" as="node()"/>
		<xsl:param name="PCHO" as="node()"/>
		<xsl:variable name="displaylabel">
			<xsl:value-of select="normalize-unicode($thesubject/*,'NFC')"/>
		</xsl:variable>
		<xsl:variable name="conceptclass">
			<xsl:choose>
				<xsl:when test="$thesubject/mods:geographic">edm:Place</xsl:when>
				<xsl:otherwise>skos:Concept</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="gnddata">
			<xsl:if
				test="($thesubject/*/@authorityURI='http://d-nb.info/gnd/') and ($gndresources!='none')">
				<xsl:copy-of
					select="document(concat($thesubject/*/@valueURI,'/about/rdf'))/rdf:RDF/rdf:Description/*"
				/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="conceptdata">
			<xsl:choose>
				<xsl:when test="$thesubject/mods:geographic">place</xsl:when>
				<xsl:otherwise>concept</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="conceptsameas">
			<xsl:choose>
				<xsl:when test="($model='DM2E') or ($thesubject/mods:geographic)"
					>owl:sameAs</xsl:when>
				<xsl:otherwise>skos:exactMatch</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="uri">
			<xsl:choose>
				<xsl:when test="$thesubject/*/@valueURI">
					<xsl:value-of
						select="concat(mets2dm2e:uripath($conceptdata,concat('authority_',$thesubject/*/@authority)),encode-for-uri(substring-after($thesubject/*/@valueURI,$thesubject/*/@authorityURI)))"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="position">
						<xsl:number select="$thesubject"/>
					</xsl:variable>
					<xsl:value-of
						select="concat(mets2dm2e:uripath($conceptdata,($coll-id,mets2dm2e:recordid($PCHO))),$position,'_',encode-for-uri(translate($displaylabel,' ,/&lt;&gt;','___')))"
					/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="($thesubject/*/@valueURI) and ($resources!='internal')">
				<xsl:element name="edm:ProvidedCHO">
					<xsl:attribute name="rdf:about">
						<xsl:value-of select="mets2dm2e:modsid($PCHO,'item')"/>
					</xsl:attribute>
					<xsl:element name="dc:subject">
						<xsl:attribute name="rdf:resource">
							<xsl:value-of select="$thesubject/*/@valueURI"/>
						</xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:when test="$resources='literal'">
				<xsl:element name="edm:ProvidedCHO">
					<xsl:attribute name="rdf:about">
						<xsl:value-of select="mets2dm2e:modsid($PCHO,'item')"/>
					</xsl:attribute>
					<xsl:element name="dc:subject">
						<xsl:value-of select="$displaylabel"/>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="edm:ProvidedCHO">
					<xsl:attribute name="rdf:about">
						<xsl:value-of select="mets2dm2e:modsid($PCHO,'item')"/>
					</xsl:attribute>
					<xsl:element name="dc:subject">
						<xsl:attribute name="rdf:resource">
							<xsl:value-of select="$uri"/>
						</xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if
			test="($thesubject/*/@valueURI) and (($resources='external') or ($resources='literal') or ($model='DDB'))">
			<xsl:element name="{$conceptclass}">
				<xsl:attribute name="rdf:about">
					<xsl:value-of select="$thesubject/*/@valueURI"/>
				</xsl:attribute>
				<xsl:element name="skos:prefLabel">
					<xsl:value-of select="$displaylabel"/>
				</xsl:element>
			</xsl:element>
		</xsl:if>
		<xsl:if
			test="($resources='internal') or (not($thesubject/*/@valueURI) and (($resources!='literal') or ($model='DDB')))">
			<xsl:element name="{$conceptclass}">
				<xsl:attribute name="rdf:about">
					<xsl:value-of select="$uri"/>
				</xsl:attribute>
				<xsl:element name="skos:prefLabel">
					<xsl:call-template name="languagetag"/>
					<xsl:value-of select="$displaylabel"/>
				</xsl:element>
				<xsl:if test="$thesubject/*/@valueURI">
					<xsl:element name="{$conceptsameas}">
						<xsl:attribute name="rdf:resource">
							<xsl:value-of select="$thesubject/*/@valueURI"/>
						</xsl:attribute>
					</xsl:element>
					<xsl:for-each select="$gnddata/owl:sameAs">
						<xsl:element name="{$conceptsameas}">
							<xsl:attribute name="rdf:resource">
								<xsl:value-of select="$gnddata/owl:sameAs/@rdf:resource"/>
							</xsl:attribute>
						</xsl:element>
					</xsl:for-each>
				</xsl:if>
			</xsl:element>
		</xsl:if>
		<xsl:if test="$model='DDB'">
			<xsl:element name="edm:ProvidedCHO">
				<xsl:attribute name="rdf:about">
					<xsl:value-of select="mets2dm2e:modsid($PCHO,'item')"/>
				</xsl:attribute>
				<xsl:element name="dcterms:subject">
					<xsl:attribute name="rdf:resource">
						<xsl:choose>
							<xsl:when
								test="($thesubject/*/@valueURI) and not($resources='internal')">
								<xsl:value-of select="$thesubject/*/@valueURI"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$uri"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<xsl:template name="languagetag">
		<xsl:param name="thelanguage"/>
		<xsl:attribute name="xml:lang">
			<xsl:choose>
				<xsl:when test="string-length($thelanguage)>0">
					<xsl:value-of select="mets2dm2e:rfclanguage($thelanguage)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$metalanguage"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<!-- functions -->

	<xsl:function name="mets2dm2e:uripath">
		<xsl:param name="thetype"/>
		<xsl:param name="thenext" as="xs:string*"/>
		<xsl:choose>
			<xsl:when test="$uri='local'">
				<xsl:value-of
					select="concat('#',$prov-id,':',string-join(insert-before($thenext,0,$thetype),':'),':')"
				/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of
					select="concat($root,'/',$thetype,'/',string-join(insert-before($thenext,0,$prov-id),'/'),'/')"
				/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

	<xsl:function name="mets2dm2e:recordid">
		<xsl:param name="themodspart" as="node()"/>
		<xsl:choose>
			<xsl:when test="$id_type='mods'">
				<xsl:value-of select="$themodspart/mods:recordInfo/mods:recordIdentifier"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of
					select="translate(replace($themodspart/mods:identifier[@type=$id_type][1],'://','_'),'.','_')"
				/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

	<xsl:function name="mets2dm2e:modsid">
		<xsl:param name="themodspart" as="node()"/>
		<xsl:param name="thetype"/>
		<xsl:value-of
			select="concat(mets2dm2e:uripath($thetype,$coll-id),mets2dm2e:recordid($themodspart))"/>
	</xsl:function>

	<xsl:function name="mets2dm2e:metsid">
		<xsl:param name="themodspart" as="node()"/>
		<xsl:param name="thetype"/>
		<xsl:param name="thepage"/>
		<xsl:value-of select="concat(mets2dm2e:modsid($themodspart,$thetype),'_',$thepage/@ID)"/>
	</xsl:function>

	<xsl:function name="mets2dm2e:rfclanguage">
		<xsl:param name="language"/>
		<xsl:variable name="script">
			<xsl:value-of select="substring-after($language,'-')"/>
		</xsl:variable>
		<xsl:variable name="rfclang">
			<xsl:variable name="lang">
				<xsl:choose>
					<xsl:when test="contains($language,'-')">
						<xsl:value-of select="substring-before($language,'-')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$language"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:choose>
				<xsl:when
					test="exists(index-of(('amh','ara','cat','dan','eng','fra','fre','heb','hun',
				'ita','lat','nor','rus','ukr','yid'),$lang))">
					<xsl:value-of select="substring($lang,1,2)"/>
				</xsl:when>
				<xsl:when test="$lang='ces' or $lang='cze'">
					<xsl:text>cs</xsl:text>
				</xsl:when>
				<xsl:when test="$lang='ger' or $lang='deu'">
					<xsl:text>de</xsl:text>
				</xsl:when>
				<xsl:when test="$lang='nld' or $lang='dut'">
					<xsl:text>nl</xsl:text>
				</xsl:when>
				<xsl:when test="$lang='ell' or $lang='gre'">
					<xsl:text>el</xsl:text>
				</xsl:when>
				<xsl:when test="$lang='spa'">
					<xsl:text>es</xsl:text>
				</xsl:when>
				<xsl:when test="$lang='per' or $lang='fas'">
					<xsl:text>fa</xsl:text>
				</xsl:when>
				<xsl:when test="$lang='pol'">
					<xsl:text>pl</xsl:text>
				</xsl:when>
				<xsl:when test="$lang='por'">
					<xsl:text>pt</xsl:text>
				</xsl:when>
				<xsl:when test="$lang='swe'">
					<xsl:text>sv</xsl:text>
				</xsl:when>
				<xsl:when test="$lang='tur'">
					<xsl:text>tr</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$lang"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="string-length($script)>0">
				<xsl:value-of select="concat($rfclang,'-',$script)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$rfclang"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

</xsl:stylesheet>
