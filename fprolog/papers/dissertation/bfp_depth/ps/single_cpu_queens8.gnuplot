
# This is a command file for gnuplot

# set title "Single cpu performance comparison: 8 queens"

set nokey

set tics out

set nogrid

set xtics ("       DelphiKS" 1,"         PrologPF" 3,"         PrologPF(C)" 5, \
          "         wamcc" 7, "         Sicstus" 9)

set ytics ("0  " 0,"5  " 5,"10  " 10,"20  " 20,"30  " 30,"40  " 40,"50  " 50,"60  " 60,"70  " 70)
set yrange [0:70]
set ylabel "seconds"

set size 0.4,0.4

set terminal postscript portrait mono "Times-Roman" 8

set output "single_cpu_queens8.ps"

plot "single_cpu_queens8.data" with lines

