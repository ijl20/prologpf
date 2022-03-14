#! /usr/bin/ksh

# usage: seq_group <prog> <G1> <Gn> <Gstep> <L>
#            where G1 = group size starting value
#            where Gn = group size ending value
#            where Gstep = group size step value
#            and   L = BFP depth limit

# seq_file=$1".seq"

# echo $1 "(cpu 0.."$max_cpu", limit="$3")" # " >"$seq_file

g=$2 

while ((g <= $3))
do
    seq_time.ksh $1 $g $5
   ((g = g + $4))
done

