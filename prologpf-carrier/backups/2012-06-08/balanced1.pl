
:- main([o_utils]).

:- public('$orc_0_query'/4).

count(0).
count(N) :- N > 0, N1 is N - 1, count(N1), !.

c(1).
c(2).
c(3).
c(4).
c(5).
c(6).
c(7).
c(8).
c(9).
c(10).
c(11).
c(12).

query :- c(X), count(10000), o_send_soln(X).

:- o_bfp.
