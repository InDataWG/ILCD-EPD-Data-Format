<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:edoc="http://www.iai.fzk.de/lca/edoc" xmlns:process="http://lca.jrc.it/ILCD/Process"
    xmlns:lciamethod="http://lca.jrc.it/ILCD/LCIAMethod" xmlns:flow="http://lca.jrc.it/ILCD/Flow" xmlns:flowproperty="http://lca.jrc.it/ILCD/FlowProperty"
    xmlns:unitgroup="http://lca.jrc.it/ILCD/UnitGroup" xmlns:source="http://lca.jrc.it/ILCD/Source" xmlns:contact="http://lca.jrc.it/ILCD/Contact"
    xmlns:common="http://lca.jrc.it/ILCD/Common" xmlns:epd0="http://www.pe-international.com/EPD/2007" xmlns:epd="http://www.iai.kit.edu/EPD/2013"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xml="http://www.w3.org/XML/1998/namespace" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="xs xsi edoc process source contact flow flowproperty lciamethod unitgroup epd epd0 common">

    <xsl:strip-space elements="*"/>

    <xsl:output indent="yes" method="xml"/>

    <xsl:variable name="uuid" select="/process:processDataSet/process:processInformation/process:dataSetInformation/common:UUID/text()"/>



    <xsl:template match="processing-instruction()|comment()">
        <xsl:text>
</xsl:text>
        <xsl:copy/>
        <xsl:text>
</xsl:text>
    </xsl:template>

    <xsl:template match="/">
        <xsl:result-document href="{concat($uuid, '.xml')}">
            <xsl:apply-templates/>
        </xsl:result-document>
    </xsl:template>

    <!-- copy -->
    <xsl:template match="process:processDataSet">
        <xsl:copy>
            <xsl:apply-templates select="@*|*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*">
        <xsl:element name="{name()}" namespace="{namespace-uri()}">
            <!-- go process attributes and children -->
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:copy-of select="."/>
    </xsl:template>

</xsl:stylesheet>
