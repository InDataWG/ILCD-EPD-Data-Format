<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:edoc="http://www.iai.fzk.de/lca/edoc" xmlns:process="http://lca.jrc.it/ILCD/Process"
    xmlns:lciamethod="http://lca.jrc.it/ILCD/LCIAMethod" xmlns:flow="http://lca.jrc.it/ILCD/Flow" xmlns:flowproperty="http://lca.jrc.it/ILCD/FlowProperty"
    xmlns:unitgroup="http://lca.jrc.it/ILCD/UnitGroup" xmlns:source="http://lca.jrc.it/ILCD/Source" xmlns:contact="http://lca.jrc.it/ILCD/Contact"
    xmlns:common="http://lca.jrc.it/ILCD/Common" xmlns:epd0="http://www.pe-international.com/EPD/2007" xmlns:epd="http://www.iai.kit.edu/EPD/2013"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xml="http://www.w3.org/XML/1998/namespace" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="xs xsi edoc process source contact flow flowproperty lciamethod unitgroup epd epd0 common">

    <xsl:include href="migrate-util.xsl"/>

    <xsl:strip-space elements="*"/>

    <xsl:output indent="yes" method="xml"/>

    <xsl:param name="sourceFilesMigratedUUID" select="'../../oekobaudat_en_migrated_uuid'"/>

    <xsl:variable name="currentFileName" select="document-uri(/)"/>

    <xsl:variable name="uuid" select="/*/*/*[local-name()='dataSetInformation']/common:UUID/text()"/>

    <xsl:variable name="lang_mapping_processes" select="document('oekobaudat_en_mapping.xml')"/>

    <xsl:variable name="lang_mapping_products" select="document('oekobaudat_en_mapping_products.xml')"/>
    
    <xsl:variable name="indicators" select="document('oekobaudat_indicators.xml')"/>

    <xsl:variable name="specialMapping">
        <xsl:choose>
            <xsl:when test="count($lang_mapping_products/entries/entry[@obd=lower-case($uuid)])>0">
                <xsl:value-of select="true()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="dsType">
        <xsl:choose>
            <xsl:when test="local-name(/*)='processDataSet'">
                <xsl:text>processes</xsl:text>
            </xsl:when>
            <xsl:when test="local-name(/*)='flowDataSet'">
                <xsl:text>flows</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">Invalid dataset with root element <xsl:value-of select="name(/*)"/></xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="enDatasetUUID">
        <xsl:choose>
            <xsl:when test="$dsType='processes'">
                <!-- for processes, use mapping file -->
                <xsl:value-of select="($lang_mapping_processes/entries/entry[@obd=lower-case($uuid)])[1]/@gabien"/>
            </xsl:when>
            <xsl:when test="$dsType='flows'">
                <!-- for flows, look in the mapping file, if not found there, look if a corresponding dataset is present -->
                <xsl:variable name="mappedFlowUUID" select="($lang_mapping_products/entries/entry[@obd=lower-case($uuid)])[1]/@gabien"/>
                <xsl:message>===<xsl:value-of select="$mappedFlowUUID"></xsl:value-of>===</xsl:message>
                <xsl:choose>
                    <xsl:when test="string($mappedFlowUUID)=''">
                        <xsl:value-of select="$uuid"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>*********</xsl:message>
                        <xsl:value-of select="$mappedFlowUUID"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">ERROR: illegal ds type</xsl:message>                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable> 
        
        
    
    <xsl:variable name="enDatasetURI" select="concat($sourceFilesMigratedUUID, '/', $dsType, '/', $enDatasetUUID, '.xml')"/>



    <!--    <xsl:template match="processing-instruction()|comment()">
        <xsl:text>
</xsl:text>
        <xsl:copy/>
    </xsl:template>
-->
    <xsl:template match="/">
        <xsl:message> <xsl:value-of select="$uuid"></xsl:value-of>    #### <xsl:value-of select="$enDatasetURI"></xsl:value-of></xsl:message>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- copy -->
    <xsl:template match="process:processDataSet">
        <xsl:copy>
            <xsl:apply-templates select="@*|*"/>
        </xsl:copy>

        <xsl:variable name="enDatasetURI" select="concat($sourceFilesMigratedUUID, '/', $dsType, '/', $enDatasetUUID, '.xml')"/>

        <xsl:variable name="enDatasetRefFlowInternalID"
            select="(document($enDatasetURI, /))/process:processDataSet/process:processInformation/process:quantitativeReference/process:referenceToReferenceFlow/text()"/>


        <xsl:variable name="enDatasetRefFlowUUID"
            select="(document($enDatasetURI, /))/process:processDataSet/process:exchanges/process:exchange[@dataSetInternalID=$enDatasetRefFlowInternalID]/process:referenceToFlowDataSet/@refObjectId"/>

        <xsl:variable name="deDataSetRefFlowUUID"
            select="process:exchanges/process:exchange[@dataSetInternalID=/process:processDataSet/process:processInformation/process:quantitativeReference/process:referenceToReferenceFlow/text()]/process:referenceToFlowDataSet/@refObjectId"/>

        <xsl:if test="$deDataSetRefFlowUUID!=$enDatasetRefFlowUUID">
            <xsl:message>OBD <xsl:value-of select="$deDataSetRefFlowUUID"/> EN <xsl:value-of select="$enDatasetRefFlowUUID"/></xsl:message>
        </xsl:if>
    </xsl:template>

    <xsl:template match="flow:flowDataSet[flow:modellingAndValidation/flow:LCIMethod/flow:typeOfDataSet='Product flow']">
        <xsl:copy>
            <xsl:apply-templates select="@*|*"/>
        </xsl:copy>
    </xsl:template>

    <!-- ignore non-products -->
    <xsl:template match="flow:flowDataSet[flow:modellingAndValidation/flow:LCIMethod/flow:typeOfDataSet!='Product flow']"/>
    
    

    <!--    <xsl:template match="process:exchanges|process:LCIAResults"> </xsl:template>-->

    <!-- insert en data after de data -->
    <xsl:template match="*[not(ancestor::process:exchanges) and not(ancestor::process:LCIAResults) and @xml:lang='de']">
        <xsl:element name="{name()}" namespace="{namespace-uri()}">
            <!-- go process attributes and children -->
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
        <!-- look for en candidates and if any copy them -->
        <xsl:if
            test="not(preceding-sibling::*[local-name()=local-name(current()) and @xml:lang='en']) and not(following-sibling::*[local-name()=local-name(current()) and @xml:lang='en'])">
            <!--            <xsl:message>
                <xsl:value-of select="name()"/>
            </xsl:message>
-->
            <xsl:call-template name="mergeEnData"/>
        </xsl:if>
    </xsl:template>

    <!-- insert en data after de data for exchanges/LCIAResults using descriptions in mapping file-->
    <xsl:template match="*[(ancestor::process:exchanges or ancestor::process:LCIAResults) and @xml:lang='de']">
        <xsl:element name="{name()}" namespace="{namespace-uri()}">
            <!-- go process attributes and children -->
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
        <!-- look for en candidates and copy them -->
        <xsl:variable name="parentRefObjectId" select="parent::*/@refObjectId"/>

        <xsl:variable name="enData">
            <xsl:if
                test="not(preceding-sibling::*[local-name()=local-name(current()) and @xml:lang='en']) and not(following-sibling::*[local-name()=local-name(current()) and @xml:lang='en'])">
                <xsl:value-of select="($indicators/indicators/*/*/*/*[parent::*/@refObjectId=$parentRefObjectId and @xml:lang='en'])[1]/text()"/>
            </xsl:if>
        </xsl:variable>
        <xsl:if test="$enData!=''">
            <xsl:element name="{name()}" namespace="{namespace-uri()}">
                <xsl:attribute name="xml:lang" select="'en'"/>
                <xsl:value-of select="$enData"/>
            </xsl:element>
        </xsl:if>

    </xsl:template>


    <!-- override en data for products flows where a special name is defined in mapping file-->
    <xsl:template match="flow:baseName[@xml:lang='de' and $specialMapping='true']" priority="50">
        <xsl:element name="{name()}" namespace="{namespace-uri()}">
            <!-- go process attributes and children -->
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
        
        <xsl:variable name="enData">
            <xsl:value-of select="($lang_mapping_products/entries/entry[@obd=lower-case($uuid)])[1]/@nameen"/>
        </xsl:variable>
        <xsl:if test="$enData!=''">
            <xsl:element name="{name()}" namespace="{namespace-uri()}">
                <xsl:attribute name="xml:lang" select="'en'"/>
                <xsl:value-of select="$enData"/>
            </xsl:element>
        </xsl:if>
        
    </xsl:template>
    



    <xsl:template name="mergeEnData">

        <xsl:variable name="currentElement" select="local-name()"/>
        <xsl:variable name="parentElement" select="local-name(parent::*)"/>
        <xsl:variable name="parentRefObjectId" select="parent::*/@refObjectId"/>

        <xsl:variable name="enData">
            <xsl:choose>
                <xsl:when test="parent::*/@refObjectId">
                    <!-- check parent refobjectid -->
                    <xsl:value-of
                        select="(document($enDatasetURI, /)//*[local-name()=$currentElement and local-name(parent::*)=$parentElement and parent::*/@refObjectId=$parentRefObjectId][@xml:lang='en'])[1]/text()"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="(document($enDatasetURI, /)//*[local-name()=$currentElement and local-name(parent::*)=$parentElement][@xml:lang='en'])[1]/text()"/>
                </xsl:otherwise>
            </xsl:choose>

        </xsl:variable>

        <!--        <xsl:message>
            <xsl:value-of select="concat($currentElement, ' ', $parentElement, ' ', ' ',  ' ', ($enData!=''))"/>
        </xsl:message>
-->
        <xsl:if test="$enData!=''">
            <xsl:element name="{name()}" namespace="{namespace-uri()}">
                <xsl:attribute name="xml:lang" select="'en'"/>
                <xsl:value-of select="$enData"/>
            </xsl:element>
        </xsl:if>

    </xsl:template>

    <xsl:template match="*">
        <xsl:element name="{name()}" namespace="{namespace-uri()}">
            <!-- go process attributes and children -->
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>

    <!-- fix generalComment w/o @xml:lang -->
    <xsl:template match="*[local-name()='generalComment']" priority="50">
        <xsl:element name="{name()}" namespace="{namespace-uri()}">
            <!-- go process attributes and children -->
            <xsl:if test="not(@xml:lang)">
                <xsl:attribute name="xml:lang" select="'de'"/>
            </xsl:if>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
        <xsl:call-template name="mergeEnData"/>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:copy-of select="."/>
    </xsl:template>




    <!-- increment version number -->
    <xsl:template match="*[local-name()='publicationAndOwnership']">

        <xsl:element name="{name()}" namespace="{namespace-uri()}">
            <common:dataSetVersion>
                <xsl:call-template name="incrementVersionNumber">
                    <xsl:with-param name="version" select="common:dataSetVersion/text()"/>
                </xsl:call-template>
            </common:dataSetVersion>
            <xsl:apply-templates select="*[local-name()!='dataSetVersion']"/>
        </xsl:element>
    </xsl:template>




</xsl:stylesheet>
