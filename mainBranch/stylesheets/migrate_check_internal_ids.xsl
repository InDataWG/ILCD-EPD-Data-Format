<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:edoc="http://www.iai.fzk.de/lca/edoc" xmlns:process="http://lca.jrc.it/ILCD/Process"
    xmlns:lciamethod="http://lca.jrc.it/ILCD/LCIAMethod" xmlns:flow="http://lca.jrc.it/ILCD/Flow" xmlns:flowproperty="http://lca.jrc.it/ILCD/FlowProperty"
    xmlns:unitgroup="http://lca.jrc.it/ILCD/UnitGroup" xmlns:source="http://lca.jrc.it/ILCD/Source" xmlns:contact="http://lca.jrc.it/ILCD/Contact"
    xmlns:common="http://lca.jrc.it/ILCD/Common" xmlns:epd="http://www.iai.kit.edu/EPD/2013" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xml="http://www.w3.org/XML/1998/namespace" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="xs xsi edoc process source contact flow flowproperty lciamethod unitgroup">

    <!-- this stylesheet checks whether the id declared in quantitativeReference/referenceToReferenceFlow actually exists and if the reference flow is correctly declared as output -->

    <xsl:strip-space elements="*"/>

    <xsl:output indent="yes" method="xml"/>

    <xsl:template match="@*|*">
        <xsl:apply-templates select="@*|node()"/>
    </xsl:template>

    <xsl:template match="process:quantitativeReference/process:referenceToReferenceFlow">
        <xsl:variable name="declared" select="text()"/>
        <xsl:if test="count(/process:processDataSet/process:exchanges/process:exchange[@dataSetInternalID=$declared])!=1">
            <xsl:message terminate="no">ERROR: referenceToReferenceFlow and dataSetInternalID do not match! Declared: <xsl:value-of select="$declared"/> Found: <xsl:value-of select="/process:processDataSet/process:exchanges/process:exchange[1]/@dataSetInternalID"/></xsl:message>
        </xsl:if>
        <xsl:if test="/process:processDataSet/process:exchanges/process:exchange[@dataSetInternalID=$declared]/process:exchangeDirection/text()!='Output'">
            <xsl:message terminate="no">ERROR: referenceFlow does not declare an Output!</xsl:message>
        </xsl:if>
        <xsl:if test="/process:processDataSet/process:exchanges/process:exchange[@dataSetInternalID=$declared]/process:meanAmount='0'">
            <xsl:message terminate="no">ERROR: referenceFlow declares an amount of zero!</xsl:message>
        </xsl:if>
        <xsl:if test="document(/process:processDataSet/process:exchanges/process:exchange[@dataSetInternalID=$declared]/process:referenceToReferenceFlow/@uri)=''">
            <xsl:message terminate="no">ERROR: referenceFlow does not reference an existing product!</xsl:message>
        </xsl:if>
    </xsl:template>

    <xsl:template match="/">
        <xsl:if test="count(process:processDataSet/process:processInformation/process:quantitativeReference/process:referenceToReferenceFlow)=0">
            <xsl:message terminate="no">ERROR: no quantitative reference declared!!</xsl:message>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>
