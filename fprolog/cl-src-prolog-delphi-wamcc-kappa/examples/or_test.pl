
:- main([k1_utils]).

:- public o_query/0.

a(a) :- o_kbuild(1).
a(b) :- o_kbuild(2).
a(c) :- o_kbuild(3).
a(d) :- o_kbuild(4).

b([a,a,a,a,a,a,a,a,a]) :- o_kbuild(1).
b([b,b,b,b,a,b,b,a,a]) :- o_kbuild(2).
b([b,b,b,b,b,b,b,a,a]) :- o_kbuild(3).
b([b,b,b,b,c,b,b,a,a]) :- o_kbuild(4).
b([b,b,d,a,a,a,a,a,a]) :- o_kbuild(5).

o_query :- a(A), a(B),a(C),a(D),a(E),a(F),a(G),a(H),a(I),
           b([A,B,C,D,E,F,G,H,I]),
           o_ksoln([A,B,C,D,E,F,G,H,I]).

:- o_kloop.
