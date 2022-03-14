
# This is a command file for gnuplot

# set title "pentbook_cut_c Speedup G=30, L=1..30"

set key 26,25

set grid

set xtics (1,3,6,9,12,15,18,21,24,27,30)

set ylabel "Speedup"

set xlabel "L"

set yrange [1:20]

set label "A" at 25,11.4
set label "B" at 16,16.6

set size 0.5,0.5

set terminal postscript portrait mono "Times-Roman" 12

set output "spd_compare_doubling.ps"

plot "spd_compare.data" using 1:8 title "SOK doubling, full orcs" with linespoints, \
     "spd_compare.data" using 1:6 title "SOK doubling, orcs to ports" with linespoints, \
     "spd_compare.data" using 1:4 title "SOK doubling, no orc partitioning" with linespoints, \
     "spd_compare.data" using 1:2 title "BFP one-time" with linespoints
     



