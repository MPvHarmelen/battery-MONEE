#!/opt/local/bin/gnuplot -persist
# $Id: qualitative-selective-pressure.gpl $


# Black background
set object 42 rectangle from screen 0,0 to screen 1,1 fillcolor rgb "black" behind
axiscolor="#808080"

set border 3 back linetype 0 linecolor rgb axiscolor  linewidth 1.000
set style fill  transparent solid 0.60 noborder

set style circle radius graph 0.02, first 0, 0
set tics back
#set grid xtics nomxtics ytics nomytics noztics nomztics nox2tics nomx2tics noy2tics nomy2tics nocbtics nomcbtics
set grid back   linetype 3 linecolor rgb axiscolor linewidth 0.500,  linetype 3 linecolor rgb axiscolor linewidth 0.500

set size square
set style increment userstyles
set style line 1  linetype 1 linecolor rgb "#2b6088"  linewidth 1.500 pointtype 1 pointsize default pointinterval 0
set style line 2  linetype 2 linecolor rgb "#f36e21"  linewidth 1.500 pointtype 2 pointsize default pointinterval 0
set style line 3  linetype 3 linecolor rgb "#3da648"  linewidth 1.500 pointtype 3 pointsize default pointinterval 0
set style line 4  linetype 4 linecolor rgb "#808080"  linewidth 1.500 pointtype 4 pointsize default pointinterval 0
set style line 5  linetype 5 linecolor rgb "#fee704"  linewidth 1.500 pointtype 5 pointsize default pointinterval 0
set style line 6  linetype 6 linecolor rgb "#ee2924"  linewidth 1.500 pointtype 6 pointsize default pointinterval 0
set style line 7  linetype 7 linecolor rgb "#0f6fb7"  linewidth 1.500 pointtype 7 pointsize default pointinterval 0
set style line 8  linetype 8 linecolor rgb "#8d1e1c"  linewidth 1.500 pointtype 8 pointsize default pointinterval 0
set style line 80  linetype 0 linecolor rgb axiscolor  linewidth 1.000 pointtype 0 pointsize default pointinterval 0
set style line 81  linetype 3 linecolor rgb axiscolor  linewidth 0.500 pointtype 3 pointsize default pointinterval 0


#set cblabel "nr. offspring"  textcolor rgb "#808080"
unset colorbox
set cbrange [ 0 : 5 ]
set cbtics 1

set palette negative defined (0 "#FFFFB2", 1 "#FECC5C", 2 "#FD8D3C", 3 "#F03B20", 4 "#BD0026", 5 '#808080')

set xlabel "nr. pucks collected" textcolor rgb axiscolor
set xrange [ 0 : 80 ]

set ylabel "distance travelled" textcolor rgb axiscolor
set yrange [ 0 : 4000 ]

# Code below for plotting selected experiments publication quality
unset multiplot
set key off
set term aqua 0 size 2048 512 font "Helvetica,22" dashed title 'qualitative-selection-pressure'

set multiplot layout 1,4

# plot discrete colour key
set object 1 circle at screen 0.86,0.22 fc palette cb 0;
set label 1 at screen 0.87,0.22 '0 children' tc rgb axiscolor
set object 2 circle at screen 0.86,0.275 fc palette cb 1;
set label 2 at screen 0.87,0.27 '1 child' tc rgb  axiscolor
set object 3 circle at screen 0.86,0.325 fc palette cb 2;
set label 3 at screen 0.87,0.32 '2 children' tc rgb  axiscolor
set object 4 circle at screen 0.86,0.375 fc palette cb 3;
set label 4 at screen 0.87,0.37 '3 children' tc rgb  axiscolor
set object 5 circle at screen 0.86,0.425 fc palette cb 4;
set label 5 at screen 0.87,0.42 '4 children' tc rgb  axiscolor
set object 6 circle at screen 0.86,0.475 fc palette cb 5;
set label 6 at screen 0.87,0.47 '5 children or more' tc rgb axiscolor

set ytics format "%g"
set size 0.28,1.0

set label 43 't=1,000-6,000' at 79,300 right front textcolor rgb axiscolor
# Generate data with:
# awk '1000 < $1 && $1 < 6000{print $0}' *.pressure-stats | sort  -k 6 > foo.1000
plot 'foo.1000' u ($3+$4):5:(0.4):6 w circles lc palette notitle

#unset labels and objects or they are redrawn for the following subplots
unset object 42
unset label 1
unset label 2
unset label 3
unset label 4
unset label 5
unset label 6
unset object 1
unset object 2
unset object 3
unset object 4
unset object 5
unset object 6

unset ylabel
set ytics format ""
set size 0.22,1.0
set origin 0.25,0

set label 43  't=150,000-155,000' textcolor rgb axiscolor
# Generate with:
# awk '150000 <= $1 && $1 < 155000' *.pressure-stats | sort  -k 6 > foo.150K
plot 'foo.150K' u ($3+$4):5:(0.4):6 w circles lc palette notitle
set size 0.22,1.0
set origin 0.45,0

set label 43  't=300,000-305,000' textcolor rgb axiscolor
# Generate with:
# awk '300000 <= $1 && $1 < 305000' *.pressure-stats | sort  -k 6 > foo.300K
plot 'foo.300K' u ($3+$4):5:(0.4):6 w circles lc palette notitle

set size 0.22,1.0
set origin 0.65,0
set label 43  't=900,000-905,000' textcolor rgb axiscolor
# Generate with:
# awk '900000 <= $1 && $1 < 905000' *.pressure-stats | sort  -k 6 > foo.900K
plot 'foo.900K' u ($3+$4):5:(0.4):6 w circles lc palette notitle



unset multiplot
