
# This is a command file for gnuplot

set key 35.45,18.7

set grid

set xtics (1,3,6,9,12,15,18,21,24,27,30)

set ylabel "Speedup"

set xlabel "L"

set yrange [1:20]

set size 0.9,0.9

set terminal postscript landscape mono "Times-Roman" 12

set output "spd_compare_all.ps"

plot "spd_compare.data" using 1:2 title "one-time" with linespoints, \
     "spd_compare.data" using 1:3 title "fixed, no orc partitioning" with linespoints, \
     "spd_compare.data" using 1:4 title "doubling, no orc partitioning" with linespoints, \
     "spd_compare.data" using 1:5 title "fixed, orcs to ports" with linespoints, \
     "spd_compare.data" using 1:6 title "doubling, orcs to ports" with linespoints, \
     "spd_compare.data" using 1:7 title "fixed, full orcs" with linespoints, \
     "spd_compare.data" using 1:8 title "doubling, full orcs" with linespoints




