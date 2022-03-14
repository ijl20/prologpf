
:- main.

% build code

circuit(Specification,Solution) :- o_build(1),
	num(Depth_limit), Depth_limit < 5,  write(Depth_limit), nl, 
search(Depth_limit, 0, Specification, Solution).
 
search(_Depth_limit, _Depth, Table, Solution) :- o_build(1),
	signals(Solution, Table).

search(Depth_limit, Depth, Table, nand(Sl1,Sl2)) :- o_build(2),
	Depth < Depth_limit,
	D is Depth +1,
	search(Depth_limit, D, Sp1, Sl1),
	ngate(Table, Sp1, Sp2),
	search(Depth_limit, D, Sp2, Sl2).


signals( 0, [0,1,0,1,0,1,0,1]) :- o_build(1).
signals( 1, [0,0,1,1,0,0,1,1]) :- o_build(2).
signals( 2, [0,0,0,0,1,1,1,1]) :- o_build(3).
signals( v, [1,1,1,1,1,1,1,1]) :- o_build(4).
signals( i0, [1,0,1,0,1,0,1,0]) :- o_build(5).
signals( i1, [1,1,0,0,1,1,0,0]) :- o_build(6).
signals( i2, [1,1,1,1,0,0,0,0]) :- o_build(7).

ngate([], [], []) :- o_build(1).
ngate([1|T0], [0|T1], [_|T2]) :- o_build(2), ngate(T0,T1,T2).
ngate([1|T0], [1|T1], [0|T2]) :- o_build(3), ngate(T0,T1,T2).
ngate([0|T0], [1|T1], [1|T2]) :- o_build(4), ngate(T0,T1,T2).

num(0) :- o_build(1).
num(N) :- o_build(2), num(M), N is M+1.

% follow code

circuit(0,A,B) :- circuit(A,B).
circuit(1,Specification,Solution) :- 
	o_follow(N1), num(N1,Depth_limit), Depth_limit < 5, write(Depth_limit), nl, 
        o_follow(N2), search(Depth_limit, 0, Specification, Solution).
 
search(0,A,B,C,D) :- search(A,B,C,D).
search(1,_Depth_limit, _Depth, Table, Solution) :-
	o_follow(N1), signals(N1, Solution, Table).

search(2,Depth_limit, Depth, Table, nand(Sl1,Sl2)) :-
	Depth < Depth_limit,
	D is Depth +1,
	o_follow(N1), search(N1, Depth_limit, D, Sp1, Sl1),
	o_follow(N2), ngate(N2, Table, Sp1, Sp2),
	o_follow(N3), search(N3, Depth_limit, D, Sp2, Sl2).


signals(0,A,B) :- signals(A,B).
signals(1, 0, [0,1,0,1,0,1,0,1]).
signals(2, 1, [0,0,1,1,0,0,1,1]).
signals(3, 2, [0,0,0,0,1,1,1,1]).
signals(4, v, [1,1,1,1,1,1,1,1]).
signals(5, i0, [1,0,1,0,1,0,1,0]).
signals(6, i1, [1,1,0,0,1,1,0,0]).
signals(7, i2, [1,1,1,1,0,0,0,0]).

ngate(0,A,B,C) :- ngate(A,B,C).
ngate(1,[], [], []).
ngate(2,[1|T0], [0|T1], [_|T2]) :- o_follow(N1), ngate(N1,T0,T1,T2).
ngate(3,[1|T0], [1|T1], [0|T2]) :- o_follow(N1), ngate(N1,T0,T1,T2).
ngate(4,[0|T0], [1|T1], [1|T2]) :- o_follow(N1), ngate(T0,T1,T2).

num(0,A) :- num(A).
num(1,0).
num(2,N) :- o_follow(N1), num(N1,M), N is M+1.

o_query :- true.

b_query :- circuit([0,0,0,1,0,1,1,1],X), o_soln(X).

f_query :- o_follow(N), circuit(N,[0,0,0,1,0,1,1,1],X), o_soln(X).


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


