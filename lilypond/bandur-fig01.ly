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
  \key c \major
  \numericTimeSignature
  \time 6/8
  \partial 4.
}

scoreAHornFI = \relative c'' {
  \global
  \transposition f
  <<
    {e8 e e
    e4 d8 e4 f8
    g4. e8 e e
    e4 d8 e4 f8
    g e f g e f
    g4. d8 d d
    d4 e8 f4 g8
    e4 d8 g f e
    g f e \acciaccatura e d c d 
    c4}\\
    {c8^\markup {{\dynamic ff} \italic (possibile)} c c
    c4 g8 c4 d8
    e4. c8 c c
    c4 g8 c4 d8
    e c d e c d
    e4. g,8 g g
    g4 c8 d4 e8
    c4 g8 e'8 d c
    e d c g e g
    e4}
  >>
   r8
}

scoreAHornFII = \relative c'' {
  \global
  \transposition f
   <<
    {e8 e e
    e4 d8 e4 f8
    g4. e8 e e
    e4 d8 e4 f8
    g e f g e f
    g4. d8 d d
    d4 e8 f4 g8
    e4 d8 g f e
    g f e \acciaccatura e d c d 
    c4}\\
    {c8^\markup {{\dynamic ff} \italic (possibile)} c c
    c4 g8 c4 d8
    e4. c8 c c
    c4 g8 c4 d8
    e c d e c d
    e4. g,8 g g
    g4 c8 d4 e8
    c4 g8 e'8 d c
    e d c g e g
    e4}
  >>
   r8
}


pianoPart = \new PianoStaff \with {
  instrumentName = "Hr. (F)"
} <<
  \new Staff = "scoreAHornFIPart" \scoreAHornFI
  \new Staff = "scoreAHornFIIPart" \scoreAHornFII
>>


%scoreAHornFIPart = \new Staff \with {
 % instrumentName = "Cor. (F)"
%} \scoreAHornFI

%scoreAHornFIIPart = \new Staff \with {
%  instrumentName = "Horn in F II"
%} \scoreAHornFII

\score {
  <<
    \pianoPart
  >>
  \layout { }
}
