
:- main([o_utils]).

:- public('$orc_0_query'/4).

get_solutions(Board_size, Soln) :- solve(Board_size, [], Soln). 

solve(Bs, [square(Bs, Y) | L], [square(Bs, Y) | L]).
solve(Board_size, Initial, Final) :-
		newsquare(Initial, Next, Board_size),
		solve(Board_size, [Next | Initial], Final).

newsquare([square(I,J) | Rest], square(X, Y), Boardsize) :-
	I < Boardsize, X is I + 1, snint(Y, Boardsize),
	notthreatened(I, J, X, Y), safe(X, Y, Rest).
newsquare([], square(1, X), Boardsize) :- snint(X, Boardsize).

snint(X, X).
snint(N, NPlusOneOrMore) :- M is NPlusOneOrMore - 1, M > 0,
	snint(N,M).

notthreatened(I, J, X, Y) :- I \== X, J \== Y, 
	U1 is I - J, V1 is X - Y, U1 \== V1,
	U2 is I + J, V2 is X + Y, U2 \== V2, !.

safe(X, Y, []) :- !.
safe(X, Y, [square(I, J) | L]) :-
	notthreatened(I, J, X, Y), safe(X, Y, L).

query :- get_solutions(8,X), o_send_soln(X).

:- o_bfp.





