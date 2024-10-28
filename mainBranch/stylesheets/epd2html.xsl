<?xml version="1.0" encoding="UTF-8"?>
<!-- @version-tag-EPD@ -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:process="http://lca.jrc.it/ILCD/Process"
    xmlns:common="http://lca.jrc.it/ILCD/Common" xmlns:epd="http://www.iai.kit.edu/EPD/2013" xmlns:exslt="http://exslt.org/common" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    exclude-result-prefixes="xsl xs process common">

    <xsl:import href="process2html.xsl"/>

    <!-- use this parameter to define which fields are to be displayed. Allowed values: mandatory, recommended, all -->
    <xsl:param name="showFieldsMode">all</xsl:param>

    <!-- default language for which language codes are not displayed -->
    <xsl:param name="defaultLanguage" select="'de'"/>

    <!-- alternative language to fall back to if no data is available for the default language specified above -->
    <xsl:param name="alternativeLanguage" select="'en'"/>

    <!-- EPD customizations -->

    <xsl:param name="roundReferenceFlowAmount" select="'true'"/>

    <msxsl:script language="JScript" implements-prefix="exslt"> this['node-set'] = function (x) { return x; } </msxsl:script>

    <!-- captions -->
    <xsl:variable name="caption.contents">
        <xsl:choose>
            <xsl:when test="$defaultLanguage='de'">
                <xsl:text> Inhalt: </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> Contents: </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="caption.environmentalIndicators">
        <xsl:choose>
            <xsl:when test="$defaultLanguage='de'">
                <xsl:text>Umweltindikatoren</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Environmental indicators</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="caption.indicators">
        <xsl:choose>
            <xsl:when test="$defaultLanguage='de'">
                <xsl:text>Indikatoren</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Indicators</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="caption.indicator">
        <xsl:choose>
            <xsl:when test="$defaultLanguage='de'">
                <xsl:text>Indikator</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Indicator</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="caption.LCIIndicators">
        <xsl:choose>
            <xsl:when test="$defaultLanguage='de'">
                <xsl:text>Parameter zur Beschreibung des Ressourceneinsatzes und sonstige Umweltinformationen</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>LCI indicators </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="caption.LCIAIndicators">
        <xsl:choose>
            <xsl:when test="$defaultLanguage='de'">
                <xsl:text>Parameter zur Beschreibung der Umweltwirkungen</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>LCIA indicators </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="caption.inputs">
        <xsl:text>Inputs</xsl:text>
    </xsl:variable>

    <xsl:variable name="caption.outputs">
        <xsl:text>Outputs</xsl:text>
    </xsl:variable>

    <xsl:variable name="caption.direction">
        <xsl:choose>
            <xsl:when test="$defaultLanguage='de'">
                <xsl:text>Richtung</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Direction</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="caption.value">
        <xsl:choose>
            <xsl:when test="$defaultLanguage='de'">
                <xsl:text>Wert</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Value</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="caption.unit">
        <xsl:choose>
            <xsl:when test="$defaultLanguage='de'">
                <xsl:text>Einheit</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Unit</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="caption.amount">
        <xsl:choose>
            <xsl:when test="$defaultLanguage='de'">
                <xsl:text>Menge</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Amount</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="caption.fractions">
        <xsl:choose>
            <xsl:when test="$defaultLanguage='de'">
                <xsl:text>Anteile</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Fractions</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="caption.referenceFlow">
        <xsl:choose>
            <xsl:when test="$defaultLanguage='de'">
                <xsl:text>Referenzfluss (Flussdatensatz)</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Reference flow (flow data set)</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="caption.yes">
        <xsl:choose>
            <xsl:when test="$defaultLanguage='de'">
                <xsl:text>Ja</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Yes</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="caption.no">
        <xsl:choose>
            <xsl:when test="$defaultLanguage='de'">
                <xsl:text>Nein</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>No</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="caption.safetyMargins">
        <xsl:choose>
            <xsl:when test="$defaultLanguage='de'">
                <xsl:text>Enthaltene Sicherheitszuschläge</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Safety margins</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="caption.safetyMarginsDescription">
        <xsl:choose>
            <xsl:when test="$defaultLanguage='de'">
                <xsl:text>Begründung</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Description</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="caption.classId">
        <xsl:choose>
            <xsl:when test="$defaultLanguage='de'">
                <xsl:text>Gliederungsnummer</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Class ID</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="caption.scenarios">
        <xsl:choose>
            <xsl:when test="$defaultLanguage='de'">
                <xsl:text>Szenarien</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Scenarios</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="caption.scenario">
        <xsl:choose>
            <xsl:when test="$defaultLanguage='de'">
                <xsl:text>Szenario</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Scenario</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="caption.scenario.group">
        <xsl:choose>
            <xsl:when test="$defaultLanguage='de'">
                <xsl:text>Gruppe</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>group</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="caption.scenario.default">
        <xsl:choose>
            <xsl:when test="$defaultLanguage='de'">
                <xsl:text>(Standard)</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>(default)</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    

    <!-- adjust type of dataset -->
    <xsl:template match="process:modellingAndValidation/process:LCIMethodAndAllocation/process:typeOfDataSet/text()" priority="100">
        <xsl:value-of select="'EPD Dataset'"/>
    </xsl:template>

    <!-- build table of contents -->
    <xsl:template name="makeToc">
        <tr>
            <td class="toc" colspan="2">
                <xsl:value-of select="$caption.contents"/>
                <xsl:for-each select="/*/*[local-name()!='exchanges' and local-name()!='administrativeInformation']">
                    <xsl:choose>
                        <xsl:when test="position()!=last()">
                            <xsl:variable name="fieldShortDesc">
                                <xsl:call-template name="getFieldShortDesc">
                                    <xsl:with-param name="fieldName" select="local-name()"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <a href="#{local-name()}">
                                <xsl:value-of select="$fieldShortDesc"/>
                            </a>
                            <xsl:text>  -  </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <a href="#{$caption.environmentalIndicators}">
                                <xsl:value-of select="$caption.environmentalIndicators"/>
                            </a>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </td>
        </tr>
    </xsl:template>


    <!-- subsection datasetInformation -->
    <xsl:template match="/*/*/process:dataSetInformation" priority="10">
        <xsl:variable name="fieldShortDesc">
            <xsl:call-template name="getFieldShortDesc">
                <xsl:with-param name="fieldName" select="local-name()"/>
            </xsl:call-template>
        </xsl:variable>
        <tr>
            <td class="subsection" colspan="2" style="padding-left: 20px;">
                <xsl:value-of select="$fieldShortDesc"/>
            </td>
        </tr>
        <xsl:apply-templates select="../process:geography/process:locationOfOperationSupplyOrProduction" mode="override"/>
        <xsl:apply-templates select="../process:time/common:referenceYear" mode="override"/>
        <xsl:apply-templates select="process:name"/>
        <xsl:apply-templates select="process:identifierOfSubDataSet"/>
        <xsl:apply-templates select="../process:technology/process:technologicalApplicability" mode="override"/>
        <xsl:apply-templates select="process:functionalUnitFlowProperties"/>
        <xsl:apply-templates select="common:synonyms"/>
        <xsl:apply-templates
            select="/process:processDataSet/process:exchanges/process:exchange[@dataSetInternalID=/process:processDataSet/process:processInformation/process:quantitativeReference/process:referenceToReferenceFlow/text()]/process:referenceToFlowDataSet"/>

        <xsl:call-template name="masterTemplate">
            <xsl:with-param name="currentName" select="local-name()"/>
            <xsl:with-param name="applyTemplates" select="false()"/>
            <xsl:with-param name="omitIfEmpty" select="false()"/>
            <xsl:with-param name="disableDescendantCount" select="false()"/>
            <xsl:with-param name="copy" select="true()"/>
            <xsl:with-param name="fieldShortDesc" select="$caption.amount"/>
            <xsl:with-param name="paddingleft" select="30"/>
            <xsl:with-param name="data">
                <xsl:call-template name="styleNumber">
                    <xsl:with-param name="number"
                        select="/process:processDataSet/process:exchanges/process:exchange[@dataSetInternalID=/process:processDataSet/process:processInformation/process:quantitativeReference/process:referenceToReferenceFlow/text()]/process:meanAmount"/>
                    <xsl:with-param name="round" select="$roundReferenceFlowAmount"/>
                    <xsl:with-param name="precision"
                        select="string-length(substring-before(/process:processDataSet/process:exchanges/process:exchange[@dataSetInternalID=/process:processDataSet/process:processInformation/process:quantitativeReference/process:referenceToReferenceFlow/text()]/process:meanAmount, '.'))+1"
                    />
                </xsl:call-template>
                <!-- show unit -->
                <xsl:text> </xsl:text>
                <xsl:call-template name="getUnitGroupAndFlowProperty">
                    <xsl:with-param name="flowDatasetURI" select="/*/process:exchanges/process:exchange/process:referenceToFlowDataSet/@uri"/>
                </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates select="../../process:modellingAndValidation/process:dataSourcesTreatmentAndRepresentativeness/process:useAdviceForDataSet" mode="overrideHighlight"/>
        <xsl:call-template name="masterTemplate">
            <xsl:with-param name="applyTemplates" select="false()"/>
            <xsl:with-param name="fieldShortDesc" select="$caption.classId"/>
            <xsl:with-param name="paddingleft" select="30"/>
            <xsl:with-param name="data">
                <xsl:value-of select="process:classificationInformation/common:classification[@name='oekobau.dat']/common:class[last()]/@classId"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates select="process:classificationInformation"/>

        <tr>
            <td/>
            <td class="data">
                <table class="data">
                    <tr>
                        <td valign="bottom">
                            <xsl:call-template name="rowMasterTemplate">
                                <xsl:with-param name="omitIfEmpty" select="false()"/>
                                <xsl:with-param name="displayFieldName" select="false()"/>
                                <xsl:with-param name="copy" select="true()"/>
                                <xsl:with-param name="data">
                                    <xsl:apply-templates select="/process:processDataSet/process:administrativeInformation/process:publicationAndOwnership/common:copyright"
                                        mode="override"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </td>
                        <td valign="bottom">
                            <xsl:call-template name="rowMasterTemplate">
                                <xsl:with-param name="omitIfEmpty" select="false()"/>
                                <xsl:with-param name="displayFieldName" select="false()"/>
                                <xsl:with-param name="copy" select="true()"/>
                                <xsl:with-param name="data">
                                    <xsl:apply-templates
                                        select="/process:processDataSet/process:administrativeInformation/process:publicationAndOwnership/common:referenceToOwnershipOfDataSet"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </td>
                        <td valign="bottom">
                            <xsl:call-template name="rowMasterTemplate">
                                <xsl:with-param name="omitIfEmpty" select="false()"/>
                                <xsl:with-param name="displayFieldName" select="false()"/>
                                <xsl:with-param name="copy" select="true()"/>
                                <xsl:with-param name="data">
                                    <xsl:apply-templates select="process:referenceToExternalDocumentation"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <xsl:apply-templates select="common:generalComment"/>
        <xsl:apply-templates select="common:other/*[namespace-uri()='http://www.iai.kit.edu/EPD/2013']"/>
    </xsl:template>



    <xsl:template match="common:copyright" mode="override" priority="20">
        <xsl:call-template name="masterTemplate">
            <xsl:with-param name="applyTemplates" select="false()"/>
            <xsl:with-param name="omitIfEmpty" select="true()"/>
            <xsl:with-param name="copy" select="true()"/>
            <xsl:with-param name="data">
                <xsl:choose>
                    <xsl:when test=".='true' or .='1'">
                        <xsl:value-of select="$caption.yes"/>
                    </xsl:when>
                    <xsl:when test=".='false' or .='0'">
                        <xsl:value-of select="$caption.no"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>


    <xsl:template match="process:LCIMethodAndAllocation/common:other/epd:subType" priority="1000">
        <xsl:call-template name="masterTemplate">
            <xsl:with-param name="fieldShortDesc">Subtyp</xsl:with-param>
            <xsl:with-param name="applyTemplates" select="'true'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="process:LCIMethodAndAllocation" priority="1000">
        <xsl:apply-templates/>
        <xsl:apply-templates select="common:other/epd:subType"/>
    </xsl:template>


    <xsl:key name="exchange-modules" match="/process:processDataSet/process:exchanges/process:exchange/common:other/epd:amount" use="concat(@epd:module, '++', @epd:scenario)"/>
    <xsl:key name="LCIAResult-modules" match="/process:processDataSet/process:LCIAResults/process:LCIAResult/common:other/epd:amount" use="concat(@epd:module, '++', @epd:scenario)"/>


    <xsl:template match="process:exchanges" priority="100">
        <tr>
            <td class="section" colspan="2" style="padding-left: 10px;">
                <a name="{$caption.environmentalIndicators}"/>Parameter zur Beschreibung des Ressourceneinsatzes und sonstige Umweltinformationen </td>
        </tr>
        <tr>
            <td colspan="3">
                <table>
                    <tr>
                        <th colspan="2"/>
                        <xsl:for-each
                            select="/process:processDataSet/process:exchanges/process:exchange/common:other/epd:amount[generate-id()
                            = generate-id(key('exchange-modules',concat(@epd:module, '++', @epd:scenario))[1])]">
                            <th class="table_header" valign="top">
                                <xsl:value-of select="@epd:module"/>
                                <xsl:if test="@epd:scenario">
                                    <xsl:variable name="scenario" select="@epd:scenario"/>
                                    <br/>
                                    <xsl:value-of
                                        select="/process:processDataSet/process:processInformation/process:dataSetInformation/common:other/epd:scenarios/epd:scenario[@epd:name=$scenario]/epd:description[@xml:lang='de']/text()"
                                    />
                                    <xsl:if
                                        test="/process:processDataSet/process:processInformation/process:dataSetInformation/common:other/epd:scenarios/epd:scenario[@epd:name=$scenario]/@epd:default='true'">
                                        <br/><xsl:text>(Standard)</xsl:text>
                                    </xsl:if>
                                </xsl:if>
                            </th>
                        </xsl:for-each>
                    </tr>
                    <xsl:apply-templates select="process:exchange[not(process:meanAmount)]"/>
                </table>
            </td>
        </tr>
        <xsl:apply-templates select="/process:processDataSet/process:LCIAResults" mode="a"/>
    </xsl:template>

    <xsl:template match="process:exchange" priority="100">
        <!--     <xsl:sort data-type="number" order="ascending"
                select="((@epd:phase='A1-A3_PRODUCTION') * 1) + ((@epd:phase='A4_TRANSPORT') * 3) + ((@epd:phase='A5_INSTALLATION') * 4)
                +((@epd:phase='B6_ENERGY_EINSATZ') * 5) 
                +((@epd:phase='C3_WASTE_HANDLING') * 6)
                +((@epd:phase='C4_LANDFILLING') * 7)
                +((@epd:phase='D_RECYCLING_POTENTIAL') * 8)
                +((@epd:phase='D_from_A') * 9)
                +((@epd:phase='D_from_C') * 10)"/>-->
        <!--                <xsl:sort select="" />-->
        <tr class="exchanges_data">
            <td style="padding-left: 30px;">
                <a href="{process:referenceToFlowDataSet/@uri}">
                    <xsl:value-of select="process:referenceToFlowDataSet/common:shortDescription"/>
                </a>
            </td>
            <td>
                <a href="{common:other/epd:referenceToUnitGroupDataSet/@uri}">
                    <xsl:value-of select="common:other/epd:referenceToUnitGroupDataSet/common:shortDescription"/>
                </a>
            </td>
            <xsl:variable name="other" select="common:other"/>
            <xsl:for-each
                select="/process:processDataSet/process:exchanges/process:exchange/common:other/epd:amount[generate-id()
                = generate-id(key('exchange-modules',concat(@epd:module, '++', @epd:scenario))[1])]">
                <xsl:variable name="currentModule" select="@epd:module"/>
                <xsl:variable name="currentScenario" select="@epd:scenario"/>
                <xsl:variable name="number">
                    <xsl:choose>
                        <xsl:when test="@epd:scenario">
                            <xsl:value-of select="exslt:node-set($other)/epd:amount[@epd:module=$currentModule and @epd:scenario=$currentScenario]/text()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="exslt:node-set($other)/epd:amount[@epd:module=$currentModule]/text()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <td align="center">
                    <xsl:call-template name="styleNumber">
                        <xsl:with-param name="number" select="$number"/>
                        <xsl:with-param name="round" select="true()"/>
                    </xsl:call-template>
                </td>
            </xsl:for-each>
        </tr>

    </xsl:template>

    <xsl:template match="epd:amount">
        <xsl:value-of select="text()"/>
    </xsl:template>

    <xsl:template match="process:LCIAResults"/>

    <xsl:template match="process:LCIAResults" priority="100" mode="a">
        <tr>
            <td class="section" colspan="2" style="padding-left: 10px;"> Parameter zur Beschreibung der Umweltwirkungen </td>
        </tr>
        <tr>
            <td colspan="3"> 
                <table>
                    <tr>
                        <th colspan="2"/>
                        <xsl:for-each
                            select="/process:processDataSet/process:LCIAResults/process:LCIAResult/common:other/epd:amount[generate-id() = generate-id(key('LCIAResult-modules',concat(@epd:module, '++', @epd:scenario))[1])]">
                            <th class="table_header" valign="top">
                                <xsl:value-of select="@epd:module"/>
                                <xsl:if test="@epd:scenario">
                                    <xsl:variable name="scenario" select="@epd:scenario"/>
                                    <br/>
                                    <xsl:value-of
                                        select="/process:processDataSet/process:processInformation/process:dataSetInformation/common:other/epd:scenarios/epd:scenario[@epd:name=$scenario]/epd:description[@xml:lang='de']/text()"/>
                                    <!--                                                                        <br/><a class="info">Szenario <xsl:value-of select="@epd:scenario"/><span><xsl:value-of select="/process:processDataSet/process:processInformation/process:dataSetInformation/common:other/epd:scenarios/epd:scenario[@epd:name=$scenario]/epd:description[@xml:lang='de']/text()"/></span></a>
-->
                                    <xsl:if
                                        test="/process:processDataSet/process:processInformation/process:dataSetInformation/common:other/epd:scenarios/epd:scenario[@epd:name=$scenario]/@epd:default='true'">
                                        <br/><xsl:text>(Standard)</xsl:text>
                                    </xsl:if>
                                </xsl:if>
                            </th>
                        </xsl:for-each>
                    </tr>
                    <xsl:apply-templates/>
                </table>
            </td>
        </tr>

    </xsl:template>

    <xsl:template match="process:LCIAResult">
        <tr class="exchanges_data">
            <td style="padding-left: 30px;">
                <a href="{process:referenceToLCIAMethodDataSet/@uri}">
                    <xsl:value-of select="process:referenceToLCIAMethodDataSet/common:shortDescription"/>
                </a>
            </td>
            <td>
                <a href="{common:other/epd:referenceToUnitGroupDataSet/@uri}">
                    <xsl:value-of select="common:other/epd:referenceToUnitGroupDataSet/common:shortDescription"/>
                </a>
            </td>
            <xsl:variable name="other" select="common:other"/>
            <xsl:for-each
                select="/process:processDataSet/process:LCIAResults/process:LCIAResult/common:other/epd:amount[generate-id() = generate-id(key('LCIAResult-modules',concat(@epd:module, '++', @epd:scenario))[1])]">
                <xsl:variable name="currentModule" select="@epd:module"/>
                <xsl:variable name="currentScenario" select="@epd:scenario"/>
                <xsl:variable name="number">
                    <xsl:choose>
                        <xsl:when test="@epd:scenario">
                            <xsl:value-of select="exslt:node-set($other)/epd:amount[@epd:module=$currentModule and @epd:scenario=$currentScenario]/text()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="exslt:node-set($other)/epd:amount[@epd:module=$currentModule]/text()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <td align="center">
                    <xsl:call-template name="styleNumber">
                        <xsl:with-param name="number" select="$number"/>
                        <xsl:with-param name="round" select="true()"/>
                    </xsl:call-template>
                </td>
            </xsl:for-each>
        </tr>

    </xsl:template>



    <xsl:template match="process:referenceToFlowDataSet">
        <xsl:call-template name="masterTemplate">
            <xsl:with-param name="currentName" select="local-name()"/>
            <xsl:with-param name="applyTemplates" select="false()"/>
            <xsl:with-param name="omitIfEmpty" select="false()"/>
            <xsl:with-param name="disableDescendantCount" select="false()"/>
            <xsl:with-param name="copy" select="true()"/>
            <xsl:with-param name="fieldShortDesc" select="$caption.referenceFlow"/>
            <xsl:with-param name="data">
                <xsl:call-template name="renderReference"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>


    <xsl:template match="/process:processDataSet/process:processInformation/process:geography"/>

    <xsl:template match="/process:processDataSet/process:processInformation/process:time[common:referenceYear and count(child::*[local-name()!='referenceYear'])=0]" priority="100"> </xsl:template>


    <xsl:template match="epd:safetyMargins">
        <tr>
            <td class="subsection" colspan="2" style="padding-left: 20px;">
                <xsl:value-of select="$caption.safetyMargins"/>
            </td>
        </tr>
        <xsl:call-template name="masterTemplate">
            <xsl:with-param name="fieldShortDesc">
                <xsl:value-of select="$caption.safetyMargins"/>
            </xsl:with-param>
            <xsl:with-param name="data">
                <xsl:value-of select="epd:margins"/>
                <xsl:text> %</xsl:text>
            </xsl:with-param>
            <xsl:with-param name="paddingleft">30</xsl:with-param>
        </xsl:call-template>

        <xsl:apply-templates select="epd:description"/>

    </xsl:template>

    <xsl:template match="epd:safetyMargins/epd:description">
        <xsl:call-template name="masterTemplate">
            <xsl:with-param name="fieldShortDesc">
                <xsl:value-of select="$caption.safetyMarginsDescription"/>
            </xsl:with-param>
            <xsl:with-param name="paddingleft">30</xsl:with-param>
            <xsl:with-param name="applyTemplates" select="true()"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="epd:scenarios">
        <xsl:call-template name="masterTemplate">
            <xsl:with-param name="fieldShortDesc">
                <xsl:value-of select="$caption.scenarios"/>
            </xsl:with-param>
            <xsl:with-param name="paddingleft">30</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates select="epd:scenario"/>
    </xsl:template>

    <xsl:template match="epd:scenario">
        <xsl:call-template name="masterTemplate">
            <xsl:with-param name="fieldShortDesc">
                <xsl:value-of select="$caption.scenario"/><xsl:if test="@epd:group"><xsl:text> </xsl:text><xsl:value-of select="$caption.scenario.group"/><xsl:text> </xsl:text><xsl:value-of select="@epd:group"/></xsl:if>
            </xsl:with-param>
            <xsl:with-param name="paddingleft">40</xsl:with-param>
            <xsl:with-param name="data">
                <xsl:value-of select="epd:description[$defaultLanguage]/text()"/><xsl:if test="@epd:default='true' or @epd:default='TRUE'"><xsl:text> </xsl:text><xsl:value-of select="$caption.scenario.default"/></xsl:if>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>






    <xsl:template name="styleNumber">
        <xsl:param name="number"/>
        <xsl:param name="round" select="false()"/>
        <xsl:param name="precision" select="3"/>
        <xsl:variable name="rounded">
            <xsl:choose>
                <xsl:when test="$round='true'">
                    <xsl:call-template name="formatNumber">
                        <xsl:with-param name="number" select="$number"/>
                        <xsl:with-param name="precision" select="$precision"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$number"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$number!='-'">
                <xsl:choose>
                    <xsl:when test="$round='true'">
                        <a class="info" href="javascript:void(0);">
                            <xsl:choose>
                                <xsl:when test="$defaultLanguage='de'">
                                    <xsl:value-of select="translate($rounded, '.', ',')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$rounded"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            <span>
                                <xsl:value-of select="$number"/>
                            </span>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$defaultLanguage='de'">
                                <xsl:value-of select="translate($rounded, '.', ',')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$rounded"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$number"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="formatNumber">
        <xsl:param name="number"/>
        <xsl:param name="precision" select="3"/>
        <xsl:variable name="negative">
            <xsl:choose>
                <xsl:when test="number($number) &lt; 0">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="false()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <!-- scientific notation: do nothing -->
            <xsl:when test="contains($number, 'E')">
                <xsl:variable name="base" select="substring-before($number, 'E')"/>
                <xsl:variable name="exponent" select="substring-after($number, 'E')"/>
                <xsl:variable name="formatted">
                    <xsl:call-template name="formatNumber">
                        <xsl:with-param name="number" select="$base"/>
                        <xsl:with-param name="precision" select="$precision"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat($formatted, 'E', $exponent)"/>
            </xsl:when>
            <!-- all other cases -->
            <xsl:otherwise>
                <xsl:variable name="base">
                    <xsl:choose>
                        <xsl:when test="contains($number, '.')">
                            <xsl:value-of select="substring-before($number, '.')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$number"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="basedigits">
                    <xsl:choose>
                        <xsl:when test="number($base) = 0">
                            <xsl:value-of select="0"/>
                        </xsl:when>
                        <xsl:when test="number($base) &lt; 0">
                            <xsl:value-of select="string-length($base) - 1"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="string-length($base)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="basefactor" select="$precision - $basedigits"/>
                <xsl:variable name="zerosAfterComma">
                    <xsl:choose>
                        <xsl:when test="$basefactor > 0">
                            <xsl:call-template name="countZerosAfterDecimalSeparator">
                                <xsl:with-param name="number" select="$number"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="0"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:variable name="formatString">
                    <xsl:text>0</xsl:text>
                    <xsl:if test="$basefactor > 0">
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                    <xsl:call-template name="padding">
                        <xsl:with-param name="chars" select="'#'"/>
                        <xsl:with-param name="length" select="$basefactor + $zerosAfterComma"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="format-number($number, $formatString)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="power">
        <xsl:param name="base"/>
        <xsl:param name="exponent"/>
        <xsl:param name="result" select="1"/>
        <xsl:choose>
            <xsl:when test="$exponent &lt; 0 or contains(string($exponent), '.')">
                <xsl:text>NaN</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="_power">
                    <xsl:with-param name="base" select="$base"/>
                    <xsl:with-param name="exponent" select="$exponent"/>
                    <xsl:with-param name="result" select="1"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="_power">
        <xsl:param name="base"/>
        <xsl:param name="exponent"/>
        <xsl:param name="result" select="1"/>
        <xsl:choose>
            <xsl:when test="$exponent = 0">
                <xsl:value-of select="$result"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="_power">
                    <xsl:with-param name="base" select="$base"/>
                    <xsl:with-param name="exponent" select="$exponent - 1"/>
                    <xsl:with-param name="result" select="$result * $base"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="countZerosAfterDecimalSeparator">
        <xsl:param name="number"/>
        <xsl:param name="result" select="0"/>
        <xsl:choose>
            <xsl:when test="starts-with(substring-after($number, '.'), '0')">
                <xsl:variable name="_result">
                    <xsl:call-template name="countZerosAfterDecimalSeparator">
                        <xsl:with-param name="number" select="$number * 10"/>
                        <xsl:with-param name="result" select="$result + 1"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$_result"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$result"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- end EPD customizations -->

</xsl:stylesheet>
