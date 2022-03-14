% ijl20 pentominoes unify patterns with board
%
% The basic technique is we start with board as a matrix of free vars, e.g.
%
% Board = [[ _ , _ , _ ],
%          [ _ , _ , _ ],
%          [ _ , _ , _ ],
%          [ _ , _ , _ ],
%          [ _ , _ , _ ]].
% We identify the Row/Column of the first free variable (in this case 0,0)
% and unify each row of that board with the corresponding row of 
% 'select'ed Pentomino piece patterns, such as:
%         [['C','C'|_],
%          ['C', _ |_],
%          ['C','C'|_]]).
% Resulting in:
% Board = [['C','C', _ ],
%          ['C', _ , _ ],
%          ['C','C', _ ],
%          [ _ , _ , _ ],
%          [ _ , _ , _ ]].
%
% If no piece can be found that successfully unifies with the board (given the
% current free Row/Col) then the program backtracks through earlier selected
% pieces as you'd expect.
%
% e.g. pents(P) will succeed with P=['C','t','b','S','l','+'] with the actual
% atoms derived from the pent(name,Pattern) clause at the end of this code.
%
%  C C    +    L      T T T  b    M M    l    t      f f  Z Z    S    I
%  C    + + +  L        T    b b    M M  l    t t  f f      Z    S    I
%  C C    +    L L L    T    b b      M  l    t      f      Z Z  S S  I
%                                        l l  t                    S  I
%                                                                     I
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Collect the pentomino patterns %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% pents(P) succeeds with P as list of unique Piece id's.
pents(P) :- setof(Pent,Pattern^pent(Pent,Pattern),P).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create the board             %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% board(Rows,Cols,Board) succeeds with Board as a list of Rows lists of Cols free vars.
% e.g. board(5,3,Board) succeeds with
% Board = [[_,_,_],
%          [_,_,_],
%          [_,_,_],
%          [_,_,_],
%          [_,_,_]].
board(0,_,[]).
board(Rows,Cols,[Row|Board]) :- 
    Rows > 0,
    board_row(Cols,Row),
    Rem_rows is Rows-1,
    board(Rem_rows, Cols, Board).

% board_row(Cols,Board_row) builds a simple list of Col free vars.
board_row(0,[]).
board_row(Cols,[_|Row]) :- 
    Cols > 0,
    Rem_cols is Cols-1,
    board_row(Rem_cols,Row).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Place pieces on board %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% place_row_col(Pattern,Board,Row,Col)
% Succeeds if can place (i.e. unify) a 'Piece Pattern' on the Board with first 'empty' cell (i.e.
% a free variable) at Row,Col within Board.
place_row_col([],_,0,_).
place_row_col([P|Ps],[B|Bs],0,Col) :- place_row(P,B,Col), place_row_col(Ps,Bs,0,Col).
place_row_col(P,[_|Bs],Row,Col) :- Row > 0, NextRow is Row-1, place_row_col(P,Bs,NextRow,Col).

% place_row(Pattern_row,Board_row,Col)
% Succeeds if Pattern_row can be unified with Board_row from column Col
%place_row(P,P1,0) :- append(P,_,P1).
place_row(P,P,0).
place_row(P,[_|Bs],Col) :- Col > 0, NextCol is Col-1, place_row(P,Bs,NextCol).

% free_row_col(Board,Row,Column)
% Succeeds if first free variable on the Board is at indexes Row, Column
free_row_col([B|_],0,Col) :- free_col(B,Col), !.
free_row_col([_|Bs],Row,Col) :- free_row_col(Bs,R,Col), Row is R + 1.

% free_col(Board_row,Col)
% Succeeds if first free variable in the Board_row is at index Col
free_col([B|_],0) :- \+ atom(B), !.
free_col([_|Bs],Col) :- free_col(Bs,C), Col is C + 1.

% offset(P, N) succeeds if first occupied cell of pattern P row 0 is at index N.
offset([R|_],Offset) :- row_offset(R,Offset).

row_offset([P|_],0) :- atom(P).
row_offset([X|P],Offset) :- \+ atom(X), row_offset(P,N), Offset is N+1.

% place(Pieces,Board) succeeds if we can fill Board with unique Pieces
place([Piece|Pieces],Board) :- 
    free_row_col(Board,Free_row,Free_col), 
    select(Pn,[Piece|Pieces],Rem_pieces),
    pent(Pn,Pattern),
    offset(Pattern,Offset),
    Col is Free_col-Offset,
    Col >= 0,
    place_row_col(Pattern,Board,Free_row,Col), 
    %    ( place(Rem_pieces,Board) -> true ; print_board(Board), nl, fail ).
    place(Rem_pieces,Board).
% Ultimate success condition is there are no free cells left in Board
% Note an alternative success condition can be
% place([],_). i.e. we have placed ALL the pieces - this is only suitable for
% board sizes exactly the same number of cells as covered by all the pieces (i.e. 60)
place(_,Board) :- \+ free_row_col(Board,_,_).

print_board([Board_row|Board_rows]) :-
    print_board_row(Board_row),
    print_board(Board_rows).
print_board([]).

print_board_row([Cell|Cells]) :- print_cell(Cell), print_board_row(Cells).
print_board_row([]) :- nl.

print_cell(C) :- atom(C), print(' '), print(C).
print_cell(C) :- \+ atom(C), print(' '), print('_').

solution(Board) :- solution(6,10,Board).

solution(Rows,Cols,Board) :-
    board(Rows,Cols,Board),
    pents(Pents),
    place(Pents,Board),
    print_board(Board),nl.

% Pentomino pieces
% C + L T b S l t M f Z I
%

pent('C',[['C','C'|_],
          ['C', _ |_],
          ['C','C'|_]]).

pent('C',[['C','C'|_],
          [ _ ,'C'|_],
          ['C','C'|_]]).

pent('C',[['C','C','C'|_],
          ['C', _ ,'C'|_]]).

pent('C',[['C', _ ,'C'|_],
          ['C','C','C'|_]]).

pent('t',[[ _ ,'t'|_],
          ['t','t'|_],
          [ _ ,'t'|_],
          [ _ ,'t'|_]]).

pent('t',[[ _ ,'t'|_],
          [ _ ,'t'|_],
          ['t','t'|_],
          [ _ ,'t'|_]]).

pent('t',[['t'|_],
          ['t','t'|_],
          ['t'|_],
          ['t'|_]]).

pent('t',[['t'|_],
          ['t'|_],
          ['t','t'|_],
          ['t'|_]]).

pent('t',[['t','t','t','t'|_],
          [ _ ,'t'|_]]).

pent('t',[['t','t','t','t'|_],
          [ _ , _ ,'t'|_]]).

pent('t',[[ _ ,'t'|_],
          ['t','t','t','t'|_]]).

pent('t',[[ _ , _ ,'t'|_],
          ['t','t','t','t'|_]]).

pent('l',[['l','l','l','l'|_],
          ['l'|_]]).

pent('l',[['l','l','l','l'|_],
          [ _ , _ , _ ,'l'|_]]).

pent('l',[['l'|_],
          ['l','l','l','l'|_]]).

pent('l',[[ _ , _ , _ ,'l'|_],
          ['l','l','l','l'|_]]).

pent('l',[['l'|_],
          ['l'|_],
          ['l'|_],
          ['l','l'|_]]).

pent('l',[['l','l'|_],
          ['l'|_],
          ['l'|_],
          ['l'|_]]).

pent('l',[[ _ ,'l'|_],
          [ _ ,'l'|_],
          [ _ ,'l'|_],
          ['l','l'|_]]).

pent('l',[['l','l'|_],
          [ _ ,'l'|_],
          [ _ ,'l'|_],
          [ _ ,'l'|_]]).

pent('b',[['b','b'|_],
          ['b','b','b'|_]]).

pent('b',[[ _ ,'b','b'|_],
          ['b','b','b'|_]]).

pent('b',[['b','b','b'|_],
          ['b','b'|_]]).

pent('b',[['b','b','b'|_],
          [ _ ,'b','b'|_]]).

pent('b',[['b'|_],
          ['b','b'|_],
          ['b','b'|_]]).

pent('b',[[ _ ,'b'|_],
          ['b','b'|_],
          ['b','b'|_]]).

pent('b',[['b','b'|_],
          ['b','b'|_],
          ['b'|_]]).

pent('b',[['b','b'|_],
          ['b','b'|_],
          [ _ ,'b'|_]]).

pent('S',[[ _ ,'S'|_],
          ['S','S'|_],
          ['S'|_],
          ['S'|_]]).

pent('S',[['S', _ |_],
          ['S','S'|_],
          [ _ ,'S'|_],
          [ _ ,'S'|_]]).

pent('S',[[ _ ,'S'|_],
          [ _ ,'S'|_],
          ['S','S'|_],
          ['S'|_]]).

pent('S',[['S'|_],
          ['S'|_],
          ['S','S'|_],
          [ _ ,'S'|_]]).

pent('S',[['S','S','S'|_],
          [ _ , _ ,'S','S'|_]]).

pent('S',[[ _ ,'S','S','S'|_],
          ['S','S'|_]]).

pent('S',[['S','S'|_],
          [ _ ,'S','S','S'|_]]).

pent('S',[[ _ , _ ,'S','S'|_],
          ['S','S','S'|_]]).

pent('+',[[ _ ,'+', _ |_],
          ['+','+','+'|_],
          [ _ ,'+'|_]]).

pent('L',[['L'|_],
          ['L'|_],
          ['L','L','L'|_]]).

pent('L',[['L','L','L'|_],
          ['L'|_],
          ['L'|_]]).

pent('L',[['L','L','L'|_],
          [ _ , _ ,'L'|_],
          [ _ , _ ,'L'|_]]).

pent('L',[[ _ , _ ,'L'|_],
          [ _ , _ ,'L'|_],
          ['L','L','L'|_]]).

pent('T',[[ _ ,'T'|_],
          [ _ ,'T'|_],
          ['T','T','T'|_]]).

pent('T',[['T'|_],
          ['T','T','T'|_],
          ['T'|_]]).

pent('T',[['T','T','T'|_],
          [ _ ,'T'|_],
          [ _ ,'T'|_]]).

pent('T',[[ _ , _ ,'T'|_],
          ['T','T','T'|_],
          [ _ , _ ,'T'|_]]).

pent('M',[['M','M'|_],
          [ _ ,'M','M'|_],
          [ _ , _ ,'M'|_]]).

pent('M',[[ _ , _ ,'M'|_],
          [ _ ,'M','M'|_],
          ['M','M'|_]]).

pent('M',[['M'|_],
          ['M','M'|_],
          [ _ ,'M','M'|_]]).

pent('M',[[ _ ,'M','M'|_],
          ['M','M'|_],
          ['M'|_]]).

pent('f',[[ _ ,'f'|_],
          [ _ ,'f','f'|_],
          ['f','f'|_]]).

pent('f',[['f'|_],
          ['f','f','f'|_],
          [ _ ,'f'|_]]).

pent('f',[[ _ ,'f','f'|_],
          ['f','f'|_],
          [ _ ,'f'|_]]).

pent('f',[[ _ ,'f'|_],
          ['f','f','f'|_],
          [ _ , _ ,'f'|_]]).

pent('f',[[ _ ,'f'|_],
          ['f','f'|_],
          [ _ ,'f','f'|_]]).

pent('f',[[ _ , _ ,'f'|_],
          ['f','f','f'|_],
          [ _ ,'f'|_]]).

pent('f',[['f','f'|_],
          [ _ ,'f','f'|_],
          [ _ ,'f'|_]]).

pent('f',[[ _ ,'f'|_],
          ['f','f','f'|_],
          ['f'|_]]).

pent('Z',[[ _ ,'Z','Z'|_],
          [ _ ,'Z'|_],
          ['Z','Z'|_]]).

pent('Z',[['Z'|_],
          ['Z','Z','Z'|_],
          [ _ , _ ,'Z'|_]]).

pent('Z',[['Z','Z'|_],
          [ _ ,'Z'|_],
          [ _ ,'Z','Z'|_]]).

pent('Z',[[ _ , _ ,'Z'|_],
          ['Z','Z','Z'|_],
          ['Z'|_]]).

pent('I',[['I','I','I','I','I'|_]]).

pent('I',[['I'|_],
          ['I'|_],
          ['I'|_],
          ['I'|_],
          ['I'|_]]).

