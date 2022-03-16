
%
% Fit pentominoes into a board
%
%  X X    X    X      X X X  X    X X    X    X    X X    X X    X    X
%  X    X X X  X        X    X X    X X  X    X      X X    X    X    X
%  X X    X    X X X    X    X X      X  X    X X    X      X X  X X  X
%                                        X X  X                    X  X
%                                                                     X
%
%  C C    X    L      T T T  6    M M    l    t      f f  Z Z    S    I
%  C    X X X  L        T    6 6    M M  l    t t  f f      Z    S    I
%  C C    X    L L L    T    6 6      M  l    t      f      Z Z  S S  I
%                                        l l  t                    S  I
%                                                                     I
%
% Board is 3 x 20, represented as a single list of atoms no_piece | piece | border
%
% Each pentomino (Piece) has a number 1..12. Pieces is an integer list.
%
% Pentominoes are defined in relation pent(Piece, Orientation, Pattern)
% where:
%     Piece is the integer labelling the pentomino
%     Orientation is an integer representing each possible rotation of the pentomino
%     Pattern 
%
% A state is represented as state(Board, Pieces, History)
% where:
%     Board is the current state of the Board as list no_piece | piece | border
%     Pieces is the integer list of remaining pieces
%     History is the list of pieces and their orientation 
%
solution(H) :-
    initial_state(Si),
    can_reach(Si,state(_,[],H)).

initial_state(state(Board,Pieces,[])) :-
    setof(P,A^B^pent(P,A,B),Pieces),
    gen_board(5,Board).

% gen_board(N, Board) will generate a board of size 4 x N
gen_board(0,[]).
gen_board(N,[np,np,np,border|T]) :-
    N > 0,
    I is (N - 1),
    gen_board(I,T).

% can_reach(State1,State2) succeeds if State2 can be reached from State1
can_reach(S1,S2) :-
    trans(S1,S2).
can_reach(S1,S2) :-
    trans(S1,S),
    can_reach(S,S2).

% transform State to New_State
%
% select(Element,List,New_list) is a builtin, succeeds if Element of List is removed in New_List.
%
trans(state(Board,Pieces,History), state(New_Board,New_Pieces,[[Piece,Orientation] | History ])) :-
    select(Piece,Pieces,New_Pieces),
    pent(Piece,Orientation,Pattern),
    play_pent(Board,Pattern,New_Board).

/*
delete(X,[X|Y],Y).
delete(X,[Y|Z], [Y|Z1]) :- delete(X,Z,Z1).
*/

% play_pent(Board, Pattern, New_board) succeeds if
% Pattern can be matched to start of Board and
% New_board is the remaining board after pattern is
% placed.
play_pent(Board,Pattern,New_Board) :-
    match(Board,Pattern,Board1),
    trim(Board1,New_Board).

% trim (Board, New_board) succeeds if New_board is
% Board with leading 'piece' and 'border' elements
% removed. I.e. New_board always starts with 'no_piece'.
trim([],[]).
trim([border|T],Board) :- trim(T,Board).
trim([p|T],Board) :- trim(T,Board).
trim([np|Board],[np|Board]).

% match(Board, Pattern, New_board) succeeds if Pattern
% can be matched (see below) to start of Board and
% New_board is the Board remaining after the match.
%
% Empty pattern => match succeeds
match(Board,[],Board).
% match succeeds if Board piece matches pattern 'dnm' | 'op'
% and rest of Board matches rest of Pattern
match([p|Tb],[dnm|Tp],[p|Tnb]) :- match(Tb,Tp,Tnb).
match([p|Tb],[p|Tp],[p|Tnb]) :- match(Tb,Tp,Tnb).
% match succeeds if Board no_piece matches pattern 'dnm' | 'np'
% and rest of Board matches rest of Pattern
match([np|Tb],[np|Tp],[p|Tnb]) :- match(Tb,Tp,Tnb).
match([np|Tb],[dnm|Tp],[np|Tnb]) :- match(Tb,Tp,Tnb).
% match succeeds if Board border matches pattern 'dnm'
% and rest of Board matches rest of Pattern
match([border|Tb],[dnm|Tp],[border|Tnb]) :- match(Tb,Tp,Tnb).

% pent(Piece, Orientation, Pattern)
%
% X X
% X  
% X X
pent('C',1,[ np, np, np,dnm, 
             np,dnm, np]).
pent('C',2,[ np,  p, np,dnm,
             np, np, np]).
pent('C',3,[ np, np,dnm,dnm,
             np,dnm,dnm,dnm, 
             np, np]).
pent('C',4,[ np, np,dnm,dnm,
            dnm, np,dnm,dnm,
             np, np]).
% X 
% X  
% X X X
pent('L',1,[ np, np, np,dnm,
           dnm,dnm, np,dnm,
           dnm,dnm, np]).
pent('L',2,[ np, np, np,dnm,
             np,dnm,dnm,dnm,
             np]).
pent('L',3,[         np,dnm,
              p,  p, np,dnm,
             np, np, np]).
pent('L',4,[ np,  p,  p,dnm,
             np,  p,  p,dnm,
             np, np, np]).
% P P
% P P 
% P
pent('P',1,[     np, np,dnm,
             np, np, np]).
pent('P',2,[     np, np,dnm,
             dnm,np, np,dnm,
             dnm,np]).
pent('P',3,[ np, np,  p,dnm,
             np, np, np]).
pent('P',4,[ np, np,dnm,dnm,
             np, np,dnm,dnm,
            dnm, np]).
pent('P',5,[ np, np, np,dnm,
             np, np]).
pent('P',6,[ np, np, np,dnm,
            dnm, np, np]).
pent('P',7,[     np,dnm,dnm,
            dnm, np, np,dnm,
            dnm, np, np]).
pent('P',8,[     np,dnm,dnm,
             np, np,dnm,dnm,
             np, np]).

