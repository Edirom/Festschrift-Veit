\version "2.18.0"

\header {
  % Voreingestellte LilyPond-Tagline entfernen
  tagline = ##f
}

\layout {
  \context {
    \Score
    \remove "Bar_number_engraver"
  }
}

global = {
  \key f \major
  \time 4/4
    \tempo "Andantino quasi Allegretto"
}

sopranoVoice = \relative c'' {
  \global
  \dynamicUp
  
}

verse = \lyricmode {
  
  
}

right = \relative c'' {
  \global
  <f, a>8 c <f a>8 c <f a>8 c <e g bes> c
  \repeat unfold 4 {<a' c> c,}
  \override BreathingSign.text = \markup {
    \musicglyph #"scripts.caesura.straight"
  } \breathe
  \repeat unfold 2 {<a' c> c,} <a' c> c, <g' bes> c,
  <a' c> c, <a' c> c, <g' bes> c, <g' bes> c,
  <f c'> c <g' bes> c, <f a> c <e g> c
  <des f>2\ff^\markup { \italic{Gli Araldi danno il Segno di morte}} r
  <des des'>~<des des'>8 r r4
  <f des'>4 r <as f'> r
  <ais fis'> r <d! f a!> r
  <cis e! a> r <b e gis> r
  \key a \major a2~a8 b-. cis-. d-.
  e2~e8 fis-. e-. cis-.
  a2~a8 b-. cis-. d-.
  e2~e8 fis-. gis-. a-.
  b2~b8 ais-. b-. cis-.
  d2~d8 cis-. b-. a-.
  gis2~gis8 a-. gis-. fis-.
  e[ r16 fis e8 r16 fis] e8[ r16 d cis8 r16 b]
  a2
}

left = \relative c {
  \global
  f4 r r2 
  f4 r r2 \override BreathingSign.text = \markup {
    \musicglyph #"scripts.caesura.straight"
  } \breathe
  f4 r r2
  a4 r bes, r
  a bes c r
  \repeat tremolo 8 {des,32 des'} des,8 r r4
  \repeat tremolo 8 {des32 des'} des,8 r r4
  des'4 r cis r
  fis r d! r
  e! r e r
  \key a \major <a cis>8 e' <a, cis> e' a,4 r
  <a cis>8 e' <a, cis> e' a,4 r
  <a cis>8 e' <a, cis> e' a,4 r
  <a cis>8 e' <a, cis> e' a,4 r
  <a d>8 fis' <a, d>8 fis' <a, d>4 r
  <a d>8 f' <a, d>8 f' <a, d>4 r
  <a d>8 e' <a, d>8 e' <a, d>4 r
  <a, d e gis> <a d e gis> <a d e gis> <a d e gis>
  <a cis e a> s4
  
}

sopranoVoicePart = \new Staff \with {
  %instrumentName = "S."
} {
  << 
  \key f \major
  <<\new Voice = "one" \relative c'' 
    { a2^"Emma"~\tuplet 3/2 {a8( c bes)} \tuplet 3/2 {bes( d c)}
  c4.( d16 e) f4-. r
   \override BreathingSign.text = \markup {
    \musicglyph #"scripts.caesura.straight"
  } \breathe
  a,2~\tuplet 3/2 {a8( c bes)} \tuplet 3/2 {bes( d c)}
  c4 a'8( g) g[( f]) \autoBeamOff e d
  \autoBeamOn
  \tuplet 3/2{ c( e d)} \tuplet 3/2 {bes( d c)} \tuplet 3/2 {a( d c)} \tuplet 3/2 {bes( g a)}
  \autoBeamOff f f r4 r2
  r2 r4 as8. as16
  des4. cis8 cis4\( dis8\) eis
  fis2 fis4 gis8 a!
  e!1 \bar "||" \key a \major
  a,4 r r2
  \clef tenor r2 e4.^"Norcesto" cis8
  a4 a r2
  r2 e'4 cis
  b b r2
  r2 r4 \stemUp  
  b4 d2 
    r2
  r2 r4 e cis a}
  \new Voice = "two" \relative c' {  s1 s s s s s s s s s s s s s s s2 s4 \stemDown b4 e,2 s2 s s4 e cis' a}
  >>

  \new Lyrics \lyricsto "one" {Per -- te so -- lo
  lie -- ti
  fu -- _ ro lie -- ti
  fu -- ro_i gior -- ni
  mie -- i.
  Si -- vo -- lia -- mo~u ni -- ti al cie -- lo; mor -- te
  ven -- ga!
  V'ar -- res -- ta -- te!
  E'in -- no --
  cen -- te! 
  E -- che!
  Fia ve -- ro!
 }
   >>
   }
  
%\addlyrics { \verse }


pianoPart = \new PianoStaff \with {
  %instrumentName = "Kl."
} <<
  \new Staff = "right" \right
  \new Staff = "left" { \clef bass \left }
>>

\score {
  <<
    \sopranoVoicePart
    \pianoPart
  >>
  \layout { }
}
