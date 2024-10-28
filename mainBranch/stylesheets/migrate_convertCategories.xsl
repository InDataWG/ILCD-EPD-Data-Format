<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    
    <xsl:output indent="yes"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="cats">
        <CategorySystem xmlns="http://lca.jrc.it/ILCD/Categories" xmlns:common="http://lca.jrc.it/ILCD/Common" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://lca.jrc.it/ILCD/Categories ../schemas/ILCD_Categories.xsd" name="OEKOBAU.DAT">
            <categories dataType="Process">
                
                <xsl:for-each-group select="cat" group-adjacent="@code">
                    
                    <category id="{@code}" name="{@name}">

                        <xsl:variable name="parentCode" select="@code"/>

                        <xsl:for-each-group select="current-group()" group-adjacent="starts-with(@code, $parentCode)">
                            
                            <categoryy id="{current-group()[1]/@code}" name="{current-group()[1]/@name}">
                                
                            </categoryy>
                            
                        </xsl:for-each-group>
                        


                    </category>
                    
                </xsl:for-each-group>
                
                
            </categories>
        </CategorySystem>
    </xsl:template>

    <!-- category level 0 -->
    <xsl:template match="cat[not(contains(local-name(), '.'))]" priority="100">
        <category id="{@code}" name="{@name}">

<!--            <xsl:apply-templates select="following-sibling::cat[not(contains(substring-after(local-name(), '.'),'.'))]"/>-->

        </category>

    </xsl:template>


    <!-- category level 1 -->
    <xsl:template match="cat[not(contains(substring-after(@code, '.'),'.'))]" priority="50">

        <category id="{@code}" name="{@name}">
            
        <xsl:apply-templates select="following-sibling::cat[contains(substring-after(local-name(), '.'),'.')]"/>
        </category>
    </xsl:template>


    <!-- category level 2 -->
    <xsl:template match="cat[contains(substring-after(local-name(), '.'),'.')]" priority="10"> 
        <category id="{@code}" name="{@name}"/>
    </xsl:template>

</xsl:stylesheet>
