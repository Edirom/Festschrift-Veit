<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" version="2.0"
    xmlns:functx="http://www.functx.com"
    xmlns:tei="http://www.tei-c.org/ns/1.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> June 24, 2015</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:output omit-xml-declaration="yes" indent="yes" encoding="UTF-8" method="xml"
        media-type="xml"/>
    
    <xsl:variable name="ID-picture-string">
        <xsl:value-of select="concat(tei:basename(document-uri(.)), '-pers000')"/>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:element name="particDesc">
            <xsl:element name="listPerson">
                <xsl:for-each select="distinct-values(//tei:name[ancestor::tei:text])">
                    <!-- Sortiert wird nach dem letzten Namensbestandteil im Text (= hoffentlich der Nachname) -->
                    <xsl:sort select="tokenize(normalize-space(.), ' ')[last()]"/>
                    <xsl:element name="person">
                        <!-- Laufende ID wird vergeben -->
                        <xsl:attribute name="xml:id">
                            <xsl:value-of select="format-number(position(), $ID-picture-string)"/>
                        </xsl:attribute>
                        <!-- Registereintrag in der Form "Nachname, Vorname" -->
                        <xsl:element name="p">
                            <xsl:variable name="nameTokens" select="tokenize(normalize-space(.), ' ')"/>
                            <xsl:value-of select="$nameTokens[last()]"/>
                            <xsl:if test="count($nameTokens) gt 1">
                                <xsl:text>, </xsl:text>
                                <xsl:value-of select="string-join(subsequence($nameTokens, 1, count($nameTokens) -1), ' ')"/>
                            </xsl:if>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    
    <!-- Simple function for grabbing the file basename -->
    <!-- original at http://www.stylusstudio.com/xsllist/handler.asp?/xsllist/199905/post60130.html -->
    <xsl:function name="tei:basename">
        <xsl:param name="path"/>
        <xsl:choose>
            <!-- forward slash for *nix -->
            <xsl:when test="matches($path, '/')">
                <xsl:value-of select="tei:basename(substring-after($path, '/'))"/>
            </xsl:when>
            <!-- backslash for windows -->
            <xsl:when test="matches($path, '\\')">
                <xsl:value-of select="tei:basename(substring-after($path, '\'))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="substring-before($path, '.xml')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    

</xsl:stylesheet>
