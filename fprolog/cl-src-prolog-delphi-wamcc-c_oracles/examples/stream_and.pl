
:- main([o_utils]).

mem(X,[X|_]).
mem(X,[_|Y]) :- mem(X,Y).

fact(1,1).
fact(X,F) :- X > 1, X1 is X - 1, fact(X1,F1), F is X * F1.

o_query :- mem(X,[1,2,3,4]), fact(X,Y), o_soln(Y).

next_num(1) :- o_init.
next_num(X) :- next_num(X1), X is X1 + 1.

:- next_num(X), o_set_l(X), ( o_query, fail; o_print_orcs ), fail.
