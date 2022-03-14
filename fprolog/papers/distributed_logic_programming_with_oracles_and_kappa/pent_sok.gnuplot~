
# This is a command file for gnuplot

# set nokey

set grid

set xtics (1,3,6,9,12,15,18,21,24,27,30)

set ylabel "Speedup"

set xlabel "G"

set yrange [1:20]

set size 0.5,0.5

set terminal postscript portrait mono "Times-Roman" 12

set output "pent_G_1_30.ps"

plot "pent_G_1_30.data" using 1:4 title "SOK" with linespoints, \
     "pent_G_1_30.data" using 1:3 title "BFP" with linespoints

