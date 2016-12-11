#!/opt/local/bin/gnuplot -persist
#
unset grid
set size square
set title system('pwd')
set xlabel "green puck ratio"
set ylabel "count"
set yrange [ 0.00000 : 15.0000 ]
set arrow 1 from 0.5, 0, 0 to 0.5, 15, 0 nohead back nofilled linetype -1 linecolor rgb "#222222"  linewidth 2.000
plot "< awk '$1==999000{print $0}' pucks-collected-ratio.0 | gawk -f ~/projects/awk/transpose.awk | tail -n 64 | gawk -f ~/projects/awk/histogram.awk 0 1 50" w impulse lw 4 notitle
