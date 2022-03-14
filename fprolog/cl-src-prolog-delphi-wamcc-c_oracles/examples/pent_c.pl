
:- public f_query/0, b_query/0.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%     pentbook_cut for o_utils in 'C'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- main([o_utils_c]).

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

query :- true. % for PrologPF(PL) compatibility

:- o_bfp_c.

