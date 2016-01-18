<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   exclude-result-prefixes="xs"
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns:cgrid="http://edirom.de/cgrid"
   xmlns:eg="http://www.tei-c.org/ns/Examples"
   version="2.0">
   
   <xsl:output encoding="UTF-8" media-type="text" omit-xml-declaration="yes" indent="no" method="text"/>
   
   <xsl:key name="biblio-refs" match="tei:ref[@type='bibl'][not(tokenize(@rend, '\s+')='inline')]" use="@target"/>
   
   <!-- Params for the LaTeX documentclass to be overwritten from outside -->
   <xsl:param name="documentClass" select="'scrbook'" as="xs:string"/>
   <xsl:param name="output" select="'pdf'" as="xs:string"/>
   <xsl:param name="paper" select="'20.95cm:27.3cm'" as="xs:string"/>
   <xsl:param name="fontsize" select="'10pt'" as="xs:string"/>
   <xsl:param name="headings" select="'small'" as="xs:string"/>
   <xsl:param name="DIV" select="'9'" as="xs:string"/>
   <xsl:param name="revision" select="'0'" as="xs:string"/>
   
   <xsl:variable name="docRoot" select="/"/>
   <xsl:key name="name-index" match="tei:person" use="@xml:id"/>
   
   <xsl:variable name="preamble-documentClass" as="element()">
      <documentClass>
         <xsl:attribute name="type" select="$documentClass"/>
         <option>paper=<xsl:value-of select="$paper"/></option>
         <option>fontsize=<xsl:value-of select="$fontsize"/></option>
         <option>headings=<xsl:value-of select="$headings"/></option>
         <option>DIV=<xsl:value-of select="$DIV"/></option>
         <xsl:if test="$output = 'draft'">
            <option>draft</option>
         </xsl:if>
      </documentClass>
   </xsl:variable>
   
   <xsl:variable name="preamble" as="item()+">
      <xsl:value-of select="concat('\documentclass[', string-join($preamble-documentClass/option, ','), ']{', $preamble-documentClass/@type, '}')"/>
      
      \input{../latex/cgrid-packages.def}
      \input{../latex/cgrid-macros.def}
      \input{../latex/colors.def}
      
      <xsl:if test="$output='print'">
         \hypersetup{linkcolor=black, urlcolor=black, citecolor=black}
      </xsl:if>
      
      \makeindex
      
   </xsl:variable>
   
   <xsl:variable name="titlepage" as="item()+">
      \title{<xsl:apply-templates select="/tei:teiCorpus/tei:teiHeader//tei:title[@type='main']"/>}
      \subtitle{<xsl:apply-templates select="/tei:teiCorpus/tei:teiHeader//tei:title[@type='sub']"/>}
      \author{}
      \publishers{<xsl:apply-templates select="/tei:teiCorpus/tei:teiHeader//tei:editor"/>}
      \date{}
      \extratitle{\centering<xsl:apply-templates select="/tei:teiCorpus/tei:teiHeader//tei:title[@type='main']"/>}
      \input{../latex/lowertitleback.tex}
      <xsl:if test="$revision ne '0'">
         \titlehead{Korrekturfahne, rev. <xsl:value-of select="$revision"/> vom <xsl:value-of select="format-date(current-date(), '[D].&#8239;[M].&#8239;[Y]')"/>}
      </xsl:if>
   </xsl:variable>
   
   <xsl:template match="/">
      <xsl:choose>
         <xsl:when test="$output = 'biblio'">
            <xsl:call-template name="set-biblio"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:call-template name="set-text"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- Default template for typesetting the whole volume -->
   <xsl:template name="set-text">
      <xsl:value-of select="$preamble"/>
      <xsl:value-of select="$titlepage"/>
      <xsl:text>
         \begin{document}
         \mainmatter
         \maketitle
         
         \markleft{Inhaltsverzeichnis}
         \markright{Inhaltsverzeichnis}
         \ohead{} % supress page mark for the TOC
         \tableofcontents
         \cleardoublepage\ohead{\pagemark} % activate page numbering after the TOC
      </xsl:text>
      
      <xsl:apply-templates select="//tei:TEI[@rend='front']"/>   
      
      <!-- Beginn Main Matter -->
      <!--<xsl:text>\mainmatter </xsl:text>-->
      <xsl:apply-templates select="//tei:TEI[not(@rend='front')]"/>
      
      <!-- Beginn Back Matter -->
      <xsl:text>\backmatter </xsl:text>
      <!-- Autoren der Beiträge -->
      <xsl:call-template name="set-cvs"/>
      <xsl:call-template name="add-see-references"/>
      <xsl:text>
         \cleardoublepage
         \renewcommand{\indexname}{Personen- und Werkregister}
         \markleft{Personen- und Werkregister}
         \markright{Personen- und Werkregister}
         \addcontentsline{toc}{chapter}{\indexname}
         \footnotesize
         \printindex
         \end{document}
      </xsl:text>
   </xsl:template>
   
   <!-- Special template for typesetting only the bibliography -->
   <xsl:template name="set-biblio">
      <xsl:value-of select="$preamble"/>
      <xsl:value-of select="$titlepage"/>
      <xsl:text>
         \begin{document}
         \mainmatter
      </xsl:text>
      <xsl:for-each select="//tei:TEI">
         <xsl:text>\section{</xsl:text>
         <xsl:value-of select="string-join(./tei:teiHeader//tei:titleStmt//tei:author/tei:name, ', ')"/>
         <xsl:text>} \begin{compactitem}</xsl:text>
         <xsl:for-each select=".//tei:div[@type='bibliography']/tei:listBibl/tei:bibl">
            <xsl:text>\item </xsl:text>
            <xsl:apply-templates select="."/>
            <!--<xsl:text> \par </xsl:text>-->
         </xsl:for-each>
         <xsl:text>
            \end{compactitem}
         </xsl:text>
      </xsl:for-each>
      <xsl:text>
         \end{document}
      </xsl:text>
   </xsl:template>
   
   <!-- Druckt den Anhang 'Autorinnen und Autoren der Beiträge' aus den Autor-affiliation-Elementen der Beiträge -->
   <xsl:template name="set-cvs">
      <xsl:choose>
         <!-- Verhindert die (leere) Ausgabe des Anhangs für Korrekturfahnen -->
         <xsl:when test="some $i in //tei:fileDesc//tei:author/tei:affiliation satisfies normalize-space($i) ne ''">
            <xsl:value-of select="cgrid:chapter-preamble(
               'ngerman',
               'Autorinnen und Autoren der Beiträge',
               'Autorinnen und Autoren der Beiträge',
               'Autorinnen und Autoren der Beiträge',
               'Autorinnen und Autoren der Beiträge'
               )"/>
            <xsl:for-each select="//tei:fileDesc//tei:author[not(ancestor::tei:TEI/@rend='front')]">
               <xsl:sort select="tei:name/tei:surname" collation="http://saxon.sf.net/collation?lang=de-DE"/>
               <xsl:text>\paragraph{</xsl:text>
               <xsl:value-of select="tei:name"/>
               <xsl:text>}</xsl:text>
               <xsl:apply-templates select="tei:affiliation"/>
               <xsl:if test="normalize-space(tei:affiliation) eq ''">
                  <xsl:message>Warnung: Affiliation (Kurzbiographie) wurde nicht angegeben für <xsl:value-of select="tei:name"/></xsl:message>
               </xsl:if>
            </xsl:for-each>
            <xsl:text>\par</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:message>Warnung: Affiliation (Kurzbiographie) wurde nicht angegeben – überspringe Kapitel 'Autorinnen und Autoren der Beiträge'.</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- Fügt dem Index "siehe"-Verweise hinzu -->
   <xsl:template name="add-see-references">
      <xsl:for-each select="//tei:p[parent::tei:person][not(@n)][preceding-sibling::tei:p]">
         <xsl:text>\index{</xsl:text>
         <xsl:value-of select="normalize-space(.)"/>
         <xsl:text>|see{</xsl:text>
         <xsl:value-of select="normalize-space(parent::tei:person/tei:p[1])"/>
         <xsl:text>}}</xsl:text>
      </xsl:for-each>
   </xsl:template>
   
   <xsl:template match="tei:TEI">
      <xsl:variable name="author" as="xs:string*">
         <xsl:value-of select="string-join(./tei:teiHeader//tei:titleStmt//tei:author/tei:name, ', ')"/>
      </xsl:variable>
      <xsl:variable name="mainTitle" as="xs:string*">
         <xsl:apply-templates select="./tei:teiHeader//tei:titleStmt//tei:title[@type='main']" mode="chapterHeading"/>
      </xsl:variable>
      <xsl:variable name="subTitle" as="xs:string*">
         <xsl:apply-templates select="./tei:teiHeader//tei:titleStmt//tei:title[@type='sub']" mode="chapterHeading"/>
      </xsl:variable>
      <xsl:variable name="mainTitleToc" as="xs:string*">
         <xsl:apply-templates select="./tei:teiHeader//tei:titleStmt//tei:title[@type='main']" mode="toc"/>
      </xsl:variable>
      <xsl:variable name="subTitleToc" as="xs:string*">
         <xsl:apply-templates select="./tei:teiHeader//tei:titleStmt//tei:title[@type='sub']" mode="toc"/>
      </xsl:variable>
      <xsl:variable name="markright" as="xs:string*">
         <xsl:choose>
            <xsl:when test="tei:teiHeader//tei:titleStmt//tei:title[@type='short']">
               <xsl:apply-templates select="./tei:teiHeader//tei:titleStmt//tei:title[@type='short']" mode="toc"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="$mainTitleToc"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <xsl:value-of select="cgrid:chapter-preamble(
         cgrid:language-code-to-babel(cgrid:current-language(.)),
         string-join((cgrid:normalize-string-join($author), cgrid:normalize-string-join($mainTitleToc), cgrid:normalize-string-join($subTitleToc)), '\newline{}'),
         cgrid:chap-title(cgrid:normalize-string-join($author), string-join((cgrid:normalize-string-join($mainTitle), cgrid:normalize-string-join($subTitle)), '\newline\large ')),
         cgrid:normalize-string-join($author),
         cgrid:normalize-string-join($markright)
         )"/>
      
      <xsl:apply-templates select="tei:text/tei:body"/>
      <xsl:apply-templates select="tei:text/tei:back/tei:div[@type='appendix']"/>
   </xsl:template>
   
   <xsl:template match="tei:title" mode="chapterHeading">
      <xsl:apply-templates/>
   </xsl:template>
   
   <xsl:template match="tei:title" mode="toc">
      <xsl:apply-templates select="node()[not(local-name(.) = 'note')]"/>
   </xsl:template>
   
   <xsl:template match="tei:title[ancestor::tei:text]" mode="#all">
      <!-- Titel im Text und in der Bibliographie werden grundsätzlich kursiv ausgegeben -->
      <xsl:choose>
         <!-- … wenn sie nicht in einem quote oder q stecken. -->
         <xsl:when test="parent::tei:q or parent::tei:quote">
            <xsl:apply-templates/>
         </xsl:when>
         <!-- … oder es explizit unterdrückt wird -->
         <xsl:when test="@rend='normal'">
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:call-template name="render">
               <xsl:with-param name="rend" select="'italic'" as="xs:string"/>
            </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>
      
      <!-- Werktitel für den Index -->
      <xsl:for-each select="tokenize(@ref, '\s+')">
         <xsl:variable name="canonical-form-node" select="$docRoot/id(substring(current(), 2))" as="element(tei:p)"/>
         <xsl:choose>
            <xsl:when test="$canonical-form-node">
               <xsl:variable name="canonical-form-text" as="xs:string*">
                  <!-- need to process text() due to thin spaces etc. -->
                  <xsl:apply-templates select="$canonical-form-node/node()"/>
               </xsl:variable>
               <xsl:text>\index{</xsl:text>
               <!-- 
                  Need to escape exclamation mark (and other characters!!)  for MakeIndex 
                  http://tex.stackexchange.com/questions/176931/how-to-escape-character-in-index 
                  AND: need to revert \slash to / : otherwise  we'll get duplicate index entries
               -->
               <xsl:value-of select="concat(normalize-space($canonical-form-node/parent::tei:person/tei:p[1]), '!', replace(replace(normalize-space(string-join($canonical-form-text, '')), '!', '&quot;!'), '\\slash ', '/'))"/>
               <xsl:text>}</xsl:text>
            </xsl:when>
            <xsl:otherwise>
               <xsl:message select="concat('No canonical form for &quot;', normalize-space(.), '&quot;')"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:for-each>
   </xsl:template>
   
   <xsl:template match="tei:div[@type='motto']">
      <xsl:variable name="left-indent" as="xs:string">
         <xsl:choose>
            <xsl:when test="matches(@rendition, 'latex')">
               <xsl:variable name="rendition" select="tokenize(@rendition, '\s+')[matches(., 'latex')]"/>
               <xsl:value-of select="normalize-space(id(substring($rendition, 2)))"/>
            </xsl:when>
            <xsl:otherwise><xsl:text>0.3\textwidth</xsl:text></xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:text>{\raggedright\small</xsl:text>
      <xsl:value-of select="cgrid:set-indent('left', $left-indent)"/>
      <xsl:apply-templates/>
      <xsl:text>\par}\par\bigskip </xsl:text>
   </xsl:template>
   
   <!-- Standard-sections mit Überschriften -->
   <xsl:template match="tei:div[normalize-space(tei:head) ne '']">
      <!-- Compute the depth of the div and add "sub"sections accordingly -->
      <xsl:variable name="section-command" as="xs:string" select="concat('\', string-join(for $i in ancestor::tei:div return 'sub', ''), 'section')"/>
      <xsl:if test="@rend='landscape'">
         <xsl:text>\begin{landscape}</xsl:text>
      </xsl:if>
      <xsl:if test="@type='appendix' and not(@rend='landscape')">
         <xsl:text>\newpage</xsl:text>
      </xsl:if>
      <xsl:choose>
         <!-- Numbered section headings -->
         <xsl:when test="@rend='numbered-heading'">
            <xsl:value-of select="concat($section-command, '{')"/>
         </xsl:when>
         <!-- Default: Starred version (e.g. \section*{}) for suppression of section numbers -->
         <xsl:otherwise>
            <xsl:value-of select="concat($section-command, '*{')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="tei:head" mode="sectionHead"/>
      <xsl:text>}</xsl:text>
      <xsl:if test="@xml:id">
         <xsl:text>\label{</xsl:text>
         <xsl:value-of select="@xml:id"/>
         <xsl:text>}</xsl:text>
      </xsl:if>
      <xsl:apply-templates/>
      <xsl:if test="(following-sibling::tei:div[1])[normalize-space(tei:head) eq ''] and not(@rend='suppress-alinea') and ancestor::tei:body">
         <xsl:call-template name="alinea"/>
      </xsl:if>
      <xsl:if test="@rend='landscape'">
         <xsl:text>\end{landscape}</xsl:text>
      </xsl:if>
   </xsl:template>
   
   <!-- Sections ohne Überschrift werden nur mit einem vertikalen Abstand getrennt -->
   <xsl:template match="tei:div[normalize-space(tei:head) eq ''][not(@type)]">
      <xsl:if test="@xml:id">
         <xsl:value-of select="concat('\phantomsection\label{', @xml:id, '}\noindent ')"/>
      </xsl:if>
      <xsl:apply-templates select="*"/>
      <xsl:if test="(following-sibling::tei:div[1])[normalize-space(tei:head) eq ''] and not(@rend='suppress-alinea') and ancestor::tei:body">
        <xsl:call-template name="alinea"/>
      </xsl:if>
   </xsl:template>
   
   <!--<xsl:template match="tei:div[@type='appendix']">
      <xsl:text>\section*{Anhang}</xsl:text>
      <xsl:apply-templates/>
   </xsl:template>-->
   
   <xsl:template match="tei:p">
      <xsl:if test="@rend=('noIndent', 'spaced')">
         <xsl:text>\noindent{}</xsl:text>
      </xsl:if>
      <xsl:choose>
         <xsl:when test="@rend='right'">
            <xsl:text>\begin{flushright}</xsl:text>
            <xsl:if test="ancestor::tei:floatingText">
               <xsl:value-of select="cgrid:set-indent('right', '\floatingTextIndentRight')"/>
            </xsl:if>
            <xsl:apply-templates/>
            <xsl:text>\end{flushright}</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates/>
            <xsl:text>\par </xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="@rend=('spaced')">
         <xsl:text>\smallskip </xsl:text>
      </xsl:if>
   </xsl:template>
   
   <xsl:template match="tei:q" mode="#all">
      <xsl:choose>
         <xsl:when test="@xml:lang">
            <xsl:text>\hyphenquote{</xsl:text>
            <xsl:value-of select="cgrid:language-code-to-babel(@xml:lang)"/>
            <xsl:text>}{</xsl:text>
         </xsl:when>
         <xsl:otherwise>\enquote{</xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates/>
      <xsl:text>}</xsl:text>
   </xsl:template>
   
   <xsl:template match="tei:pb">
      <!-- Bei Seitenumbrüchen innerhalb von Absätzen muss die letzte Zeile aufgefüllt werden, daher \linebreak -->
      <!-- Bei folgenden Blockelemente (quote) muss das aber verhindert werden -->
      <xsl:if test="ancestor::tei:p and not(following-sibling::*[1]/local-name(.) eq 'quote')">
         <xsl:text>\linebreak</xsl:text>
      </xsl:if>
      <xsl:text>\newpage </xsl:text>
   </xsl:template>
   
   <xsl:template match="tei:pb[@rend='clear']">
      <xsl:text>\clearpage </xsl:text>
   </xsl:template>
   
   <xsl:template match="tei:cb">
      <xsl:text>\columnbreak </xsl:text>
   </xsl:template>
   
   <xsl:template match="tei:quote">
      <xsl:choose>
         <xsl:when test="@xml:lang">
            <xsl:text>\hyphenblockquote{</xsl:text>
            <xsl:value-of select="cgrid:language-code-to-babel(@xml:lang)"/>
            <xsl:text>}</xsl:text>
         </xsl:when>
         <xsl:otherwise>\blockquote</xsl:otherwise>
      </xsl:choose>
      <xsl:if test="@source">
         <xsl:variable name="sourceNode" select="id(substring(@source, 2))"/>
         <xsl:variable name="content">
            <xsl:apply-templates select="$sourceNode" mode="quote"/>
         </xsl:variable>
         <!-- First: Construct a standard footnote -->
         <xsl:variable name="footnote" select="cgrid:footnote($content,$sourceNode/@xml:id)"/>
         <xsl:text>[</xsl:text>
         <!-- Second: strip off the \footnote{} command -->
         <xsl:value-of select="substring($footnote, 11, string-length($footnote) - 11)"/>
         <xsl:text>]</xsl:text>
      </xsl:if>
      <xsl:text>{</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>}</xsl:text>
   </xsl:template>
   
   <xsl:template match="tei:soCalled" mode="#all">
      <xsl:text>\enquote*{</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>}</xsl:text>
   </xsl:template>
   
   <xsl:template match="tei:note" mode="#default">
      <xsl:variable name="content">
         <xsl:apply-templates/>
      </xsl:variable>
      <xsl:value-of select="cgrid:footnote($content, @xml:id)"/>
   </xsl:template>
   
   <xsl:template match="tei:note" mode="quote">
      <xsl:apply-templates/>
   </xsl:template>
   
   <xsl:template match="tei:note | tei:ref[@type='bibl'][not(ancestor::tei:note)]" mode="caption">
      <xsl:choose>
         <xsl:when test="tokenize(@rend, '\s+')='inline'">
            <xsl:call-template name="resolve-ref"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>\protect\footnotemark</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- The longtable package cannot process footnotes in the head or the foot of a table; -->
   <!-- Need to work around with footnotemark and footnotetext -->
   <xsl:template match="tei:note[ancestor::tei:row[@role='label']] | tei:ref[@type='bibl'][not(ancestor::tei:note)][ancestor::tei:row[@role='label']]" priority="5">
      <xsl:text>\protect\footnotemark</xsl:text>
   </xsl:template>
   
   <!-- Ziemlich spezielles template für die Behandlung von Zitaten als Motto
      (siehe z.B: wernerkeil.xml) -->
   <xsl:template match="tei:cit[parent::tei:div[@type='motto']]">
      <xsl:variable name="content">
         <xsl:apply-templates select="tei:ref" mode="quote"/>
      </xsl:variable>
      
      <xsl:apply-templates select="tei:quote/node()"/>
      <xsl:value-of select="cgrid:footnote($content, @xml:id)"/>
   </xsl:template>
   
   <xsl:template match="tei:name[@ref]" mode="#all">
      <xsl:apply-templates/>
      <xsl:for-each select="tokenize(@ref, '\s+')">
         <xsl:variable name="canonical-form" as="xs:string*">
            <xsl:apply-templates select="key('name-index',substring(current(), 2), $docRoot)/tei:p[1]/node()"/>
         </xsl:variable>
         <xsl:choose>
            <xsl:when test="normalize-space(string-join($canonical-form, '')) ne ''">
               <xsl:text>\index{</xsl:text>
               <xsl:value-of select="normalize-space(string-join($canonical-form, ''))"/>
               <xsl:text>}</xsl:text>
            </xsl:when>
            <xsl:otherwise>
               <xsl:message select="concat('No canonical form for &quot;', normalize-space(.), '&quot;')"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:for-each>
   </xsl:template>
   
   <xsl:template match="tei:hi" mode="#all">
      <xsl:variable name="rend" select="tokenize(normalize-space(@rend), '\s')"/>
      <xsl:call-template name="render">
         <xsl:with-param name="rend" select="$rend"/>
      </xsl:call-template>
   </xsl:template>
   
   <xsl:template match="tei:emph[parent::tei:title]">
      <xsl:call-template name="render">
         <xsl:with-param name="rend" select="'normal'"/>
      </xsl:call-template>
   </xsl:template>
   
   <xsl:template match="tei:lb" mode="#all">
      <xsl:choose>
         <!-- Extrawurst für captions in Tabellen oder Abbildungen -->
         <xsl:when test="ancestor::tei:table or ancestor::tei:figure">
            <xsl:text>\newline{}</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>\\</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template match="tei:lb[@rend='par']">
      <xsl:text>\vspace{\smallskipamount}\newline{}</xsl:text>
   </xsl:template>
   
   <xsl:template match="tei:floatingText">
      <xsl:if test="@xml:id='schreiter-letter02'">
         <!-- some special rule for fixing print layout -->
         <xsl:text>\vspace{-0.5ex}</xsl:text>
      </xsl:if>
      <!-- another special rule for fixing print layout -->
      <xsl:if test="@xml:id='grotjahn-float02'">
         <xsl:text>{\small\setlength{\floatingTextIndentLeft}{.5cm}\setlength{\floatingTextIndentRight}{.5cm}\setlength{\columnsep}{-1.2cm}\setlength{\smallskipamount}{3pt}</xsl:text>
      </xsl:if>
      <xsl:text>\begin{floatingText}</xsl:text>
      <xsl:if test="@xml:id">
         <xsl:value-of select="concat('\phantomsection\label{', @xml:id, '}')"/>
      </xsl:if>
      <xsl:choose>
         <xsl:when test="@rend='twocolumns'">
            <xsl:text>\begin{multicols}{2}</xsl:text>
         </xsl:when>
      </xsl:choose>
      <!-- Directly jump to body children to prevent extra new lines -->
      <xsl:apply-templates select="tei:body/*"/>
      <xsl:choose>
         <xsl:when test="@rend='twocolumns'">
            <xsl:text>\end{multicols}</xsl:text>
         </xsl:when>
      </xsl:choose>
      <xsl:text>\end{floatingText}</xsl:text>
      <xsl:if test="@xml:id=('schreiter-letter02', 'allroggen-float01', 'allroggen-float02')">
         <!-- some special rule for fixing print layout -->
         <xsl:text>\vspace{-0.5ex}</xsl:text>
      </xsl:if>
      <xsl:if test="@xml:id='grotjahn-float02'">
         <xsl:text>}</xsl:text>
      </xsl:if>
   </xsl:template>
   
   <xsl:template match="tei:list">
      <xsl:variable name="type" as="xs:string">
         <xsl:choose>
            <xsl:when test="@rend='ordered'">enumerate</xsl:when>
            <xsl:when test="@rend='alpha'">compactenum</xsl:when>
            <xsl:when test="@rend='simple'">compactitem</xsl:when>
            <xsl:when test="@type='gloss'">description</xsl:when>
            <xsl:otherwise>itemize</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="tei:head">
            <xsl:text>\subparagraph{</xsl:text>
            <xsl:apply-templates select="tei:head" mode="sectionHead"/>
            <xsl:text>}</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>\par\smallskip</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="concat('\begin{', $type, '}')"/>
      <xsl:if test="$type = 'compactitem'"><xsl:text>[]</xsl:text></xsl:if>
      <xsl:if test="@rend='alpha'"><xsl:text>[(a)]</xsl:text></xsl:if>
      <xsl:if test="ancestor::tei:floatingText">
         <xsl:text>\addtolength{\floatingTextIndentLeft}{5mm}</xsl:text>
         <xsl:value-of select="cgrid:set-indent('left', '\floatingTextIndentLeft')"/>
         <xsl:value-of select="cgrid:set-indent('right', '\floatingTextIndentRight')"/>
      </xsl:if>
      <xsl:apply-templates/>
      <xsl:value-of select="concat('\end{', $type, '}\smallskip ')"/>
   </xsl:template>
   
   <xsl:template match="tei:item">
      <xsl:text>\item </xsl:text>
      <xsl:apply-templates/>
   </xsl:template>
   
   <xsl:template match="tei:item[parent::tei:list/@type='gloss']">
      <xsl:text>\item[</xsl:text>
      <xsl:value-of select="cgrid:clean-text(preceding-sibling::tei:label[1])"/>
      <xsl:text>] </xsl:text>
      <xsl:apply-templates/>
   </xsl:template>
   
   <!-- Labels werden in gloss-Listen in die \item[] reingeholt (s.o.) -->
   <xsl:template match="tei:label[parent::tei:list]"/>
   
   <xsl:template match="tei:ref[@type='crossref']" mode="#all">
      <xsl:choose>
         <xsl:when test="@rend='page'">
            <xsl:value-of select="concat('\pageref{', substring(@target, 2), '}')"/>
         </xsl:when>
         <xsl:when test="@rend='no'">
            <xsl:value-of select="concat('\ref{', substring(@target, 2), '}')"/>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   
   <!-- Werden als Beleg innerhalb von \blockquote[]{} ausgewertet -->
   <xsl:template match="tei:note[@type='bibl']" mode="#default"/>
   
   <xsl:template match="tei:ref[@type='bibl']" mode="#default">
      <xsl:choose>
         <xsl:when test="//tei:quote[@source = concat('#', current()/@xml:id)]"/>
         <xsl:otherwise>
            <xsl:variable name="content">
               <xsl:call-template name="resolve-ref"/>
            </xsl:variable>
            <xsl:value-of select="cgrid:footnote($content, @xml:id)"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template match="tei:ref[@type='bibl'][ancestor::tei:note|parent::tei:bibl] | tei:ref[tokenize(@rend, '\s+')='inline']" mode="#default" priority="1">
      <xsl:call-template name="resolve-ref"/>
   </xsl:template>
   
   <xsl:template match="tei:ref[@type='bibl']" mode="quote">
      <xsl:call-template name="resolve-ref"/>
   </xsl:template>
   
   <xsl:template match="tei:ref | tei:ptr" mode="#all">
      <xsl:choose>
         <xsl:when test="normalize-space(.) eq ''">
            <xsl:text>\url{</xsl:text>
            <xsl:value-of select="replace(replace(@target, '%', '\\%'), '#', '\\#')"/>
            <xsl:text>}</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>\href{</xsl:text>
            <xsl:value-of select="replace(replace(@target, '%', '\\%'), '#', '\\#')"/>
            <xsl:text>}{</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>}</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <!--
         Hinzusetzen von [Stand: XXX]
         Nur wenn kein Text innerhalb des ref enthalten ist 
      -->
      <xsl:if test="not(.//text()) and not(@type)">
         <xsl:variable name="lang">
            <xsl:value-of select="cgrid:current-language(.)"/>
         </xsl:variable>
         <xsl:choose>
            <xsl:when test="$lang='en'">
               <xsl:text> {[}last accessed: 30&#8239;Nov.&#8239;2015{]}</xsl:text>
            </xsl:when>
            <xsl:otherwise>
               <xsl:text> {[}Stand: 30.&#8239;Nov.&#8239;2015{]}</xsl:text>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
   </xsl:template>
   
   <xsl:template match="tei:table">
      <xsl:variable name="caption">
         <xsl:apply-templates select="tei:head" mode="caption"/>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="@xml:id='heidlberger-table01'">
            <xsl:text>\begin{longtable}{p{.2\textwidth}p{.6\textwidth}}</xsl:text>
         </xsl:when>
         <xsl:when test="@xml:id='heidlberger-table02'">
            <xsl:text>\small\begin{longtable}{>{\raggedright}p{.3\textwidth}p{.6\textwidth}}</xsl:text>
         </xsl:when>
         <xsl:when test="@xml:id=('borchard-table02','borchard-table03','borchard-table04','borchard-table05','borchard-table06')">
            <xsl:text>\begin{longtable}{p{.3\textwidth}p{.3\textwidth}p{.3\textwidth}}</xsl:text>
         </xsl:when>
         <xsl:when test="@xml:id='borchard-table01'">
            <xsl:text>\begin{longtable}{lp{.2\textwidth}p{.7\textwidth}}</xsl:text>
         </xsl:when>
         <xsl:when test="@xml:id='beck-table01'">
            <xsl:text>\begin{longtable}{llp{.6\textwidth}}</xsl:text>
         </xsl:when>
         <xsl:when test="@xml:id='capelle-table01'">
            <xsl:text>\begin{longtable}{lp{.25\textwidth}p{.45\textwidth}}</xsl:text>
         </xsl:when>
         <xsl:when test="@xml:id='capelle-table02'">
            <xsl:text>\begin{longtable}{p{.2\textwidth}p{.3\textwidth}p{.4\textwidth}}</xsl:text>
         </xsl:when>
         <xsl:when test="@xml:id='capelle-table03'">
            <xsl:text>\begin{longtable}{lp{.3\textwidth}p{.4\textwidth}}</xsl:text>
         </xsl:when>
         <xsl:when test="@xml:id='capelle-table04'">
            <xsl:text>\begin{longtable}{p{.2\textwidth}p{.5\textwidth}p{.2\textwidth}}</xsl:text>
         </xsl:when>
         <xsl:when test="@xml:id='huck-table01'">
            <xsl:text>\footnotesize\begin{longtable}{l >{\raggedright}p{.4\textwidth} >{\raggedright\arraybackslash}p{.4\textwidth}}</xsl:text>
         </xsl:when>
         <xsl:when test="@xml:id='huck-table02'">
            <xsl:text>\footnotesize\begin{longtable}{>{\raggedright}p{.3\textwidth} *{2}{>{\raggedright\arraybackslash}p{.05\textwidth}} >{\raggedright}p{.06\textwidth} *{4}{>{\raggedright\arraybackslash}p{.05\textwidth}} *{2}{>{\raggedright\arraybackslash}p{.06\textwidth}} *{2}{>{\raggedright\arraybackslash}p{.05\textwidth}}}</xsl:text>
         </xsl:when>
         <xsl:when test="@xml:id='huck-table03'">
            <xsl:text>\footnotesize\begin{longtable}{>{\raggedright}p{.3\textwidth} >{\raggedright}p{.1\textwidth} >{\raggedright}p{.1\textwidth} >{\raggedright}p{.1\textwidth} >{\raggedright}p{.1\textwidth} >{\raggedright}p{.15\textwidth} >{\raggedright\arraybackslash}p{.2\textwidth}}</xsl:text>
         </xsl:when>
         <xsl:when test="starts-with(@xml:id, 'viglianti')">
            <xsl:text>\footnotesize\begin{longtable}{p{.45\textwidth}p{.45\textwidth}}</xsl:text>
         </xsl:when>
         <xsl:when test="@xml:id='geertinger-table01'">
            <xsl:text>\begin{longtable}{p{.45\textwidth}p{.45\textwidth}}</xsl:text>
         </xsl:when>
         <xsl:when test="@xml:id='kleinertz-table01'">
            <xsl:text>\begin{longtable}{cp{.6\textwidth}c}</xsl:text>
         </xsl:when>
         <xsl:when test="@xml:id='acquavella-rauch-table01'">
            <xsl:text>\begin{sidewaystable}\small\begin{longtable}{p{.17\textwidth}p{.17\textwidth}p{.17\textwidth}p{.17\textwidth}p{.17\textwidth}}</xsl:text>
         </xsl:when>
         <xsl:when test="@xml:id='acquavella-rauch-table02'">
            <xsl:text>\begin{longtable}{llp{.15\textwidth}p{.3\textwidth}}</xsl:text>
         </xsl:when>
         <xsl:when test="@xml:id='siegert-table01'">
            <xsl:text>\scriptsize\begin{longtable}{p{.25\textwidth}ccccccccc}</xsl:text>
         </xsl:when>
         <xsl:when test="@xml:id='siegert-table02'">
            <xsl:text>\scriptsize\begin{longtable}{p{.02\textwidth}>{\raggedright}p{.2\textwidth}>{\raggedright}p{.2\textwidth}>{\raggedright}p{.2\textwidth}>{\RaggedRight\arraybackslash}p{.21\textwidth}}</xsl:text>
         </xsl:when>
         <xsl:when test="@xml:id='grotjahn-table01'">
            <xsl:text>\begin{longtable}{>{\raggedright}p{.45\textwidth}>{\raggedright\arraybackslash}p{.5\textwidth}}</xsl:text>
         </xsl:when>
         <xsl:when test="@xml:id='grotjahn-table02'">
            <xsl:text>\begin{longtable}{>{\raggedright}p{.41\textwidth}>{\raggedright\arraybackslash}p{.51\textwidth}}</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="concat('\begin{longtable}{', string-join(for $i in tei:row[1]/tei:cell return 'l', ''),  '}')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="not(@rend='noRules')"><xsl:text> \toprule </xsl:text></xsl:if>
      <xsl:apply-templates/>
      <xsl:if test="not(@rend='noRules')"><xsl:text> \bottomrule </xsl:text></xsl:if>
      <xsl:if test="$caption ne ''">
         <xsl:value-of select="concat('\caption[]{', $caption, '}')"/>
      </xsl:if>
      <xsl:if test="@xml:id">
         <xsl:text>\label{</xsl:text>
         <xsl:value-of select="@xml:id"/>
         <xsl:text>}</xsl:text>
      </xsl:if>
      <xsl:text>\end{longtable}\normalsize </xsl:text>
      <xsl:if test="@xml:id='acquavella-rauch-table01'">
         <xsl:text>\end{sidewaystable}\normalsize </xsl:text>
      </xsl:if>
      <!-- Fußnoten im Tabellenkopf und in der caption müssen extra ausgegeben werden -->
      <xsl:for-each select="tei:row[@role='label']//(tei:note,tei:ref[@type='bibl'][not(ancestor::tei:note)][not(tokenize(@rend, '\s+')='inline')]) | tei:head//(tei:note,tei:ref[@type='bibl'][not(ancestor::tei:note)][not(tokenize(@rend, '\s+')='inline')])">
         <xsl:variable name="content">
            <xsl:apply-templates select="." mode="quote"/>
         </xsl:variable>
         <xsl:value-of select="concat('\footnotetext{', cgrid:footnoteText($content), '}')"/>
      </xsl:for-each>
   </xsl:template>
   
   <xsl:template match="tei:table[@rend='simple']">
      <xsl:text>\begin{tabular}</xsl:text>
      <xsl:value-of select="concat('{', string-join(for $i in tei:row[1]/tei:cell return 'l', ''),  '}')"/>
      <xsl:apply-templates/>
      <xsl:text>\end{tabular}\par </xsl:text>
   </xsl:template>
   
   <xsl:template match="tei:row">
      <xsl:apply-templates select="tei:cell"/>
      <xsl:text>\\</xsl:text>
      <xsl:if test="descendant-or-self::*[@role='label']">
         <xsl:if test="not(ancestor::tei:table/@rend='noRules')"><xsl:text>\midrule</xsl:text></xsl:if>
         <xsl:text>\endhead</xsl:text>
      </xsl:if>
      <xsl:if test="descendant-or-self::*[@role='midlabel'] and not(ancestor::tei:table/@rend='noRules')">
         <xsl:text>\midrule</xsl:text>
      </xsl:if>
      <!-- dirty hack um die Tabellen bei Raffaele schlanker zu bekommen -->
      <xsl:if test="not(ancestor::tei:table//eg:egXML or ancestor::tei:table/@rend='noRules')">
         <xsl:text> \addlinespace </xsl:text>
      </xsl:if>
   </xsl:template>
   
   <xsl:template match="tei:cell">
      <xsl:choose>
         <xsl:when test="@cols">
            <!-- compute the width for the combined cell -->
            <xsl:variable name="width" select="concat('p{', @cols div (count(parent::*/tei:cell) - 1 + @cols) - 0.1,'\textwidth}')" as="xs:string"/>
            <xsl:value-of select="concat('\multicolumn{', @cols, '}{', $width,'}{')"/>
            <xsl:apply-templates/>
            <xsl:text>}</xsl:text>
         </xsl:when>
         <xsl:when test="@rend='vertical'">
            <xsl:text>\rotatebox[origin=c]{90}{\parbox{3cm}{</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>}}</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="following-sibling::tei:cell">
         <xsl:text> &amp; </xsl:text>
      </xsl:if>
   </xsl:template>
   
   <xsl:template match="tei:milestone[matches(@rendition, 'latex')]">
      <xsl:value-of select="normalize-space(id(substring(@rendition, 2)))"/>
   </xsl:template>
   
   <xsl:template match="tei:figure[tei:graphic]">
      <!-- Umgebung: entweder eigenes 'notenbeispiel' oder Standard-figure -->
      <xsl:variable name="env" as="xs:string">
         <xsl:choose>
            <xsl:when test="@rend='notenbeispiel'">notenbeispiel</xsl:when>
            <xsl:otherwise>figure</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="pos" as="xs:string?">
         <xsl:choose>
            <xsl:when test="@place='bottom'">b</xsl:when>
            <xsl:when test="@place='here'">h</xsl:when>
            <xsl:when test="@place='top'">t</xsl:when>
            <xsl:when test="@place='page'">p</xsl:when>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="width" as="xs:string?">
         <xsl:choose>
            <xsl:when test="matches(@rendition, 'latex')">
               <xsl:variable name="rendition" select="tokenize(@rendition, '\s+')[matches(., 'latex')]"/>
               <xsl:value-of select="normalize-space(id(substring($rendition, 2)))"/>
            </xsl:when>
            <xsl:when test="number(substring-before(tei:graphic/@width, 'px')) gt 400">
               <xsl:text>width=0.9\textwidth</xsl:text>
            </xsl:when>
            <xsl:otherwise/>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="height" as="xs:string?">
         <xsl:choose>
            <xsl:when test="number(substring-before(tei:graphic/@height, 'px')) gt 600">
               <xsl:text>height=0.85\textheight</xsl:text>
            </xsl:when>
            <xsl:otherwise/>
         </xsl:choose>
      </xsl:variable>
      <xsl:value-of select="concat('\begin{', $env,'}')"/>
      <xsl:if test="$pos"><xsl:value-of select="concat('[', $pos,']')"/></xsl:if>
      <xsl:text>\centering\includegraphics</xsl:text>
      <xsl:if test="$width or $height">
         <xsl:text>[</xsl:text>
         <xsl:value-of select="string-join(($width,$height,'keepaspectratio'), ',')"/>
         <xsl:text>]</xsl:text>
      </xsl:if>
      <xsl:text>{</xsl:text>
      <xsl:value-of select="tei:graphic/@url"/>
      <xsl:text>}</xsl:text>
      <!-- Bei leerem tei:head wird das caption ausgelassen und der Figure-Zähler zurückgesetzt. Sollte nur eine Notlösung sein, siehe praetzlich.xml -->
      <xsl:if test="not(normalize-space(tei:head) = '')">
         <xsl:text>\caption[]{</xsl:text>
         <xsl:apply-templates select="tei:head" mode="caption"/>
         <xsl:text>}</xsl:text>
      </xsl:if>
      <!-- Label wird gesetzt -->
      <xsl:value-of select="concat('\label{', @xml:id,'}')"/>
      <!-- fieser hack, damit die Fußnote noch auf die Seite rutscht -->
      <xsl:if test="@xml:id='bandur-fig10'">
         <xsl:text>\vspace{-3mm}</xsl:text>
      </xsl:if>
      <!-- Umgebung wird beendet -->
      <xsl:value-of select="concat('\end{', $env,'}')"/>
      <!-- Zuletzt müssen noch eventuell vorhandene Fußnotentexte ausgegeben werden -->
      <xsl:for-each select="tei:head//(tei:note,tei:ref[@type='bibl'][not(ancestor::tei:note)][not(tokenize(@rend, '\s+')='inline')])">
         <xsl:variable name="content">
            <xsl:apply-templates select="." mode="quote"/>
         </xsl:variable>
         <xsl:if test="@rend='noPageBreak'">
            <xsl:text>\interfootnotelinepenalty=10000</xsl:text>
         </xsl:if>
         <xsl:value-of select="concat('\footnotetext{', cgrid:footnoteText($content), '}')"/>
         <xsl:if test="@rend='noPageBreak'">
            <xsl:text>\interfootnotelinepenalty=100</xsl:text>
         </xsl:if>
      </xsl:for-each>
   </xsl:template>
   
   <xsl:template match="tei:figure[eg:egXML]">
      <xsl:variable name="caption" as="xs:string*">
         <xsl:apply-templates select="tei:head" mode="caption"/>
      </xsl:variable>
      <xsl:variable name="label" select="@xml:id" as="xs:string?"/>
      <xsl:text>\begin{listing}</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>\unskip</xsl:text>
      <xsl:if test="normalize-space(string-join(($caption),'')) ne ''">
         <xsl:text>\caption{\footnotesize </xsl:text>
         <xsl:value-of select="string-join($caption, '')"/>
         <xsl:text>}</xsl:text>
      </xsl:if>
      <xsl:if test="normalize-space(string-join(($label),'')) ne ''">
         <xsl:text>\label{</xsl:text>
         <xsl:value-of select="string-join($label, '')"/>
         <xsl:text>}</xsl:text>
      </xsl:if>
      <xsl:text>\end{listing}</xsl:text>
      
      <!-- Zuletzt müssen noch eventuell vorhandene Fußnotentexte ausgegeben werden -->
      <xsl:for-each select="tei:head//(tei:note,tei:ref[@type='bibl'][not(ancestor::tei:note)][not(tokenize(@rend, '\s+')='inline')])">
         <xsl:variable name="content">
            <xsl:apply-templates select="." mode="quote"/>
         </xsl:variable>
         <xsl:value-of select="concat('\footnotetext{', cgrid:footnoteText($content), '}')"/>
      </xsl:for-each>
   </xsl:template>
   
   <xsl:template match="eg:egXML">
      <xsl:variable name="minted-options" as="xs:string*">
         [breaklines,
         fontsize=\scriptsize,
         breakafter=>,
         samepage=true,
         style=bw
         <xsl:if test="parent::tei:figure">
            ,xleftmargin=\floatingTextIndentLeft
            ,xrightmargin=\floatingTextIndentRight
            ,frame=lines
            ,framesep=2ex
            ,framerule=.8pt
         </xsl:if>]
      </xsl:variable>
      <xsl:choose>
         <!-- wenn das @source-Attribut angegeben ist, dann wird die entsprechende Datei geladen -->
         <xsl:when test="@source">
            <xsl:text>\inputminted</xsl:text>
            <xsl:value-of select="normalize-space(string-join($minted-options,''))"/>
            <xsl:text>{xml}</xsl:text>
            <xsl:value-of select="concat('{', @source, '}')"/>
         </xsl:when>
         <!-- Ansonsten wird der content des egXML ausgegeben -->
         <xsl:otherwise>
            <xsl:text>\begin{minted}</xsl:text>
            <xsl:value-of select="normalize-space(string-join($minted-options,''))"/>
            <xsl:text>{xml}&#10;</xsl:text>
            <xsl:apply-templates mode="listing"/>
            <xsl:text>&#10;\end{minted}</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!--<xsl:template match="eg:egXML">
      <xsl:text>\begin{lstlisting}[frame=none]</xsl:text>
      <xsl:apply-templates mode="serialize"/>
      <xsl:text>&#10;\end{lstlisting}</xsl:text>
   </xsl:template>-->
   
   <xsl:template match="tei:gi">
      <xsl:text>\gi{&lt;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&gt;}</xsl:text>
   </xsl:template>
   
   <xsl:template match="tei:att">
      <xsl:text>\att{@</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>}</xsl:text>
   </xsl:template>
   
   <xsl:template match="tei:tag">
      <xsl:text>\gi{&lt;</xsl:text>
      <xsl:if test="@type='end'">
         <xsl:text>/</xsl:text>
      </xsl:if>
      <xsl:value-of select="replace(., '&quot;', '\\textquotedbl{}')"/>
      <xsl:text>&gt;}</xsl:text>
   </xsl:template>
   
   <xsl:template match="tei:foreign" mode="#all">
      <xsl:choose>
         <xsl:when test="@xml:lang='gr'">
            <xsl:text>\textgreek{</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>}</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>\foreignlanguage{</xsl:text>
            <xsl:value-of select="cgrid:language-code-to-babel(@xml:lang)"/>
            <xsl:text>}{</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>}</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- Im default mode werden heads unterdrückt, da sie innerhalb einer caption oder als sectionHead ausgegeben werden -->
   <xsl:template match="tei:head"/>
   
   <xsl:template match="tei:head" mode="caption">
      <xsl:apply-templates mode="#current"/>
   </xsl:template>
   
   <xsl:template match="tei:head" mode="sectionHead">
      <xsl:apply-templates/>
   </xsl:template>
   
   <xsl:template match="tei:bibl[@type='short']"/>
   <xsl:template match="tei:bibl[@type='short']" mode="shortTitle">
      <xsl:apply-templates/>
   </xsl:template>
   <xsl:template match="tei:back"/>
   
   <xsl:template match="tei:edition">
      <xsl:call-template name="render">
         <xsl:with-param name="rend" select="'sup'"/>
      </xsl:call-template>
   </xsl:template>
   
   <xsl:template match="tei:sp">
      <xsl:apply-templates select="*"/>
      <xsl:if test="following-sibling::tei:*">
         <xsl:text>\par\smallskip </xsl:text>
      </xsl:if>
   </xsl:template>
   
   <xsl:template match="tei:speaker">
      <xsl:text>\noindent </xsl:text>
      <xsl:call-template name="render">
         <xsl:with-param name="rend" select="'smallcaps'" as="xs:string"/>
      </xsl:call-template>
      <xsl:choose>
         <xsl:when test="following-sibling::*[1] = following-sibling::tei:stage">
            <xsl:text> </xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>\newline </xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template match="tei:stage">
      <xsl:call-template name="render">
         <!-- stage-Aweisungen werden kursiv gesetzt, bei vorhandenem @rend wird das ebenfalls ausgewertet -->
         <xsl:with-param name="rend" select="(tokenize(normalize-space(@rend), ' '), 'italic')" as="xs:string*"/>
      </xsl:call-template>
      <xsl:choose>
         <!-- Zwischen speaches wird das stage als eigener Block gesetzt -->
         <xsl:when test="preceding-sibling::tei:sp or following-sibling::tei:sp">
            <xsl:text>\par\smallskip </xsl:text>
         </xsl:when>
         <!-- Zwischen lines wird das stage als eigene Zeile gesetzt -->
         <xsl:when test="parent::tei:sp and following-sibling::*">
            <xsl:text>\newline </xsl:text>
         </xsl:when>
         <!-- Ansonsten einfach inline -->
      </xsl:choose>
   </xsl:template>
   
   <xsl:template match="tei:lg">
      <xsl:text>\noindent </xsl:text>
      <xsl:apply-templates select="*"/>
      <xsl:if test="following-sibling::tei:*">
         <xsl:text>\par\smallskip </xsl:text>
      </xsl:if>
   </xsl:template>
   
   <xsl:template match="tei:l">
      <xsl:apply-templates/>
      <xsl:if test="following-sibling::*">
         <xsl:text>\newline </xsl:text>
      </xsl:if>
   </xsl:template>
   
   <xsl:template match="text()">
      <xsl:value-of select="cgrid:clean-text(.)"/>
   </xsl:template>
   
   <xsl:template match="text()" mode="listing">
      <xsl:value-of select="cgrid:clean-text-xml(.)"/>
   </xsl:template>
   
   <xsl:template name="resolve-ref">
      <xsl:variable name="lang">
         <xsl:value-of select="cgrid:current-language(.)"/>
      </xsl:variable>
      <xsl:variable name="curNode" select="."/>
      <xsl:variable name="ibid">
         <xsl:choose>
            <xsl:when test="$lang = 'en'">
               <xsl:text>Ibid.</xsl:text>
            </xsl:when>
            <xsl:otherwise>
               <xsl:text>Ebd.</xsl:text>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <!-- Der erste Verweis auf die unter ref@target angegebene Literatur wird gesucht -->
      <xsl:variable name="first-bibl-ref" select="cgrid:find-first-bibl-reference(@target)" as="element(tei:ref)?"/>
      <xsl:choose>
         <!-- 
            wenn am <ref> ein @rend='ibid' angegeben ist, wird die Ausgabe der Literaturangabe unterdrückt
            und nur ein "Ebd." und der Inhalt des <ref> ausgegeben
         -->
         <xsl:when test="@rend='ibid'">
            <xsl:choose>
               <xsl:when test="parent::tei:note and preceding-sibling::text()">
                  <xsl:value-of select="lower-case($ibid)"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="$ibid"/>
               </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="normalize-space(.) ne ''">
               <xsl:text>, </xsl:text>
               <xsl:apply-templates/>
            </xsl:if>
         </xsl:when>
         
         <!-- mit ref@rend=full kann das Vollzitat erzwungen werden -->
         <xsl:when test="tokenize(@rend, '\s+')='full'">
            <xsl:call-template name="full-bibliographic-reference">
               <xsl:with-param name="lang" select="$lang"/>
            </xsl:call-template>
         </xsl:when>
         
         <!-- Wenn $first-bibl-ref leer ist, dann ist der einzige Verweis auf die Literatur innerhalb von refs mit @rend='inline' -->
         <xsl:when test="empty($first-bibl-ref)">
            <xsl:call-template name="full-bibliographic-reference">
               <xsl:with-param name="lang" select="$lang"/>
            </xsl:call-template>
         </xsl:when>
         
         <!-- Ausgabe des Kurztitels, wenn das aktuelle ref nicht der erste Verweis auf die Literatur ist -->
         <xsl:when test="not(generate-id(.) = generate-id($first-bibl-ref))">
            <xsl:call-template name="short-bibliographic-reference">
               <xsl:with-param name="lang" select="$lang"/>
               <xsl:with-param name="id-of-first-bibl-ref" select="cgrid:get-note-id($first-bibl-ref)"/>
            </xsl:call-template>
         </xsl:when>
         
         <!-- Ansonsten wird das Vollzitat (= <bibl>) ausgegeben -->
         <xsl:otherwise>
            <xsl:call-template name="full-bibliographic-reference">
               <xsl:with-param name="lang" select="$lang"/>
            </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template name="full-bibliographic-reference">
      <xsl:param name="lang" as="xs:string"/>
      <xsl:variable name="biblio" as="xs:string*">
         <xsl:apply-templates select="id(substring(@target, 2))"/>
      </xsl:variable>
      <xsl:value-of select="string-join($biblio,'')"/>
      <xsl:if test="normalize-space(.) ne ''">
         <xsl:text>, </xsl:text>
         <xsl:value-of select="cgrid:add-here($lang, string-join($biblio,''), normalize-space(.))"/>
         <xsl:apply-templates/>
      </xsl:if>
   </xsl:template>
   
   <xsl:template name="short-bibliographic-reference">
      <xsl:param name="lang" as="xs:string"/>
      <xsl:param name="id-of-first-bibl-ref" as="xs:string"/>
      <xsl:variable name="biblio" as="xs:string*">
         <xsl:apply-templates select="id(substring(@target, 2))/tei:bibl[@type='short']" mode="shortTitle"/>
      </xsl:variable>
      <xsl:value-of select="string-join($biblio,'')"/>
      
      <!-- Verweis auf die Fußnote mit der kompletten Literaturangabe -->
      <xsl:choose>
         <xsl:when test="$lang = 'en'">
            <xsl:text> (see note~\ref{</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text> (wie Anm.\,\ref{</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="$id-of-first-bibl-ref"/>
      <xsl:text>})</xsl:text>
      
      <!-- Folgend wird die Seitenangabe (innerhalb des tei:ref) ausgegeben -->
      <xsl:if test="normalize-space(.) ne ''">
         <xsl:text>, </xsl:text>
         <xsl:value-of select="cgrid:add-here($lang, string-join($biblio,''), normalize-space(.))"/>
         <xsl:apply-templates/>
      </xsl:if>
   </xsl:template>
   
   <xsl:template name="render">
      <xsl:param name="rend" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$rend[1]='italic'">
            <xsl:text>\textit{</xsl:text>
            <xsl:call-template name="render">
               <xsl:with-param name="rend" select="subsequence($rend, 2)"/>
            </xsl:call-template>
            <xsl:text>}</xsl:text>
         </xsl:when>
         <xsl:when test="$rend[1]='underline'">
            <xsl:text>\uline{</xsl:text>
            <xsl:call-template name="render">
               <xsl:with-param name="rend" select="subsequence($rend, 2)"/>
            </xsl:call-template>
            <xsl:text>}</xsl:text>
         </xsl:when>
         <xsl:when test="$rend[1]='doubleunderline'">
            <xsl:text>\uuline{</xsl:text>
            <xsl:call-template name="render">
               <xsl:with-param name="rend" select="subsequence($rend, 2)"/>
            </xsl:call-template>
            <xsl:text>}</xsl:text>
         </xsl:when>
         <xsl:when test="$rend[1]='sup'">
            <xsl:text>\textsuperscript{</xsl:text>
            <xsl:call-template name="render">
               <xsl:with-param name="rend" select="subsequence($rend, 2)"/>
            </xsl:call-template>
            <xsl:text>}</xsl:text>
         </xsl:when>
         <xsl:when test="$rend[1]='spaced'">
            <xsl:text>\so{</xsl:text>
            <xsl:call-template name="render">
               <xsl:with-param name="rend" select="subsequence($rend, 2)"/>
            </xsl:call-template>
            <xsl:text>}</xsl:text>
         </xsl:when>
         <xsl:when test="$rend[1]='bold'">
            <xsl:text>\textbf{</xsl:text>
            <xsl:call-template name="render">
               <xsl:with-param name="rend" select="subsequence($rend, 2)"/>
            </xsl:call-template>
            <xsl:text>}</xsl:text>
         </xsl:when>
         <xsl:when test="$rend[1]='typewriter'">
            <xsl:text>\texttt{</xsl:text>
            <xsl:call-template name="render">
               <xsl:with-param name="rend" select="subsequence($rend, 2)"/>
            </xsl:call-template>
            <xsl:text>}</xsl:text>
         </xsl:when>
         <xsl:when test="$rend[1]='music'">
            <xsl:text>\music{</xsl:text>
            <xsl:call-template name="render">
               <xsl:with-param name="rend" select="subsequence($rend, 2)"/>
            </xsl:call-template>
            <xsl:text>}</xsl:text>
         </xsl:when>
         <xsl:when test="$rend[1]='strikethrough'">
            <xsl:text>\sout{</xsl:text>
            <xsl:call-template name="render">
               <xsl:with-param name="rend" select="subsequence($rend, 2)"/>
            </xsl:call-template>
            <xsl:text>}</xsl:text>
         </xsl:when>
         <xsl:when test="$rend[1]='add'">
            <xsl:text>\textsf{\color{gray050}</xsl:text>
            <xsl:call-template name="render">
               <xsl:with-param name="rend" select="subsequence($rend, 2)"/>
            </xsl:call-template>
            <xsl:text>}</xsl:text>
         </xsl:when>
         <xsl:when test="$rend[1]='smallcaps'">
            <xsl:text>\textsc{</xsl:text>
            <xsl:call-template name="render">
               <xsl:with-param name="rend" select="subsequence($rend, 2)"/>
            </xsl:call-template>
            <xsl:text>}</xsl:text>
         </xsl:when>
         <xsl:when test="$rend[1]='supplied'">
            <xsl:text>{[}</xsl:text>
            <xsl:call-template name="render">
               <xsl:with-param name="rend" select="subsequence($rend, 2)"/>
            </xsl:call-template>
            <xsl:text>{]}</xsl:text>
         </xsl:when>
         <xsl:when test="$rend[1]='normal'">
            <xsl:text>\textnormal{</xsl:text>
            <xsl:call-template name="render">
               <xsl:with-param name="rend" select="subsequence($rend, 2)"/>
            </xsl:call-template>
            <xsl:text>}</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:if test="$rend">
               <xsl:message select="concat('Unknown rendition: ', $rend)"/>
            </xsl:if>
            <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template name="alinea">
      <xsl:text>\par\medskip </xsl:text>
      <xsl:text>\centerline{***}</xsl:text>
      <xsl:text>\par\bigskip </xsl:text>
   </xsl:template>
   
   <xsl:function name="cgrid:set-indent" as="xs:string">
      <xsl:param name="margin" as="xs:string"/>
      <xsl:param name="width" as="xs:string"/>
      <xsl:value-of select="concat('\setlength{\',$margin, 'skip}{', $width, '}')"/>
   </xsl:function>
   
   <!-- Recursively escape various LaTeX special characters -->
   <xsl:function name="cgrid:clean-text" as="xs:string">
      <xsl:param name="string" as="xs:string"/>
      <xsl:variable name="apos">&#x0027;</xsl:variable>
      <xsl:choose>
         <xsl:when test="contains($string, '&#x00A0;')">
            <!-- Geschütztes Leerzeichen (normale Breite) -->
            <xsl:value-of select="cgrid:clean-text(replace($string, '&#x00A0;', '~'))"/>
         </xsl:when>
         <xsl:when test="matches($string, '[^\\]&#x0026;') or matches($string, '^&#x0026;')">
            <!-- Kaufmanns-Und & -->
            <xsl:value-of select="cgrid:clean-text(replace($string, '&#x0026;', '\\&#x0026;'))"/>
         </xsl:when>
         <xsl:when test="contains($string, '&#x2019;')">
            <!-- Apostroph (typographisches muss für LaTeX wieder in ein gerades umgesetzt werden) -->
            <xsl:value-of select="cgrid:clean-text(replace($string, '&#x2019;', $apos))"/>
         </xsl:when>
         <xsl:when test="matches($string, '[&#8201;&#8239;]')">
            <!-- Geschütztes Leerzeichen (schmale Breite) -->
            <xsl:value-of select="cgrid:clean-text(replace($string, '[&#8201;&#8239;]', '\\,'))"/>
         </xsl:when>
         <xsl:when test="matches($string, '[^\{]\[') or matches($string, '^\[')">
            <xsl:value-of select="cgrid:clean-text(replace($string, '\[', '{[}'))"/>
         </xsl:when>
         <xsl:when test="matches($string, '[^\{]\]') or matches($string, '^\]')">
            <xsl:value-of select="cgrid:clean-text(replace($string, '\]', '{]}'))"/>
         </xsl:when>
         <xsl:when test="matches($string, '[^\$]&lt;') or matches($string, '^&lt;')">
            <xsl:value-of select="cgrid:clean-text(replace($string, '&lt;', '\$&lt;\$'))"/>
         </xsl:when>
         <xsl:when test="matches($string, '[^\$]&gt;') or matches($string, '^&gt;')">
            <xsl:value-of select="cgrid:clean-text(replace($string, '&gt;', '\$&gt;\$'))"/>
         </xsl:when>
         <xsl:when test="matches($string, '[^\\]#') or matches($string, '^#')">
            <!-- "#": Latex special characters müssen geschützt werden -->
            <xsl:value-of select="cgrid:clean-text(replace($string, '#', '\\#'))"/>
         </xsl:when>
         <xsl:when test="matches($string, '[^\\]%') or matches($string, '^%')">
            <!-- "%": Latex special characters müssen geschützt werden -->
            <xsl:value-of select="cgrid:clean-text(replace($string, '%', '\\%'))"/>
         </xsl:when>
         <xsl:when test="matches($string, '[^\\]_') or matches($string, '^_')">
            <!-- "_": Latex special characters müssen geschützt werden -->
            <xsl:value-of select="cgrid:clean-text(replace($string, '_', '\\_'))"/>
         </xsl:when>
         <xsl:when test="matches($string, '\n\s*\n')">
            <!-- zwei Zeilenumbrüche müssen vermieden werden, da LaTeX sonst einen Umbruch einfügt -->
            <xsl:value-of select="cgrid:clean-text(replace($string, '\s*\n', ' '))"/>
         </xsl:when>
         <xsl:when test="contains($string, '/')">
            <!-- Forward Slash (verhindert Trennstelle und wird daher ersetzt) -->
            <xsl:value-of select="cgrid:clean-text(replace($string, '/', '\\slash '))"/>
         </xsl:when>
         <xsl:when test="contains($string, 'Jahrhundert')">
            <!-- Silbentrennung: Da "Jahrhundert" oft in Kombination als "18.\,Jahrhundert" erscheint und an diesen Stellen die Silbentrennung unterdrückt wird -->
            <xsl:value-of select="cgrid:clean-text(replace($string, 'Jahrhundert', 'Jahr&quot;-hun&quot;-dert'))"/>
         </xsl:when>
         <xsl:when test="contains($string, 'Carl-Maria-von-Weber-Gesamtausgabe')">
            <!-- Silbentrennung:  -->
            <xsl:value-of select="cgrid:clean-text(replace($string, 'Carl-Maria-von-Weber-Gesamtausgabe', 'Carl-Maria&quot;=von&quot;=Weber&quot;=Gesamt&quot;-ausgabe'))"/>
         </xsl:when>
         <xsl:when test="matches($string, '\d–\d')">
            <!-- Silbentrennung: "1750–1800" -->
            <xsl:value-of select="cgrid:clean-text(replace($string, '(\d)–(\d)', '$1–&quot;&quot;$2'))"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$string"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
   
   <!-- Recursively escape various XML special characters -->
   <xsl:function name="cgrid:clean-text-xml" as="xs:string">
      <xsl:param name="string" as="xs:string"/>
      <xsl:choose>
         <xsl:when test="matches($string, '&#x0026;[^alg][^mt][^p][^;]')">
            <!-- Kaufmanns-Und & in der Mitte oder am Anfang des strings -->
            <xsl:value-of select="cgrid:clean-text-xml(replace($string, '&#x0026;([^a][^m][^p][^;])', '&amp;amp;$1'))"/>
         </xsl:when>
         <xsl:when test="matches($string, '&#x0026;\s*$')">
            <!-- Kaufmanns-Und & am Ende des strings -->
            <xsl:value-of select="cgrid:clean-text-xml(replace($string, '&#x0026;(\s*)$', '&amp;amp;$1'))"/>
         </xsl:when>
         <xsl:when test="matches($string, '&lt;')">
            <xsl:value-of select="cgrid:clean-text-xml(replace($string, '&lt;', '&amp;lt;'))"/>
         </xsl:when>
         <xsl:when test="matches($string, '&gt;')">
            <xsl:value-of select="cgrid:clean-text-xml(replace($string, '&gt;', '&amp;gt;'))"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$string"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
   
   <!-- A mapping of language codes (e.g. 'en') to strings recognised by the LaTeX Babel package -->
   <xsl:function name="cgrid:language-code-to-babel" as="xs:string">
      <xsl:param name="language-code" as="xs:string"/>
      <xsl:choose>
         <xsl:when test="$language-code = 'en'">english</xsl:when>
         <xsl:when test="$language-code = 'fr'">french</xsl:when>
         <xsl:when test="$language-code = 'gr'">greek</xsl:when>
         <xsl:when test="$language-code = 'it'">italian</xsl:when>
         <xsl:when test="$language-code = 'de'">ngerman</xsl:when>
      </xsl:choose>
   </xsl:function>
   
   <!-- Return the language codes (e.g. 'en') of the current article -->
   <xsl:function name="cgrid:current-language" as="xs:string">
      <xsl:param name="node" as="node()"/>
      <xsl:value-of select="$node/ancestor-or-self::tei:TEI//tei:langUsage/tei:language/@ident"/>
   </xsl:function>
   
   <!-- Construct footnotes with label (if id is given) -->
   <xsl:function name="cgrid:footnote" as="xs:string">
      <xsl:param name="content" as="item()*"/>
      <xsl:param name="id" as="xs:string?"/>
      <xsl:variable name="footnoteText" select="cgrid:footnoteText($content)" as="xs:string"/>
      <xsl:variable name="label" as="xs:string?">
         <xsl:choose>
            <xsl:when test="$id">
               <xsl:value-of select="concat('\label{',normalize-space($id),'}')"/>
            </xsl:when>
            <xsl:otherwise/>
         </xsl:choose>
      </xsl:variable>
      <xsl:value-of select="concat(
         '\footnote{',
         $footnoteText,
         $label,
         '}'
         )"/>
   </xsl:function>
   
   <!-- Prepare footnote text, i.e. normalize-spaced and with a full stop at the end -->
   <xsl:function name="cgrid:footnoteText" as="xs:string">
      <xsl:param name="content" as="item()*"/>
      <xsl:variable name="footnoteText" select="normalize-space(string-join($content, ''))" as="xs:string"/>
      <xsl:choose>
         <!-- Überprüfen, ob bereits ein Satzendepunkt den Fußnotentext abschließt -->
         <xsl:when test="matches($footnoteText, '[\.\?!]\}?$')">
            <xsl:value-of select="$footnoteText"/>
         </xsl:when>
         <xsl:otherwise>
            <!-- Ansonsten wird am Ende ein Punkt zugefügt -->
            <xsl:value-of select="concat($footnoteText, '.')"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
   
   <!-- Add 'hier:' wenn bei Artikeln mit Seitenbereich ein Ausschnitt gewählt wird -->
   <!-- z.B.: Karl Maurer, Textkritik und Interpretation, in: Poetica 16, 1984, S. 324–355, hier: S. 353. -->
   <xsl:function name="cgrid:add-here" as="xs:string?">
      <xsl:param name="lang" as="xs:string"/>
      <xsl:param name="biblioTarget" as="xs:string"/>
      <xsl:param name="biblioRef" as="xs:string"/>
      <xsl:choose>
         <xsl:when test="$lang eq 'en'">
            <xsl:if test="matches($biblioTarget, 'p\.\\,[\dIVX]+') and matches($biblioRef, 'p\.&#8239;[\dIVX]+')">
               <xsl:text> here </xsl:text>
            </xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <xsl:if test="matches($biblioTarget, 'Sp?\.\\,[\dIVX]+') and matches($biblioRef, 'Sp?\.&#8239;[\dIVX]+')">
               <xsl:text> hier </xsl:text>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
   
   <!-- 
      Ob der Kurztitel genommen wird, wird an anderer Stelle entschieden
      Hier hangeln wir uns nur zur ersten Nennung eines ref@target
      und geben die entsprechende xml:id aus
   -->
   <xsl:function name="cgrid:find-first-bibl-reference" as="element(tei:ref)?">
      <xsl:param name="target" as="xs:string"/>
      <!-- direct references to the target -->
      <xsl:variable name="direct-refs" select="key('biblio-refs', $target, $docRoot)"/>
      <!-- indirect references to the target via tei:bibl objects and their respective references -->
      <xsl:variable name="indirect-refs" select="key('biblio-refs', $direct-refs/ancestor::tei:bibl/@xml:id/concat('#',.), $docRoot)"/>
      
      <!-- return the first occurence of the union of both sets -->
      <xsl:sequence select="($direct-refs | $indirect-refs)[1]"/>
   </xsl:function>
   
   <xsl:function name="cgrid:get-note-id" as="xs:string">
      <xsl:param name="ref" as="element(tei:ref)?"/>
      <xsl:choose>
         <!-- Falls vorhanden muss die ID des Elterelements note (oder ref) genommen werden -->
         <xsl:when test="$ref/parent::tei:note">
            <xsl:value-of select="$ref/parent::tei:note/@xml:id"/>
         </xsl:when>
         <xsl:when test="$ref/parent::tei:ref">
            <xsl:value-of select="$ref/parent::tei:ref/@xml:id"/>
         </xsl:when>
         <!-- Wenn das target ein bibl ist, dann muss rekursiv dessen erste Erwähnung gesucht werden -->
         <xsl:when test="$ref/parent::tei:bibl">
            <xsl:value-of select="cgrid:find-first-bibl-reference(($docRoot//@target[.=concat('#', $ref/parent::tei:bibl/@xml:id)])[1])"/>
            <xsl:message>cgrid:get-note-id(): The rare bibl case; found for ref@target='<xsl:value-of select="$ref/@target"/>'.</xsl:message>
         </xsl:when>
         <xsl:when test="$ref/@xml:id">
            <xsl:value-of select="$ref/@xml:id"/>
         </xsl:when>
         <xsl:when test="empty($ref)">
            <xsl:message>cgrid:get-note-id(): Empty ref</xsl:message>
         </xsl:when>
         <xsl:otherwise>
            <xsl:message>cgrid:get-note-id(): No ID found for ref@target='<xsl:value-of select="$ref/@target"/>'; this should not happen :(</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
   
   <xsl:template match="*" mode="listing serialize">
      <xsl:text>&lt;</xsl:text>
      <xsl:value-of select="name()"/>
      <xsl:apply-templates select="@*" mode="#current" />
      <xsl:choose>
         <xsl:when test="node()">
            <xsl:text>&gt;</xsl:text>
            <xsl:apply-templates mode="#current"/>
            <xsl:text>&lt;/</xsl:text>
            <xsl:value-of select="name()"/>
            <xsl:text>&gt;</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text> /&gt;</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template match="comment()" mode="listing serialize">
      <xsl:text>&lt;!--</xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>--&gt;</xsl:text>
   </xsl:template>
   
   <xsl:template match="@*" mode="serialize">
      <xsl:text> </xsl:text>
      <xsl:value-of select="name()"/>
      <xsl:text>=\textquotedbl{}</xsl:text>
      <xsl:value-of select="cgrid:clean-text(.)"/>
      <xsl:text>\textquotedbl{}</xsl:text>
   </xsl:template>
   
   <xsl:template match="@*" mode="listing">
      <xsl:text> </xsl:text>
      <xsl:value-of select="name()"/>
      <xsl:text>="</xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>"</xsl:text>
   </xsl:template>
   
   <!-- Function for abstracting the chapter preamble -->
   <xsl:function name="cgrid:chapter-preamble">
      <xsl:param name="lang" as="xs:string"/>
      <xsl:param name="toc-title" as="xs:string"/>
      <xsl:param name="chap-title" as="xs:string"/>
      <xsl:param name="markleft" as="xs:string"/>
      <xsl:param name="markright" as="xs:string"/>
      
      <!-- First, set the language of the chapter -->
      <xsl:text>\selectlanguage{</xsl:text>
      <xsl:value-of select="$lang"/>
      <xsl:text>}</xsl:text>
      
      <!-- Rücksetzen diverser Zähler -->
      <xsl:text>
         \setcounter{section}{0}
         \setcounter{table}{0}
         \setcounter{figure}{0}
         \setcounter{notenbeispiel}{0}
         \setcounter{footnote}{0}
      </xsl:text>
      
      <!-- Überschrift und TOC-Eintrag -->
      <!-- in eckigen Klammern zunächst der TOC-Eintrag -->
      <xsl:text>\addchap[</xsl:text>
      <xsl:value-of select="normalize-space($toc-title)"/>
      <!-- danach die chapter-Überschrift (Untertitel wird hier in large gesetzt) -->
      <xsl:text>]{</xsl:text>
      <xsl:value-of select="normalize-space($chap-title)"/>
      <xsl:text>}</xsl:text>
      
      <!-- Kolumnentitel -->
      <xsl:text>\markleft{</xsl:text>
      <xsl:value-of select="normalize-space($markleft)"/>
      <xsl:text>}\markright{</xsl:text>
      <xsl:value-of select="normalize-space($markright)"/>
      <xsl:text>}</xsl:text>
   </xsl:function>
   
   <!-- Returns The chapter title as a string -->
   <!-- param part1: Displayed above the horizontal rule -->
   <!-- param part2: Displayed beneath the horizontal rule -->
   <xsl:function name="cgrid:chap-title" as="xs:string">
      <xsl:param name="part1" as="xs:string"/>
      <xsl:param name="part2" as="xs:string?"/>
      <xsl:value-of select="concat($part1, '\vspace{-.9ex}\newline\makebox[\linewidth]{\hrulefill}\vspace{.2ex}\newline{}', $part2)"/>
   </xsl:function>
   
   <xsl:function name="cgrid:normalize-string-join" as="xs:string?">
      <xsl:param name="items" as="item()*"/>
      <xsl:choose>
         <xsl:when test="exists($items)">
            <xsl:value-of select="normalize-space(string-join($items, ''))"/>
         </xsl:when>
         <xsl:otherwise/>
      </xsl:choose>
   </xsl:function>
   
</xsl:stylesheet>