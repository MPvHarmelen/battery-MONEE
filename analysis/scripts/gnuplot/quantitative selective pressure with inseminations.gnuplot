#!/opt/local/bin/gnuplot
#
# Plot FET file with results of Fisher's exact test for selective pressure
#

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
set ytics nomirror


set title system('pwd')
set key bottom box ls 81

set xtics 250000
set xlabel ''
set mxtics 5

set logscale y
set yrange [1e-300:1]
set ylabel offset 2,0
set ylabel "p-value (Fisher's exact test)"

# Code below for plotting selected experiments publication quality
unset multiplot
set key off
set term aqua 0 size 2048 1024 font "Helvetica,22" dashed title "selection-pressure-commrange"
set multiplot
set xtics format ""
set ytics format "%g"
set size 0.26,0.45
set origin 0,0.44
set title 'Comm. range 10'
plot 'commdist.10/FET.txt' u 1:2 w li lw 2 notitle, '' u 1:3 w li lw 2 notitle
unset ylabel
set ytics format ""
set size 0.22,0.45
set origin 0.26,0.44
set title 'Comm. range 20'
plot 'commdist.20/FET.txt' u 1:2 w li lw 2 notitle, '' u 1:3 w li lw 2 notitle
set size 0.22,0.45
set origin 0.48,0.44
set title 'Comm. range 30'
plot 'commdist.30/FET.txt' u 1:2 w li lw 2 notitle, '' u 1:3 w li lw 2 notitle
set size 0.22,0.45
set origin 0.7,0.44
set title 'Comm. range 40'
set key bottom box ls 81
plot 'commdist.40/FET.txt' u 1:2 w li lw 2 ti 'distance', '' u 1:3 w li lw 2 ti 'nr. pucks collected'

set xlabel 'time'
set ytics format "%6g"
set xtics format "%g"
set yrange [0:60]
unset logscale y
set ylabel "median nr. inseminations"
set ylabel offset 2,0
unset key

set size 0.26,0.45
set origin 0,0
set title ''
#plot 'commdist.10/pucks-collected.counts.stats'  u 1:3 ps 0.2 lt 3 notitle, 'commdist.10/inseminations.stats' u 1:3 ps 0.2 lt 4 notitle axes x1y2
plot 'commdist.10/inseminations.stats' u 1:3 ps 0.2 lt 3 notitle

unset ylabel
set ytics format ""
set size 0.22,0.45
set origin 0.26,0
plot 'commdist.20/inseminations.stats' u 1:3 ps 0.2 lt 3 notitle
set origin 0.48,0
set size 0.22,0.45
plot 'commdist.30/inseminations.stats' u 1:3 ps 0.2 lt 3 notitle
set origin 0.7,0
set size 0.22,0.45
plot 'commdist.40/inseminations.stats' u 1:3 ps 0.2 lt 3 notitle

unset multiplot
#
# set term aqua 1 size 2048 512 font "Helvetica,22" dashed title "selection-pressure-eggtime"
# set multiplot layout 1,4
# set ytics format "%g"
# set size 0.28,1.0
# set title 'Egg time 100'
# plot 'eggTime.100/FET.txt' u 1:2 w li lw 2 notitle, '' u 1:3 w li lw 2 notitle
# unset ylabel
# set ytics format ""
# set size 0.22,1.0
# set origin 0.28,0
# set title 'Egg time 200'
# plot 'eggTime.200/FET.txt' u 1:2 w li lw 2 notitle, '' u 1:3 w li lw 2 notitle
# set size 0.22,1.0
# set origin 0.50,0
# set title 'Egg time 500'
# plot 'eggTime.500/FET.txt' u 1:2 w li lw 2 notitle, '' u 1:3 w li lw 2 notitle
# set size 0.22,1.0
# set origin 0.72,0
# set title 'Egg time 1000'
# set key bottom box ls 81
# plot 'eggTime.1000/FET.txt' u 1:2 w li lw 2 ti 'distance', '' u 1:3 w li lw 2 ti 'nr. pucks collected'
# unset multiplot
#
#
# set term aqua 2 size 2048 512 font "Helvetica,22" dashed title "selection-pressure-lifetime"
# set multiplot layout 1,4
# set ytics format "%g"
# set size 0.28,1.0
# set title 'Life time 700'
# plot 'lifeTime.700/FET.txt' u 1:2 w li lw 2 notitle, '' u 1:3 w li lw 2 notitle
# unset ylabel
# set ytics format ""
# set size 0.22,1.0
# set origin 0.28,0
# set title 'Life time 1000'
# plot 'lifeTime.1000/FET.txt' u 1:2 w li lw 2 notitle, '' u 1:3 w li lw 2 notitle
# set size 0.22,1.0
# set origin 0.50,0
# set title 'Life time 2000'
# plot 'lifeTime.2000/FET.txt' u 1:2 w li lw 2 notitle, '' u 1:3 w li lw 2 notitle
# set size 0.22,1.0
# set origin 0.72,0
# set title 'Life time 5000'
# set key bottom box ls 81
# plot 'lifeTime.5000/FET.txt' u 1:2 w li lw 2 ti 'distance', '' u 1:3 w li lw 2 ti 'nr. pucks collected'
# unset multiplot