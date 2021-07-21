<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ead="urn:isbn:1-931666-22-9"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="ead xlink">

    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ead:physdesc">

        <xsl:variable name="is_file_bytes_groep" select="count(ead:extent[@unit='bytes' or @unit='file'])"/>
        <xsl:variable name="is_not_file_bytes_groep" select="count(ead:extent[not(@unit='bytes' or @unit='file')])"/>
        <xsl:variable name="altrender">
            <xsl:choose>
                <xsl:when test="$is_not_file_bytes_groep > 1">Part</xsl:when>
                <xsl:when test="$is_file_bytes_groep > 2">Part</xsl:when>
                <xsl:when test="$is_not_file_bytes_groep = 1 and $is_file_bytes_groep > 0">Part</xsl:when>
                <xsl:otherwise>Whole</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- eerst de file en bytes groep in dezelfde physdesc -->
        <xsl:if test="$is_file_bytes_groep > 0">
            <ead:physdesc label="Physical Description" altrender="{$altrender}">
                <xsl:for-each select="ead:extent[@unit='bytes' or @unit='file']">
                    <xsl:copy><xsl:apply-templates select="node() | @*"/></xsl:copy>
                </xsl:for-each>
            </ead:physdesc>
        </xsl:if>

        <!-- Dan de andere groepen ieder in een eigen physdesc -->
        <xsl:if test="$is_not_file_bytes_groep > 0">
            <xsl:for-each select="ead:extent[not(@unit='bytes' or @unit='file')]">
                <ead:physdesc label="Physical Description" altrender="{$altrender}">
                    <xsl:copy><xsl:apply-templates select="node() | @*"/></xsl:copy>
                </ead:physdesc>
            </xsl:for-each>
        </xsl:if>

    </xsl:template>

</xsl:stylesheet>