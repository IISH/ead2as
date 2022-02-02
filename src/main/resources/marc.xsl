<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:marc="http://www.loc.gov/MARC21/slim">

    <xsl:template match="node()|@*">
        <xsl:apply-templates select="node() | @*"/>
    </xsl:template>

    <xsl:template match="marc:record">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="marc"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="node()|@*" mode="marc">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="marc"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>