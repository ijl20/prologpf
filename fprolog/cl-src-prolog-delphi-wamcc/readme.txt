to compile a program:

prologpf -c -ppf -kcode pent_k1
w_gcc_ok -O2 -c pent_k1.c
w_gcc_ok -s -o pent_k1 pent_k1.o k1_utils.o -lwamcc

