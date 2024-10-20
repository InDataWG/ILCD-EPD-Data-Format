<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- util templates -->
    
    <xsl:template name="incrementVersionNumber">
        <xsl:param name="version"/>
        
        <xsl:variable name="currentVersion" select="$version"/>
        
        <xsl:variable name="currentVersionMaj">
            <xsl:analyze-string select="$currentVersion" regex="(.*)\.(.*)\.(.*)">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        
        <xsl:variable name="currentVersionMin">
            <xsl:analyze-string select="$currentVersion" regex="(.*)\.(.*)\.(.*)">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(2)"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        
        <xsl:variable name="minIncrement">
            <xsl:value-of select="number($currentVersionMin) + 1"/>
        </xsl:variable>
        
        <xsl:variable name="newVersion">
            <xsl:value-of select="concat($currentVersionMaj, '.', format-number($minIncrement, '00'), '.000')"/>
        </xsl:variable>
        
        <xsl:value-of select="$newVersion"/>
        
    </xsl:template>
    
    
    <xsl:template name="substring-after-last">
        <xsl:param name="string"/>
        <xsl:param name="delimiter"/>
        <xsl:choose>
            <xsl:when test="contains($string, $delimiter)">
                <xsl:call-template name="substring-after-last">
                    <xsl:with-param name="string" select="substring-after($string, $delimiter)"/>
                    <xsl:with-param name="delimiter" select="$delimiter"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$string"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="substring-before-last">
        <xsl:param name="string1" select="''"/>
        <xsl:param name="string2" select="''"/>
        
        <xsl:if test="$string1 != '' and $string2 != ''">
            <xsl:variable name="head" select="substring-before($string1, $string2)"/>
            <xsl:variable name="tail" select="substring-after($string1, $string2)"/>
            <xsl:value-of select="$head"/>
            <xsl:if test="contains($tail, $string2)">
                <xsl:value-of select="$string2"/>
                <xsl:call-template name="substring-before-last">
                    <xsl:with-param name="string1" select="$tail"/>
                    <xsl:with-param name="string2" select="$string2"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    
    <xsl:template name="string-replace-all">
        <xsl:param name="text"/>
        <xsl:param name="replace"/>
        <xsl:param name="by"/>
        <xsl:choose>
            <xsl:when test="contains($text, $replace)">
                <xsl:value-of select="substring-before($text,$replace)"/>
                <xsl:value-of select="$by"/>
                <xsl:call-template name="string-replace-all">
                    <xsl:with-param name="text" select="substring-after($text,$replace)"/>
                    <xsl:with-param name="replace" select="$replace"/>
                    <xsl:with-param name="by" select="$by"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>