#!/bin/gnuplot

set term png

set xl 'x [AU]'
set yl 'y [AU]'
set zl 'z [AU]'

set xr [-3:3]
set yr [-3:3]
set zr [-0.7:0.7]

do for [ii=1:1000] {
	set out sprintf("png/trajec_%03.0f.png", ii)
	splot 'xyz1' every ::1::ii w l lt 1, \
	      'xyz1' every ::ii::ii w p pt 7 lt 1, \
	      'xyz2' every ::1::ii w l lt 2, \
	      'xyz2' every ::ii::ii w p pt 7 lt 2, \
              'xyz3' every ::1::ii w l lt 3, \
	      'xyz3' every ::ii::ii w p pt 7 lt 3
}
