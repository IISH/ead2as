<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ead="urn:isbn:1-931666-22-9"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="ead xlink">

    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ead:descgrp[not(ead:address)
and not(ead:chronlist)
and not(ead:list)
and not(ead:note)
and not(ead:table)
and not(ead:blockquote)
and not(ead:p)
and not(ead:accessrestrict)
and not(ead:accruals)
and not(ead:acqinfo)
and not(ead:altformavail)
and not(ead:appraisal)
and not(ead:arrangement)
and not(ead:bibliography)
and not(ead:bioghist)
and not(ead:controlaccess)
and not(ead:custodhist)
and not(ead:descgrp)
and not(ead:fileplan)
and not(ead:index)
and not(ead:odd)
and not(ead:originalsloc)
and not(ead:otherfindaid)
and not(ead:phystech)
and not(ead:prefercite)
and not(ead:processinfo)
and not(ead:relatedmaterial)
and not(ead:scopecontent)
and not(ead:separatedmaterial)
and not(ead:userestrict)]"/>

</xsl:stylesheet>


