#!/opt/local/bin/gnuplot
#
# Plot FET file with results of Fisher's exact test for selective pressure
#
reset

set style line 1 lc rgb "#2B6088" lw 1.5
set style line 2 lc rgb "#F36E21" lw 1.5
set style line 3 lc rgb "#3DA648" lw 1.5
set style line 4 lc rgb "#808080" lw 1.5
set style line 5 lc rgb "#FEE704" lw 1.5
set style line 6 lc rgb "#EE2924" lw 1.5
set style line 7 lc rgb "#0F6FB7" lw 1.5
set style line 8 lc rgb "#8D1E1C" lw 1.5

set style increment user

# Line style for axes
set style line 80 lt 0
set style line 80 lt rgb "#808080"

# Line style for grid
set style line 81 lt 3  # dashed
set style line 81 lt rgb "#808080" lw 0.5  # grey

set grid back linestyle 81
set border 3 back linestyle 80 # Remove border on top and right.  These
             # borders are useless and make it harder
             # to see plotted lines near the border.
    # Also, put it in grey; no need for so much emphasis on a border.
set xtics nomirror
set ytics nomirror format "%6g"


#set title system('pwd')
set key bottom box ls 81

set xtics 250000
set xlabel ''

set mxtics 5

set style rect fc lt -1 fs solid 0.15 noborder

# Code below for plotting selected experiments publication quality
unset multiplot
set key bottom box ls 81
set ytics scale default
set term aqua 0 size 768 1024 font "Helvetica,22" dashed title "selection-pressure-inseminations-pucks"

set multiplot
set xtics format ""
set size 1,0.44
set origin 0,0.57
set logscale y
set yrange [1e-300:1]
set ylabel offset 2,0
set ylabel "selection pressure"
set obj 2 rect from 100000,1e-300 to 300000,6000

#set title 'Comm. range 10'
plot 'commdist.27/FET.txt' u 1:2 w li lw 2 ti 'distance', '' u 1:3 w li lw 2 ti 'nr. pucks collected'

set yrange [0:60]
unset logscale y
set ylabel "inseminations"
set ylabel offset 2,0
set ytics 15
set key off
set size 1,0.3
set origin 0,0.3
set title ''

#set obj 2 rect from 100000,0 to 250000,60

#plot 'commdist.10/pucks-collected.counts.stats'  u 1:3 ps 0.2 lt 3 notitle, 'commdist.10/inseminations.stats' u 1:3 ps 0.2 lt 4 notitle axes x1y2
plot 'commdist.27/inseminations.stats' u 1:3 ps 0.2 lt 3 notitle

set ylabel "pucks collected"
set label 1 'time' at 500000,-450 center
set ytics 500
set yrange [0:1500]
set xtics format "%g" offset 0,0
set origin 0,0.035
set title ''

#set obj 2 rect from 100000,0 to 250000,6000

plot 'commdist.27/pucks-collected.counts.stats'  u 1:3 ps 0.2 lt 6 notitle

unset multiplot
