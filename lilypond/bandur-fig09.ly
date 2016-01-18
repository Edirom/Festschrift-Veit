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
  \key d \major
  \numericTimeSignature
  \time 6/8
  \partial 4.
  \tempo \markup { \column {
        \line { Allegro }
        \line { Fanfare \italic L'Halali }
    } } 
}

scoreAOboe = \relative c'' {
  \global
  <<
    {fis8^\f fis fis
    \grace g8 fis4 e8 \grace g8 fis4 g8
    a4. fis8 fis fis
    \grace g8 fis4 e8 \grace g8 fis4 g8
    a4}\\
    {d,8 d d
    \grace e8 d4 cis8 \grace e8 d4 e8
    fis4. d8 d d
    \grace e8 d4 cis8 d4 e8
    fis4}
  >>
   r8
}

scoreAViolinI = \relative c'' {
  \global
  r4 r8
  R2.
  r4 r8 <a fis'> <a fis'> <a fis'>
  \grace g'8 < a, fis' >4 <a e'>8  \grace g'8 < a, fis' >4 <a g'>8
  <d, a' a'>4.
  
}

scoreAViolinII = \relative c'' {
  \global
  r4 r8
  R2.
  r4 r8 d8 d d \grace e8 d4 cis8 d4 e8 fis4 r8
  
}

scoreAHornF = \relative c'' {
  \global
  \transposition f
  <<
    {e8 e e
    e4 d8 \grace fis8 e4 fis8
    g4. e8 e e
    e4 d8 \grace fis8 e4 fis8
    g4.}\\
    {cis,8 cis cis
    cis4 g8 cis4 d8
    e4. cis8 cis cis
    cis4 g8 cis4 d8
    e4.}
  >>
  
}

scoreAViola = \relative c' {
  \global
  r4 r8
  R2.
  r4 r8 d,8\f d d
  d4. d4. d4 r8
  
}

scoreABassVoice = \relative c {
  \global
  \dynamicUp
  r4 r8
  R2. R R r4 r8
  
}

scoreABassoon = \relative c {
  \global
  d8 d d
  d fis a d4 d8
  d4. d,8 d d
  d fis a d4 d8
  d4 r8
  
}

scoreAContrabass = \relative c {
  \global
  r4 r8
  R2.
  r4 r8 d8\f d d
  d4. d4. d4 r8
  
}

scoreAOboePart = \new Staff \with {
  instrumentName = "Ob."
} \scoreAOboe

scoreAViolinIPart = \new Staff \with {
  instrumentName = "Vl. 1"
} \scoreAViolinI

scoreAViolinIIPart = \new Staff \with {
  instrumentName = "Vl. 2"
} \scoreAViolinII

scoreAHornFPart = \new Staff \with {
  instrumentName = "Hr. (C)"
} \scoreAHornF

scoreAViolaPart = \new Staff \with {
  instrumentName = "Va."
} { \clef alto \scoreAViola }

scoreABassVoicePart = \new Staff \with {
  instrumentName = "Mr. Western"
} { \clef bass \scoreABassVoice }

scoreABassoonPart = \new Staff \with {
  instrumentName = "Fg. solo"
} { \clef bass \scoreABassoon }

scoreAContrabassPart = \new Staff \with {
  instrumentName = "B."
} { \clef bass \scoreAContrabass }

\score {
  <<
    \scoreAOboePart
    \scoreAViolinIPart
    \scoreAViolinIIPart
    \scoreAHornFPart
    \scoreAViolaPart
    \scoreABassVoicePart
    \scoreABassoonPart
    \scoreAContrabassPart
  >>
  \layout { }
}
