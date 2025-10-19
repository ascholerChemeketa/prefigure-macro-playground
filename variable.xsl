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

    <!-- expansion for "author:variable" elements -->
    <xsl:template match="author:variable">
        <!-- store the expected attributes into variables to use in this template -->
        <xsl:variable name="name" select="@name"/>
        <xsl:variable name="value" select="@value"/>
        <xsl:variable name="anchor" select="@anchor"/>
        <!-- width is optional and defaults to 120 -->
        <xsl:variable name="width">
            <xsl:choose>
                <xsl:when test="@width">
                    <xsl:value-of select="@width"/>
                </xsl:when>
                <xsl:otherwise>120</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- height is always 20 -->
        <xsl:variable name="height">20</xsl:variable>

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

        <!-- calculate y location of labels - center of rectangle -->
        <xsl:variable name="label-y">
            <xsl:value-of select="$anchor-y + ($height div 2)"/>
        </xsl:variable>
        <!-- calculate x location of value - center of rectangle -->
        <xsl:variable name="value-label-x">
            <xsl:value-of select="$anchor-x + ($width div 2)"/>
        </xsl:variable>

        <!-- create a group to hold the variable name, box, and value -->
        <!-- when used in the string value of an attribute, {$name}   -->
        <!-- inserts the value of the variable "name"                 -->
        <group at="variable-{$name}"
               font="monospace">
            <label at="variable-x-{$name}"
                   anchor="({$anchor-x}, {$label-y})"
                   alignment="west">
                <!-- To use a variable in the body of an element, we must -->
                <!-- use xsl:value-of to insert its value                 -->
                <xsl:value-of select="$name"/>
            </label>
            <rectangle lower-left="{$anchor}"
                       dimensions="({$width}, {$height})"
                       stroke="black"
                       thickness="1">
            </rectangle>
            <label at="variable-{$name}-value"
                   anchor="({$value-label-x}, {$label-y})"
                   alignment="c">
                <xsl:value-of select="$value"/>
            </label>
        </group>
    </xsl:template>

    <!-- expansion for "author:variable-annotation" elements -->
    <xsl:template match="author:variable-annotation">
        <!-- store the expected attributes into variables to use in this template -->
        <xsl:variable name="ref" select="@ref"/>

        <!-- get the related variable by matching "ref" attribute to variable "at" -->
        <xsl:variable name="related-variable" select="//author:variable[@at=current()/@ref]"/>

        <!-- Now create the annotation element -->
        <annotation ref="{$related-variable/@at}"
                  text="The variable {$related-variable/@name}">
            <annotation ref="variable-{$related-variable/@name}-value"
                        text="The value of {$related-variable/@name} is {$related-variable/@value}"/>
        </annotation>
    </xsl:template>

    <xsl:template match="author:pointer">
        <!-- store the expected attributes into variables to use in this template -->
        <xsl:variable name="name" select="@name"/>
        <xsl:variable name="anchor" select="@anchor"/>
        <xsl:variable name="ref" select="@ref"/>
        <!-- width is optional and defaults to 120 -->
        <xsl:variable name="width">
            <xsl:choose>
                <xsl:when test="@width">
                    <xsl:value-of select="@width"/>
                </xsl:when>
                <xsl:otherwise>120</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- height is always 20 -->
        <xsl:variable name="height">20</xsl:variable>

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

        <!-- calculate y location of labels - center of rectangle -->
        <xsl:variable name="label-y">
            <xsl:value-of select="$anchor-y + ($height div 2)"/>
        </xsl:variable>
        <!-- calculate x location of value - center of rectangle -->
        <xsl:variable name="value-label-x">
            <xsl:value-of select="$anchor-x + ($width div 2)"/>
        </xsl:variable>

        <!-- get the related variable by matching "ref" attribute to variable "at" -->
        <xsl:variable name="related-variable" select="//author:variable[@at=current()/@ref]"/>

        <!-- create a group to hold the variable name, box, and value -->
        <!-- when used in the string value of an attribute, {$name}   -->
        <!-- inserts the value of the variable "name"                 -->
        <group at="pointer-{$name}"
               font="monospace">
            <label at="pointer-x-{$name}"
                   anchor="({$anchor-x}, {$label-y})"
                   alignment="west">
                <!-- To use a variable in the body of an element, we must -->
                <!-- use xsl:value-of to insert its value                 -->
                <xsl:value-of select="$name"/>
            </label>
            <rectangle lower-left="({$anchor-x}, {$anchor-y})"
                       dimensions="({$width}, {$height})"
                       stroke="black"
                       thickness="1">
            </rectangle>
            <label at="pointer-{$name}-value"
                   anchor="({$value-label-x}, {$label-y})"
                   alignment="c">
                <xsl:value-of select="$related-variable/@value"/>
            </label>
        </group>
    </xsl:template>

</xsl:stylesheet>