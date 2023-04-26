
:- main([f_utils]).

/* some functions from the Foundations of Computer Science class */

fun(facr(N),
    if(N=1,
       1,
       N * facr(N-1)
      )).

fun(faci(N,Acc),
    if(N=1,
       Acc,
       faci(N-1,N*Acc)
      )).

fun(plus(M,N),M+N).

fun(nfold(F,N,X),
    if(N=1,
       F @ [X],
       nfold(F,N-1,F @ [X])
      )).

fun(inc(X), X+1). 

ex(1,Fact)  :- Fact = facr(5).
ex(2,Fact)  :- Fact = faci(5,1).
ex(3,Succ)  :- Succ = plus(1).
ex(4,Z)     :- Y = plus(1), Z = Y @ [2].
ex(5,Z)     :- Z = plus(1) @ [2].
ex(6,NFold) :- NFold = nfold(inc,3,7).
