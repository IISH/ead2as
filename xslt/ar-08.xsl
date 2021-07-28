<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ead="urn:isbn:1-931666-22-9"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="ead xlink">

    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>

    <!-- verwijder komma's -->
    <xsl:template match="ead:langmaterial">
        <xsl:variable name="label" select="@label"/>
        <xsl:for-each select="ead:language">
            <ead:langmaterial>
                <xsl:attribute name="label">
                    <xsl:value-of select="$label"/>
                </xsl:attribute>
                <xsl:attribute name="encodinganalog">546$a</xsl:attribute>
                <xsl:copy>
                    <xsl:apply-templates select="node() | @*"/>
                </xsl:copy>
            </ead:langmaterial>
        </xsl:for-each>
    </xsl:template>

    <!-- verwijder @encodinganalog -->
    <xsl:template match="ead:langmaterial/ead:language/@encodinganalog[.='041$a']"/>
    <xsl:template match="ead:langmaterial/ead:language/@encodinganalog[.='041a']"/>

</xsl:stylesheet>