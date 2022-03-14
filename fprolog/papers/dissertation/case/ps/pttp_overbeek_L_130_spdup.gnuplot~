
# This is a command file for gnuplot

set nokey

set grid

set xtics (1,3,6,9,12,15,18,21,24,27,30,33,36,39,42)

set ylabel "Runtime (ms)"

set xlabel "G"

# set yrange [1:14]

set size 0.5,0.5

set terminal postscript portrait mono "Times-Roman" 12

set output "pttp_overbeek_L_130_runtime.ps"

plot "pttp_overbeek.data" using 2:4 with linespoints



