<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:cgrid="http://edirom.de/cgrid"
    exclude-result-prefixes="xs tei cgrid"
    version="2.0">
    
    <xsl:output method="xhtml" omit-xml-declaration="yes" encoding="UTF-8" indent="yes"/>
    
    <!-- 
        Create a dummy HTML page with all the URL references from the cgrid TEI files 
        as input for the linkchecker cli 
    -->
    
    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>Extracted Links from the cgrid TEI files</title>
            </head>
            <body>
                <xsl:for-each select="distinct-values(//@target[starts-with(., 'http')])">
                    <a href="{.}"/>
                </xsl:for-each>
            </body>
        </html>
    </xsl:template>
    
</xsl:stylesheet>