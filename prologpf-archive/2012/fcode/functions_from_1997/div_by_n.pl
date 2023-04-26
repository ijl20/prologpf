
% testing free variables in lambda terms

:- main([f_utils,o_utils]).

fun div_by_n(N) = lambda([X],'$fun_/'([X,N],Z),Z).

ex(1,Z) :- Z = div_by_n(2).
ex(2,Z) :- Z = div_by_n(2) @ [10].

o_query :- true.
