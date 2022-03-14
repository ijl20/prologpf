
# This is a command file for gnuplot

set nokey

set grid

set ylabel "Oracle stack size"

set xlabel "Depth limit L"

set tics out

set size 0.4,0.4

set terminal postscript portrait mono "Times-Roman" 10

set output "pent_orc_storage.ps"

plot "pent_orc_count.data" using 6:9 with linespoints



