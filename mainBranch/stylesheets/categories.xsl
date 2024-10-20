<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:cat="http://lca.jrc.it/ILCD/Categories"
    xmlns:common="http://lca.jrc.it/ILCD/Common" xmlns:exslt="http://exslt.org/common" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="xsl xs common">


    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="cat:CategorySystem">

        <html>
            <title>
                <xsl:apply-templates select="@name"/>
            </title>
            <body>
                <h2>Category System: <xsl:apply-templates select="@name"/></h2>

                <xsl:apply-templates/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="cat:categories">
        <table cellpadding="3px" cellspacing="3px">
            <tr>
                <td colspan="5">
                    <h3><xsl:apply-templates select="@dataType"/> Categories</h3>
                </td>
            </tr>
            <xsl:apply-templates/>
        </table>
        <br/>
        <br/>
    </xsl:template>

    <xsl:template match="cat:category">
        <xsl:variable name="indent" select="count(ancestor::cat:category)"/>
        <tr>
            <td>
                <xsl:for-each select="ancestor::cat:category">
                    <xsl:text>&#160;&#160;&#160;</xsl:text>
                </xsl:for-each>
                <xsl:choose>
                    <xsl:when test="$indent > 0">
                        <xsl:apply-templates select="@id"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <b>
                            <xsl:apply-templates select="@id"/>
                        </b>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
            <td>&#160;</td>
            <td>
                <xsl:for-each select="ancestor::cat:category">
                    <xsl:text>&#160;&#160;&#160;</xsl:text>
                </xsl:for-each>
                <xsl:choose>
                    <xsl:when test="$indent > 0">
                        <xsl:apply-templates select="@name"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <b>
                            <xsl:apply-templates select="@name"/>
                        </b>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
        <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>
