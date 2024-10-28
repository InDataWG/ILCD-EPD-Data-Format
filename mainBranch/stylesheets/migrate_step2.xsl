<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:edoc="http://www.iai.fzk.de/lca/edoc" xmlns:process="http://lca.jrc.it/ILCD/Process"
    xmlns:lciamethod="http://lca.jrc.it/ILCD/LCIAMethod" xmlns:flow="http://lca.jrc.it/ILCD/Flow" xmlns:flowproperty="http://lca.jrc.it/ILCD/FlowProperty"
    xmlns:unitgroup="http://lca.jrc.it/ILCD/UnitGroup" xmlns:source="http://lca.jrc.it/ILCD/Source" xmlns:contact="http://lca.jrc.it/ILCD/Contact"
    xmlns:common="http://lca.jrc.it/ILCD/Common" xmlns:epd="http://www.iai.kit.edu/EPD/2013" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xml="http://www.w3.org/XML/1998/namespace" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="xs xsi edoc process source contact flow flowproperty lciamethod unitgroup">

    <!-- group the modules for the indicators -->

    <xsl:strip-space elements="*"/>

    <xsl:output indent="yes" method="xml"/>
    
    <xsl:param name="checkIndicators" select="false()"/>

    <xsl:variable name="source_modules"
        >A1-A3,A1,A2,A3,A4,A5,B1,B2,B3,B4,B5,B6,B7,C1,C2,C3,C3_$a,C3_$b,C3_$c,C3_$d,C3_$e,C4,C4_$a,C4_$b,C4_$c,C4_$d,C4_$e,D,D_$a,D_$b,D_$c,D_$d,D_$e</xsl:variable>
    <!--<xsl:variable name="source_modules"
        >A1-A3_PRODUCTION,A4_TRANSPORT,A5_INSTALLATION,B6_ENERGY_USE,C3_WASTE_PROCESSING,C3_WASTE_PROCESSING_$a,C3_WASTE_PROCESSING_$b,C3_WASTE_PROCESSING_$c,C3_WASTE_PROCESSING_$d,C3_WASTE_PROCESSING_$e,C4_DISPOSAL,C4_DISPOSAL_$a,C4_DISPOSAL_$b,C4_DISPOSAL_$c,C4_DISPOSAL_$d,C4_DISPOSAL_$e,D_RECYCLING_POTENTIAL,D_RECYCLING_POTENTIAL_$a,D_RECYCLING_POTENTIAL_$b,D_RECYCLING_POTENTIAL_$c,D_RECYCLING_POTENTIAL_$d,D_RECYCLING_POTENTIAL_$e,D_from_A,D_from_C</xsl:variable>
    -->

    <xsl:template match="processing-instruction()|comment()">
        <xsl:text>
</xsl:text>
        <xsl:copy/>
    </xsl:template>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- copy -->
    <xsl:template match="*">
        <xsl:copy>
            <!-- go process attributes and children -->
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:copy-of select="."/>
    </xsl:template>
    
    <xsl:template match="process:exchanges">
        <xsl:copy>
            <xsl:copy-of select="process:exchange[not(@epd:module)]"/>
            
            <xsl:variable name="sourceExchanges" select="."/>
            
            <xsl:for-each select="document('oekobaudat_indicators.xml')/indicators/LCIIndicators/LCIIndicator">
                <xsl:variable name="indicatorId" select="./referenceToFlowDataSet/@refObjectId"/>
                
                <xsl:if test="$sourceExchanges/process:exchange[process:referenceToFlowDataSet[@refObjectId=$indicatorId]]">
                    <xsl:variable name="exchange" select="$sourceExchanges/process:exchange[process:referenceToFlowDataSet/@refObjectId=$indicatorId][1]"></xsl:variable>
                    <xsl:element name="exchange" namespace="http://lca.jrc.it/ILCD/Process">
                        <xsl:copy-of select="$exchange/process:referenceToFlowDataSet"/>
                        <xsl:copy-of select="$exchange/process:functionType"/>
                        <xsl:copy-of select="$exchange/process:exchangeDirection"/>
                        <xsl:element name="common:other" namespace="http://lca.jrc.it/ILCD/Common">
                            
                            <xsl:for-each select="tokenize($source_modules, ',')">
                                <xsl:variable name="module" select="."/>
                                <xsl:if test="$sourceExchanges/process:exchange[@epd:module=$module]">
                                    <xsl:element name="epd:amount" namespace="http://www.iai.kit.edu/EPD/2013">
                                        <xsl:attribute name="epd:module" namespace="http://www.iai.kit.edu/EPD/2013" select="$module"/>
                                        <xsl:value-of
                                            select="$sourceExchanges/process:exchange[process:referenceToFlowDataSet/@refObjectId=$indicatorId and @epd:module=$module]/common:other/epd:amount"
                                        />
                                    </xsl:element>
                                </xsl:if>
                            </xsl:for-each>
                            
                            <xsl:copy-of
                                select="$exchange/common:other/epd:referenceToUnitGroupDataSet"
                            />
                        </xsl:element>
                    </xsl:element>
                </xsl:if>
            </xsl:for-each>
        </xsl:copy>
        
        <xsl:if test="$checkIndicators='true'">
            <xsl:for-each select="process:exchange[position()>1]">
                <xsl:variable name="exchangeIndUUID" select="process:referenceToFlowDataSet/@refObjectId"/>
                <xsl:variable name="exchangeIndDesc" select="process:referenceToFlowDataSet/common:shortDescription/text()"/>
                <xsl:variable name="found">
                    <xsl:for-each select="document('oekobaudat_indicators.xml')/indicators/LCIIndicators/LCIIndicator">
                        <xsl:variable name="indicatorId" select="./referenceToFlowDataSet/@refObjectId"/>
                        <xsl:if test="$indicatorId=$exchangeIndUUID">
                            <xsl:value-of select="true()"/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:if test="$found!='true'">
                    <xsl:message terminate="no">ERROR: Indicator with UUID <xsl:value-of select="$exchangeIndUUID"/> (<xsl:value-of select="$exchangeIndDesc"/>) could not be found in indicators file.</xsl:message>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    
    <xsl:template match="process:LCIAResults">
        <xsl:copy>
            
            <xsl:variable name="sourceLCIAResults" select="."/>
            
            <xsl:for-each select="document('oekobaudat_indicators.xml')/indicators/LCIAIndicators/LCIAIndicator">
                <xsl:variable name="indicatorId" select="./referenceToLCIAMethodDataSet/@refObjectId"/>
                
                <xsl:if test="$sourceLCIAResults/process:LCIAResult[process:referenceToLCIAMethodDataSet[@refObjectId=$indicatorId]]">
                    <xsl:element name="LCIAResult" namespace="http://lca.jrc.it/ILCD/Process">
                        <xsl:copy-of select="$sourceLCIAResults/process:LCIAResult[process:referenceToLCIAMethodDataSet/@refObjectId=$indicatorId][1]/process:referenceToLCIAMethodDataSet"/>
                        <xsl:element name="common:other" namespace="http://lca.jrc.it/ILCD/Common">
                            
                            <xsl:for-each select="tokenize($source_modules, ',')">
                                <xsl:variable name="module" select="."/>
                                <xsl:if test="$sourceLCIAResults/process:LCIAResult[@epd:module=$module]">
                                    <xsl:element name="epd:amount" namespace="http://www.iai.kit.edu/EPD/2013">
                                        <xsl:attribute name="epd:module" namespace="http://www.iai.kit.edu/EPD/2013" select="$module"/>
                                        <xsl:value-of
                                            select="$sourceLCIAResults/process:LCIAResult[process:referenceToLCIAMethodDataSet/@refObjectId=$indicatorId and @epd:module=$module]/common:other/epd:amount"
                                        />
                                    </xsl:element>
                                </xsl:if>
                            </xsl:for-each>
                            
                            <xsl:copy-of
                                select="$sourceLCIAResults/process:LCIAResult[process:referenceToLCIAMethodDataSet/@refObjectId=$indicatorId][1]/common:other/epd:referenceToUnitGroupDataSet"
                            />
                        </xsl:element>
                    </xsl:element>
                </xsl:if>
            </xsl:for-each>
        </xsl:copy>
        
        <xsl:if test="$checkIndicators='true'">
            <xsl:for-each select="process:LCIAResult">
                <xsl:variable name="exchangeIndUUID" select="process:referenceToLCIAMethodDataSet/@refObjectId"/>
                <xsl:variable name="exchangeIndDesc" select="process:referenceToLCIAMethodDataSet/common:shortDescription/text()"/>
                <xsl:variable name="found">
                    <xsl:for-each select="document('oekobaudat_indicators.xml')/indicators/LCIAIndicators/LCIAIndicator">
                        <xsl:variable name="indicatorId" select="./referenceToLCIAMethodDataSet/@refObjectId"/>
                        <xsl:if test="$indicatorId=$exchangeIndUUID">
                            <xsl:value-of select="true()"/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:if test="$found!='true'">
                    <xsl:message terminate="no">ERROR: Indicator with UUID <xsl:value-of select="$exchangeIndUUID"/> (<xsl:value-of select="$exchangeIndDesc"/>) could not be found in indicators file.</xsl:message>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
        
    </xsl:template>
    
    

</xsl:stylesheet>
