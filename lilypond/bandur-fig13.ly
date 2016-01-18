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
}

flute = \relative c'' {
  \global
  <d fis>8\ff <d fis> <d fis>
  <d fis>4 <a e'>8 <d fis>4 <e g>8
  <fis a>4 <fis a>8 <d fis> <d fis> <d fis>
  <d fis>4 <a e'>8 <d fis>4 <e g>8
  <fis a>4. <a, e'>8 <a e'> <a e'>
  <a e'>4 <d fis>8 <e g>4 <fis a>8
  <e g>4 <d fis>8 <fis a> <e g> <d fis>
  <fis a> <e g> <d fis> <fis a> <e g> <d fis>
  <a e'>4. <a e'>8 <a e'> <a e'>
  <a e'>4 <d fis>8 <e g>4 <fis a>8
  <e g>4 <d fis>8 <fis a>8 <e g> <d fis>
  <fis a>8 <e g> <d fis> <<{\acciaccatura fis8 \stemUp e}\\{a,}>> <fis d'> <a e'>
  <fis d'>4.
  
}

clarinet = \relative c'' {
  \global
  <d fis>8\ff <d fis> <d fis>
  <d fis>4 <a e'>8 <d fis>4 <e g>8
  <fis a>4 <fis a>8 <d fis> <d fis> <d fis>
  <d fis>4 <a e'>8 <d fis>4 <e g>8
  <fis a>4. <a, e'>8 <a e'> <a e'>
  <a e'>4 <d fis>8 <e g>4 <fis a>8
  <e g>4 <d fis>8 <fis a> <e g> <d fis>
  <fis a> <e g> <d fis> <fis a> <e g> <d fis>
  <a e'>4. <a e'>8 <a e'> <a e'>
  <a e'>4 <d fis>8 <e g>4 <fis a>8
  <e g>4 <d fis>8 <fis a>8 <e g> <d fis>
  <fis a>8 <e g> <d fis> <<{\acciaccatura fis8 \stemUp e}\\{a,}>> <fis d'> <a e'>
  <fis d'>4.
  
}

trumpetC = \relative c'' {
  %\global
  \partial 4.
  \key c \major
  <c e>8\ff<c e> <c e>
  <c e>4 <g d'>8 <c e>4 <d f>8
  <e g>4 <e g>8 <c e> <c e> <c e>
  <c e>4 <g d'>8 <c e>4 <d f>8
  <e g>4. <g, d'>8 <g d'> <g d'>
  <g d'>4 <c e>8 <d f>4 <e g>8 
  
  <d f>4 <c e>8 <e g> <d f> <c e>
  <e g>8 <d f> <c e> <e g>8 <d f> <c e>
  <g d'>4. <g d'>8 <g d'> <g d'>
  <g d'>4 <c e>8 < d f>4 <e g>8
  <d f>4 <c e>8 <e g> <d f> <c e>
  <e g> <d f> <c e> <<{\acciaccatura e8 \stemUp d}\\{g,}>> <e c'> <g d'>
  <e c'>4.
  
}

flutePart = \new Staff \with {
  instrumentName = "Ob."
} \flute

clarinetPart = \new Staff \with {
  instrumentName = "Kl."
} \clarinet

trumpetCPart = \new Staff \with {
  instrumentName = "Hr. (D)"
} \trumpetC

\score {
  <<
    \flutePart
    \clarinetPart
    \trumpetCPart
  >>
  \layout { }
}
