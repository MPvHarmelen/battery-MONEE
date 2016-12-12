#!/opt/local/bin/gnuplot -persist
# $Id: plot-pressure.gnuplot $
#set terminal aqua 0 title "/Volumes/RAID/monee/tmp" size 512,512 font "Helvetica,14" noenhanced solid
set terminal pngcairo enhanced font "Helvetica,14" size 1024,768

# Black background
set object 1 rectangle from screen 0,0 to screen 1,1 fillcolor rgb"black" behind

set border 3 back linetype 0 linecolor rgb "#808080"  linewidth 1.000
set style fill  transparent solid 0.60 noborder

set style circle radius graph 0.02, first 0, 0
set tics back
#set grid xtics nomxtics ytics nomytics noztics nomztics nox2tics nomx2tics noy2tics nomy2tics nocbtics nomcbtics
set grid back   linetype 3 linecolor rgb "#808080"  linewidth 0.500,  linetype 3 linecolor rgb "#808080"  linewidth 0.500

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
set style line 80  linetype 0 linecolor rgb "#808080"  linewidth 1.000 pointtype 0 pointsize default pointinterval 0
set style line 81  linetype 3 linecolor rgb "#808080"  linewidth 0.500 pointtype 3 pointsize default pointinterval 0

set title system("pwd") textcolor rgb "#808080"

set cblabel "nr. offspring"  textcolor rgb "#808080"
set cbrange [ 0 : 5 ]
set palette negative defined ( \
    0 '#EE2924',\
    1 '#EE2924',\
    1 '#F36E21',\
    2 '#F36E21',\
    2 '#3DA648',\
    3 '#3DA648',\
    3 '#2B6088',\
    4 '#2B6088',\
    4 '#2B6088',\
    5 '#BFBFBF')
set cbtics 1

set palette negative defined (0 "#FFFFB2", 1 "#FECC5C", 2 "#FD8D3C", 3 "#F03B20", 4 "#BD0026", 5 '#808080')

set xlabel "nr. pucks collected" textcolor rgb "#808080"
set xrange [ 0 : 80 ]

set ylabel "distance travelled" textcolor rgb "#808080"
set yrange [ 0 : 4000 ]

plot '<cat' u ($3+$4):5:(0.4):6 w circles lc palette notitle
