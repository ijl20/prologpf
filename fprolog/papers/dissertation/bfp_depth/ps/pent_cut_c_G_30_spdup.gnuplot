
# This is a command file for gnuplot

# set title "pentbook_cut_c Speedup G=30, L=1..30"

set key 10.45,18.7

set grid

set xtics (1,3,6,9,12,15,18,21,24,27,30)

set ylabel "Speedup"

set xlabel "L"

set yrange [1:20]

set size 0.5,0.5

set terminal postscript portrait mono "Times-Roman" 12

set output "pent_cut_c_G_30_spdup.ps"

plot "pent_cut_c_G_30.data" using 1:5 title "fixed" with linespoints, \
     "pent_cut_c_G_30.data" using 1:8 title "demand 0ms" with linespoints, \
     "pent_cut_c_G_30.data" using 1:11 title "demand 25ms" with linespoints, \
     "pent_cut_c_G_30.data" using 1:14 title "demand 250ms" with linespoints




