#! /usr/bin/ksh

# usage: seq_time.ksh <prog> <G> <L>
#            where G = group size
#            and   L = BFP depth limit

seq_test.ksh $1 $2 $3 | awk -f seq_time.awk - prog=$1 group_count=$2 limit=$3

