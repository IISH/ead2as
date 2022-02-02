<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ead="urn:isbn:1-931666-22-9" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <xsl:template match="node()|@*">
        <xsl:apply-templates select="node() | @*"/>
    </xsl:template>

    <xsl:template match="ead:ead">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="ead"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="node()|@*" mode="ead">
        <xsl:copy>
        <xsl:apply-templates select="node() | @*" mode="ead"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>