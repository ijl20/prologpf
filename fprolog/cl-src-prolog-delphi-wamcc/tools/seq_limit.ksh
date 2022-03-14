#! /usr/bin/ksh

# usage: seq_limit.ksh <prog> <G> <L1> <Ln> <Lstep>
#            where G = group size
#            where L1 = BFP limit starting value
#            where Ln = BFP limit ending value
#            where Lstep = BFP limit step value

l=$3 

while ((l <= $4))
do
    seq_time.ksh $1 $2 $l
   ((l = l + $5))
done

