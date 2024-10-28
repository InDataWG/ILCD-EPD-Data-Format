<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:process="http://lca.jrc.it/ILCD/Process"
    xmlns:lciamethod="http://lca.jrc.it/ILCD/LCIAMethod" xmlns:flow="http://lca.jrc.it/ILCD/Flow" xmlns:flowproperty="http://lca.jrc.it/ILCD/FlowProperty"
    xmlns:unitgroup="http://lca.jrc.it/ILCD/UnitGroup" xmlns:source="http://lca.jrc.it/ILCD/Source" xmlns:contact="http://lca.jrc.it/ILCD/Contact"
    xmlns:common="http://lca.jrc.it/ILCD/Common"  xmlns:epd="http://www.iai.kit.edu/EPD/2013"
    xmlns:xml="http://www.w3.org/XML/1998/namespace" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="xsi epd process"
    version="2.0">
    
    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:template match="process:processDataSet/process:processInformation/process:dataSetInformation">
        <xsl:variable name="referenceFlowId" select=" /process:processDataSet/process:processInformation/process:quantitativeReference/process:referenceToReferenceFlow/text()"/>
        <xsl:variable name="productId" select="/process:processDataSet/process:exchanges/process:exchange[@dataSetInternalID=$referenceFlowId][1]/process:referenceToFlowDataSet/@refObjectId"/>
        <xsl:element name="entry">
            <xsl:attribute name="processId"><xsl:copy-of select="common:UUID"/></xsl:attribute>
            <xsl:attribute name="productId" select="$productId"/>
            <xsl:copy-of select="process:classificationInformation/common:classification" copy-namespaces="no"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="text()"/>
    
    <xsl:template match="@*"/>
    
</xsl:stylesheet>