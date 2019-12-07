#!/bin/bash
cat <<EOF > stress.tex
\let\origdump=\dump\let\dump\relax
\batchmode
\input plain.tex
\let\dump\origdump

\count0=0
\def\A{\ifnum\count0<450000
  \count1=1000000 \advance\count1\count0
  \edef\N{QW\the\count1}
  \expandafter\xdef\csname HOGE\N\endcsname{ABCDEFGHI}%
  \advance\count0 by1\let\next=\A\else\let\next\relax
  \fi\next}
\A
\let\N\undefined
\count0=0
\def\A{\ifnum\count0<199
  \count1=1000000 \advance\count1\count0
  \edef\N{\the\count1}
  \font\S=cmr10 at \N sp\fontdimen39707\S=1sp
  \advance\count0 by1\let\next=\A\else\let\next\relax
  \fi\next}
\A
\dump
EOF

cat <<EOF > test0.tex
\font\a=cmss10 at 1000000sp
\a qwertyuiopasdfghjkl$\int^\infty_0 e^{-x^2}\,dx$\end
EOF


test0() {
  ENGINE=$1
  echo $ENGINE
  rm -f stress-$ENGINE.fmt test0.dvi &>/dev/null
  $ENGINE -ini -etex -progname=$ENGINE -jobname=stress-$ENGINE stress &>/dev/null
  ls -l stress-$ENGINE.fmt
  $ENGINE -fmt=./stress-$ENGINE.fmt test0.tex &>/dev/null
  ls -l test0.dvi
}

test0 tex
test0 etex
test0 pdftex
test0 ptex
test0 eptex
test0 uptex
test0 euptex
test0 xetex

cat <<EOF > test1.tex
\documentclass{article}
\begin{document}
The \textit{quick} \textbf{brown} \textsc{fox} jumps over the lazy dog.
\[
  \frac{\pi}{2} =
  \left( \int_{0}^{\infty} \frac{\sin x}{\sqrt{x}} dx \right)^2 =
  \sum_{k=0}^{\infty} \frac{(2k)!}{2^{2k}(k!)^2} \frac{1}{2k+1} =
  \prod_{k=1}^{\infty} \frac{4k^2}{4k^2 - 1}
\]
\end{document}
EOF

test1() {
  ENGINE=$1
  echo $ENGINE
  rm -f latex-$ENGINE.fmt test1.dvi &>/dev/null
  $ENGINE -ini -etex -progname=latex-dev -jobname=latex-$ENGINE latex.ini &>/dev/null
  ls -l latex-$ENGINE.fmt
  $ENGINE -fmt=./latex-$ENGINE.fmt test1.tex &>/dev/null
  ls -l test1.dvi
}

test1 etex
test1 pdftex
test1 eptex
test1 euptex
test1 xetex
