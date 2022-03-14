
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%             TRANSFORMATION:                                               %%
%%                                                                           %%
%%   ORIGINAL CODE:                                                          %%
%%       a(X).                                                               %%
%%       a(X) :- c(X), d(X).                                                 %%
%%                                                                           %%
%%   TRANSFORMED CODE:                                                       %%
%%       a(X,1) :- o_build(1).                                               %%
%%       a(X,2) :- o_build(2), o_follow(N1), c(X,N1), o_follow(N2), d(X,N2). %%
%%                                                                           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- public o_build/1, o_follow/1, o_soln/1, o_bfp_c/0.

%%%%%%%%%% ORACLE PRIMITIVES %%%%%%%%%%%%%%%%%%%%%%%%

o_build(N) :- pragma_c(o_build1).
o_build(_) :- pragma_c(o_build2).

o_follow(N) :- pragma_c(o_follow).

o_set_build :- pragma_c(o_set_build).

o_set_follow :- pragma_c(o_set_follow).

o_read_build(B) :- pragma_c(o_read_build).

o_read_b_depth(N) :- pragma_c(o_read_b_depth).

o_read_f_depth(N) :- pragma_c(o_read_f_depth).

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
    o_set_build,
    o_query,                /* BUILD mode query */
    fail.

o_bfp_c :-       /* Phase 1: pick oracles and search */
    cputime(T1),
    argv(1, Arg1), number_atom(G,Arg1),
    argv(2, Arg2), number_atom(N,Arg2),
    argv(3, Arg3), number_atom(L,Arg3),
    % o_print_orcs,
    o_set_l(10000),        /* L = infinity */    
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
    o_set_follow,
    o_query,               /* FOLLOW mode query */
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



