<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:edoc="http://www.iai.fzk.de/lca/edoc" xmlns:process="http://lca.jrc.it/ILCD/Process"
    xmlns:lciamethod="http://lca.jrc.it/ILCD/LCIAMethod" xmlns:flow="http://lca.jrc.it/ILCD/Flow" xmlns:flowproperty="http://lca.jrc.it/ILCD/FlowProperty"
    xmlns:unitgroup="http://lca.jrc.it/ILCD/UnitGroup" xmlns:source="http://lca.jrc.it/ILCD/Source" xmlns:contact="http://lca.jrc.it/ILCD/Contact"
    xmlns:common="http://lca.jrc.it/ILCD/Common" xmlns:epd0="http://www.pe-international.com/EPD/2007" xmlns:epd="http://www.iai.kit.edu/EPD/2013"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xml="http://www.w3.org/XML/1998/namespace" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="xs xsi edoc process source contact flow flowproperty lciamethod unitgroup epd0">

    <xsl:include href="migrate-util.xsl"/>

    <xsl:strip-space elements="*"/>

    <xsl:output indent="yes" method="xml"/>

    <xsl:param name="threshold" select="0.5"/>

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

    <xsl:variable name="uuid" select="/process:processDataSet/process:processInformation/process:dataSetInformation/common:UUID/text()"/>

    <xsl:variable name="referenceFlowAmount" select="/process:processDataSet/common:other/epd0:EPD/epd0:referenceFlowAmount/text()"/>


    <!-- map old module declaration (e.g. "(A1-A3)" to new one (e.g. "A1-A3") -->
    <xsl:variable name="moduleDescriptor">
        <xsl:call-template name="decodemodule">
            <xsl:with-param name="declared_module" select="$fileNameSuffix"/>
        </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="modules"
        select="'(A1-A3),(A4),(A5),(B1),(B2),(B3),(B4),(B5),(B6),(C1),(C2),(C3),(C3C4),(C3$a),(C3$b),(C3$c),(C3$d),(C3$e),(C4),(C4$a),(C4$b),(C4$c),(C4$d),(C4$e),(D),(D_aus_C3C4),(D$a),(D$b),(D$c),(D$d),(D$e),(D_aus_A),(D_aus_C),(D_aus_C3),(D_aus_C4),(D_aus_C3C4),(50_50-C3_C4)'"/>


    <xsl:variable name="cat_mapping" select="document('oekobaudat_categories.xml')"/>

    <xsl:variable name="subtype_mapping" select="document('oekobaudat_subtypes.xml')"/>

    <!--    <xsl:template match="processing-instruction()|comment()">
        <xsl:text>
</xsl:text>
        <xsl:copy/>
    </xsl:template>
-->
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- copy -->
    <xsl:template match="process:processDataSet">
        <xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="http://iai-uiserv1.iai.kit.edu/EPD/stylesheets/epd2html.xsl"</xsl:processing-instruction>
        <xsl:text>
</xsl:text>
        <processDataSet xmlns="http://lca.jrc.it/ILCD/Process" xmlns:common="http://lca.jrc.it/ILCD/Common" xmlns:epd="http://www.iai.kit.edu/EPD/2013"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <xsl:apply-templates select="@*|*"/>
        </processDataSet>
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

    <!-- entferne Version-Suffixe von URIs -->
    <xsl:template match="@uri">
        <xsl:choose>
            <xsl:when test="starts-with(., '../')">
                <xsl:attribute name="uri">
                    <xsl:analyze-string select="." regex="(.*)_(.*)(\.xml)">
                        <xsl:matching-substring>
                            <xsl:value-of select="concat(regex-group(1),regex-group(3))"/>
                        </xsl:matching-substring>
                        <xsl:non-matching-substring>
                            <xsl:value-of select="."/>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- entferne versions-Attribute von Objektverweisen -->
    <xsl:template match="@version[parent::*[@refObjectId]]"/>



    <xsl:template match="@epd0:*">
        <xsl:attribute name="epd:{local-name()}" namespace="http://www.iai.kit.edu/EPD/2013">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="epd0:*">
        <xsl:element name="epd:{local-name()}" namespace="http://www.iai.kit.edu/EPD/2013">
            <xsl:apply-templates select="node()|@*"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="epd0:EPD">
        <xsl:apply-templates select="epd0:LCIIndicators"/>
        <xsl:apply-templates select="epd0:LCIAIndicators"/>
    </xsl:template>


    <xsl:template match="epd0:LCIIndicators"/>


    <xsl:template match="process:exchanges">
        <xsl:element name="exchanges" namespace="http://lca.jrc.it/ILCD/Process">
            <xsl:apply-templates/>

            <!-- if no reference flow is present, maybe in one of the datasets for the other phases -->
            <xsl:if test="not(process:exchange)">

                <xsl:variable name="refFlows">
                    <xsl:for-each select="tokenize($modules, ',')">
                        <xsl:variable name="currentmodule" select="string(.)"/>
                        <xsl:variable name="relatedFileName" select="concat($fileNameNoSuffix, '_', $currentmodule, '.xml')"/>
                        <xsl:variable name="fileAvailable" select="doc-available($relatedFileName)"/>

                        <xsl:if test="$currentmodule!=$fileNameSuffix and $fileAvailable">
                            <xsl:apply-templates select="document($relatedFileName)/process:processDataSet/process:exchanges/process:exchange"/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:if test="count($refFlows/process:exchange) &gt; 0">
                    <xsl:apply-templates select="$refFlows/process:exchange[1]"/>
                </xsl:if>
            </xsl:if>

            <xsl:apply-templates select="/process:processDataSet/common:other/epd0:EPD/epd0:LCIIndicators/epd0:indicator"/>

            <xsl:for-each select="tokenize($modules, ',')">
                <xsl:variable name="currentmodule" select="string(.)"/>
                <xsl:variable name="relatedFileName" select="concat($fileNameNoSuffix, '_', $currentmodule, '.xml')"/>
                <xsl:variable name="fileAvailable" select="doc-available($relatedFileName)"/>

                <xsl:if test="$currentmodule!=$fileNameSuffix and $fileAvailable">
                    <xsl:variable name="foreignRefFlowAmount" select="document($relatedFileName)/process:processDataSet/common:other/epd0:EPD/epd0:referenceFlowAmount/text()"/>
                    <xsl:if test="$referenceFlowAmount!=$foreignRefFlowAmount">
                        <xsl:variable name="deviation" select="round ( abs(  ( number($referenceFlowAmount) * 100) div number($foreignRefFlowAmount) - 100) * 1000 ) div 1000"/>
                        <xsl:variable name="severity">
                            <xsl:choose>
                                <xsl:when test="number($deviation) &gt; number($threshold)">
                                    <xsl:text>ERROR</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>INFO</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="message">
                            <xsl:value-of select="$severity"/><xsl:text>: reference flow amount mismatch</xsl:text>
                            <xsl:choose><xsl:when test="$severity='INFO'">
                                    <xsl:text> below threshold of </xsl:text><xsl:value-of select="$threshold"/>%<xsl:text>.</xsl:text>
                                </xsl:when><xsl:otherwise>
                                    <xsl:text>!</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose><xsl:text> Deviation of </xsl:text><xsl:value-of select="$deviation"></xsl:value-of><xsl:text>%. Should be </xsl:text><xsl:value-of select="$referenceFlowAmount"/>, but found value <xsl:value-of select="$foreignRefFlowAmount"
                            /> in file <xsl:value-of select="$relatedFileName"/>. </xsl:variable>
                        <xsl:message terminate="no"><xsl:value-of select="$message"/></xsl:message>
                    </xsl:if>

                    <xsl:apply-templates select="document($relatedFileName)/process:processDataSet/common:other/epd0:EPD/epd0:LCIIndicators/epd0:indicator">
                        <xsl:with-param name="module">
                            <xsl:call-template name="decodemodule">
                                <xsl:with-param name="declared_module" select="$currentmodule"/>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:apply-templates>
                </xsl:if>
            </xsl:for-each>

        </xsl:element>

    </xsl:template>


    <xsl:template match="process:exchange">
        <xsl:element name="{name()}" namespace="{namespace-uri()}">
            <!-- go process attributes and children -->
            <xsl:apply-templates select="@*|node()"/>
            <xsl:if test="not(process:exchangeDirection)">
                <xsl:element name="exchangeDirection" namespace="{namespace-uri()}">Output</xsl:element>
            </xsl:if>
            <xsl:if test="/process:processDataSet/common:other/epd0:EPD/epd0:referenceFlowAmount/text()!=''">
                <xsl:element name="meanAmount" namespace="http://lca.jrc.it/ILCD/Process">
                    <xsl:value-of select="/process:processDataSet/common:other/epd0:EPD/epd0:referenceFlowAmount"/>
                </xsl:element>
            </xsl:if>
        </xsl:element>
    </xsl:template>


    <xsl:template match="epd0:LCIIndicators/epd0:indicator">
        <xsl:param name="module" select="$moduleDescriptor"/>
        <xsl:element name="exchange" namespace="http://lca.jrc.it/ILCD/Process">
            <xsl:attribute name="epd:module" namespace="http://www.iai.kit.edu/EPD/2013">
                <xsl:value-of select="$module"/>
            </xsl:attribute>
            <xsl:attribute name="dataSetInternalID">
                <xsl:value-of select="position()-1"/>
            </xsl:attribute>
            <xsl:apply-templates select="epd0:referenceToLCIAMethodDataSet" mode="LCI"/>
            <xsl:element name="functionType" namespace="http://lca.jrc.it/ILCD/Process">General reminder flow</xsl:element>
            <xsl:element name="exchangeDirection" namespace="http://lca.jrc.it/ILCD/Process">
                <xsl:value-of select="epd0:exchangeDirection"/>
            </xsl:element>
            <common:other>
                <epd:amount module="SUM">
                    <xsl:value-of select="epd0:totalAmount"/>
                </epd:amount>
                <xsl:apply-templates select="epd0:referenceToUnitGroupDataSet"/>
            </common:other>
        </xsl:element>
    </xsl:template>


    <xsl:template match="epd0:referenceToLCIAMethodDataSet" mode="LCI">
        <xsl:element name="referenceToFlowDataSet" namespace="http://lca.jrc.it/ILCD/Process">
            <xsl:attribute name="type">flow data set</xsl:attribute>
            <xsl:attribute name="refObjectId">
                <xsl:value-of select="@refObjectId"/>
            </xsl:attribute>
            <xsl:attribute name="uri">
                <xsl:variable name="uri1">
                    <xsl:call-template name="string-replace-all">
                        <xsl:with-param name="text" select="@uri"/>
                        <xsl:with-param name="replace" select="'flowproperties'"/>
                        <xsl:with-param name="by" select="'flows'"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="uri2">
                    <xsl:call-template name="string-replace-all">
                        <xsl:with-param name="text" select="$uri1"/>
                        <xsl:with-param name="replace" select="'external_docs'"/>
                        <xsl:with-param name="by" select="'flows'"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:analyze-string select="$uri2" regex="(.*)_(.*)(\.xml)">
                    <xsl:matching-substring>
                        <xsl:value-of select="concat(regex-group(1),regex-group(3))"/>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:value-of select="$uri2"/>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:attribute>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>


    <xsl:template match="epd0:LCIAIndicators">
        <xsl:element name="LCIAResults" namespace="http://lca.jrc.it/ILCD/Process">
            <xsl:apply-templates select="epd0:indicator"/>

            <xsl:for-each select="tokenize($modules, ',')">
                <xsl:variable name="currentmodule" select="string(.)"/>
                <xsl:variable name="relatedFileName" select="concat($fileNameNoSuffix, '_', $currentmodule, '.xml')"/>
                <xsl:variable name="fileAvailable" select="doc-available($relatedFileName)"/>

                <xsl:if test="$currentmodule!=$fileNameSuffix and $fileAvailable">
                    <xsl:apply-templates select="document($relatedFileName)/process:processDataSet/common:other/epd0:EPD/epd0:LCIAIndicators/epd0:indicator">
                        <xsl:with-param name="module">
                            <xsl:call-template name="decodemodule">
                                <xsl:with-param name="declared_module" select="$currentmodule"/>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:apply-templates>
                </xsl:if>
            </xsl:for-each>

        </xsl:element>
    </xsl:template>

    <xsl:template match="epd0:LCIAIndicators/epd0:indicator">
        <xsl:param name="module" select="$moduleDescriptor"/>
        <xsl:element name="LCIAResult" namespace="http://lca.jrc.it/ILCD/Process">
            <xsl:attribute name="epd:module" namespace="http://www.iai.kit.edu/EPD/2013">
                <xsl:value-of select="$module"/>
            </xsl:attribute>
            <xsl:apply-templates select="epd0:referenceToLCIAMethodDataSet" mode="LCIA"/>
            <common:other>
                <epd:amount module="SUM">
                    <xsl:value-of select="epd0:totalAmount"/>
                </epd:amount>
                <xsl:apply-templates select="epd0:referenceToUnitGroupDataSet"/>
            </common:other>
        </xsl:element>
    </xsl:template>


    <xsl:template match="epd0:referenceToLCIAMethodDataSet" mode="LCIA">
        <xsl:element name="referenceToLCIAMethodDataSet" namespace="http://lca.jrc.it/ILCD/Process">
            <xsl:attribute name="type">LCIA method data set</xsl:attribute>
            <xsl:attribute name="refObjectId">
                <xsl:value-of select="@refObjectId"/>
            </xsl:attribute>
            <xsl:attribute name="uri">
                <xsl:variable name="uri">
                    <xsl:call-template name="string-replace-all">
                        <xsl:with-param name="text" select="@uri"/>
                        <xsl:with-param name="replace" select="'flowproperties'"/>
                        <xsl:with-param name="by" select="'lciamethods'"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:analyze-string select="$uri" regex="(.*)_(.*)(\.xml)">
                    <xsl:matching-substring>
                        <xsl:value-of select="concat(regex-group(1),regex-group(3))"/>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:value-of select="$uri"/>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:attribute>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="epd0:referenceToUnitGroupDataSet">
        <xsl:element name="epd:referenceToUnitGroupDataSet" namespace="http://www.iai.kit.edu/EPD/2013">
            <xsl:attribute name="type">unit group data set</xsl:attribute>
            <xsl:attribute name="refObjectId">
                <xsl:value-of select="@refObjectId"/>
            </xsl:attribute>
            <xsl:attribute name="uri">
                <xsl:apply-templates select="@uri"/>
            </xsl:attribute>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>



    <xsl:template match="common:other">
        <xsl:apply-templates/>
    </xsl:template>


    <!-- insert comments from related datasets -->
    <xsl:template match="common:generalComment">
        <xsl:element name="{name()}" namespace="{namespace-uri()}">
            <xsl:apply-templates select="@*"/>
            <xsl:copy-of select="text()"/>

            <xsl:for-each select="tokenize($modules, ',')">
                <xsl:variable name="currentmodule" select="string(.)"/>
                <xsl:variable name="relatedFileName" select="concat($fileNameNoSuffix, '_', $currentmodule, '.xml')"/>
                <xsl:variable name="fileAvailable" select="doc-available($relatedFileName)"/>

                <xsl:if test="$currentmodule!=$fileNameSuffix and $fileAvailable">
                    <xsl:text> </xsl:text>
                    <xsl:copy-of select="document($relatedFileName)/process:processDataSet/process:processInformation/process:dataSetInformation/common:generalComment/text()"/>
                </xsl:if>
            </xsl:for-each>

        </xsl:element>
    </xsl:template>


    <xsl:template match="process:quantitativeReference">
        <xsl:choose>
            <xsl:when test="@type='Reference flow(s)' and process:referenceToReferenceFlow/text()">
                <xsl:element name="{local-name()}" namespace="http://lca.jrc.it/ILCD/Process">
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <!-- if quantitative reference is wrong or missing, try to repair -->
                <!-- let's try to repair this -->
                <xsl:choose>
                    <!-- if there is an exchange with an ID, we're good -->
                    <xsl:when test="/process:processDataSet/process:exchanges/process:exchange[1]/@dataSetInternalID">
                        <xsl:element name="{local-name()}" namespace="http://lca.jrc.it/ILCD/Process">
                            <xsl:attribute name="type" select="'Reference flow(s)'"/>
                            <xsl:element name="referenceToReferenceFlow" namespace="http://lca.jrc.it/ILCD/Process">
                                <xsl:value-of select="/process:processDataSet/process:exchanges/process:exchange[1]/@dataSetInternalID"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:when>
                    <!-- if not, let's see if we can find one in another dataset -->
                    <xsl:otherwise>
                        <xsl:variable name="qrefs">
                            <xsl:for-each select="tokenize($modules, ',')">
                                <xsl:variable name="currentmodule" select="string(.)"/>
                                <xsl:variable name="relatedFileName" select="concat($fileNameNoSuffix, '_', $currentmodule, '.xml')"/>
                                <xsl:variable name="fileAvailable" select="doc-available($relatedFileName)"/>
                                <xsl:if test="$currentmodule!=$fileNameSuffix and $fileAvailable">
                                    <xsl:apply-templates select="document($relatedFileName)/process:processDataSet/process:processInformation/process:quantitativeReference"/>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:if test="count($qrefs/process:quantitativeReference[@type='Reference flow(s)' and process:referenceToReferenceFlow/text()]) &gt; 0">
                            <xsl:apply-templates select="$qrefs/process:quantitativeReference[1]"/>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>


    <!-- cut numbers and modules from name -->
    <xsl:template match="process:baseName[@xml:lang='de']/text()">
        <xsl:analyze-string select="." regex="[0-9]+\.[0-9]+\.[0-9]+.?(.*)\(.*\)">
            <!-- .{1}(.*).{1}\(.*\) -->
            <xsl:matching-substring>
                <xsl:value-of select="normalize-space(regex-group(1))"/>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <!-- cut numbers and modules from name -->
    <xsl:template match="process:baseName[@xml:lang='en']/text()">
        <xsl:analyze-string select="." regex="(.*) \(EN15804.*">
            <!-- .{1}(.*).{1}\(.*\) -->
            <xsl:matching-substring>
                <xsl:value-of select="normalize-space(regex-group(1))"/>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    
    <!-- insert oekobaudat classification -->
    <xsl:template match="process:classificationInformation">
        <xsl:element name="{name()}" namespace="{namespace-uri()}">
<!--            <xsl:apply-templates/>-->
            <xsl:variable name="category_code">
                <xsl:analyze-string select="/process:processDataSet/process:processInformation/process:dataSetInformation/process:name/process:baseName/text()"
                    regex="([0-9]+\.[0-9]+\.[0-9]+).?(.*)\(.*\)">
                    <xsl:matching-substring>
                        <xsl:value-of select="normalize-space(regex-group(1))"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:variable>

            <xsl:variable name="category_code_0" select="substring-before($category_code, '.')"/>

            <xsl:variable name="category_code_1" select="substring-before(substring-after($category_code, concat($category_code_0,'.')), '.')"/>

            <xsl:variable name="category_code_2">
                <xsl:call-template name="substring-after-last">
                    <xsl:with-param name="delimiter" select="'.'"/>
                    <xsl:with-param name="string" select="$category_code"/>
                </xsl:call-template>
            </xsl:variable>

            <common:classification name="OEKOBAU.DAT">
                <common:class level="0" classId="{$cat_mapping/cats/cat[@code=$category_code_0]/@code}">
                    <xsl:value-of select="$cat_mapping/cats/cat[@code=$category_code_0]/@name"/>
                </common:class>
                <common:class level="1" classId="{$cat_mapping/cats/cat[@code=concat($category_code_0,'.',$category_code_1)]/@code}">
                    <xsl:value-of select="$cat_mapping/cats/cat[@code=concat($category_code_0,'.',$category_code_1)]/@name"/>
                </common:class>
                <common:class level="2" classId="{$cat_mapping/cats/cat[@code=concat($category_code_0,'.',$category_code_1,'.',$category_code_2)]/@code}">
                    <xsl:value-of select="$cat_mapping/cats/cat[@code=concat($category_code_0,'.',$category_code_1,'.',$category_code_2)]/@name"/>
                </common:class>
            </common:classification>
        </xsl:element>
    </xsl:template>


    <!-- fix type of dataset -->
    <xsl:template match="process:typeOfDataSet/text()">
        <xsl:value-of select="'EPD'"/>
    </xsl:template>

    <!-- insert EPD subtype -->
    <!-- THIS IS A MERELY HEURISTIC APPROACH!! (as this information is not explicitly available yet)  -->
    <xsl:template match="process:LCIMethodAndAllocation">
        <xsl:element name="{name()}" namespace="{namespace-uri()}">
            <xsl:apply-templates/>

            <xsl:choose>
                <!-- lookup in mapping table -->
                <xsl:when test="count($subtype_mapping/items/item[@id=$uuid])!=0">
                    <common:other>
                        <epd:subType>
                            <xsl:value-of select="$subtype_mapping/items/item[@id=$uuid]/@type"/>
                            <xsl:text> dataset</xsl:text>
                        </epd:subType>
                    </common:other>
                </xsl:when>
                <!-- owner is PE: generic dataset -->
                <xsl:when
                    test="/process:processDataSet/process:administrativeInformation/process:publicationAndOwnership/common:referenceToOwnershipOfDataSet/common:shortDescription[@xml:lang='de']/text()='PE INTERNATIONAL'">
                    <common:other>
                        <epd:subType>generic dataset</epd:subType>
                    </common:other>
                </xsl:when>
                <!-- owner is BV Gips: representative dataset -->
                <xsl:when
                    test="/process:processDataSet/process:administrativeInformation/process:publicationAndOwnership/common:referenceToOwnershipOfDataSet/@refObjectId='f1138191-3176-41ed-8ce6-b0e335732e04'">
                    <common:other>
                        <epd:subType>representative dataset</epd:subType>
                    </common:other>
                </xsl:when>
                <!-- owner is DBC: average dataset -->
                <xsl:when
                    test="/process:processDataSet/process:administrativeInformation/process:publicationAndOwnership/common:referenceToOwnershipOfDataSet/@refObjectId='3b80251d-e09c-466b-b471-31a945a879c4'">
                    <common:other>
                        <epd:subType>template dataset</epd:subType>
                    </common:other>
                </xsl:when>
            </xsl:choose>
        </xsl:element>

    </xsl:template>

    <!-- replace compliance with EN15804 -->
    <xsl:template match="process:modellingAndValidation">
        <xsl:element name="{name()}" namespace="{namespace-uri()}">
            <xsl:apply-templates select="*[local-name()!='complianceDeclarations']"/>
            <xsl:element name="complianceDeclarations" namespace="{namespace-uri()}">
                <xsl:element name="compliance" namespace="{namespace-uri()}">
                    <common:referenceToComplianceSystem type="source data set" uri="../sources/b00f9ec0-7874-11e3-981f-0800200c9a66.xml"
                        refObjectId="b00f9ec0-7874-11e3-981f-0800200c9a66">
                        <common:shortDescription xml:lang="de">DIN EN 15804</common:shortDescription>
                        <common:shortDescription xml:lang="en">DIN EN 15804</common:shortDescription>
                    </common:referenceToComplianceSystem>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>


    <!-- add version number -->
    <xsl:template match="process:publicationAndOwnership">
        <xsl:choose>
            <xsl:when test="count(common:dataSetVersion)>0">
                <xsl:element name="{name()}" namespace="{namespace-uri()}">
                    <common:dataSetVersion><xsl:copy-of select="common:dataSetVersion/text()"/></common:dataSetVersion>
                    <xsl:apply-templates select="*[local-name()!='dataSetVersion']"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="{name()}" namespace="{namespace-uri()}">
                    <common:dataSetVersion>00.02.000</common:dataSetVersion>
                    <xsl:apply-templates select="*[local-name()!='dataSetVersion']"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="process:dataEntryBy">
        <xsl:element name="{name()}" namespace="{namespace-uri()}">
            <common:timeStamp>
                <xsl:value-of select="current-dateTime()"/>
            </common:timeStamp>
            <common:referenceToDataSetFormat refObjectId="a97a0155-0234-4b87-b4ce-a45da52f2a40" type="source data set"
                uri="../sources/ILCD_Format_a97a0155-0234-4b87-b4ce-a45da52f2a40.xml">
                <common:shortDescription xml:lang="de">ILCD format 1.1</common:shortDescription>
                <common:shortDescription xml:lang="en">ILCD format 1.1</common:shortDescription>
            </common:referenceToDataSetFormat>
            <common:referenceToDataSetFormat type="source data set" refObjectId="cba73800-7874-11e3-981f-0800200c9a66" uri="../sources/cba73800-7874-11e3-981f-0800200c9a66.xml">
                <common:shortDescription xml:lang="de">EPD-Datenformaterweiterungen</common:shortDescription>
                <common:shortDescription xml:lang="en">EPD Data Format Extensions</common:shortDescription>
            </common:referenceToDataSetFormat>
            <xsl:apply-templates select="*[local-name()!='timeStamp' and local-name()!='referenceToDataSetFormat']"/>
        </xsl:element>
    </xsl:template>

    <!-- replace schema -->
    <xsl:template match="@xsi:schemaLocation">
        <xsl:choose>
            <xsl:when test="contains(., 'ILCD_ProcessDataSet')">
                <xsl:attribute name="xsi:schemaLocation" select="replace(., 'ILCD_ProcessDataSet', 'EPD_DataSet')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="decodemodule">
        <xsl:param name="declared_module"/>
        <xsl:choose>
            <xsl:when test="$declared_module='(A1-A3)'">
                <xsl:value-of select="'A1-A3'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(A1)'">
                <xsl:value-of select="'A1'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(A2)'">
                <xsl:value-of select="'A2'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(A3)'">
                <xsl:value-of select="'A3'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(A4)'">
                <xsl:value-of select="'A4'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(A5)'">
                <xsl:value-of select="'A5'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(B1)'">
                <xsl:value-of select="'B1'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(B2)'">
                <xsl:value-of select="'B2'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(B3)'">
                <xsl:value-of select="'B3'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(B4)'">
                <xsl:value-of select="'B4'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(B5)'">
                <xsl:value-of select="'B5'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(B6)'">
                <xsl:value-of select="'B6'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(B7)'">
                <xsl:value-of select="'B7'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(C1)'">
                <xsl:value-of select="'C1'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(C2)'">
                <xsl:value-of select="'C2'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(C3)'">
                <xsl:value-of select="'C3'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(C3C4)'">
                <xsl:value-of select="'C4'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(C3$a)'">
                <xsl:value-of select="'C3_$a'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(C3$b)'">
                <xsl:value-of select="'C3_$b'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(C3$c)'">
                <xsl:value-of select="'C3_$c'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(C3$d)'">
                <xsl:value-of select="'C3_$d'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(C3$e)'">
                <xsl:value-of select="'C3_$e'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(C4)'">
                <xsl:value-of select="'C4'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(C4$a)'">
                <xsl:value-of select="'C4_$a'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(C4$b)'">
                <xsl:value-of select="'C4_$b'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(C4$c)'">
                <xsl:value-of select="'C4_$c'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(C4$d)'">
                <xsl:value-of select="'C4_$d'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(C4$e)'">
                <xsl:value-of select="'C4_$e'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(D)'">
                <xsl:value-of select="'D'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(D$a)'">
                <xsl:value-of select="'D_$a'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(D$b)'">
                <xsl:value-of select="'D_$b'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(D$c)'">
                <xsl:value-of select="'D_$c'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(D$d)'">
                <xsl:value-of select="'D_$d'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(D$e)'">
                <xsl:value-of select="'D_$e'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(D_aus_A)'">
                <xsl:value-of select="'D'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(D_aus_C)'">
                <xsl:value-of select="'D'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(D_aus_C3)'">
                <xsl:value-of select="'D'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(D_aus_C4)'">
                <xsl:value-of select="'D'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(D_aus_C3C4)'">
                <xsl:value-of select="'D'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(50_50-C3_C4)'">
                <xsl:value-of select="'D'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">Unknown module: '<xsl:value-of select="$declared_module"/>'</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--    <xsl:template name="decodemodule">
        <xsl:param name="declared_module"/>
        <xsl:choose>
            <xsl:when test="$declared_module='(A1-A3)'">
                <xsl:value-of select="'A1-A3_PRODUCTION'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(A4)'">
                <xsl:value-of select="'A4_TRANSPORT'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(A5)'">
                <xsl:value-of select="'A5_INSTALLATION'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(B6)'">
                <xsl:value-of select="'B6_ENERGY_USE'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(C3)'">
                <xsl:value-of select="'C3_WASTE_PROCESSING'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(C3$a)'">
                <xsl:value-of select="'C3_WASTE_PROCESSING_$a'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(C3$b)'">
                <xsl:value-of select="'C3_WASTE_PROCESSING_$b'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(C3$c)'">
                <xsl:value-of select="'C3_WASTE_PROCESSING_$c'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(C3$d)'">
                <xsl:value-of select="'C3_WASTE_PROCESSING_$d'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(C3$e)'">
                <xsl:value-of select="'C3_WASTE_PROCESSING_$e'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(C4)'">
                <xsl:value-of select="'C4_DISPOSAL'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(C4$a)'">
                <xsl:value-of select="'C4_DISPOSAL_$a'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(C4$b)'">
                <xsl:value-of select="'C4_DISPOSAL_$b'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(C4$c)'">
                <xsl:value-of select="'C4_DISPOSAL_$c'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(C4$d)'">
                <xsl:value-of select="'C4_DISPOSAL_$d'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(C4$e)'">
                <xsl:value-of select="'C4_DISPOSAL_$e'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(D)'">
                <xsl:value-of select="'D_RECYCLING_POTENTIAL'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(D$a)'">
                <xsl:value-of select="'D_RECYCLING_POTENTIAL_$a'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(D$b)'">
                <xsl:value-of select="'D_RECYCLING_POTENTIAL_$b'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(D$c)'">
                <xsl:value-of select="'D_RECYCLING_POTENTIAL_$c'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(D$d)'">
                <xsl:value-of select="'D_RECYCLING_POTENTIAL_$d'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(D$e)'">
                <xsl:value-of select="'D_RECYCLING_POTENTIAL_$e'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(D_aus_A)'">
                <xsl:value-of select="'D_from_A'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(D_aus_C)'">
                <xsl:value-of select="'D_from_C'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(D_aus_C3)'">
                <xsl:value-of select="'D_from_C3'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(D_aus_C4)'">
                <xsl:value-of select="'D_from_C4'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(50_50-C3_C4)'">
                <xsl:value-of select="'50_50-C3_C4'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(C3C4)'">
                <xsl:value-of select="'C3_C4'"/>
            </xsl:when>
            <xsl:when test="$declared_module='(D_aus_C3C4)'">
                <xsl:value-of select="'D_from_C3C4'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">Unknown module: '<xsl:value-of select="$declared_module"/>'</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    -->



</xsl:stylesheet>
