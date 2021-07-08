<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ead="urn:isbn:1-931666-22-9"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:ext="java:org.Utils"
                exclude-result-prefixes="ead xlink ext">

    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ead:unittitle[ead:unitdate]">
        <xsl:variable name="unitdate" select="ext:unitdate(ead:unitdate/text())"/>
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
        <ead:unitdate calendar="gregorian" era="ce">
            <xsl:value-of select="$unitdate"/>
        </ead:unitdate>
    </xsl:template>

    <!-- verwijder het unitdate element, maar hou de tekst erin. -->
    <xsl:template match="ead:unittitle/ead:unitdate">
        <xsl:value-of select="text()"/>
    </xsl:template>

</xsl:stylesheet>