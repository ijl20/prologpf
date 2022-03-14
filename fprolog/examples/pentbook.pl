
%
% Fit pentominoes into a board
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
solution(H) :-
    initial_state(Si),
    can_reach(Si,Sf),
    final_state(Sf),
    Sf = state(_,_,H).

initial_state(state(Board,[1,2,3,4,5,6,7,8,9,10,11,12],[])) :-
    gen_board(20,Board).

% gen_board(N, Board) will generate a board of size 4 x N
gen_board(0,[]).
gen_board(N,[no_piece,no_piece,no_piece,border|T]) :-
    N > 0,
    I is (N - 1),
    gen_board(I,T).

% final_state(State) succeeds when the list of remaining pieces is empty
final_state(state(_,[],_)).

can_reach(S1,S2) :-
    trans(S1,S),
    S = S2.
can_reach(S1,S2) :-
    trans(S1,S),
    can_reach(S,S2).

% transform State to New_State
%
% select(Element,List,New_list) is a builtin, succeeds if Element of List is removed in New_List.
%
trans(State,New_State) :-
    State = state(Board,Pieces,History),
    select(Piece,Pieces,New_Pieces),
    pent(Piece,Orientation,Pattern),
    play_pent(Board,Pattern,New_Board),
    New_State = state(New_Board,New_Pieces,
        [[Piece,Orientation] | History]).

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
trim([piece|T],Board) :- trim(T,Board).
trim(Board,Board) :- Board = [no_piece|_].

% match(Board, Pattern, New_board) succeeds if Pattern
% can be matched (see below) to start of Board and
% New_board is the Board remaining after the match.
%
% Empty pattern => match succeeds
match(Board,[],Board).
% match succeeds if Board piece matches pattern 'dnm' | 'op'
% and rest of Board matches rest of Pattern
match([piece|Tb],[dnm|Tp],[piece|Tnb]) :-
    match(Tb,Tp,Tnb).
match([piece|Tb],[op|Tp],[piece|Tnb]) :-
    match(Tb,Tp,Tnb).
% match succeeds if Board no_piece matches pattern 'dnm' | 'np'
% and rest of Board matches rest of Pattern
match([no_piece|Tb],[np|Tp],[piece|Tnb]) :-
    match(Tb,Tp,Tnb).
match([no_piece|Tb],[dnm|Tp],[no_piece|Tnb]) :-
    match(Tb,Tp,Tnb).
% match succeeds if Board border matches pattern 'dnm'
% and rest of Board matches rest of Pattern
match([border|Tb],[dnm|Tp],[border|Tnb]) :-
    match(Tb,Tp,Tnb).

% pent(Piece, Orientation, Pattern)
%
% X X X 
% X   X
pent(1,1,[ np, np, np,dnm, 
           np,dnm, np]).
pent(1,2,[ np, op, np,dnm,
           np, np, np]).
pent(1,3,[ np, np,dnm,dnm,
           np,dnm,dnm,dnm, 
           np, np]).
pent(1,4,[ np, np,dnm,dnm,
           dnm,np,dnm,dnm,
           np, np]).
%   X
% X X X
%   X
pent(2,1,[     np, op,dnm,
           np, np, np,dnm,
          dnm, np]).
% X X X
%     X
%     X
pent(3,1,[ np, np, np,dnm,
          dnm,dnm, np,dnm,
          dnm,dnm, np]).
pent(3,2,[np, np, np,dnm,
          np,dnm,dnm,dnm,
          np]).
pent(3,3,[        np,dnm,
          op, op, np,dnm,
          np, np, np]).
pent(3,4,[np, op, op,dnm,
          np, op, op,dnm,
          np, np, np]).
%   X
%   X
% X X X
pent(4,1,[     np, op,dnm,
           op, np, op,dnm,
           np, np, np]).
pent(4,2,[ np, op, op,dnm,
           np, np, np,dnm,
           np]).
pent(4,3,[         np,dnm,
           np, np, np,dnm,
           dnm,dnm,np]).
pent(4,4,[ np, np, np,dnm,
          dnm, np,dnm,dnm,
          dnm, np]).
%   X X
% X X X
pent(5,1,[     np, np,dnm,
           np, np, np]).
pent(5,2,[     np, np,dnm,
           dnm,np, np,dnm,
           dnm,np]).
pent(5,3,[ np, np, op,dnm,
           np, np, np]).
pent(5,4,[ np, np,dnm,dnm,
           np, np,dnm,dnm,
          dnm, np]).
pent(5,5,[ np, np, np,dnm,
           np, np]).
pent(5,6,[ np, np, np,dnm,
          dnm, np, np]).
pent(5,7,[     np,dnm,dnm,
          dnm, np, np,dnm,
          dnm, np, np]).
pent(5,8,[     np,dnm,dnm,
           np, np,dnm,dnm,
           np, np]).
%     X
%   X X
% X X
pent(6,1,[         np,dnm,
           op, np, np,dnm,
           np, np]).
pent(6,2,[ np, op, op,dnm,
           np, np, op,dnm,
          dnm, np, np]).
pent(6,3,[ np, np, op,dnm,
          dnm, np, np,dnm,
          dnm,dnm, np]).
pent(6,4,[     np, np,dnm,
           np, np,dnm,dnm,
           np]).
%   X
%   X
%   X
% X X  
pent(7,1,[     np,dnm,dnm,
          dnm, np,dnm,dnm,
          dnm, np,dnm,dnm,
           np, np]).
pent(7,2,[ np,dnm,dnm,dnm,
           np,dnm,dnm,dnm,
           np,dnm,dnm,dnm,
           np, np]).
pent(7,3,[ np, np,dnm,dnm,
           np,dnm,dnm,dnm,
           np,dnm,dnm,dnm,
           np]).
pent(7,4,[ np, np,dnm,dnm,
          dnm, np,dnm,dnm,
          dnm, np,dnm,dnm,
          dnm, np]).
% X
% X
% X X
% X
pent(8,1,[ np,dnm,dnm,dnm,
           np,dnm,dnm,dnm,
           np, np,dnm,dnm,
           np]).
pent(8,2,[ np,dnm,dnm,dnm,
           np, np,dnm,dnm,
           np,dnm,dnm,dnm,
           np]).
pent(8,3,[         np,dnm,
          dnm,dnm, np,dnm,
          dnm, np, np,dnm,
          dnm,dnm, np]).
pent(8,4,[     np,dnm,dnm,
           np, np,dnm,dnm,
          dnm, np,dnm,dnm,
          dnm, np]).
% X X
%   X X
%   X
pent(9,1,[ np, np, op,dnm,
          dnm, np, np,dnm,
          dnm, np]).
pent(9,2,[         np,dnm,
           np, np, np,dnm,
          dnm, np]).
pent(9,3,[ np, op, op,dnm,
           np, np, np,dnm,
          dnm, np]).
pent(9,4,[     np, np,dnm,
           np, np,dnm,dnm,
          dnm, np]).
pent(9,5,[     np, op,dnm,
           np, np, op,dnm,
          dnm, np, np]).
pent(9,6,[     np, op,dnm,
           op, np, np,dnm,
           np, np]).
pent(9,7,[     np, op,dnm,
           np, np, np,dnm,
          dnm,dnm, np]).
pent(9,8,[     np, op,dnm,
           np, np, np,dnm,
           np]).
%   X X
%   X
% X X
pent(10,1,[     np, np,dnm,
            op, np,dnm,dnm,
            np, np]).
pent(10,2,[ np, np, op,dnm,
           dnm, np, op,dnm,
           dnm, np, np]).
pent(10,3,[ np, op, op,dnm,
            np, np, np,dnm,
           dnm,dnm, np]).
pent(10,4,[         np,dnm,
            np, np, np,dnm,
            np]).
%     X
%     X
%   X X
%   X
pent(11,1,[         np,dnm,
           dnm,dnm, np,dnm,
           dnm, np, np,dnm,
           dnm, np]).
pent(11,2,[     np,dnm,dnm,
           dnm, np,dnm,dnm,
           dnm, np, np,dnm,
           dnm,dnm, np]).
pent(11,3,[     np,dnm,dnm,
           dnm, np, np,dnm,
           dnm,dnm, np,dnm,
           dnm,dnm, np]).
pent(11,4,[     np,dnm,dnm,
            np, np,dnm,dnm,
            np,dnm,dnm,dnm,
            np]).
% X
% X
% X
% X
% X
pent(12,1,[ np,dnm,dnm,dnm,
            np,dnm,dnm,dnm,
            np,dnm,dnm,dnm,
            np,dnm,dnm,dnm,
            np]).

