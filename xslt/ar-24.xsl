<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ead="urn:isbn:1-931666-22-9"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="ead xlink">

    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ead:daogrp[ead:daoloc]">
        <xsl:variable name="h" select="ead:daoloc[position()=1]/@xlink:href"/>
        <ead:daogrp xlink:type="extended">
            <ead:daoloc xlink:href="{substring-before($h, '?')}" xlink:type="locator" xlink:label="handle"/>
        </ead:daogrp>
    </xsl:template>

</xsl:stylesheet>