\version "2.18.0"

\header {
  % Voreingestellte LilyPond-Tagline entfernen
  tagline = ##f
}

#(set-global-staff-size 16)

\layout {
  \context {
    \Score
    \remove "Bar_number_engraver"
  }
}

global = {
  \key es \major
  \numericTimeSignature
  \time 6/8
  \partial 4.
}

tenorVoice = \relative c' {
  \global
  \dynamicUp
  \autoBeamOff
  r4 r8 R2.
  r4^"Tenor" g8 g4 g8
  g4 f8 g4 as8
  bes4 r8 r4 r8
  R2.
  r4 g8 g g g
  g4 f8 g4 as8
  bes4.~bes4
  
}

verseTenorVoice = \lyricmode {
  Sein na -- hes 
  En -- de kün -- digt 
  an
  des tö -- nen -- den Er -- zes Ju -- bel --
  lied,_
  
}

bassVoice = \relative c {
  \global
  \dynamicUp
  \autoBeamOff
  r4 r8 R2.
  r4^"Bass" es8 es4 es8
  es4 bes8 es4 f8
  es4 r8 r4 r8
  R2.
  r4 es8 es es es 
  es4 bes8 es4 f8
  g4.~g4
  
}

verseBassVoice = \lyricmode {
  Sein na -- hes 
  En -- de kün -- digt 
  an
  des tö -- nen -- den Er -- zes Ju -- bel --
  lied,_
  
}

right = \relative c'' {
  \global
  <es g>8^"Ob."\f <es g> <es g>
  <es g>4 <bes f'>8 <es g>4 <f as>8
  <g bes>4 <es, g>8_"Kl." <es g>4 <es g>8
  <es g>4 <bes f'>8 <es g>4 <f as>8
  <g bes>4 <es' g>8^"Ob." <es g>4 <es g>8
  <es g>4 <bes f'>8 <es g>4 <f as>8
  <g bes>4 <es, g>8_"Kl." <es g>4 <es g>8
  <es g>4 <bes f'>8 <es g>4 <f as>8
  <g bes>8( es') <g, bes> <g bes>
  
}

left = \relative c' {
  \global
  \clef treble
  <es g>8^"Hr." <es g> <es g>
  <es g>4 <bes f'>8 <es g>4 <f as>8
  <g bes>4 \clef bass <es, g>8^"Fg." <es g>4 <es g>8
  <es g>4 <bes f'>8 <es g>4 <f as>8
  <g bes>4 \clef treble <es' g>8^"Hr." <es g>4 <es g>8
  <es g>4 <bes f'>8 <es g>4 <f as>8
  <g bes>4 \clef bass <es, g>8^"Fg." <es g>4 <es g>8
  <es g>4 <bes f'>8 <es g>4 <f as>8
  <es g bes>^"Str." <es es'> <es es'>-. <es es'>-.
  
}

tenorVoicePart = \new Staff \with {
  %instrumentName = "Tenor"
} { \clef "treble_8" \tenorVoice }
\addlyrics { \verseTenorVoice }

bassVoicePart = \new Staff \with {
  %instrumentName = "Bass"
} { \clef bass \bassVoice }
\addlyrics { \verseBassVoice }

pianoPart = \new PianoStaff \with {
  %instrumentName = "Klavier"
} <<
  \new Staff = "right" \right
  \new Staff = "left" { \clef bass \left }
>>

\score {
  <<
    \tenorVoicePart
    \bassVoicePart
    \pianoPart
  >>
  \layout {indent = #0 }
}
