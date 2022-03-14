
# This is a command file for gnuplot

# StartDate is day number of start of write-up (156 = Jun 6th)
# StartYear is year of start of writeup
# Deadline is day number of deadline, counting from Jan 1st of StartYear
#    i.e. 426  = Feb 28th 1998 i.e. 365 + 61

StartDate = 156
StartYear = 1997
Deadline  = 426

MaxWords = 60000

set title "PrologPF: Parallel Functional Logic on the Delphi Machine"

set nokey

set ytics 0,5000,MaxWords

set xtics ("Jul 1 97" 181, "Aug 1" 212, "Sep 1" 243, "Oct 1" 273, "Nov 1" 304, \
           "Dec 1" 334, "Jan 1 98" 365, "Feb 1" 396, "Mar 1" 424)

set format x ""

set grid

plot [x=StartDate:Deadline] "words.data" using 1:2 with lines, \
   "words.forecast" with lines, \
   "words.data" using 3:2 with lines, \
   (x - StartDate)*(MaxWords/(Deadline-StartDate)) 

pause -1 "Hit <return> to quit"
