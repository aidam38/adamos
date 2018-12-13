#!/bin/gnuplot

set term png


set xl 'x [AU]'
set yl 'y [AU]'
set zl 'z [AU]'

set xr [-3:3]
set yr [-3:3]
set zr [-0.7:0.7]

set term post eps enh color solid "Helvetica" 18
do for [ii=1:1000] {
	set out sprintf("png/trajec_%03.0f.png", ii)
	splot 'xyz' every ::((ii-1)*20+1)::ii*20 w p pt 7 ps 0.5, \
}

q
'xyz' every ::1::ii*20 w l lt 1, \
