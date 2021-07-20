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

    <xsl:template match="ead:unittitle[count(ead:unitdate)>1]">
        <xsl:variable name="unitdate" select="ext:unitdate(ead:unitdate/text())"/>
        <xsl:choose>
            <xsl:when test="$unitdate">
                <xsl:copy>
                    <xsl:apply-templates select="node()| @*" mode="no_unitdate"/>
                    <ead:unitdate calendar="gregorian" era="ce">
                        <xsl:value-of select="$unitdate"/>
                    </ead:unitdate>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="node() | @*"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="node() | @*" mode="no_unitdate">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="no_unitdate"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ead:unitdate" mode="no_unitdate"/>

</xsl:stylesheet>