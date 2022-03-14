
# This is a command file for gnuplot

set nokey

set grid

set xtics (1,3,6,9,12,15,18,21,24,27,30,33,36,39,42)

set ylabel "Speedup"

set xlabel "G"

# set yrange [1:14]

set size 0.4,0.4

set terminal postscript portrait mono "Times-Roman" 12

set output "overbeek_bfp.ps"

plot x, "overbeek_bfp.data" using 2:5 with linespoints



