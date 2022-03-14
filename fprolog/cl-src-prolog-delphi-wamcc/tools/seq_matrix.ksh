#! /usr/bin/ksh

# usage: seq_matix.ksh <prog> <G1> <Gn> <Gstep> <L1> <Ln> <Lstep>
#                        $1    $2   $3    $4     $5   $6    $7
#            where G1 = Group count starting value
#            where Gn = Group count ending value
#            where Gstep = Group count step value
#            where L1 = BFP limit starting value
#            where Ln = BFP limit ending value
#            where Lstep = BFP limit step value

l=$5 

while ((l <= $6))
do
    g=$2
    while ((g <= $3))
      do
        seq_time.ksh $1 $g $l
        ((g = g + $4))
      done
    ((l = l + $7))
done

