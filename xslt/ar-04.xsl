<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ead="urn:isbn:1-931666-22-9"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="ead xlink">

    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ead:origination/ead:persname[not(@audience)]|ead:origination/ead:corpname[not(@audience)]">
        <xsl:copy>
            <xsl:attribute name="audience">external</xsl:attribute>
            <xsl:apply-templates select="text()|@*"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>