<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ead="urn:isbn:1-931666-22-9"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="ead xlink">

    <xsl:variable name="creation" select="ead:ead/ead:eadheader/ead:profiledesc/ead:creation"/>

    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ead:eadheader/ead:profiledesc">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>

        <xsl:if test="not(//ead:eadheader/ead:revisiondesc)">
            <ead:revisiondesc>
                <ead:change>
                    <xsl:choose>
                        <xsl:when test="$creation/ead:date">aaaaaaaaaaaaaaaaaaaaaaa
                            <ead:date calendar="gregorian" era="ce">
                                <xsl:value-of select="$creation/ead:date"/>
                            </ead:date>
                        </xsl:when>
                        <xsl:otherwise>bbbbbbbbbbbbbbbbbbb
                            <ead:date>Undated</ead:date>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="$creation">
                            <ead:item>ccccccccccccccccccccccccccccc
                                <xsl:value-of select="$creation/text()"/>
                            </ead:item>
                        </xsl:when>
                        <xsl:otherwise>dddddddddddddddddddd
                            <ead:item>Finding aid created by IISH Collection Processing Department</ead:item>
                        </xsl:otherwise>
                    </xsl:choose>
                </ead:change>
            </ead:revisiondesc>
        </xsl:if>
    </xsl:template>

    <xsl:template match="ead:profiledesc/ead:creation"/>

    <xsl:template match="ead:revisiondesc">
        <ead:revisiondesc>
            <xsl:copy-of select="node() | @*"/>
            <ead:change>
                <xsl:choose>
                    <xsl:when test="$creation/ead:date">eeeeeeeeeeeeeeeeeee
                        <ead:date calendar="gregorian" era="ce">
                            <xsl:value-of select="$creation/ead:date"/>
                        </ead:date>
                        <ead:item>
                            <xsl:value-of select="$creation/text()"/>
                        </ead:item>
                    </xsl:when>
                    <xsl:when test="$creation">ffffffffffffffffffff
                        <ead:date>Undated</ead:date>
                        <ead:item>
                            <xsl:value-of select="$creation/text()"/>
                        </ead:item>
                    </xsl:when>
                    <xsl:otherwise>
                        <ead:date>Undated</ead:date>
                        <xsl:choose>
                            <xsl:when test="$creation">gggggggggggggggggggggggg
                                <ead:item>
                                    <xsl:value-of select="$creation/text()"/>
                                </ead:item>
                            </xsl:when>
                            <xsl:otherwise>hhhhhhhhhhhhhhhhhhhhhhhhhhhhh
                                <ead:item>Finding aid created by IISH Collection Processing Department</ead:item>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </ead:change>
        </ead:revisiondesc>
    </xsl:template>

</xsl:stylesheet>