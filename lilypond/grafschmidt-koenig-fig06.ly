\version "2.18.0"

\paper {
	indent = 10
	line-width = 130
	ragged-right = ##f
	left-margin = 10
}

\header {
    title = "Hoch lebe dies Haus"
  subtitle = "für fünfstimmigen Männerchor"
  subsubtitle = "WoO VIII/7 (1903)"
  poet = "Text: unbekannt"
  tagline = ##f
}

  
  #(define-public (bracket-stencils grob)
  (let ((lp (grob-interpret-markup grob (markup #:fontsize 3.5 #:translate (cons -0.3 -0.5) "[")))
        (rp (grob-interpret-markup grob (markup #:fontsize 3.5 #:translate (cons -0.3 -0.5) "]"))))
    (list lp rp)))

bracketify = #(define-music-function (parser loc arg) (ly:music?)
   (_i "Tag @var{arg} to be parenthesized.")
#{
  \once \override ParenthesesItem.stencils = #bracket-stencils
  \parenthesize $arg
#})


\layout {
  \context {
    \Score
    \remove "Bar_number_engraver"
     \override NonMusicalPaperColumn #'line-break-permission = ##f
  }
}

global = {
  \key f \major
  \numericTimeSignature
  \time 4/4
}

tenorOneVoice = \relative c' {
  \global
  \dynamicUp
  \autoBeamOff

  c2->\ff f->
  a!2.-> \tuplet 3/2 {g8-> e-> f->}
  f2->  \bracketify r \bar "|."
}

verseTenorOneVoice = \lyricmode {
  Hoch, hoch,
  hoch le -- be dies
  Haus[!]
}

tenorTwoVoice = \relative c {
  \global
  \dynamicUp
  \autoBeamOff
  
  f2->\ff a->
  a2.-> \tuplet 3/2 {d!8-> c-> c->}
  c2-> \bracketify r 
}

verseTenorTwoVoice = \lyricmode {
  Hoch, hoch,
  hoch le -- be dies
  Haus[!]
}

bassOneVoice = \relative c' {
  \global
  \dynamicUp
  \autoBeamOff
  
  a2->\ff d2->
  des2.-> \tuplet 3/2 {d8-> g,-> f->}
  a2-> \bracketify r 
}

verseBassOneVoice = \lyricmode {
  Hoch, hoch,
  hoch le -- be dies
  Haus[!]
}

bassTwoVoiceOne = \relative c' {
  \global
  \dynamicUp
  \autoBeamOff
  
    f,2->\ff f->
    f2.-> \tuplet 3/2 {f8-> bes-> a->}
    c,2->
}

verseBassTwoVoice = \lyricmode {
  Hoch, hoch,
  hoch le -- be dies
  Haus[!]
}

bassTwoVoiceTwo = \relative c' {
 \global
 \autoBeamOff
 \dynamicUp
 
    f,2_> b,_>
    bes!2._> \tuplet 3/2 {b8_> c_> f,_>}
    f2_> \bracketify r 
}

tenorOneVoicePart = \new Staff \with {
  instrumentName = "Tenor 1"
} { \clef "treble_8" \tenorOneVoice }
\addlyrics { \verseTenorOneVoice }

tenorTwoVoicePart = \new Staff \with {
  instrumentName = "Tenor 2"
} { \clef "treble_8"  \tenorTwoVoice }
\addlyrics { \verseTenorTwoVoice }


bassOneVoicePart = \new Staff \with {
  instrumentName = "Bass 1"
} { \clef bass \bassOneVoice }
\addlyrics { \verseBassOneVoice }

bassTwoVoicePart = \new Staff \with {
  instrumentName = "Bass 2"
} { <<
  {
  \clef bass \stemUp \bassTwoVoiceOne}\\
{\stemDown \bassTwoVoiceTwo }

\addlyrics { \verseBassTwoVoice }
>> }

\score {
  <<
  \new StaffGroup  
  <<
    \tenorOneVoicePart
    \tenorTwoVoicePart
  >>
  \new StaffGroup
  <<
    \bassOneVoicePart
    \bassTwoVoicePart
  >>
  >>
}
