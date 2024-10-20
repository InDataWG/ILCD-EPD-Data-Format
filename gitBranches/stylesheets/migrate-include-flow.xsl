<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"  xmlns:process="http://lca.jrc.it/ILCD/Process"
    xmlns:lciamethod="http://lca.jrc.it/ILCD/LCIAMethod" xmlns:flow="http://lca.jrc.it/ILCD/Flow" xmlns:fp="http://lca.jrc.it/ILCD/FlowProperty"
    xmlns:unitgroup="http://lca.jrc.it/ILCD/UnitGroup" xmlns:source="http://lca.jrc.it/ILCD/Source" xmlns:contact="http://lca.jrc.it/ILCD/Contact"
    xmlns:common="http://lca.jrc.it/ILCD/Common" exclude-result-prefixes="process source contact flow fp lciamethod unitgroup">
    
    <xsl:template name="renderflow">
        <xsl:param name="name"/>
        <xsl:param name="uuid"/>
        <xsl:param name="comment"/>

        <xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="http://iai-uiserv1.iai.kit.edu/EPD/stylesheets/flow2html.xsl"</xsl:processing-instruction>
        <flowDataSet xmlns="http://lca.jrc.it/ILCD/Flow" xmlns:common="http://lca.jrc.it/ILCD/Common" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://lca.jrc.it/ILCD/Flow ../../schemas/ILCD_FlowDataSet.xsd" version="1.1" locations="../ILCDLocations.xml">
            <flowInformation>
                <dataSetInformation>
                    <common:UUID>
                        <xsl:value-of select="$uuid"/>
                    </common:UUID>
                    <name>
                        <baseName xml:lang="de">
                            <xsl:value-of select="$name"/>
                        </baseName>
                    </name>
                    <classificationInformation>
                        <xsl:apply-templates select="fp:flowPropertiesInformation/fp:dataSetInformation/fp:classificationInformation/*"/>
                    </classificationInformation>
                    <common:generalComment xml:lang="de">
                        <xsl:value-of select="$comment"/>
                    </common:generalComment>
                </dataSetInformation>
            </flowInformation>
            <modellingAndValidation>
                <LCIMethod>
                    <typeOfDataSet>Other flow</typeOfDataSet>
                </LCIMethod>
            </modellingAndValidation>
            <administrativeInformation>
                <dataEntryBy>
                    <common:timeStamp><xsl:value-of select="current-dateTime()"/></common:timeStamp>
                    <xsl:apply-templates select="fp:administrativeInformation/fp:dataEntryBy/common:referenceToDataSetFormat"/>
                </dataEntryBy>
                <publicationAndOwnership>
                    <common:dataSetVersion>00.00.001</common:dataSetVersion>
                </publicationAndOwnership>
            </administrativeInformation>
<!--            <flowProperties>
                <flowProperty dataSetInternalID="0">
                    <referenceToFlowPropertyDataSet type="flow property data set" refObjectId="00000000-0000-0000-0000-000000000000" version="00.00" uri="">
                        <common:shortDescription xml:lang="en">shortDescription20</common:shortDescription>
                        <common:shortDescription xml:lang="de">shortDescription21</common:shortDescription>
                    </referenceToFlowPropertyDataSet>
                    <meanValue>0</meanValue>
                    <minimumValue>0</minimumValue>
                    <maximumValue>0</maximumValue>
                    <uncertaintyDistributionType>undefined</uncertaintyDistributionType>
                    <relativeStandardDeviation95In>12.123</relativeStandardDeviation95In>
                    <dataDerivationTypeStatus>Measured</dataDerivationTypeStatus>
                    <generalComment xml:lang="en">generalComment0</generalComment>
                    <generalComment xml:lang="de">generalComment1</generalComment>
                </flowProperty>
            </flowProperties>
-->        </flowDataSet>

    </xsl:template>

</xsl:stylesheet>
