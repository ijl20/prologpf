
# This is a command file for gnuplot

# set nokey

set grid

set xtics (1,3,6,9,12,15,18,21,24,27,30)

set ylabel "Speedup"

set xlabel "G"

set yrange [1:20]

set size 0.4,0.4

set terminal postscript portrait mono "Times-Roman" 12

set output "pent_sok.ps"

plot "pent_sok.data" using 1:4 title "SOK" with linespoints, \
     "pent_sok.data" using 1:3 title "BFP" with linespoints

