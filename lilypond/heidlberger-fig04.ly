\version "2.18.0"

%#(set-global-staff-size 15.5)
#(set-default-paper-size "a3" 'landscape)

\header {
  % Voreingestellte LilyPond-Tagline entfernen
  tagline = ##f
}

global = {
  \key f \major
  \numericTimeSignature
  \time 3/4
  \tempo "Andantino"
}

\layout {
  \context {
    \Staff
    \consists "Mark_engraver"
    \override RehearsalMark.self-alignment-X = #LEFT
  }
  \context {
    \StaffGroup
    systemStartDelimiterHierarchy =
      #'(SystemStartBrace (SystemStartBracket a b))
  }
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

%
% Erster Einsatz
%

sopranoVoiceExA = \relative c'' {
  \global
  \dynamicUp
  r4 r r8 c
  c8. ( a16) f4 r8 c'
  c~c32 ( bes  a bes) g4 r8 c
   \autoBeamOff c4~c16[ d32(  e]) f16 e  d[( c]) bes a \autoBeamOn
  g32 ( c b c b c d c) c,4 \skip4
    \override BreathingSign.text = \markup {
    \musicglyph #"scripts.caesura.straight"
  } \breathe \bar " "
}

verseSopranoVoiceExA = \lyricmode {
  Di gio -- ja, di
  pa -- ce, la
  bel -- la la bel -- la spe -- ran -- za
  
}


bcMusicExA = \relative c {
  \global
  
  R2.
  r4 f8 r f r
  r4 c8 r c r
  r4 f8 r f r
  r4 c8 r \skip4
    \override BreathingSign.text = \markup {
    \musicglyph #"scripts.caesura.straight"
  } \breathe \bar " "
}

bcFiguresExA = \figuremode {
  \global
  \override Staff.BassFigureAlignmentPositioning #'direction = #DOWN
  % Abbildungen folgen hier.
}

sopranoVoicePartExA = \new Staff \with {
  instrumentName = "Emma"
} { \sopranoVoiceExA }
\addlyrics { \verseSopranoVoiceExA }


bassoContinuoPartExA = \new Staff \with {
  instrumentName = "(Basso)"
} { \clef bass << \bcMusicExA \bcFiguresExA >> }


%
% Zweiter Einsatz
%
sopranoVoiceExB = \relative c'' {
  \global
  \dynamicUp
  R2.
  r4 c8.( a16) f8 r
  r4 c'8~c32( bes a bes) g4
  r4 a8.[( c16]) bes[( a]) g[( f])
  e4~e32( g fis g a g f g) c,8 r
    \override BreathingSign.text = \markup {
    \musicglyph #"scripts.caesura.straight"
  } \breathe \bar " "
  
}

verseSopranoVoiceExB = \lyricmode {
  Gio -- ja
  pa -- ce
  bel -- la spe -- ran -- za
  
}

altoVoiceExB = \relative c' {
  \clef tenor
  \global
  \dynamicUp
  r4 r r8 c
  c8.( a16) f4 r8 c'
  c8~c32( bes a bes) g4 r8 c8 
  \autoBeamOff c4~c16[ d32( e]) f16 e d c bes a
  \autoBeamOn g32( c b c b c d c) c,4 \skip4
    \override BreathingSign.text = \markup {
    \musicglyph #"scripts.caesura.straight"
  } \breathe \bar " "
  
  
}

verseAltoVoiceExB = \lyricmode {
  Di gio -- ja, di
  pa -- ce per -- 
  du -- ta per -- du -- ta ho la
  spe -- me,
  
}

bcMusicExB = \relative c {
  \global
  R2.
  f8[\pp f] <f c'>8 r < f c'> r
  c[ c] <c bes'> r <c bes'> r
  f[ f] f r f r
  c[ c] <c c'> r <c c'> r
    \override BreathingSign.text = \markup {
    \musicglyph #"scripts.caesura.straight"
  } \breathe \bar " "
  
}

bcFiguresExB = \figuremode {
  \global
  \override Staff.BassFigureAlignmentPositioning #'direction = #DOWN
  % Abbildungen folgen hier.
}

sopranoVoicePartExB = \new Staff \with {
  instrumentName = "Emma"
} { \sopranoVoiceExB }
\addlyrics { \verseSopranoVoiceExB }

altoVoicePartExB = \new Staff \with {
  instrumentName = "Norcester"
} { \altoVoiceExB }
\addlyrics { \verseAltoVoiceExB }

bassoContinuoPartExB = \new Staff \with {
  instrumentName = "(Basso)"
} { \clef bass << \bcMusicExB \bcFiguresExB >> }


%
% Dritter Einsatz
%
sopranoVoiceExC = \relative c'' {
  \global
  \dynamicUp
  \autoBeamOff
  R2.
  r4 a~a16[ bes32( a] g16) f
  e8.[( g16]) bes4 r
  r8 a a bes16 c d[( c]) bes a
  g4 e8 r r4 \override BreathingSign.text = \markup {
    \musicglyph #"scripts.caesura.straight"
  } \breathe \bar " "
  
}

verseSopranoVoiceExC = \lyricmode {
  ah di
  pa -- ce
  la bel -- la la bel -- la spe -- 
  ran -- za.
  
}

tenorVoiceExC = \relative c' {
  \set Staff.clefGlyph = #"clefs.G"
  \set Staff.clefPosition = #-2
  \set Staff.clefTransposition = #-7
  \set Staff.middleCPosition = #1
  \set Staff.middleCClefPosition = #1
  \key f \major
  \global
  \dynamicUp
  r4 r r8 c
  c8.( a16) f4 r8 c'
  c8~c32( bes a bes) g4 r8 c8
  \autoBeamOff c4~c16[ d32( c]) bes16 a bes[ a] g f
 e32[( c' b c b c d c]) c,4 \skip4
 \override BreathingSign.text = \markup {
    \musicglyph #"scripts.caesura.straight"
  } \breathe \bar " "
  
  
}

verseTenorVoiceExC = \lyricmode {
  Di gio -- ja, di
  pa -- ce la
  bel -- la, la bel -- la spe -- 
  ran -- za.
  
}

altoVoiceExC = \relative c' {
  \clef tenor
  \global
  \dynamicUp
  R2.
  \autoBeamOff
  r4 c8.[( a16]) f4
  r4 c'8[~c32( bes a bes]) g4
  r4 f8.[ g32( a]) bes8 bes
  c4~c32[( g fis g a g f g]) c4
  \override BreathingSign.text = \markup {
    \musicglyph #"scripts.caesura.straight"
  } \breathe \bar " "
  
  
}

verseAltoVoiceExC = \lyricmode {
  gio -- ja
  pa -- ce
  spe -- me per -- 
  du -- ta,
  
}

bcMusicExC = \relative c {
  \global
  R2.
  <<\override TupletBracket.bracket-visibility = #'if-no-beam
    { \tuplet 6/4 {f16[^"(Klar.)" a c f c a] } \tuplet 6/4 {f16 a c a c f} 
    s4 s2. s \tuplet 6/4 {c16[ e g c, e g] } }\\
    {f,,8 r  f r f'^"etc." r
    <c e>8 r c, r c' r
    f, r s2
    c'8 r <c e g>^"etc." r <c e g> r}
  >>
  \override BreathingSign.text = \markup {
    \musicglyph #"scripts.caesura.straight"
  } \breathe \bar " "
}

bcFiguresExC = \figuremode {
  \global
  \override Staff.BassFigureAlignmentPositioning #'direction = #DOWN
  % Abbildungen folgen hier.
  
}

sopranoVoicePartExC = \new Staff \with {
  instrumentName = "Emma"
} { \sopranoVoiceExC }
\addlyrics { \verseSopranoVoiceExC }

tenorVoicePartExC = \new Staff \with {
  instrumentName = "Edemondo"
} { \tenorVoiceExC }
\addlyrics { \verseTenorVoiceExC }

altoVoicePartExC = \new Staff \with {
  instrumentName = "Norcester"
} { \altoVoiceExC }
\addlyrics { \verseAltoVoiceExC }

bassoContinuoPartExC = \new Staff \with {
  instrumentName = "(Basso)"
} { \clef bass << \bcMusicExC \bcFiguresExC >> }



%
% Ausgabe 
%

\score {
  <<
    \new StaffGroup<< %Erzeugt Systemgruppen-Klammer
    \sopranoVoicePartExA
    \bassoContinuoPartExA
    >>
    \new StaffGroup<<
    \sopranoVoicePartExB
    \altoVoicePartExB
    \bassoContinuoPartExB
    >>
    \new StaffGroup<<
    \sopranoVoicePartExC
    \tenorVoicePartExC
    \altoVoicePartExC
    \bassoContinuoPartExC
    >>
  >>
  \layout { }
}
