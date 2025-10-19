<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:author="http://example.org">

    <!-- identity template - this just copies whatever it sees recursively       -->
    <!-- later templates will override that behavior for author defined elements -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- helpers to decompose strings like "(200, 20)" into x and y coordinates -->
    <xsl:template name="xFromCoords">
        <xsl:param name="coords"/>
        <xsl:value-of select="number(normalize-space(substring-before(substring-after($coords, '('), ',')))"/>
    </xsl:template>
    <xsl:template name="yFromCoords">
        <xsl:param name="coords"/>
        <xsl:value-of select="number(normalize-space(substring-before(substring-after($coords, ','), ')')))"/>
    </xsl:template>

    <!-- expansion for "author:array" elements -->
    <xsl:template match="author:array">
        <!-- store the expected attributes into variables to use in this template -->
        <xsl:variable name="name" select="@name"/>
        <xsl:variable name="anchor" select="@anchor"/>

        <!-- capture all the elements -->
        <xsl:variable name="elements" select="author:element"/>
        <xsl:variable name="num-elements" select="count($elements)"/>

        <!-- extract x and y coordinates from the anchor -->
        <xsl:variable name="anchor-x">
            <xsl:call-template name="xFromCoords">
                <xsl:with-param name="coords" select="$anchor"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="anchor-y">
            <xsl:call-template name="yFromCoords">
                <xsl:with-param name="coords" select="$anchor"/>
            </xsl:call-template>
        </xsl:variable>
        <!-- width is optional and defaults to 120 -->
        <xsl:variable name="width">
            <xsl:choose>
                <xsl:when test="@width">
                    <xsl:value-of select="@width"/>
                </xsl:when>
                <xsl:otherwise>120</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- height is based on the number of elements contained -->
        <xsl:variable name="height">
            <xsl:value-of select="20 * $num-elements"/>
        </xsl:variable>

        <group at="array-{$name}"
               font="monospace">
            <!-- draw the rectangle for the array -->
            <rect lower-left="({$anchor-x}, {$anchor-y})" dimensions="({$width}, {$height})" stroke="black">
            <!-- draw each element of the array -->
                <xsl:for-each select="$elements">
                    <author:variable
                        name="{$name}[{position() - 1}]"
                        value="{.}"
                        anchor="({$anchor-x}, {$anchor-y + (20 * (position() - 1))})"
                        width="{$width}"/>
                </xsl:for-each>
            </rect>
        </group>

    </xsl:template>

</xsl:stylesheet>