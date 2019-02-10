#!/bin/gnuplot

set term post eps enh color solid "Helvetica" 12
set out "keys.eps"

set term png size 1024,768 font "Helvetica" 14

set boxwidth 0.5
set style fill solid

set out "mod.png"
plot "<sed 's/<//' mod.dat | sed 's/>//'" using 1:3:xtic(2) not with boxes
set out "char.png"
plot "char.dat" using 1:3:xtic(2) not with boxes
