<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:edoc="http://www.iai.fzk.de/lca/edoc" xmlns:process="http://lca.jrc.it/ILCD/Process"
    xmlns:lciamethod="http://lca.jrc.it/ILCD/LCIAMethod" xmlns:flow="http://lca.jrc.it/ILCD/Flow" xmlns:flowproperty="http://lca.jrc.it/ILCD/FlowProperty"
    xmlns:unitgroup="http://lca.jrc.it/ILCD/UnitGroup" xmlns:source="http://lca.jrc.it/ILCD/Source" xmlns:contact="http://lca.jrc.it/ILCD/Contact"
    xmlns:common="http://lca.jrc.it/ILCD/Common" xmlns:epd="http://www.iai.kit.edu/EPD/2013" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xml="http://www.w3.org/XML/1998/namespace" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="xs xsi edoc process source contact flow flowproperty lciamethod unitgroup">

    <!-- resolve scenario aliases -->

    <xsl:strip-space elements="*"/>

    <xsl:output indent="yes" method="xml"/>

    <xsl:template match="process:dataSetInformation">
        <xsl:copy>
            <xsl:apply-templates select="*[local-name()!='other']"/>
            <xsl:choose>
                <xsl:when test="common:other/*">
                    <common:other>
                        <xsl:if
                            test="count(//epd:amount[contains(@epd:module,'$')]) > 0">
                            <xsl:call-template name="scenarioDescriptions"/>
                        </xsl:if>
                        <xsl:apply-templates select="common:other/*"/>
                    </common:other>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if
                        test="count(//epd:amount[contains(@epd:module,'$')]) > 0">
                        <common:other>
                            <xsl:call-template name="scenarioDescriptions"/>
                        </common:other>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <xsl:template name="scenarioDescriptions">
        <!-- scenario descriptions -->
        <epd:scenarios>
            <xsl:if test="count(//epd:amount[contains(@epd:module,'$a')]) > 0">
                <epd:scenario epd:name="a">
                    <epd:description xml:lang="de">0% stoffliches Recycling</epd:description>
                </epd:scenario>
            </xsl:if>                                
            <xsl:if test="count(//epd:amount[contains(@epd:module,'$b')]) > 0">
                <epd:scenario epd:name="b">
                    <epd:description xml:lang="de">100% stoffliches Recycling</epd:description>
                </epd:scenario>
            </xsl:if>                                
            <xsl:if test="count(//epd:amount[contains(@epd:module,'$c')]) > 0">
                <epd:scenario epd:name="c">
                    <epd:description xml:lang="de">100% Verbrennung</epd:description>
                </epd:scenario>
            </xsl:if>                                
            <xsl:if test="count(//epd:amount[contains(@epd:module,'$d')]) > 0">
                <epd:scenario epd:name="d">
                    <epd:description xml:lang="de">100% Deponierung</epd:description>
                </epd:scenario>
            </xsl:if>                                
            <xsl:if test="count(//epd:amount[contains(@epd:module,'$e')]) > 0">
                <epd:scenario epd:name="e">
                    <epd:description xml:lang="de">100% Recycling</epd:description>
                </epd:scenario>
            </xsl:if>                                
        </epd:scenarios>
    </xsl:template>

    <xsl:template match="epd:amount[contains(@epd:module,'$')]">
        <xsl:element name="epd:amount" namespace="http://www.iai.kit.edu/EPD/2013">
            <xsl:attribute name="module" namespace="http://www.iai.kit.edu/EPD/2013"><xsl:value-of select="substring-before(@epd:module, '_$')"/></xsl:attribute>
            <xsl:attribute name="scenario" namespace="http://www.iai.kit.edu/EPD/2013"><xsl:value-of select="substring-after(@epd:module, '_$')"/></xsl:attribute>
            <xsl:apply-templates select="text()"/>
        </xsl:element>
    </xsl:template>

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

</xsl:stylesheet>
