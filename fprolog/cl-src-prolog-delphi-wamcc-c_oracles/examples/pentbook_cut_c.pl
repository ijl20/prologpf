
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%     pentbook_cut for o_utils in 'C'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- main.

%%%%%%% BUILD CODE

solution(H) :- o_build(1),
	initial_state(Si),
	can_reach(Si,Sf),
	final_state(Sf),
	Sf = state(_,_,H).

can_reach(S1,S2) :- o_build(1),
	trans(S1,S),
	S = S2.
can_reach(S1,S2) :- o_build(2),
	trans(S1,S),
	can_reach(S,S2).

trans(State,New_State) :- o_build(1),
	State = state(Board,Pieces,History),
	del(Piece,Pieces,New_Pieces),
	pent(Piece,Orientation,Pattern),
	play_pent(Board,Pattern,New_Board),
	New_State = state(New_Board,New_Pieces,
		[[Piece,Orientation] | History]).

del(X,[X|Y],Y) :- o_build(1).
del(X,[Y|Z], [Y|Z1]) :- o_build(2), del(X,Z,Z1).


pent(1,1,[np,np,np,dnm,np,dnm,np]) :- o_build(1).
pent(1,2,[np,op,np,dnm,np,np,np]) :- o_build(2).
pent(1,3,[np,np,dnm,dnm,np,dnm,dnm,dnm,np,np]) :- o_build(3).
pent(1,4,[np,np,dnm,dnm,dnm,np,dnm,dnm,np,np]) :- o_build(4).

pent(2,1,[np,op,dnm,np,np,np,dnm,dnm,np]) :- o_build(5).

pent(3,1,[np,np,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np]) :- o_build(6).
pent(3,2,[np,np,np,dnm,np,dnm,dnm,dnm,np]) :- o_build(7).
pent(3,3,[np,dnm,op,op,np,dnm,np,np,np]) :- o_build(8).
pent(3,4,[np,op,op,dnm,np,op,op,dnm,np,np,np]) :- o_build(9).

pent(4,1,[np,op,dnm,op,np,op,dnm,np,np,np]) :- o_build(10).
pent(4,2,[np,op,op,dnm,np,np,np,dnm,np]) :- o_build(11).
pent(4,3,[np,dnm,np,np,np,dnm,dnm,dnm,np]) :- o_build(12).
pent(4,4,[np,np,np,dnm,dnm,np,dnm,dnm,dnm,np]) :- o_build(13).

pent(5,1,[np,np,dnm,np,np,np]) :- o_build(14).
pent(5,2,[np,np,dnm,dnm,np,np,dnm,dnm,np]) :- o_build(15).
pent(5,3,[np,np,op,dnm,np,np,np]) :- o_build(16).
pent(5,4,[np,np,dnm,dnm,np,np,dnm,dnm,dnm,np]) :- o_build(17).
pent(5,5,[np,np,np,dnm,np,np]) :- o_build(18).
pent(5,6,[np,np,np,dnm,dnm,np,np]) :- o_build(19).
pent(5,7,[np,dnm,dnm,dnm,np,np,dnm,dnm,np,np]) :- o_build(20).
pent(5,8,[np,dnm,dnm,np,np,dnm,dnm,np,np]) :- o_build(21).

pent(6,1,[np,dnm,op,np,np,dnm,np,np]) :- o_build(22).
pent(6,2,[np,op,op,dnm,np,np,op,dnm,dnm,np,np]) :- o_build(23).
pent(6,3,[np,np,op,dnm,dnm,np,np,dnm,dnm,dnm,np]) :- o_build(24).
pent(6,4,[np,np,dnm,np,np,dnm,dnm,np]) :- o_build(25).

pent(7,1,[np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,dnm,dnm,np,np]) :- o_build(26).
pent(7,2,[np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,np]) :- o_build(27).
pent(7,3,[np,np,dnm,dnm,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np]) :- o_build(28).
pent(7,4,[np,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np]) :- o_build(29).

pent(8,1,[np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,np,dnm,dnm,np]) :- o_build(30).
pent(8,2,[np,dnm,dnm,dnm,np,np,dnm,dnm,np,dnm,dnm,dnm,np]) :- o_build(31).
pent(8,3,[np,dnm,dnm,dnm,np,dnm,dnm,np,np,dnm,dnm,dnm,np]) :- o_build(32).
pent(8,4,[np,dnm,dnm,np,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np]) :- o_build(33).

pent(9,1,[np,np,op,dnm,dnm,np,np,dnm,dnm,np]) :- o_build(34).
pent(9,2,[np,dnm,np,np,np,dnm,dnm,np]) :- o_build(35).
pent(9,3,[np,op,op,dnm,np,np,np,dnm,dnm,np]) :- o_build(36).
pent(9,4,[np,np,dnm,np,np,dnm,dnm,dnm,np]) :- o_build(37).
pent(9,5,[np,op,dnm,np,np,op,dnm,dnm,np,np]) :- o_build(38).
pent(9,6,[np,op,dnm,op,np,np,dnm,np,np]) :- o_build(39).
pent(9,7,[np,op,dnm,np,np,np,dnm,dnm,dnm,np]) :- o_build(40).
pent(9,8,[np,op,dnm,np,np,np,dnm,np]) :- o_build(41).

pent(10,1,[np,np,dnm,op,np,dnm,dnm,np,np]) :- o_build(42).
pent(10,2,[np,np,op,dnm,dnm,np,op,dnm,dnm,np,np]) :- o_build(43).
pent(10,3,[np,op,op,dnm,np,np,np,dnm,dnm,dnm,np]) :- o_build(44).
pent(10,4,[np,dnm,np,np,np,dnm,np]) :- o_build(45).

pent(11,1,[np,dnm,dnm,dnm,np,dnm,dnm,np,np,dnm,dnm,np]) :- o_build(46).
pent(11,2,[np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,np,dnm,dnm,dnm,np]) :- o_build(47).
pent(11,3,[np,dnm,dnm,dnm,np,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np]) :- o_build(48).
pent(11,4,[np,dnm,dnm,np,np,dnm,dnm,np,dnm,dnm,dnm,np]) :- o_build(49).

pent(12,1,[np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np]) :- o_build(50).

%%%%%%%%%%%% FOLLOW CODE

solution(1,H) :-
	initial_state(Si),
	o_follow(N1),
        can_reach(N1,Si,Sf),
	final_state(Sf),
	Sf = state(_,_,H).
solution(0,A) :- solution(A).

can_reach(1,S1,S2) :-
        o_follow(N1),
	trans(N1,S1,S),
	S = S2.
can_reach(2,S1,S2) :-
        o_follow(N1),
	trans(N1,S1,S),
        o_follow(N2),
	can_reach(N2,S,S2).
can_reach(0,A,B) :- can_reach(A,B).

trans(1,State,New_State) :-
	State = state(Board,Pieces,History),
        o_follow(N1),
	del(N1,Piece,Pieces,New_Pieces),
        o_follow(N2),
	pent(N2,Piece,Orientation,Pattern),
	play_pent(Board,Pattern,New_Board),
	New_State = state(New_Board,New_Pieces,
		[[Piece,Orientation] | History]).
trans(0,A,B) :- trans(A,B).

del(1,X,[X|Y],Y).
del(2,X,[Y|Z], [Y|Z1]) :- o_follow(N), del(N,X,Z,Z1).
del(0,A,B,C) :- del(A,B,C).

pent(1,1,1,[np,np,np,dnm,np,dnm,np]).
pent(2,1,2,[np,op,np,dnm,np,np,np]).
pent(3,1,3,[np,np,dnm,dnm,np,dnm,dnm,dnm,np,np]).
pent(4,1,4,[np,np,dnm,dnm,dnm,np,dnm,dnm,np,np]).

pent(5,2,1,[np,op,dnm,np,np,np,dnm,dnm,np]).

pent(6,3,1,[np,np,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np]).
pent(7,3,2,[np,np,np,dnm,np,dnm,dnm,dnm,np]).
pent(8,3,3,[np,dnm,op,op,np,dnm,np,np,np]).
pent(9,3,4,[np,op,op,dnm,np,op,op,dnm,np,np,np]).

pent(10,4,1,[np,op,dnm,op,np,op,dnm,np,np,np]).
pent(11,4,2,[np,op,op,dnm,np,np,np,dnm,np]).
pent(12,4,3,[np,dnm,np,np,np,dnm,dnm,dnm,np]).
pent(13,4,4,[np,np,np,dnm,dnm,np,dnm,dnm,dnm,np]).

pent(14,5,1,[np,np,dnm,np,np,np]).
pent(15,5,2,[np,np,dnm,dnm,np,np,dnm,dnm,np]).
pent(16,5,3,[np,np,op,dnm,np,np,np]).
pent(17,5,4,[np,np,dnm,dnm,np,np,dnm,dnm,dnm,np]).
pent(18,5,5,[np,np,np,dnm,np,np]).
pent(19,5,6,[np,np,np,dnm,dnm,np,np]).
pent(20,5,7,[np,dnm,dnm,dnm,np,np,dnm,dnm,np,np]).
pent(21,5,8,[np,dnm,dnm,np,np,dnm,dnm,np,np]).

pent(22,6,1,[np,dnm,op,np,np,dnm,np,np]).
pent(23,6,2,[np,op,op,dnm,np,np,op,dnm,dnm,np,np]).
pent(24,6,3,[np,np,op,dnm,dnm,np,np,dnm,dnm,dnm,np]).
pent(25,6,4,[np,np,dnm,np,np,dnm,dnm,np]).

pent(26,7,1,[np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,dnm,dnm,np,np]).
pent(27,7,2,[np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,np]).
pent(28,7,3,[np,np,dnm,dnm,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np]).
pent(29,7,4,[np,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np]).

pent(30,8,1,[np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,np,dnm,dnm,np]).
pent(31,8,2,[np,dnm,dnm,dnm,np,np,dnm,dnm,np,dnm,dnm,dnm,np]).
pent(32,8,3,[np,dnm,dnm,dnm,np,dnm,dnm,np,np,dnm,dnm,dnm,np]).
pent(33,8,4,[np,dnm,dnm,np,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np]).

pent(34,9,1,[np,np,op,dnm,dnm,np,np,dnm,dnm,np]).
pent(35,9,2,[np,dnm,np,np,np,dnm,dnm,np]).
pent(36,9,3,[np,op,op,dnm,np,np,np,dnm,dnm,np]).
pent(37,9,4,[np,np,dnm,np,np,dnm,dnm,dnm,np]).
pent(38,9,5,[np,op,dnm,np,np,op,dnm,dnm,np,np]).
pent(39,9,6,[np,op,dnm,op,np,np,dnm,np,np]).
pent(40,9,7,[np,op,dnm,np,np,np,dnm,dnm,dnm,np]).
pent(41,9,8,[np,op,dnm,np,np,np,dnm,np]).

pent(42,10,1,[np,np,dnm,op,np,dnm,dnm,np,np]).
pent(43,10,2,[np,np,op,dnm,dnm,np,op,dnm,dnm,np,np]).
pent(44,10,3,[np,op,op,dnm,np,np,np,dnm,dnm,dnm,np]).
pent(45,10,4,[np,dnm,np,np,np,dnm,np]).

pent(46,11,1,[np,dnm,dnm,dnm,np,dnm,dnm,np,np,dnm,dnm,np]).
pent(47,11,2,[np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,np,dnm,dnm,dnm,np]).
pent(48,11,3,[np,dnm,dnm,dnm,np,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np]).
pent(49,11,4,[np,dnm,dnm,np,np,dnm,dnm,np,dnm,dnm,dnm,np]).

pent(50,12,1,[np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np]).

pent(0,A,B,C) :- pent(A,B,C).

%%%%%%%%%%%% UNCHANGED CODE %%%%%%%%%%%%%%%%%%%%%%

initial_state(state(Board,[1,2,3,4,5,6,7,8,9,10,11,12],[])) :-
	gen_board(20,Board), !.

gen_board(0,[]) :- !.
gen_board(N,[no_piece,no_piece,no_piece,border|T]) :-
	N > 0,
	I is (N - 1),
	gen_board(I,T).

final_state(state(_,[],_)) :- !.

play_pent(Board,Pattern,New_Board) :-
	match(Board,Pattern,Board1),
	trim(Board1,New_Board), !.

trim([],[]) :- !.
trim([border|T],Board) :- trim(T,Board).
trim([piece|T],Board) :- trim(T,Board).
trim(Board,Board) :- Board = [no_piece|_].

match(Board,[],Board) :- !.
match([piece|Tb],[dnm|Tp],[piece|Tnb]) :-
	match(Tb,Tp,Tnb).
match([piece|Tb],[op|Tp],[piece|Tnb]) :-
	match(Tb,Tp,Tnb).
match([no_piece|Tb],[np|Tp],[piece|Tnb]) :-
	match(Tb,Tp,Tnb).
match([no_piece|Tb],[dnm|Tp],[no_piece|Tnb]) :-
	match(Tb,Tp,Tnb).
match([border|Tb],[dnm|Tp],[border|Tnb]) :-
	match(Tb,Tp,Tnb).

b_query :- solution(X), o_soln(X).

f_query :- o_follow(N), solution(N,X), o_soln(X).

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


