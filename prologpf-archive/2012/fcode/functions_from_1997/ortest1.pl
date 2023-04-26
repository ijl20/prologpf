
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

fun bah @ [X] = goo(X).

fun woo @ [1] = a1;
    woo @ [2] = a2.

fun foo(X) = goo(X).

fun poo(1) = 11;
    poo(2) = 22.

fbah(X) :- X = bah(2).

ffoo(X) :- X = foo(2).

fwoo(X) :- X = woo(2).

fpoo(X) :- X = poo(2).

