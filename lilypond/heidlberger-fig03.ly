\version "2.18.0"

#(set-global-staff-size 15)

\header {
  % Voreingestellte LilyPond-Tagline entfernen
  tagline = ##f
}

global = {
  \key g \major
 % \numericTimeSignature
  \time 4/4
  \autoBeamOff
  \partial 4
  %\tempo "Andantino"
}

\layout {
  \context {
    \Score
    \override SystemStartBrace.style = #'bar-line
    \omit SystemStartBar
    \override SystemStartBrace.padding = #-0.1
    \override SystemStartBrace.thickness = #1.6
    \remove "Mark_engraver"
    \override StaffGrouper.staffgroup-staff-spacing.basic-distance = #15
  }
}

sopranoVoice = 
\relative c' {
  \global
  
  d8.^\markup "Thema" d16
  g2. c16[( b a b])
  g8 r g2 d'4
  cis16[( d e d]) a2 d4
  c16[( b a b]) g4

   % \bar " "
}
  
verseSopranoVoice = 
\lyricmode {
Il pia -- cer a -- leg -- gi a -- leg -- gi
in -- tor -- no
  
}

tenorVoice = 
\relative c' {
  \global
 
  d8.^\markup "Variation 1" d16
  g8 r g4~g16[( b d b]) d[( b d b])
  g8 r g4~g16[( b d b]) d[( b d b])
  c8 e4-> a,-> c-> fis,8
  g[ a16 b] c[ d e fis] g4

  %\bar " "
}

verseTenorVoice = 
\lyricmode {

Voi don -- 
zel -- le _
e voi pas -- 
to -- ri e voi pas --
to -- _ ri
  
}

altoVoice = \relative c' {
  \global
  
  d8.^\markup "Variation 2" d16
  g16.[( b32 a16. c32] b16.[ d32 c16. e32]) d8 e16[( d]) e[( d]) e[(d])
  g,16.[( b32 a16. c32] b16.[ d32 c16. e32]) d8 e16[( d]) e16[( d])  e16\( d\)
  c8[ e16( d] c[ b a g]) fis8 a d c
  b[ d16( c] b[ c a b]) g4
  % \bar " "
}
  

verseAltoVoice = \lyricmode {
  il pia -- cer __ _ a -- leg -- gi_in tor -- no e bril -- la _ gio -- ja in og -- ni cor __ _
  
}

bcMusic = \relative c' {
  \global
  
  d8.^\markup "[Variation 3]" d16 
  g16[( a g a]) g8 d'8-> a16[( b a b]) a8 d->
  b16[( c b c]) b8 g'8-> a,16[( b a b]) a8 e'->
  g,16[( a g a]) g8 d'-> fis,16[( g fis g]) fis8 d'-> c2\( b4\)
   % \bar " "
}

versebcMusic = \lyricmode {
  sacro a_Ol -- fre do è si _ bel
  gior -- _ no tut -- _ to spi -- _ ri pa -- ce 
  a -- mo -- re
}

sopranoVoicePart = \new Staff \with {
  %instrumentName = ""
} { \sopranoVoice }
\addlyrics { \verseSopranoVoice }

tenorVoicePart = \new Staff \with {
  %instrumentName = ""
} { \tenorVoice }
\addlyrics { \verseTenorVoice }

altoVoicePart = \new Staff \with {
  %instrumentName = ""
} { \altoVoice }
\addlyrics { \verseAltoVoice }

bassoContinuoPart = \new Staff \with {
  %instrumentName = ""
} {\bcMusic }
\addlyrics {\versebcMusic}

\score {
  <<
   \sopranoVoicePart
  \tenorVoicePart
    \altoVoicePart
    \bassoContinuoPart
  >>
  \layout {
    indent = #0
%line-width = #150
%ragged-last = ##t
    \context {
    \Score
    \omit BarNumber
    % or:
    %\remove "Bar_number_engraver"
    %noindent
    

  } }
}