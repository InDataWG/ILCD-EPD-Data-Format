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

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="@*|*">
        <xsl:apply-templates select="@*|node()"/>
    </xsl:template>

    <xsl:template match="process:classificationInformation/common:classification[@name='OEKOBAU.DAT']">
        <xsl:if test="count(common:class) &lt; 3">
            <xsl:message terminate="no">ERROR: only less than 3 classification levels declared <xsl:value-of select="count(/common:class)"/></xsl:message>
        </xsl:if>
        <xsl:if test="count(common:class[@classId='']) != 0">
            <xsl:message terminate="no">ERROR: empty classId declared</xsl:message>
        </xsl:if>
     </xsl:template>

    <xsl:template match="process:processDataSet">
        <xsl:if test="count(process:processInformation/process:dataSetInformation/process:classificationInformation/common:classification[@name='OEKOBAU.DAT'])=0">
            <xsl:message terminate="no">ERROR: no OEKOBAU.DAT classification declared!!</xsl:message>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="flow:flowDataSet[flow:modellingAndValidation/flow:LCIMethod/flow:typeOfDataSet='Product flow']">
        <xsl:if test="count(flow:flowInformation/flow:dataSetInformation/flow:classificationInformation/common:classification[@name='OEKOBAU.DAT'])=0">
            <xsl:message terminate="no">ERROR: no OEKOBAU.DAT classification declared for product flow <xsl:value-of select="/flow:flowDataSet/flow:flowInformation/flow:dataSetInformation/flow:name/flow:baseName/text()"/></xsl:message>
        </xsl:if>
        <xsl:if test="count(flow:flowInformation/flow:dataSetInformation/flow:classificationInformation/common:classification[@name='OEKOBAU.DAT']/common:class) &lt; 3">
            <xsl:message terminate="no">ERROR: less than 3 category levels declared for product flow   <xsl:value-of select="/flow:flowDataSet/flow:flowInformation/flow:dataSetInformation/flow:name/flow:baseName/text()"/></xsl:message>
        </xsl:if>
        <xsl:if test="count(flow:flowInformation/flow:dataSetInformation/flow:classificationInformation/common:classification[@name='OEKOBAU.DAT']/common:class[@classId='']) != 0">
            <xsl:message terminate="no">ERROR: empty classId declared for product flow                 <xsl:value-of select="/flow:flowDataSet/flow:flowInformation/flow:dataSetInformation/flow:name/flow:baseName/text()"/></xsl:message>
        </xsl:if>
        
        <xsl:apply-templates/>
    </xsl:template>
    
</xsl:stylesheet>
