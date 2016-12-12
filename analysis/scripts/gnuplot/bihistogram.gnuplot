#!/opt/local/bin/gnuplot -persist
#
#unset grid

# TODO: check!!
# Generate histogram files with
# awk '$1==999000{print $0}' pucks-collected-ratio.0 | gawk -f ~/projects/awk/transpose.awk | tail -n 64 | gawk -f ~/projects/awk/histogram.awk 0 1 50

# Code below for plotting selected experiments publication quality
set size square

set xlabel "green puck ratio"
set xtics 0.25

set ylabel "count"
set yrange [ -15.00000 : 15.0000 ]
set ytics ("0" 0, "5" 5, "10" 10, "15" 15, "5" -5, "10" -10, "15" -15)

set arrow 1 from 0.5, -15, 0 to 0.5, 15, 0 nohead back nofilled linetype -1 linecolor rgb "#222222"  linewidth 2.000

set label 1 at 1.03,0.5'market enabled' rotate by 90 front left
set label 2 at 1.03,-0.5 'market disabled ' rotate by 90 front right

set term aqua 0 size 768 768 font "Helvetica,22" solid title "ratios-wo-specialisation"
plot 'nospecialisation.market.histogram' u 1:2 w impulse lw 4 notitle, 'nospecialisation.nomarket.histogram' u 1:(-$2) w impulse lw 4 notitle

set term aqua 1 size 768 768 font "Helvetica,22" solid title "ratios-w-specialisation"
plot 'specialisation.market.histogram' u 1:2 w impulse lw 4 notitle, 'specialisation.nomarket.histogram' u 1:(-$2) w impulse lw 4 notitle

set arrow 1 from 0.25, -15, 0 to 0.25, 15, 0 nohead back nofilled linetype -1 linecolor rgb "#222222"  linewidth 2.000

set term aqua 2 size 768 768 font "Helvetica,22" solid title "ratios-wo-specialisation-uneven"
plot 'nospecialisation.market.uneven.histogram' u 1:2 w impulse lw 4 notitle, 'nospecialisation.nomarket.uneven.histogram' u 1:(-$2) w impulse lw 4 notitle

set term aqua 3 size 768 768 font "Helvetica,22" solid title "ratios-w-specialisation-uneven"
plot 'specialisation.market.uneven.histogram' u 1:2 w impulse lw 4 notitle, 'specialisation.nomarket.uneven.histogram' u 1:(-$2) w impulse lw 4 notitle
