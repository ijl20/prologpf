
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   8 QUEENS Problem for 'C' coded oracle primitives                %%
%%   queens10_cut.pl                                                  %%
%%   queens10_cut.usr                                                 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- main.

%% BUILD CODE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

get_solutions(Board_size, Soln) :- o_build(1), solve(Board_size, [], Soln). 

solve(Bs, [square(Bs, Y) | L], [square(Bs, Y) | L]) :- o_build(1).
solve(Board_size, Initial, Final) :-
                o_build(2),
		newsquare(Initial, Next, Board_size),
		solve(Board_size, [Next | Initial], Final).

newsquare([square(I,J) | Rest], square(X, Y), Boardsize) :-
        o_build(1),
	I < Boardsize, X is I + 1, snint(Y, Boardsize),
	notthreatened(I, J, X, Y), safe(X, Y, Rest).
newsquare([], square(1, X), Boardsize) :-
        o_build(2),
        snint(X, Boardsize).

snint(X, X) :- o_build(1).
snint(N, NPlusOneOrMore) :-
        o_build(2),
        M is NPlusOneOrMore - 1,
        M > 0,
	snint(N,M).

%% FOLLOW CODE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

get_solutions(0,A,B) :- get_solutions(A,B).
get_solutions(1,Board_size, Soln) :- o_follow(N), solve(N,Board_size, [], Soln). 

solve(0,A,B,C) :- solve(A,B,C).
solve(1,Bs, [square(Bs, Y) | L], [square(Bs, Y) | L]).
solve(2,Board_size, Initial, Final) :-
                o_follow(N1),
		newsquare(N1, Initial, Next, Board_size),
                o_follow(N2),
		solve(N2, Board_size, [Next | Initial], Final).

newsquare(0,A,B,C) :- newsquare(A,B,C).
newsquare(1,[square(I,J) | Rest], square(X, Y), Boardsize) :-
	I < Boardsize, X is I + 1,
        o_follow(N1),
        snint(N1, Y, Boardsize),
	notthreatened(I, J, X, Y),
        safe(X, Y, Rest).
newsquare(2,[], square(1, X), Boardsize) :-
        o_follow(N1),
        snint(N1, X, Boardsize).

snint(0,A,B) :- snint(A,B).
snint(1,X, X).
snint(2,N, NPlusOneOrMore) :- M is NPlusOneOrMore - 1, M > 0,
        o_follow(N1),
	snint(N1,N,M).

%% UNCHANGED CODE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

notthreatened(I, J, X, Y) :- I \== X, J \== Y, 
	U1 is I - J, V1 is X - Y, U1 \== V1,
	U2 is I + J, V2 is X + Y, U2 \== V2, !.

safe(X, Y, []) :- !.
safe(X, Y, [square(I, J) | L]) :-
	notthreatened(I, J, X, Y), safe(X, Y, L).

b_query :- get_solutions(8,X), o_soln(X).

f_query :- o_follow(N), get_solutions(N,8,X), o_soln(X).

:- o_bfp_c.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%             TRANSFORMATION:                                        %%
%%                                                                    %%
%%   ORIGINAL CODE:                                                   %%
%%        a(X).                                                       %%
%%        a(X) :- c(X), d(X).                                         %%
%%                                                                    %%
%%   BUILD CODE:                                                      %%
%%        a(X) :- o_build(1).                                         %%
%%        a(X) :- o_build(2), c(X), d(X).                             %%
%%                                                                    %%
%%   FOLLOW CODE:                                                     %%
%%        a(0,X) :- a(X).                                             %%
%%        a(1,X).                                                     %%
%%        a(2,X) :- o_follow(N1), c(N1,X), o_follow(N2), d(N2,X).     %%
%%                                                                    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%% ORACLE PRIMITIVES %%%%%%%%%%%%%%%%%%%%%%%%

o_build(N) :- pragma_c(o_build1).
o_build(_) :- pragma_c(o_build2).

o_follow(N) :- pragma_c(o_follow).

o_set_l(L) :- pragma_c(o_set_l).
o_read_l(L) :- pragma_c(o_read_l).

o_set_g(G) :- pragma_c(o_set_g).
o_read_g(G) :- pragma_c(o_read_g).

o_set_n(N) :- pragma_c(o_set_n).
o_read_n(N) :- pragma_c(o_read_n).

o_read_s(S) :- pragma_c(o_read_s).

o_init :- pragma_c(o_init).

o_set_current(I) :- pragma_c(o_set_current).
o_read_current(I) :- pragma_c(o_read_current).

o_sol_count(N) :- g_read(o_SolnCount,N).

%%%%%%%%%% UTILITY PREDS %%%%%%%%%%%%%%%%%%%%%%%%

o_read_orc(N,I,V) :- pragma_c(o_read_orc).

o_print_orcs :- o_read_s(S),
                o_print_orcs1(0,S).

o_print_orcs1(I,S) :- I < S,
                o_print_orc(I),
                I1 is I + 1,
                o_print_orcs1(I1,S),
                !.
o_print_orcs1(_,_).

o_print_orc(N) :- o_read_orc(N,0,Length),
                  write('['),
                  o_print_orc1(N,1,Length),
                  o_read_orc(N,Length,V),
                  write(V),
                  write(']'),
                  nl.

o_print_orc1(N,I,L) :- I < L,
                  o_read_orc(N,I,V),
                  write(V),
                  write(','),
                  I1 is I + 1,
                  o_print_orc1(N,I1,L),
                  !.
o_print_orc1(_,_,_).

/**************************************************************************/
/*                                                                        */
/*                    S T R A T E G I E S                                 */
/*                                                                        */
/**************************************************************************/
/*                                                                        */
/* Breadth First Partitioning                                             */
/*                                                                        */
/* Search to given depth (Limit) collecting open oracles in o_orcs        */
/* then search for unlimited depth from those oracles                     */
/*                                                                        */
/* Arguments to executable are (1) Pool size, (2) Proc number, (3) Limit  */
/*                                                                        */

o_get_oracle :- 
     o_read_current(I), 
     o_read_s(S),
     I < S.

o_get_oracle :- 
     o_read_current(I), 
     o_read_s(S),
     I < S,
     o_read_g(G),
     I1 is I+G, 
     o_set_current(I1),
     o_get_oracle.

o_soln(X) :- g_read(o_SolnCount,C), C1 is C + 1, g_assign(o_SolnCount,C1),
    write('delphi solution '), write(X), nl.

o_bfp_c :-        /* Phase 0: Collect oracles */
    o_init,
    g_assign(o_SolnCount,0),
    /* Arg1 = G, Arg2 = N, Arg3 = L */
    argv(1,Arg1), number_atom(G,Arg1), o_set_g(G),
    argv(2,Arg2), number_atom(N,Arg2), o_set_n(N),
    argv(3,Arg3), number_atom(L,Arg3), o_set_l(L),
      write('delphi bfp started '),
      write(N), write(' '), 
      write(G), write(' '),
      write(L), nl,
    cputime(T0), g_assign(o_BFstart,T0),
    b_query,                /* BUILD mode query */
    fail.

o_bfp_c :-       /* Phase 1: pick oracles and search */
    cputime(T1),
    argv(1, Arg1), number_atom(G,Arg1),
    argv(2, Arg2), number_atom(N,Arg2),
    argv(3, Arg3), number_atom(L,Arg3),
    % o_print_orcs,
    o_set_l(10000),        /* no limit L */    
    o_read_s(S), g_read(o_BFstart,T0),
    BFtime is T1-T0, g_assign(o_BFtime,BFtime),
      write('delphi bfp oracles '),
      write(N), write(' '), 
      write(G), write(' '),
      write(L), write(' '),
      write(S), write(' '),
      write(BFtime), nl,
    cputime(T2), g_assign(o_Ftime,T2),
    o_set_current(N),
    o_get_oracle,
    % o_read_current(I),
    % o_print_orc(I),
    f_query,               /* FOLLOW mode query */
    fail.

o_bfp_c :-      /* Phase 2: Statistics & Shutdown */
    cputime(T3), g_read(o_Ftime, T2), Ftime is T3-T2,
    argv(1, G),
    argv(2, N),
    argv(3, L),
    o_read_s(S),
    o_sol_count(C),
    g_read(o_BFtime, BFtime),
    Ttime is BFtime+Ftime,
      write('delphi bfp completed '),
      write(N), write(' '), 
      write(G), write(' '),
      write(L), write(' '),
      write(S), write(' '),
      write(C), write(' '),
      write(BFtime), write(' '),
      write(Ftime), write(' '),
      write(Ttime), nl,
    halt.    

o_query :- true.  % so compatible with prologpf in prolog


