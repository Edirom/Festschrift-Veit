<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:eg="http://www.tei-c.org/ns/Examples"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:template match="/">
        <xsl:element name="div">
            <xsl:apply-templates select="//eg:egXML"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="eg:egXML">
        <xsl:element name="div">
            <xsl:attribute name="class">highlight</xsl:attribute>
            <xsl:attribute name="style">display: inline-block</xsl:attribute>
            <xsl:element name="pre">
                <xsl:element name="code">
                    <xsl:attribute name="class">language-xml</xsl:attribute>
                    <xsl:attribute name="data-lang">xml</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:element name="span">
            <xsl:attribute name="class">nt</xsl:attribute>
            <xsl:text>&lt;</xsl:text>
            <xsl:value-of select="name()"/>
        </xsl:element>
            <xsl:apply-templates select="@*" mode="#current" />
            <xsl:choose>
                <xsl:when test="node()">
                    <xsl:element name="span">
                        <xsl:attribute name="class">nt</xsl:attribute>
                        <xsl:text>&gt;</xsl:text>
                    </xsl:element>
                    <xsl:apply-templates/>
                    <xsl:element name="span">
                        <xsl:attribute name="class">nt</xsl:attribute>
                        <xsl:text>&lt;/</xsl:text>
                        <xsl:value-of select="name()"/>
                        <xsl:text>&gt;</xsl:text>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="span">
                        <xsl:attribute name="class">nt</xsl:attribute>
                        <xsl:text> /&gt;</xsl:text>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
    </xsl:template>
    
    <xsl:template match="@*">
        <xsl:text> </xsl:text>
        <xsl:element name="span">
            <xsl:attribute name="class">na</xsl:attribute>
            <xsl:value-of select="name()"/>
            <xsl:text>=</xsl:text>
        </xsl:element>
        <xsl:element name="span">
            <xsl:attribute name="class">s</xsl:attribute>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>"</xsl:text>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="comment()">
        <xsl:element name="span">
            <xsl:attribute name="class">c</xsl:attribute>
            <xsl:text>&lt;!--</xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>--&gt;</xsl:text>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>