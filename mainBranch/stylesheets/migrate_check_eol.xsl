<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:edoc="http://www.iai.fzk.de/lca/edoc" xmlns:process="http://lca.jrc.it/ILCD/Process"
    xmlns:lciamethod="http://lca.jrc.it/ILCD/LCIAMethod" xmlns:flow="http://lca.jrc.it/ILCD/Flow" xmlns:flowproperty="http://lca.jrc.it/ILCD/FlowProperty"
    xmlns:unitgroup="http://lca.jrc.it/ILCD/UnitGroup" xmlns:source="http://lca.jrc.it/ILCD/Source" xmlns:contact="http://lca.jrc.it/ILCD/Contact"
    xmlns:common="http://lca.jrc.it/ILCD/Common" xmlns:epd="http://www.iai.kit.edu/EPD/2013" xmlns:epd0="http://www.pe-international.com/EPD/2007" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xml="http://www.w3.org/XML/1998/namespace" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="xs xsi edoc process source contact flow flowproperty lciamethod unitgroup">

    <!-- this stylesheet checks whether there are any potential use phase or EoL datasets that are compatible with this dataset -->

    <xsl:strip-space elements="*"/>

    <xsl:output indent="no" method="text"/>

    <xsl:variable name="currentFileName" select="document-uri(/)"/>

    <xsl:variable name="fileNameNoSuffix">
        <xsl:analyze-string select="$currentFileName" regex="(.*)_(\(.*\)).xml">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(1)"/>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:variable>

    <xsl:variable name="fileNameSuffix">
        <xsl:analyze-string select="$currentFileName" regex="(.*).?(\(.*\)).xml">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(2)"/>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:variable>

    <xsl:variable name="fileNameNoPrefixNoSuffix">
        <xsl:analyze-string select="$currentFileName" regex="[0-9]+\.[0-9]+\.[0-9]+.?(.*)\.xml">
            <!-- .{1}(.*).{1}\(.*\) -->
            <xsl:matching-substring>
                <xsl:value-of select="normalize-space(regex-group(1))"/>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:variable>

    <xsl:variable name="lookforEol" select="'B6,C3,C4,D'"/>

    <xsl:variable name="referenceFlowAmount"
        select="/process:processDataSet/process:exchanges/process:exchange[@dataSetInternalID=/process:processDataSet/process:processInformation/process:quantitativeReference/process:referenceToReferenceFlow]/process:meanAmount/text()"/>




    <xsl:template match="/">


        <xsl:for-each select="tokenize($lookforEol, ',')">
            <xsl:variable name="currentmodule" select="string(.)"/>
            <xsl:variable name="relatedFileName" select="concat($fileNameNoPrefixNoSuffix, '_(',$currentmodule, ').xml')"/>
            <xsl:variable name="fileAvailable" select="doc-available(concat('../oekobaudat.eolcheck/',$relatedFileName))"/>

            <xsl:if test="$fileAvailable">
                <xsl:message>INFO: found potential use phase / EoL match: <xsl:value-of select="$relatedFileName"/></xsl:message>

                <xsl:variable name="foreignRefFlowAmount"
                    select="document(concat('../oekobaudat.eolcheck/',$relatedFileName))/process:processDataSet/common:other/epd0:EPD/epd0:referenceFlowAmount/text()"/>
                <xsl:choose>
                    <xsl:when test="$referenceFlowAmount!=$foreignRefFlowAmount">
                        <xsl:message terminate="no">INFO: BUT reference flow amount mismatch! Should be <xsl:value-of select="$referenceFlowAmount"/>, but found value <xsl:value-of
                                select="$foreignRefFlowAmount"/> in file <xsl:value-of select="$relatedFileName"/>.</xsl:message>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message terminate="no">INFO: (reference flow amount matches)</xsl:message>
                    </xsl:otherwise>
                </xsl:choose>


            </xsl:if>
        </xsl:for-each>






    </xsl:template>




</xsl:stylesheet>
