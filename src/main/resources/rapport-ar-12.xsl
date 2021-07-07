<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ead="urn:isbn:1-931666-22-9"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="ead xlink">

    <xsl:template match="ead:ead">
        <ead:ead>
            <xsl:apply-templates select="node() | @*"/>
        </ead:ead>
    </xsl:template>

    <xsl:template match="node() | @*">
            <xsl:apply-templates select="node() | @*"/>
    </xsl:template>

    <xsl:template match="ead:acqinfo">
        <xsl:copy-of select="."/>
    </xsl:template>

</xsl:stylesheet>