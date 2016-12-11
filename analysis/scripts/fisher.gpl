#!/opt/local/bin/gnuplot
#
# $Id: fisher.gpl $
# Plot FET file with results of Fisher's exact test for selective pressure
#

set title system('pwd')
set key bottom box ls 81

set xtics 250000
set mxtics 5
set xlabel 'time'

set logscale y
set yrange [1e-300:1]
set ylabel "p-value (Fisher's exact test)"

plot 'FET.txt' u 1:2 w li lw 2 ti 'distance', '' u 1:3 w li lw 2 ti 'nr. pucks collected'

#remove quit statement to plot publication quality
quit

# Code below for plotting selected experiments publication quality
unset multiplot
set key off
set term aqua 0 size 2048 512 font "Helvetica,22" dashed title "selection-pressure-commrange"
set multiplot layout 1,4
set ytics format "%g"
set size 0.28,1.0
set title 'Comm. range 10'
plot 'commdist.10/FET.txt' u 1:2 w li lw 2 notitle, '' u 1:3 w li lw 2 notitle
unset ylabel
set ytics format ""
set size 0.22,1.0
set origin 0.28,0
set title 'Comm. range 20'
plot 'commdist.20/FET.txt' u 1:2 w li lw 2 notitle, '' u 1:3 w li lw 2 notitle
set size 0.22,1.0
set origin 0.50,0
set title 'Comm. range 30'
plot 'commdist.30/FET.txt' u 1:2 w li lw 2 notitle, '' u 1:3 w li lw 2 notitle
set size 0.22,1.0
set origin 0.72,0
set title 'Comm. range 40'
set key bottom box ls 81
plot 'commdist.40/FET.txt' u 1:2 w li lw 2 ti 'distance', '' u 1:3 w li lw 2 ti 'nr. pucks collected'
unset multiplot

set term aqua 1 size 2048 512 font "Helvetica,22" dashed title "selection-pressure-eggtime"
set multiplot layout 1,4
set ytics format "%g"
set size 0.28,1.0
set title 'Egg time 100'
plot 'eggTime.100/FET.txt' u 1:2 w li lw 2 notitle, '' u 1:3 w li lw 2 notitle
unset ylabel
set ytics format ""
set size 0.22,1.0
set origin 0.28,0
set title 'Egg time 200'
plot 'eggTime.200/FET.txt' u 1:2 w li lw 2 notitle, '' u 1:3 w li lw 2 notitle
set size 0.22,1.0
set origin 0.50,0
set title 'Egg time 500'
plot 'eggTime.500/FET.txt' u 1:2 w li lw 2 notitle, '' u 1:3 w li lw 2 notitle
set size 0.22,1.0
set origin 0.72,0
set title 'Egg time 1000'
set key bottom box ls 81
plot 'eggTime.1000/FET.txt' u 1:2 w li lw 2 ti 'distance', '' u 1:3 w li lw 2 ti 'nr. pucks collected'
unset multiplot


set term aqua 2 size 2048 512 font "Helvetica,22" dashed title "selection-pressure-lifetime"
set multiplot layout 1,4
set ytics format "%g"
set size 0.28,1.0
set title 'Life time 700'
plot 'lifeTime.700/FET.txt' u 1:2 w li lw 2 notitle, '' u 1:3 w li lw 2 notitle
unset ylabel
set ytics format ""
set size 0.22,1.0
set origin 0.28,0
set title 'Life time 1000'
plot 'lifeTime.1000/FET.txt' u 1:2 w li lw 2 notitle, '' u 1:3 w li lw 2 notitle
set size 0.22,1.0
set origin 0.50,0
set title 'Life time 2000'
plot 'lifeTime.2000/FET.txt' u 1:2 w li lw 2 notitle, '' u 1:3 w li lw 2 notitle
set size 0.22,1.0
set origin 0.72,0
set title 'Life time 5000'
set key bottom box ls 81
plot 'lifeTime.5000/FET.txt' u 1:2 w li lw 2 ti 'distance', '' u 1:3 w li lw 2 ti 'nr. pucks collected'
unset multiplot