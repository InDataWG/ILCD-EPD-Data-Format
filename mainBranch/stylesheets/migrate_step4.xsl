<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:edoc="http://www.iai.fzk.de/lca/edoc" xmlns:process="http://lca.jrc.it/ILCD/Process"
    xmlns:lciamethod="http://lca.jrc.it/ILCD/LCIAMethod" xmlns:flow="http://lca.jrc.it/ILCD/Flow" xmlns:flowproperty="http://lca.jrc.it/ILCD/FlowProperty"
    xmlns:unitgroup="http://lca.jrc.it/ILCD/UnitGroup" xmlns:source="http://lca.jrc.it/ILCD/Source" xmlns:contact="http://lca.jrc.it/ILCD/Contact"
    xmlns:common="http://lca.jrc.it/ILCD/Common" xmlns:epd="http://www.iai.kit.edu/EPD/2013" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xml="http://www.w3.org/XML/1998/namespace" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="xs xsi edoc process source contact flow flowproperty lciamethod unitgroup">

    <!-- this stylesheet merely adjusts the dataSetInternalID numbers of the exchanges to be unique and ascending -->

    <xsl:strip-space elements="*"/>

    <xsl:output indent="yes" method="xml"/>

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

    <xsl:template match="process:exchange[position()!=1]">
        <xsl:copy>
            <xsl:variable name="index">
                <xsl:choose>
                    <xsl:when test="position()!=parent::*//process:exchange[1]/@dataSetInternalID and position() &lt; parent::*//process:exchange[1]/@dataSetInternalID">
                        <xsl:value-of select="position()"></xsl:value-of>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="position()+1"></xsl:value-of>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="dataSetInternalID" select="$index"/>
            <xsl:copy-of select="@*[local-name()!='dataSetInternalID']"/>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
