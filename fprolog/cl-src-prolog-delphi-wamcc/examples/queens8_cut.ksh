#! /usr/bin/ksh

i=0
echo "queens8_cut (cpu 0..29) >queens8_cut.trace"

rm queens8_cut.trace
while ((i < 29))
do
   echo "cpu("$i")"
   queens8_cut 29 $i 19 >queens8_cut.temp
   cat queens8_cut.temp | grep cpu >>queens8_cut.trace
   echo "cpu("$i") solution count:" >>queens8_cut.trace
   cat queens8_cut.temp | grep sol | wc -l >>queens8_cut.trace
   ((i = i + 1))
done