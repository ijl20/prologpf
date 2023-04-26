
/* fcs exercise 6 */

/* infinite lists: integer streams */

:-main([f_utils,o_utils]).

% fun primes(Item(x,xs)) = cons(x, fn () => primes(filters(notdiv x) (xs())));

fun head(item(I,_))  = I.

fun tail(item(_,Xf)) = Xf @ [].

fun nth(S,1) = head(S);
    nth(S,N) = nth(tail(S), N-1).

% fun filters(F,item(X,Xs) =
%         if (F @ [X] = true)
%         then item(X, lambda([], filters(F, Xs @ [])))
%         else filters(F, Xs @ []).
    
fun filters(F,item(X,Xs)) = if (F @ [X] = true)
                            then item(X, lambda([],
                                          ( XSeval = Xs @ [],
                                           '$fun_filters'([F,XSeval], Z)
                                          ), Z))
                            else filters(F, Xs @ []).

fun notdiv(X,Y) = if (Y mod X =\= 0)
                  then true
                  else false.

fun primes(item(X,Xs)) = item(X,lambda([],
                                 ('$fun_notdiv'([X],N),
                                   Xeval = Xs @ [],
                                  '$fun_filters'([N,Xeval], F),
                                  '$fun_primes'([F],Z)
                                 ), Z)).
 
fun makeints(N) = item(N,lambda([],(N1 is N+1,'$fun_makeints'([N1],Z)),Z)).

ex1(Z) :- Z = makeints(7).         % item(7, lambda(...))
ex2(Z) :- Z = head(makeints(7)).   % 7
ex3(Z) :- Z = head(tail(makeints(6))). % 7
ex31(Z) :- Z = head(tail(tail(tail(makeints(4))))). % 7
ex4(Z) :- Z = nth(makeints(1),7).  % 7
ex5(Z) :- Z = notdiv(8,77).        % true
ex6(Z) :- Z = notdiv(11,77).       % false
ex7(Z) :- Z = head(tail(filters(notdiv(2),makeints(5)))). % 7
ex8(Z) :- Z = nth(filters(notdiv(2), makeints(1)), 4). % 7
ex9(Z) :- Z = nth(primes(makeints(2)),60).
ex91(Z) :- Z = nth(primes(makeints(2)),6).
ex92(N,Z) :- Z = nth(primes(makeints(2)),N).

ex71(Z) :- Z = filters(notdiv(2),makeints(5)).
ex72(Z) :- Z = filters(notdiv(2), makeints(6)).
ex73(Z) :- Z = tail(filters(notdiv(2), makeints(6))).

o_query :- true.
