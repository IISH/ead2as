<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ead="urn:isbn:1-931666-22-9"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="ead xlink">

<!--   verwijder linebreaks: for f in *.txt; do   while read -r line; do [ -n "$line" ] && echo "$line" >> "out/${f}"; done < "$f"; done-->

    <xsl:output method="text"/>

    <xsl:template match="node() | @*">
            <xsl:apply-templates select="node() | @*"/>
    </xsl:template>

    <xsl:template match="ead:acqinfo[@audience='internal']">
        <xsl:apply-templates select="node() | @*" mode="genest"/>
    </xsl:template>


    <xsl:template match="node() | @*" mode="genest">
            <xsl:value-of select="text()"/><xsl:text>
</xsl:text>
        <xsl:apply-templates select="node() | @*" mode="genest"/>
    </xsl:template>

</xsl:stylesheet>