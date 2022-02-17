<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ead="urn:isbn:1-931666-22-9"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:ext="java:org.Utils" xmlns:xll="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="ead xlink ext">

    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ead:daogrp[ead:daoloc]">
        <xsl:variable name="unittitle" select="ext:shortTitle(parent::ead:did/ead:unittitle)"/>
        <xsl:variable name="h" select="ead:daoloc[position()=1]/@xlink:href"/>
        <xsl:element name="ead:daogrp">
            <xsl:attribute name="xlink:type">extended</xsl:attribute>
            <xsl:if test="string-length($unittitle)!=0">
                <xsl:attribute name="xlink:title"><xsl:value-of select="$unittitle"/></xsl:attribute>
            </xsl:if>
            <ead:daoloc xlink:href="{substring-before(ext:urlDecode($h), '?')}" xlink:type="locator" xlink:label="handle"/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>