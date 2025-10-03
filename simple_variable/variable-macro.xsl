<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:author="http://example.org">

    <!-- import some shared templates-->
    <xsl:import href="../basics-templates.xsl"/>

    <xsl:variable name="default-variable-width" select="120"/>
    <xsl:variable name="default-variable-height" select="20"/>

    <!-- expansion for "author:variable" elements -->
    <xsl:template match="author:variable">
        <!-- store the expected attributes into variables to use in this template -->
        <xsl:variable name="name"
                      select="@name"/>
        <xsl:variable name="value"
                      select="@value"/>
        <xsl:variable name="anchor"
                      select="@anchor"/>

        <!-- width is optional and defaults to 120 -->
        <xsl:variable name="width">
            <xsl:choose>
                <xsl:when test="@width">
                    <xsl:value-of select="@width"/>
                </xsl:when>
                <xsl:otherwise><xsl:value-of select="$default-variable-width"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- height is always 20 -->
        <xsl:variable name="height"><xsl:value-of select="$default-variable-height"/></xsl:variable>

        <!-- extract x and y components from the anchor -->
        <xsl:variable name="anchor-x">
            <xsl:call-template name="xFromCoords">
                <xsl:with-param name="coords"
                                select="$anchor"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="anchor-y">
            <xsl:call-template name="yFromCoords">
                <xsl:with-param name="coords"
                                select="$anchor"/>
            </xsl:call-template>
        </xsl:variable>

        <!-- create a group to hold the variable name, box, and value -->
        <!-- when used in the string value of an attribute, {$name} -->
        <!-- inserts the value of the variable "name" -->
        <group font="monospace">
            <!-- We want to write the new attribute values as text expressions -->
            <!-- so that prefig definitions can be interpreted correctly       -->
            <!-- That means producing something like "(10, 20 + 30 / 2)"       -->
            <!-- or "(10, yBase + 30 / 2)" instead of doing the math in xsl    -->
            <label anchor="({$anchor-x}, {$anchor-y} + {$height} / 2)"
                   alignment="west">
                <!-- To use a variable in the body of an element, we must -->
                <!-- use xsl:value-of to insert its value -->
                <xsl:value-of select="$name"/>
            </label>
            <rectangle lower-left="{$anchor}"
                       dimensions="({$width}, {$height})"
                       stroke="black"
                       thickness="1">
            </rectangle>
            <label anchor="({$anchor-x} + {$width} / 2,{$anchor-y} + {$height} / 2)"
                   alignment="c">
                <xsl:value-of select="$value"/>
            </label>
        </group>
    </xsl:template>

</xsl:stylesheet>