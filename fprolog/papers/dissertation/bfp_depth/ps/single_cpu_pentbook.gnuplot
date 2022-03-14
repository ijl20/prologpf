
# This is a command file for gnuplot

# set title "Single cpu performance comparison: pentominoes"

set nokey

set tics out

set nogrid

set xtics ("       DelphiKS" 1,"         PrologPF" 3,"          PrologPF(C)" 5, \
          "         wamcc" 7, "          Sicstus" 9)

set ytics ("0  " 0,"500  " 500,"1000  " 1000,"1500  " 1500,"2000  " 2000,"2500  " 2500,"3000  " 3000)

set yrange [0:3000]
set ylabel "seconds"

set size 0.4,0.4

set terminal postscript portrait mono "Times-Roman" 8

set output "single_cpu_pentbook.ps"

plot "single_cpu_pentbook.data" with lines

