<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ead="urn:isbn:1-931666-22-9"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:ext="java:org.Utils"
                exclude-result-prefixes="ead xlink ext">

    <xsl:variable name="creation" select="ead:profiledesc/ead:creation"/>

    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ead:profiledesc/ead:creation"/>

    <xsl:template match="ead:revisiondesc">
        <ead:revisiondesc>
            <xsl:copy-of select="node() | @*"/>
            <ead:change>
            <xsl:choose>
                <xsl:when test="$creation/ead:date">
                    <ead:date normal="$creation/ead:date/text()" calendar="gregorian" era="ce"><xsl:value-of select="$creation/ead:date"/></ead:date>
                    <ead:item><xsl:value-of select="$creation/text()"/></ead:item>
                </xsl:when>
                <xsl:when test="$creation">
                    <ead:date>Undated</ead:date>
                    <ead:item><xsl:value-of select="$creation/text()"/></ead:item>
                </xsl:when>
                <xsl:otherwise>
                        <ead:date>Undated</ead:date>
                        <ead:item>Finding aid created by IISH Collection Processing Department</ead:item>
                </xsl:otherwise>
            </xsl:choose>
            </ead:change>
        </ead:revisiondesc>
    </xsl:template>

</xsl:stylesheet>