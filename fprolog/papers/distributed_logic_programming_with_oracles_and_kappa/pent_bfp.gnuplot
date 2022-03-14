
# This is a command file for gnuplot

# set title "pentbook_cut_c Speedup G=1..30, L=27"

set nokey

set grid

set xtics (1,3,6,9,12,15,18,21,24,27,30)

set ylabel "Speedup"

set xlabel "G"

set yrange [1:14]

set size 0.4,0.4

set terminal postscript portrait mono "Times-Roman" 12

set output "pent_bfp.ps"

plot "pent_bfp.data" using 1:3 with linespoints



