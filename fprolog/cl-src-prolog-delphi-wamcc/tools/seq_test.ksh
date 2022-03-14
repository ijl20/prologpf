#! /usr/bin/ksh

# usage: seq_test <prog> <G> <L>
#            where G = group size
#            and   L = BFP depth limit

# seq_file=$1".seq"

seq_temp=/tmp/$1_$2_$3.seq

((max_cpu = $2 - 1))

# echo $1 "(cpu 0.."$max_cpu", limit="$3")" # " >"$seq_file
 
i=0

# cat /dev/null >$seq_file

while ((i < $2))
do
                                          # echo "cpu("$i")"
   $1 $2 $i $3 | grep completed       #>$seq_temp
#    cat $seq_temp | grep cpu           # >>$seq_file
#    echo -n "cpu("$i") solution count:"    # >>$seq_file
#   cat $seq_temp | grep sol | wc -l   # >>$seq_file
   ((i = i + 1))
done

# rm $seq_temp
