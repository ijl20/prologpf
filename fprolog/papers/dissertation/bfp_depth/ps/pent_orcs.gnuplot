
# This is a command file for gnuplot

set nokey

set grid

set ylabel "ms"

set xlabel "Oracle number"

set tics out

set size 0.4,0.4

set terminal postscript portrait mono "Times-Roman" 10

set output "pent_orcs.ps"

plot "pent.orcs" using 4:10 with lines



