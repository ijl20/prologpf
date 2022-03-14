
# This is a command file for gnuplot

# set title "Single cpu performance comparison: 10 queens"

set nokey

set tics out

set nogrid

set xtics ("       DelphiKS" 1,"         PrologPF" 3,"         PrologPF(C)" 5, \
          "         wamcc" 7, "         Sicstus" 9)

# set ytics (0,5,10,20,30,40,50,60,70)

set ytics ("0  " 0,"200  " 200,"400  " 400,"600  " 600,"800  " 800,"1000  " 1000,"1200  " 1200,"1400  " 1400)

set yrange [0:1400]
set ylabel "seconds"

set size 0.4,0.4

set terminal postscript portrait mono "Times-Roman" 8

set output "single_cpu_queens10.ps"

plot "single_cpu_queens10.data" with lines

