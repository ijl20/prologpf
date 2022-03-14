
# This is a command file for gnuplot

set nokey

set grid

set ylabel "Sequential execution time (ms)"

set xlabel "Depth Limit L"

set tics out

set size 0.4,0.4

set terminal postscript portrait mono "Times-Roman" 10

set output "pent_bf_times.ps"

plot "pent_orc_count.data" using 6:8 with linespoints



