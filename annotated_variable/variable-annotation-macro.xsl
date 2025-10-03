<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:author="http://example.org">

    <xsl:import href="../basics-templates.xsl"/>

    <xsl:variable name="default-variable-width"
                  select="120"/>
    <xsl:variable name="default-variable-height"
                  select="20"/>

    <xsl:template match="author:variable">
        <xsl:variable name="name"
                      select="@name"/>
        <xsl:variable name="value"
                      select="@value"/>
        <xsl:variable name="anchor"
                      select="@anchor"/>

        <xsl:variable name="width">
            <xsl:choose>
                <xsl:when test="@width">
                    <xsl:value-of select="@width"/>
                </xsl:when>
                <xsl:otherwise><xsl:value-of select="$default-variable-width"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="height"><xsl:value-of select="$default-variable-height"/></xsl:variable>

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

        <group font="monospace" at="variable-{$name}">
            <label anchor="({$anchor-x}, {$anchor-y} + {$height} / 2)"
                   alignment="west">
                <xsl:value-of select="$name"/>
            </label>
            <rectangle lower-left="{$anchor}"
                       dimensions="({$width}, {$height})"
                       stroke="black"
                       thickness="1">
            </rectangle>
            <label at="variable-{$name}-value"
                   anchor="({$anchor-x} + {$width} / 2,{$anchor-y} + {$height} / 2)"
                   alignment="c">
                <xsl:value-of select="$value"/>
            </label>
        </group>
    </xsl:template>

    <!-- expansion for "author:variable-annotation" elements -->
    <xsl:template match="author:variable-annotation">
        <!-- store the reference attribute into a variable -->
        <xsl:variable name="ref"
                      select="@ref"/>
        <xsl:variable name="var-name"
                      select="substring-after($ref, 'variable-')"/>

        <!-- get the related variable by matching calculated name with variable's name -->
        <xsl:variable name="related-variable"
                      select="//author:variable[@name=$var-name]"/>

        <!-- Now create the annotation element -->
        <annotation ref="{$ref}"
                    text="The variable {$related-variable/@name}">
            <annotation ref="variable-{$related-variable/@name}-value"
                        text="The value of {$related-variable/@name} is {$related-variable/@value}"/>
        </annotation>
    </xsl:template>

</xsl:stylesheet>