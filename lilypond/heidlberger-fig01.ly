\version "2.18.0"

\header {
  % Voreingestellte LilyPond-Tagline entfernen
  tagline = ##f
}

\paper { 
  print-page-number = ##f 
} 

\layout {
  \context {
    %\Score
    %\remove "Bar_number_engraver"
  }
  indent = 2\cm
}

global = {
  \key es \major
  \time 4/4
}

clarinet = \relative c'' {
  \key f \major
  a'1\fermata^\pppp_\cresc
  bes\!^\markup {\italic {Cadenza ad. lib.}}_\fermata_\ff
  e,,\fermata
  R r2 r16 c'-\markup {\italic dolce} ( d c b c d c)
  f( e d c b c d c a' g f e d c b c)
   \override BreathingSign.text = \markup {
    \musicglyph #"scripts.caesura.straight"
  } \breathe
  
  %\set Score.barNumberVisibility = #all-bar-numbers-visible
  \set Score.currentBarNumber = #14
  %\bar "" 
  
  f2-\markup {\italic [dolce]}~f8 e\turn g c,
  a'2~a8( bes) g-. e-.
  c'4 bes16 a g f d'8-! r16 c\f bes a g f
  e-. c-. bes-. g-. e-. c-. bes-. g-. f4 r 
  R1
  R
  \tuplet 3/2 4 { r8-\markup{\italic{(die Stimme nachahmend)}} c''' c } \tuplet 3/2 4 { c8 c c } d4-> c8 r
  r4 c,,\trill\ppp d-> c8 r
  R1
  r2-\markup{\italic{(das Clarinett parodiert die Stimme)}} r8 \autoBeamOff c' e f
  fis2 g4-! r
  r8 c,-! e-! g-! bes4. g8
  e4.-> g8 \autoBeamOn bes2~
  bes2.~bes16. c32 a16. c32
  bes2.~bes16. c32 a16. c32
  \repeat unfold 4 {bes16. c32 a16. c32}
  bes2.\startTrillSpan \tuplet 6/4  {r8\stopTrillSpan d16( c bes a)}
  \tuplet 6/4  {g a bes a g f} \tuplet 6/4 {e f g f e d} \tuplet 6/4 {c e g e c g} \tuplet 6/4 {e g c g e g}
  
}

sopranoVoice = \relative c'' {
  \global
  \dynamicUp
  \autoBeamOff
  R1 R R
  r4 bes8 bes16 c e8 d r f
  f bes, r4 r2 R1
   \override BreathingSign.text = \markup {
    \musicglyph #"scripts.caesura.straight"
  } \breathe
  R1 R R R
  r4 r8^\markup{\italic {con tenerezza}} bes c4-> bes8 r
  r8 bes \tuplet 3/2 4 {bes bes bes} c4->( bes8) r8
  R1 R
  r2 r8 bes d es
  e2 f4 r
  r2 r8 bes,\f d f
  as4.( f8-!) d4 r
  as'4.-> ( f8) f2~\autoBeamOn
  f2.~f16. g32 e16. g32
  f2.~f16. g32 e16. g32
  \repeat unfold 4 {f16. g32 e16. g32}
  f4 r r2 R1
  
}

verse = \lyricmode {
  ah ch'e -- gli des -- so io o -- do
  ci vie -- ne
  ci cie -- ne per me
  dun -- quee -- gli 
  mia -- ma
  dun -- quee -- gli
  mia -- ma
  mia -- ma
}

right = \relative c'' {
  \global
  R1
  <d f>1\p^\markup {\teeny Bläser/Pauke}~
  <d f>4\! r r2
  R1 R R
   \override BreathingSign.text = \markup {
    \musicglyph #"scripts.caesura.straight"
  } \breathe
  <<{g,8( bes es bes as bes d bes)
    g( bes es bes as bes d bes)
    g-. bes-. es-. bes-. as-. c-. f-. c-.
    as-. bes-.\cresc d-. bes-. es\!}\\
    {es,2-"Streicher" f
    es f4 d
    es2 f4 as
    <d, f>2 <es g>8}
  >>
  r8 r4
  <bes'~ e>2->^"Ob/Fg/Hr"\p( <bes f'>8-.) r r4
  <bes~ e>2->( <bes f'>8-.) r r4
  <<{g2->( f8-.)}\\{e2^"Streicher"( f8)}>> r8 r4
  <<{g2->( f8-.)}\\{e2( f8)}>> r8 r4
  R1 R R R
  <d f>2->\sfz~<d f >8 r r4
  R1
  <d f>8\p r r4 r2
  <d f>8 r r4 r2
  <d f>8 r r4 r2
  R1
}

left = \relative c' {
  \global
  R1
  <bes, as'>~^\cresc<bes as'>4\! r r2
  R1 R R
   \override BreathingSign.text = \markup {
    \musicglyph #"scripts.caesura.straight"
  } \breathe
  es1 es2 f4 bes, es g, <as f'>2
  <bes bes'> <es bes'>8 r8 r4
  <bes' cis g'>2( <bes d as'>8-.) r8 r4
  <bes cis g'>2( <bes d as'>8-.) r8 r4
  <bes cis>2->\pp( <bes d>8-.) r8 r4
  <bes cis>2->\ppp( <bes d>8-.) r8 r4
  R1 R R R
  <bes, bes'>2->~<bes bes'>8 r8 r4
  R1
  <bes bes'>8 r8 r4 r2
  <bes bes'>8 r8 r4 r2
  <bes bes'>8 r8 r4 r2
  R1
}

clarinetPart = \new Staff \with {
  instrumentName = \markup { \teeny
         \column { "Clarinetto"
           \line { "principale in B"} } }
} \clarinet

sopranoVoicePart = \new Staff \with {
  instrumentName =  \markup { \center-align { "Teolinda" } }
} { \sopranoVoice }
\addlyrics { \verse }

pianoPart = \new PianoStaff \with {
  instrumentName =  \markup { \center-align {"Orch."} }
} <<
  \new Staff = "right" \right
  \new Staff = "left" { \clef bass \left }
>>

\score {
  <<
    \clarinetPart
    \sopranoVoicePart
    \pianoPart
  >>
  \layout { }
}
