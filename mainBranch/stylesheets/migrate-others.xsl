<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:edoc="http://www.iai.fzk.de/lca/edoc" xmlns:process="http://lca.jrc.it/ILCD/Process"
    xmlns:lciamethod="http://lca.jrc.it/ILCD/LCIAMethod" xmlns:flow="http://lca.jrc.it/ILCD/Flow" xmlns:fp="http://lca.jrc.it/ILCD/FlowProperty"
    xmlns:unitgroup="http://lca.jrc.it/ILCD/UnitGroup" xmlns:source="http://lca.jrc.it/ILCD/Source" xmlns:contact="http://lca.jrc.it/ILCD/Contact"
    xmlns:common="http://lca.jrc.it/ILCD/Common" xmlns:epd0="http://www.pe-international.com/EPD/2007" xmlns:epd="http://www.iai.kit.edu/EPD/2013"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xml="http://www.w3.org/XML/1998/namespace" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:saxon="http://saxon.sf.net/" xmlns:random="http://exslt.org/random"
    exclude-result-prefixes="random xs xsi edoc process source contact flow fp lciamethod unitgroup epd0 saxon epd">

    <xsl:include href="migrate-include-flow.xsl"/>
    <xsl:include href="migrate-include-lciamethod.xsl"/>
    <xsl:include href="migrate-util.xsl"/>
    
    <xsl:param name="indexFile"/>
    
    <xsl:variable name="cat_mapping" select="document('oekobaudat_categories.xml')"/>
    
    <xsl:variable name="productIndex" select="document($indexFile)"/>
    
    <xsl:strip-space elements="*"/>

    <xsl:output indent="yes" method="xml" saxon:line-length="1000"/>

    <xsl:variable name="currentFileName" select="document-uri(/)"/>

    <xsl:variable name="PROCESS" select="'processDataSet'"/>
    <xsl:variable name="FLOW" select="'flowDataSet'"/>
    <xsl:variable name="FLOWPROPERTY" select="'flowPropertyDataSet'"/>
    <xsl:variable name="UNITGROUP" select="'unitGroupDataSet'"/>
    <xsl:variable name="SOURCE" select="'sourceDataSet'"/>
    <xsl:variable name="CONTACT" select="'contactDataSet'"/>
    <xsl:variable name="LCIAMETHOD" select="'LCIAMethodDataSet'"/>

    <!--    <xsl:template match="processing-instruction()|comment()">
        <xsl:text>
</xsl:text>
        <xsl:copy/>
    </xsl:template>
-->
    <xsl:template match="/">
        <xsl:param name="rootElement" select="local-name(/*)"/>

        <xsl:variable name="dstype">
            <xsl:choose>
                <xsl:when test="string($rootElement)=string($PROCESS)">
                    <xsl:value-of select="'epd'"/>
                </xsl:when>
                <xsl:when test="string($rootElement)=string($LCIAMETHOD)">
                    <xsl:value-of select="'lciamethod'"/>
                </xsl:when>
                <xsl:when test="string($rootElement)=string($FLOW)">
                    <xsl:value-of select="'flow'"/>
                </xsl:when>
                <xsl:when test="string($rootElement)=string($FLOWPROPERTY)">
                    <xsl:value-of select="'flowproperty'"/>
                </xsl:when>
                <xsl:when test="string($rootElement)=string($UNITGROUP)">
                    <xsl:value-of select="'unitgroup'"/>
                </xsl:when>
                <xsl:when test="string($rootElement)=string($CONTACT)">
                    <xsl:value-of select="'contact'"/>
                </xsl:when>
                <xsl:when test="string($rootElement)=string($SOURCE)">
                    <xsl:value-of select="'source'"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="http://iai-uiserv1.iai.kit.edu/EPD/stylesheets/<xsl:value-of select="$dstype"
            />2html.xsl"</xsl:processing-instruction>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- copy -->
    <xsl:template match="fp:flowPropertyDataSet">

        <xsl:variable name="uuid" select="fp:flowPropertiesInformation/fp:dataSetInformation/common:UUID"/>

        <xsl:variable name="LCIIndicator" select="document('oekobaudat_indicators.xml')/indicators/LCIIndicators/*/*[@refObjectId=$uuid]"/>
        <xsl:variable name="LCIAIndicator" select="document('oekobaudat_indicators.xml')/indicators/LCIAIndicators/*/*[@refObjectId=$uuid]"/>


        <xsl:choose>
            <xsl:when test="contains($currentFileName, '/flows/')">
                <!-- Kraut-und-Rüben-Filter: FlowProperties aus flows-Ordner weglassen -->
            </xsl:when>

            <xsl:when test="$LCIIndicator!=''">
                <!-- generiere Flow-Datensatz -->
                <xsl:variable name="targetDoc" select="concat('../flows/', $uuid, '_', current-time(), '.xml')"/>
                <xsl:if test="not(doc-available($targetDoc))">
                    <xsl:result-document href="{$targetDoc}" method="xml">
                        <xsl:call-template name="renderflow">
                            <xsl:with-param name="name" select="$LCIIndicator"/>
                            <xsl:with-param name="uuid" select="$uuid"/>
                            <xsl:with-param name="comment" select="fp:flowPropertiesInformation/fp:dataSetInformation/common:generalComment"/>
                        </xsl:call-template>
                    </xsl:result-document>
                </xsl:if>
            </xsl:when>

            <xsl:when test="$LCIAIndicator!=''">
                <!-- generiere LCIA-Method-Datensatz -->
                <xsl:variable name="targetDoc" select="concat('../lciamethods/', $uuid,  '_', current-time(),'.xml')"/>
                <xsl:if test="not(doc-available($targetDoc))">
                    <xsl:result-document href="{$targetDoc}" method="xml">
                        <xsl:call-template name="renderlciamethod">
                            <xsl:with-param name="name" select="$LCIAIndicator"/>
                            <xsl:with-param name="uuid" select="$uuid"/>
                            <xsl:with-param name="comment" select="fp:flowPropertiesInformation/fp:dataSetInformation/common:generalComment"/>
                        </xsl:call-template>
                    </xsl:result-document>
                </xsl:if>

            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>


    <xsl:template match="*[local-name()='dataEntryBy']">
        <xsl:element name="{name()}" namespace="{namespace-uri()}">
            <common:timeStamp>
                <xsl:value-of select="current-dateTime()"/>
            </common:timeStamp>
            <common:referenceToDataSetFormat refObjectId="a97a0155-0234-4b87-b4ce-a45da52f2a40" type="source data set"
                uri="../sources/ILCD_Format_a97a0155-0234-4b87-b4ce-a45da52f2a40.xml">
                <common:shortDescription xml:lang="de">ILCD format 1.1</common:shortDescription>
            </common:referenceToDataSetFormat>
<!--            <xsl:if test="/flow:flowDataSet/flow:modellingAndValidation/flow:LCIMethod/flow:typeOfDataSet='Product flow'">
            <common:referenceToDataSetFormat type="source data set" refObjectId="cba73800-7874-11e3-981f-0800200c9a66" uri="../sources/cba73800-7874-11e3-981f-0800200c9a66.xml">
                <common:shortDescription xml:lang="en">EPD Data Format Extensions</common:shortDescription>
                <common:shortDescription xml:lang="de">EPD-Datenformaterweiterungen</common:shortDescription>
            </common:referenceToDataSetFormat>
            </xsl:if>
-->            <xsl:apply-templates select="*[local-name()!='timeStamp' and local-name()!='referenceToDataSetFormat']"/>
        </xsl:element>
    </xsl:template>


    <!-- add product classification -->
    <xsl:template match="flow:flowDataSet[flow:modellingAndValidation/flow:LCIMethod/flow:typeOfDataSet='Product flow']/flow:flowInformation/flow:dataSetInformation/flow:classificationInformation" priority="100">
        <xsl:variable name="productId" select="/flow:flowDataSet/flow:flowInformation/flow:dataSetInformation/common:UUID/text()"/>
        
        <xsl:message terminate="no">INFO: Found product flow with id <xsl:value-of select="$productId"/>, found <xsl:value-of select="count($productIndex/index/entry[@productId=$productId])"/> matches in index</xsl:message>
    
        <xsl:message terminate="no">INFO: copying <xsl:value-of select="count($productIndex/index/entry[@productId=$productId][1]/*)"></xsl:value-of> </xsl:message>

        <xsl:if test="count($productIndex/index/entry[@productId=$productId])=0">
            
            <xsl:message terminate="no">INFO: no category mapping found for product flow "<xsl:value-of select="/flow:flowDataSet/flow:flowInformation/flow:dataSetInformation/flow:name/flow:baseName/text()"/>" (<xsl:value-of select="$productId"/>) </xsl:message>
            
        </xsl:if>

        <xsl:element name="classificationInformation" namespace="http://lca.jrc.it/ILCD/Flow">
            <xsl:copy-of select="$productIndex/index/entry[@productId=$productId][1]/*" exclude-result-prefixes="#all"/>
        </xsl:element>
    </xsl:template>

    <!-- remove compliance -->
    <xsl:template match="*[local-name()='complianceDeclarations']"/>


    <xsl:template match="*">
        <xsl:copy>
            <!--            <xsl:element name="{name()}" namespace="{namespace-uri()}">-->
            <!-- go process attributes and children -->
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:copy-of select="."/>
    </xsl:template>

    <!-- entferne Version-Suffixe von URIs -->
    <xsl:template match="@uri">
        <xsl:choose>
            <xsl:when test="starts-with(., '../')">
                <xsl:attribute name="uri">
                    <xsl:analyze-string select="." regex="(.*)_(.*)(\.xml)">
                        <xsl:matching-substring>
                            <xsl:value-of select="concat(regex-group(1),regex-group(3))"/>
                        </xsl:matching-substring>
                        <xsl:non-matching-substring>
                            <xsl:value-of select="."/>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- entferne versions-Attribute von Objektverweisen -->
    <xsl:template match="@version[parent::*[@refObjectId]]"/>



</xsl:stylesheet>
