
# This is a command file for gnuplot

# set title "queens8_cut_c G=1..30, L=21"

set nokey

set grid

set xtics (1,3,6,9,12,15,18,21,24,27,30)

set ylabel "ms"

set xlabel "G"

set size 0.4,0.4

set terminal postscript portrait mono "Times-Roman" 12

set output "queens8_cut_c_L_21.ps"

plot "queens8_cut_c_L_21.data" using 1:2 with linespoints



