
/* fcs exercise 6 */

/* infinite lists: integer streams */

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

fun fmod(X,Y) = if (Z is X mod Y) then Z else fail.

fun neq(X,Y) = if (X =\= Y) then true else false.

fun nd(X,Y) = neq(fmod(Y,X),0).

fun notdiv(X,Y) = if (Y mod X =\= 0)
                  then true
                  else false.

fun primes(item(X,Xs)) = item(X,lambda([],
                                 ('$fun_nd'([X],N),
                                   Xeval = Xs @ [],
                                  '$fun_filters'([N,Xeval], F),
                                  '$fun_primes'([F],Z)
                                 ), Z)).
 
fun makeints(N) = item(N,lambda([],(N1 is N+1,'$fun_makeints'([N1],Z)),Z)).

between(X,Y,X).
between(X,Y,Z) :- X < Y, between(X+1,Y,Z).

ex(1,Z) :- Z = makeints(7).         % item(7, lambda(...))
ex(2,Z) :- Z = head(makeints(7)).   % 7
ex(3,Z) :- Z = head(tail(makeints(6))). % 7
ex(31,Z) :- Z = head(tail(tail(tail(makeints(4))))). % 7
ex(4,Z) :- Z = nth(makeints(1),7).  % 7
ex(5,Z) :- Z = notdiv(8,77).        % true
ex(6,Z) :- Z = notdiv(11,77).       % false
ex(7,Z) :- Z = head(tail(filters(notdiv(2),makeints(5)))). % 7
ex(8,Z) :- Z = nth(filters(notdiv(2), makeints(1)), 4). % 7
ex(9,Z) :- Z = nth(primes(makeints(2)),60). % 281
ex(91,Z) :- Z = nth(primes(makeints(2)),6).

ex(71,Z) :- Z = filters(notdiv(2),makeints(5)).
ex(72,Z) :- Z = filters(notdiv(2), makeints(6)).
ex(73,Z) :- Z = tail(filters(notdiv(2), makeints(6))).

ex(10,Z) :- between(1,10,Z). % succeed with Z = 1..10

ex(11,Z) :- I = primes(makeints(2)), between(1,10,N1),
  between(1,10,N2), nth(I,N1) + nth(I,N2) = 12, Z = (N1,N2). 

ex(92,N,Z) :- Z = nth(primes(makeints(2)),N).

prime(P) :- next_prime(primes(makeints(2)), P).

next_prime(Primes,P) :- P = head(Primes).
next_prime(Primes,P) :- next_prime(tail(Primes),P).
