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
  \key es \major
  \numericTimeSignature
  \time 6/8
  \partial 4.
}

scoreAClarinet = \relative c'' {
  %\global
  \key f \major
  %\transposition bes

  a'8^\markup {\dynamic f} a a
  \acciaccatura bes8 a4( g8) a4( bes8)
  c4. a8 a a
  \acciaccatura bes a4( g8) a4( bes8)
  c8( a) bes c c c
  c4. g8^\markup {\dynamic p} g g
  g4( a8) bes4( c8)
  \acciaccatura bes8 a4( g8) c8( bes) a
  c( bes) a g a f
  g4. g8^\markup {\dynamic f} g g
  g4( a8) bes4( c8)
  \acciaccatura bes8 a4( g8) c8( bes) a
  c( bes) a \acciaccatura a8 g f g
  f16( a) g f e d
  \skip 4 \skip 8
}

scoreAViolinI = \relative c'' {
  \global
  es8\f es es
  \acciaccatura f es4( d8) es4( f8)
  g4. es8 es es
  \acciaccatura f8 es4( d8) es4( f8)
  g8( es) f g g g
  g4. d8 d d
  d4( es8) f4 g8
  \acciaccatura f8 es4( d8) g8( f) es
  g( f) es d es c
  d4. d8\f d d d4( es8) f4( g8)
  \acciaccatura f8 es4( d8) g8( f) es
  g( f) es \acciaccatura es8 d c d
  es4 r8
  \skip 4 \skip 8
}

scoreAViolinII = \relative c'' {
  \global
  r4 r8
  es,2.\p~
  es~
  es~
  es~
  es4. r4 r8
  bes'2.~
  bes~
  bes~
  bes4. r4 r8
  bes2.\p~
  bes~
  bes
  g4 r8
  \skip 4 \skip 8
}

scoreAViola = \relative c' {
  \global
  r4 r8
  R2.
  R
  R
  R
  R
  R
  R
  R
  R
  R
  R
  R
  bes2.\p \bar ""
  
}

scoreAContrabass = \relative c {
  \global
  r4 r8
  es4.\p r4 r8
  es,4. r4 r8
  es'4. r4 r8
  es,4. r4 r8
  es'4. r4 r8
  bes4. r4 r8
  bes'4. r4 r8
  bes,4 r8 bes'4 r8
  bes,4. r4 r8
  bes'4. r4 r8
  bes,4. r4 r8
  es4 r8 bes'4 r8
  es,4 r8
  \skip 4 \skip 8
}

scoreAClarinetPart = \new Staff \with {
  instrumentName = "Solo Kl. (B)"
} \scoreAClarinet

scoreAViolinIPart = \new Staff \with {
  instrumentName = "Vl. 1"
} \scoreAViolinI

scoreAViolinIIPart = \new Staff \with {
  instrumentName = "Vl. 2"
} \scoreAViolinII

scoreAViolaPart = \new Staff \with {
  instrumentName = "Va."
} { \clef alto \scoreAViola }

scoreAContrabassPart = \new Staff \with {
  instrumentName = "B."
} { \clef bass \scoreAContrabass }

\score {
  <<
    \scoreAClarinetPart
    \scoreAViolinIPart
    \scoreAViolinIIPart
    \scoreAViolaPart
    \scoreAContrabassPart
  >>
  \layout { }
}
