<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ead="urn:isbn:1-931666-22-9"
                xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsh="http://www.w3.org/1999/XSL/Transform"
                xmlns:ext="java:org.Utils"
                exclude-result-prefixes="ead xlink ext">

    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ead:unitdate[last()]">
        <xsl:choose>
            <xsl:when test="ext:isUnitDate(.)">
                <xsl:copy>
                    <xsl:apply-templates select="node() | @*"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="text()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ead:unitdate">
        <xsl:value-of select="text()"/>
    </xsl:template>

</xsl:stylesheet>


