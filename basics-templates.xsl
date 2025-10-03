<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- identity template - this just copies whatever it sees recursively -->
    <!-- later templates will override that behavior for author defined elements -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- helpers to decompose strings like "(200, 20)" into x and y coordinates -->
    <!-- result is a string as there is no guarantee that the coordinate is not -->
    <!-- a prefig definition or python expression                               -->
    <xsl:template name="xFromCoords">
        <xsl:param name="coords"/>
        <xsl:value-of select="normalize-space(substring-before(substring-after($coords, '('), ','))"/>
    </xsl:template>
    <xsl:template name="yFromCoords">
        <xsl:param name="coords"/>
        <xsl:value-of select="normalize-space(substring-before(substring-after($coords, ','), ')'))"/>
    </xsl:template>

</xsl:stylesheet>