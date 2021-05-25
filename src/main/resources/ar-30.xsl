<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ead="urn:isbn:1-931666-22-9"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="ead xlink">

    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ead:physdesc">
        <xsl:for-each select=".">
            <ead:physdesc label="Physical Description"><xsl:apply-templates select="node() | @*"/></ead:physdesc>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>