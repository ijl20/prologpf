
/* o_utils.pl */

:- public o_next/2, o_send_soln/1, o_bfp/0, o_bfp_one/0.

/**************************************************************************/
/*    o_next(Next_oracle, Accumulated_oracle_so_far)                      */
/*                                                                        */
/* will return the next oracle index in N (from head of global variable   */
/* o_orc) or will return leave N as new variable if o_orc = []            */
/* also length of oracle is tracked with o_depth, which is tested against */
/* o_limit to see if call should flag open oracle and then fail.          */
/*                                                                        */
/* o_limit set to -1 means no limit.                                      */
/*                                                                        */
/* This relation should at some point be rewritten in 'C'                 */
/**************************************************************************/
/*                                                                        */
/*   o_send_soln(X): send solution term X to host                         */
/*                                                                        */
/**************************************************************************/
/*                                                                        */
/*   o_init        : initialize oracles and depth                         */
/*                                                                        */
/**************************************************************************/
/*                                                                        */
/*   o_set_limit(D): set depth limit to D                                 */
/*                                                                        */
/**************************************************************************/
/*                                                                        */
/*   o_no_limit    : specify no depth limit (i.e. free search)            */
/*                                                                        */
/**************************************************************************/
/*                                                                        */
/*   o_get_oracle(N,P): get next oracle for path processor P in pool of N */
/*                                                                        */
/**************************************************************************/
/*                                                                        */
/* Globals:                                                               */
/*                                                                        */
/*     o_orc: current oracle                                              */
/*     o_orcs: array of available oracles                                 */
/*     o_limit: depth limit                                               */
/*     o_depth: current depth                                             */
/*     o_count: count of oracles in o_orcs                                */
/*     o_SolnCount: count of solutions found by this PP                   */
/*                                                                        */
/**************************************************************************/

/* case 1: no oracle to follow, hit limit */

o_next(_,A) :- g_read(o_orc,[]),
               g_read(o_limit,L), L > 0,
               g_read(o_depth,D), D >= L,
               open_oracle(A), 
               !, fail.

/* case 2: no oracle to follow, not at limit */

o_next(_,_) :- g_read(o_orc,[]),
               g_read(o_depth,D), D1 is D+1, g_assign(o_depth,D1).

/* case 3: no oracle to follow, reduce depth on backtracking */

o_next(_,_) :- g_read(o_orc,[]),
               g_read(o_depth,D), D1 is D-1, D > 0, g_assign(o_depth,D1),
               !, fail.

o_next(_,_) :- g_read(o_orc,[]),nl, write('[] caught!'),nl, fail.


/* case 4: follow oracle */

o_next(N,_) :- g_read(o_orc, [N|S]), g_assign(o_orc,S), !.

/**************************************************************************/

open_oracle(A) :- 
    g_read(o_count,N),
    g_assign(o_orcs(N),A),
    N1 is N + 1,
    g_assign(o_count,N1).

/**************************************************************************/

o_send_soln(X) :- 
    g_read(o_SolnCount,C), C1 is C + 1, g_assign(o_SolnCount,C1),
    write('delphi solution '), write(X), nl.

/**************************************************************************/
/*                                                                        */
/*   o_init        : initialize oracles and depth                         */
/*                                                                        */

o_init :- 
    g_assign(o_depth,0),
    g_assign(o_orcs,g_array(10000)),
    g_assign(o_count,0),
    g_assign(o_orc,[]),
    g_assign(o_SolnCount,0).

/**************************************************************************/
/*                                                                        */
/*   o_set_limit(D): set depth limit to D                                 */
/*                                                                        */

o_set_limit(D) :- g_assign(o_limit, D).

/**************************************************************************/
/*                                                                        */
/*   o_set_cpu(P): set cpu number to N                                    */
/*                                                                        */

o_set_cpu(N) :- g_assign(o_proc_num,N).

/**************************************************************************/
/*                                                                        */
/*   o_no_limit    : specify no depth limit (i.e. free search)            */
/*                                                                        */

o_no_limit :- g_assign(o_limit,-1).

/**************************************************************************/
/*                                                                        */
/*   o_orc_count(N) : N is count of oracles in o_orcs                     */
/*                                                                        */

o_orc_count(N) :- g_read(o_count,N).

/**************************************************************************/
/*                                                                        */
/*   o_sol_count(N) : N is number of solutions found by this PP           */
/*                                                                        */

o_sol_count(N) :- g_read(o_SolnCount,N).

/**************************************************************************/
/*                                                                        */
/*   o_get_oracle(N,P): get next oracle for path processor P in pool of N */
/*                                                                        */

o_get_oracle(N,P) :- step_oracle(0,N,P).

step_oracle(C,N,P) :-
    (C mod N) =:= P,
    g_read(o_count,M),
    C < M,
    g_read(o_orcs(C),S),
    g_assign(o_orc,S).

step_oracle(C,N,P) :-
    C1 is C + 1,
    g_read(o_count,M),
    C1 < M,
    step_oracle(C1,N,P).

/**************************************************************************/
/*                                                                        */
/*                    Utilities                                           */
/*                                                                        */
/**************************************************************************/

print_orc  :- 
    g_read(o_proc_num,P),
    g_read(o_orc,S),
    write(orc(P,S)), write('.'), nl.

print_orcs :- g_read(o_proc_num,P), print_orcs1(P,0).
print_orcs.

print_orcs1(P,N) :-
    g_read(o_count,M),
    N < M,
    g_read(o_orcs(N),S),
    write(orc(P,N,S)), write('.'), nl,
    N1 is N + 1,
    print_orcs1(P,N1).

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

o_bfp :-        /* Phase 0: Collect oracles */
    o_init,
    /* Arg1 = G, Arg2 = N, Arg3 = L */
    argv(1,G),
    argv(2,N), 
    argv(3,Arg3), number_atom(L,Arg3), o_set_limit(L),
      write('delphi bfp started '),
      write(N), write(' '), 
      write(G), write(' '),
      write(L), nl,
    cputime(T0), g_assign(o_BFstart,T0),
    '$orc_0_o_query'(_,A,[_|A],_),
    fail.

o_bfp :-       /* Phase 1: pick oracles and search */
    cputime(T1),
    argv(1, Arg1), number_atom(G,Arg1),
    argv(2, Arg2), number_atom(N,Arg2),
    argv(3, L),
    /* print_orcs, */
    o_orc_count(S), g_read(o_BFstart,T0),
    BFtime is T1-T0, g_assign(o_BFtime,BFtime),
      write('delphi bfp oracles '),
      write(N), write(' '), 
      write(G), write(' '),
      write(L), write(' '),
      write(S), write(' '),
      write(BFtime), nl,
    cputime(T2), g_assign(o_Ftime,T2),
    o_no_limit,
    o_get_oracle(G,N),
    /* print_orc, */
    '$orc_0_o_query'(_,A,[_|A],_),
    fail.

o_bfp :-      /* Phase 2: Shutdown */
    cputime(T3), g_read(o_Ftime, T2), Ftime is T3-T2,
    argv(1, G),
    argv(2, N),
    argv(3, L),
    o_orc_count(S),
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

/**************************************************************************/
/* Breadth First Partitioning - ONE SOLUTION ONLY                         */
/*                                                                        */
/* Search to given depth (Limit) collecting open oracles in o_orcs        */
/* then search for unlimited depth from those oracles                     */
/*                                                                        */
/* Arguments to executable are (1) Pool size, (2) Proc number, (3) Limit  */
/*                                                                        */

o_bfp_one :-        /* Phase 0: Collect oracles */
    o_init,
    /* Arg1 = G, Arg2 = N, Arg3 = L */
    argv(1,G),
    argv(2,N), 
    argv(3,Arg3), number_atom(L,Arg3), o_set_limit(L),
      write('delphi bfp started '),
      write(N), write(' '), 
      write(G), write(' '),
      write(L), nl,
    cputime(T0), g_assign(o_BFstart,T0),
    '$orc_0_o_query'(_,A,[_|A],_),
    fail.

o_bfp_one :-       /* Phase 1: pick oracles and search */
    cputime(T1),
    argv(1, Arg1), number_atom(G,Arg1),
    argv(2, Arg2), number_atom(N,Arg2),
    argv(3, L),
    /* print_orcs, */
    o_orc_count(S), g_read(o_BFstart,T0),
    BFtime is T1-T0, g_assign(o_BFtime,BFtime),
      write('delphi bfp oracles '),
      write(N), write(' '), 
      write(G), write(' '),
      write(L), write(' '),
      write(S), write(' '),
      write(BFtime), nl,
    cputime(T2), g_assign(o_Ftime,T2),
    o_no_limit,
    o_get_oracle(G,N),
    /* print_orc, */
    '$orc_0_o_query'(_,A,[_|A],_),
    o_bfp_one_complete.

o_bfp_one :-
    o_bfp_one_complete.

o_bfp_one_complete :-      /* Phase 2: Shutdown */
    cputime(T3), g_read(o_Ftime, T2), Ftime is T3-T2,
    argv(1, G),
    argv(2, N),
    argv(3, L),
    o_orc_count(S),
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


