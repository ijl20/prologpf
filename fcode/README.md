# PrologF fcode

Adding functions to Prolog

# Basic test

Functional support can be tested with:
```
?- [prologf].
true.

?- [ftest].
true.

?- ftest.

'max.pf consulted ok'
'max() test ok'
'map() test ok'
true.

?- 
```

## Test with Fibonacci function

Create Fibonacci functional code e.g. in file `examples/fib.pf`:
```
fun fib(0) = 0;
    fib(1) = 1;
    fib(N) = N + fib(N-1).

fib(X,Y) :- Y = fib(X). % map the fib function to a convenient relation for ease of testing.
```
The `fib(X,Y)` relation is a testing convenience.

In `swipl`:
```
?- [prologf].
true.

?- fconsult('examples/fib.pf').
true.

?- fib(4,X).
X = 10.

?-
```

## An example conversion from fcode to Prolog

```
% Example fprolog program
%
% relation max(L,N) returns with N as largest element of list L, using a function.
%

% Function max2(X,Y) returns greater of X or Y
fun max2(X,Y) = if (X > Y) then X else Y.

% Function max(L) returns maximum element in list L
fun max([X]) = X;
    max([X|L]) = max2(X,max(L)).

% Relation max(L,N) succeeds if N is the maximum element in list L
max(L,N) :- N = max(L).

% The fprolog code above converts to Prolog as follows:
%
% '$fun_max2'([A,B],C) :- !, '$fun_aux_if'(A>B,C=A,C=B).
%
% % Lambda version
% '$fun_max2'(D,lambda(E,'$fun_max2'([F,G],H),H)) :- append(D,E,[F,G]), !.
%
% '$fun_max'([[I]],I):- !.
% '$fun_max'([[I|J]],K):-!,'$fun_max'([J],L),'$fun_max2'([I,L],K).
%
% % Lambda version
% '$fun_max'(M,lambda(N,'$fun_max'([O],Q),Q)):-append(M,N,[O]),!.
%
% max(R,S):-'$fun_max'([R],T),S=T.

```

This code can be tested with:

```
$ swipl
Welcome to SWI-Prolog (threaded, 64 bits, version 8.2.4)
SWI-Prolog comes with ABSOLUTELY NO WARRANTY. This is free software.
Please run ?- license. for legal details.

For online help and background, visit https://www.swi-prolog.org
For built-in help, use ?- help(Topic). or ?- apropos(Word).

?- [prologf].
true.

?- fconsult('examples/max.pf').
true.

?- max([1,2,5,4,6,9,3,4,2],X).
X = 9.

?-
```
