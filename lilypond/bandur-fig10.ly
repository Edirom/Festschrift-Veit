\version "2.18.0"

\header {
  % Voreingestellte LilyPond-Tagline entfernen
  tagline = ##f
}

\layout {
  \context {
    \Score
    %\remove "Bar_number_engraver"
  }
}

global = {
  \key c \major
  \numericTimeSignature
  \time 6/8
  \partial 4.
}

violin = \relative c'' {
  \global
  \set Score.barNumberVisibility = #all-bar-numbers-visible
  \set Score.currentBarNumber = #126
  \override Score.BarNumber.self-alignment-X = #LEFT
  \bar "" e8 e e 
  e4 d8 e4 f8
  g4. e8 e e
  e4 d8 e4 f8
  g e f g e f
  g4. d8 d d
  d4 e8 f4 g8
  e4 d8 g f e
  g f e d e c
  d4 r8 d d d
  d4 e8 f4 g8
  \grace f8 e4d8 g f e
  g f e \grace e8 d c d
  c4. d8 d d
  d4 e8 f4 g8
  e4 d8 r4 r8
  
}

\score {
  \new Staff \with {
    %instrumentName = "Violine"
  } \violin
  \layout { indent = #0 }
}
