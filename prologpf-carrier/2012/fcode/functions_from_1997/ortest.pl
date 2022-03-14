
:- main([f_utils, o_utils]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% or test

a(X) :- b(X); c(X).

b(b).

c(c).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cut test

cuttest(X) :- !.

query :- a(X), o_send_soln(X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function test

fun(foo(X), goo(X)).

fun(poo(X), X + X).

bah(X) :- X = foo(a).

:- o_bfp.
