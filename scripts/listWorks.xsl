<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   exclude-result-prefixes="xs"
   version="2.0">
   
   <xsl:output omit-xml-declaration="yes" indent="yes" encoding="UTF-8" method="xml"
      media-type="xml"/>
   
   <xsl:variable name="ID-picture-string">
      <xsl:value-of select="concat(tei:basename(document-uri(.)), '-work000')"/>
   </xsl:variable>
   
   <xsl:template match="/">
      <xsl:element name="particDesc">
         <xsl:element name="listPerson">
            <xsl:for-each select="distinct-values(//tei:title[ancestor::tei:body]/normalize-space())">
               <!-- Sortiert wird nach dem Anfangsbuchstaben -->
               <xsl:sort select="normalize-space(.)"/>
               <xsl:element name="p">
                  <xsl:attribute name="n" select="'work'"/>
                  <!-- Laufende ID wird vergeben -->
                  <xsl:attribute name="xml:id">
                     <xsl:value-of select="format-number(position(), $ID-picture-string)"/>
                  </xsl:attribute>
                  <!-- Registereintrag in der Form "Nachname, Vorname" -->
                  <xsl:value-of select="normalize-space(.)"/>
               </xsl:element>
            </xsl:for-each>
         </xsl:element>
      </xsl:element>
   </xsl:template>
   
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