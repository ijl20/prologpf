
# This is a command file for gnuplot

set nokey

set grid

set xtics (1,3,6,9,12,15,18,21,24,27,30)

set ylabel "Runtime (ms)"

set xlabel "G"

# set yrange [1:14]

set size 0.5,0.5

set terminal postscript portrait mono "Times-Roman" 12

set output "changlee2_L_23_runtime.ps"

plot "changlee2_L_23.data" with linespoints



