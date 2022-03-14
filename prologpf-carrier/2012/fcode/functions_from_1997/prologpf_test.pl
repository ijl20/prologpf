
:- main([f_utils, o_utils]).

fun square(X) = X * X.

fun inc(X) = X + 1.

a(X,Z) :- b(X,Y), Z = square(Y).
a(X,Z) :- b(X,Y), Z = square(square(Y)).

b(X,Y) :- Y = inc(X).
b(X,Y) :- Y = inc(inc(X)).

o_query :- a(2,Z), o_soln(Z).

:- o_bfp_c.
