#! /usr/bin/ksh

seq_test.ksh queens8_cut 1 3 | awk -f queens8_cut_orcs.awk
seq_test.ksh queens8_cut 4 6 | awk -f queens8_cut_orcs.awk
seq_test.ksh queens8_cut 9 9 | awk -f queens8_cut_orcs.awk
seq_test.ksh queens8_cut 20 12 | awk -f queens8_cut_orcs.awk
seq_test.ksh queens8_cut 42 15 | awk -f queens8_cut_orcs.awk
seq_test.ksh queens8_cut 77 18 | awk -f queens8_cut_orcs.awk
seq_test.ksh queens8_cut 136 21 | awk -f queens8_cut_orcs.awk
seq_test.ksh queens8_cut 214 24 | awk -f queens8_cut_orcs.awk
seq_test.ksh queens8_cut 340 27 | awk -f queens8_cut_orcs.awk
seq_test.ksh queens8_cut 454 30 | awk -f queens8_cut_orcs.awk

