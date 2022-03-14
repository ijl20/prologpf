
% fibonacci function versus relation

:- main([f_utils,o_utils]).

:- public fib/2.

fun fib(0) = 0;
    fib(1) = 1;
    fib(N) = fib(N-2) + fib(N-1).

fib(0,0).
fib(1,1).
fib(N,M) :- N > 1,
            N2 is N - 2,
            fib(N2,M2),
            N1 is N - 1,
            fib(N1,M1),
            M is M2 + M1.

fun fibf(X) = if fib(X,Y) then Y else fail.

fun ffib(F,0) = F @ [0];
    ffib(F,1) = F @ [1];
    ffib(F,N) = F @ [ffib(F,N-2) + ffib(F,N-1)].

fun ident(X) = X.

ex(1,Z) :- Z = fib(5).
ex(2,Z) :- fib(5,Z).
ex(3,Z) :- Z = fibf(5).
ex(4,Z) :- Z = fibf(-1).
ex(5,Z) :- Z = ffib @ [ident] @ [5].
ex(51,Z) :- Z = ffib @ [ident].
ex(6,Z) :- Z = ffib @ [lambda([X],'$fun_+'([X,1],Z),Z)] @ [5].

o_query :- true.
