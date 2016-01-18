<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns="http://www.tei-c.org/ns/1.0"
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   exclude-result-prefixes="xs tei"
   version="2.0">
   
   <xsl:output indent="yes" encoding="UTF-8"/>
   
   <xsl:template match="/">
      <xsl:processing-instruction name="xml-model">href="../schemata/cgrid.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:processing-instruction>
      <xsl:processing-instruction name="xml-model">href="../schemata/cgrid.rng" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction>
      <xsl:apply-templates/>
   </xsl:template>
   
   <xsl:template match="node()|@*">
      <xsl:copy>
         <xsl:apply-templates select="node()|@*"/>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="tei:TEI">
      <xsl:copy>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="tei:teiHeader">
      <xsl:copy>
         <xsl:apply-templates select="tei:fileDesc"/>
         <profileDesc>
            <langUsage>
               <language ident=""/>
            </langUsage>
         </profileDesc>
         <revisionDesc>
            <change when="{current-dateTime()}" who="https://github.com/peterstadler">Initial transformation from OxGarage TEI P5 to jTEI customization.</change>
         </revisionDesc>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="tei:editionStmt"/>
   
   <xsl:template match="tei:publicationStmt">
      <publicationStmt>
         <publisher>Virtueller Forschungsverbund Edirom (ViFE)</publisher>
         <availability>
            <licence target="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License (CC BY 4.0)</licence>
         </availability>
      </publicationStmt>
   </xsl:template>
   
   <xsl:template match="tei:text">
      <xsl:copy>
         <front>
            <div type="abstract" xml:id="abstract"/>
         </front>
         <xsl:apply-templates/>
         <back>
            <div type="bibliography">
               <listBibl>
                  <bibl xml:id="bloggs13"/>
               </listBibl>
            </div>
         </back>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="tei:p">
      <xsl:copy>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="tei:note">
      <xsl:copy>
         <xsl:apply-templates select="node()|@*[not(name()='place')]"/>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="tei:hi">
      <xsl:choose>
         <xsl:when test="matches(normalize-space(@rend), '^color\([^\)]+\)$')">
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy>
               <xsl:apply-templates select="node()|@*"/>
            </xsl:copy>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template match="@rend">
      <xsl:attribute name="rend">
         <xsl:analyze-string select="." regex="color\([^\)]+\)">
            <xsl:non-matching-substring>
               <xsl:value-of select="."/>
            </xsl:non-matching-substring>
         </xsl:analyze-string>
      </xsl:attribute>
   </xsl:template>
   
</xsl:stylesheet>