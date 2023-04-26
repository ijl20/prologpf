
/****** balanced2.pl test for backtrack inside oracle *********/

:- main.

/* o_utils.pl */

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
/*     o_proc_num: path processor number                                  */
/*                                                                        */
/**************************************************************************/

o_next(N,A) :- ( /* if */ g_read(o_orc,[]) ->
               	 /* then */   g_read(o_depth,D),
                              g_read(o_limit,L),
                              (/* if */ L > 0, D >= L ->
                               /* then */  open_oracle(A),!,fail;
                               /* else */  g_read(o_depth,D),
                                           D1 is D+1,
                                           g_assign(o_depth,D1)
			      );
                 /* else */   g_read(o_orc,[N|S]), g_assign(o_orc,S),!
               ).
o_next(_,_) :- g_read(o_depth,D), D1 is D-1, g_assign(o_depth,D1), fail.

/**************************************************************************/

open_oracle(A) :- 
    g_read(o_count,N),
    g_assign(o_orcs(N),A),
    N1 is N + 1,
    g_assign(o_count,N1).

/**************************************************************************/

o_send_soln(X) :- g_read(o_proc_num,N),write(sol(N,X)), write('.'), nl.

/**************************************************************************/
/*                                                                        */
/*   o_init        : initialize oracles and depth                         */
/*                                                                        */

o_init :- 
    g_assign(o_depth,0),
    g_assign(o_orcs,g_array(10000)),
    g_assign(o_count,0),
    g_assign(o_orc,[]).

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

o_bfp :-
    o_init,
    argv(3,Arg3), number_atom(L,Arg3), o_set_limit(L),
    argv(2,Arg2), write('cpu('),write(Arg2),write(') started'),nl,
    cputime(T0), g_assign(o_BFstart,T0),
    '$orc_0_query'(_,A,[_|A],_),
    fail.

o_bfp :-
    cputime(T1),
    argv(1, Arg1), number_atom(N,Arg1),
    argv(2, Arg2), number_atom(P,Arg2),
    argv(3, Arg3),
    print_orcs,
    o_orc_count(OrcCount), g_read(o_BFstart,T0),
    BFtime is T1-T0, g_assign(o_BFtime,BFtime),
    write('cpu('),write(Arg2),write(') BFtime='),
        write(BFtime), write('ms for limit='), write(Arg3),
        write(' for '), write(OrcCount), write(' oracles.'), nl,
    cputime(T2), g_assign(o_Ftime,T2),
    o_no_limit,
    o_get_oracle(N,P),
    print_orc,
    '$orc_0_query'(_,A,[_|A],_),
    fail.

o_bfp :- 
    cputime(T3), g_read(o_Ftime, T2), Ftime is T3-T2,
    argv(2, Arg2), g_read(o_BFtime, BFtime), Ttime is BFtime+Ftime,
    write('cpu('),write(Arg2),write(') completed. Ftime='),write(Ftime),
    write('ms Total_time='), write(Ttime), write(ms), nl,
    halt.    

/**************************************************************************/
/*                                                                        */
/*                    balanced2 code                                      */
/*                                                                        */
/**************************************************************************/

c(1).
c(2).
c(3).
c(4).
c(5).
c(6).
c(7).
c(8).
c(9).

a(X) :- c(_),c(_),c(X).

c(1,A,[1|E],E,1).
c(2,A,[2|E],E,2).
c(3,A,[3|E],E,3).
c(4,A,[4|E],E,4).
c(5,A,[5|E],E,5).
c(6,A,[6|E],E,6).
c(7,A,[7|E],E,7).
c(8,A,[8|E],E,8).
c(9,A,[9|E],E,9).

a(1,A,[1|E],En,X) :-
    o_next(N,A),
    c(N,A,E,E1,_),
    o_next(N1,A),
    c(N1,A,E1,E2,_),
    o_next(N2,A),
    c(N2,A,E2,En,X).

query :- o_next(N,A), a(N,A,A,E,X),write(A),nl, o_send_soln(X),fail.

'$orc_0_query'(1,A,[1|A],E) :- o_next(N,A), a(N,A,A,E,X), o_send_soln(X).
