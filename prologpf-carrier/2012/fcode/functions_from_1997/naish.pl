% Higher-order logic programming in Prolog (Naish 96)

:- main([f_utils, o_utils]).

query :- true.

fun inclist([]) = [];
    inclist([X|Xs]) = [X+1|inclist(Xs)].

fun i(X) = X.

fun map(F,[])     = [];
    map(F,[X|Xs]) = [F @ [X]|map(F,Xs)].

fun filter(P,[])     = [];
    filter(P,[X|Xs]) = if (P @ [X] = true)
                       then [X|filter(P,Xs)]
                       else filter(P,Xs).

fun foldr(F,B,[])     = B;
    foldr(F,B,[X|Xs]) = F @ [X,foldr(F,B,Xs)].

fun compose(F,G,X) = F @ [G @ [X]].
 
fun converse(F,X,Y) = F @ [Y,X].

fun append(X,Y) = if append(X,Y,Z) then Z else fail.

ex(1,Z) :- Z = filter(>(5),[3,4,5,6,7]).         % Z = [3,4]
ex(2,Z) :- Z = map(+(1),[2,3,4]).                % Z = [3,4,5]
ex(3,Z) :- Z = map(between(1),[2,3]).            % non-deterministic function
ex(4,Z) :- [3,4,5] = map(+(1),Z).                % => reversible function
ex(5,Z) :- [3,4,5] = map(+(Z),[2,3,4]).          %  "
ex(6,[X,A,B]) :- [3,4,B] = map(+(X),[2,A,4]).    % "
ex(7,[X,A,B]) :- [3,4,B] = map(+(X),[A,3,4]).    % "
ex(8,Z) :- Z = foldr(append,[],[[2],[3,4],[5]]).                      % Z = [2,3,4,5]
ex(9,Z) :- Z = foldr(converse(append),[],[[2],[3,4],[5]]).            % Z = [5,3,4,2]
ex(10,Z) :- Z = compose(map(+(1)),foldr(append,[]),[[2],[3,4],[5]]).  % Z = [3,4,5,6]
ex(11,Z) :- Z = foldr(compose(append, map(+(1))),[],[[2],[3,4],[5]]). % Z = [3,4,5,6]
ex(12,Z) :- [_,F2,_] = map(+,[2,3,4]), Z = F2 @ [4].                  % Z = 7

% Further examples from "Section 7: Skeletons and techniques"

fun length([])     = 0;
    length([_|Xs]) = 1 + length(Xs).

fun sum([])     = 0;
    sum([X|Xs]) = X + sum(Xs).


fun sum_len([])     = (0,0);
    sum_len([X|Xs]) = if ((S,L) = sum_len(Xs))
                      then (S+X,L+1)
                      else fail.

fun add1(_,Y) = 1 + Y.

fun flength(X) = foldr(add1, 0, X).

fun fsum(X) = foldr(+, 0, X).

ex(13,Z) :- Z = length([a,b,c,d,e,f,g]).  % Z = 7
ex(14,Z) :- Z = sum([1,3,3]).             % Z = 7
ex(15,Z) :- Z = sum_len([1,3,3]).         % Z = (7,3)
ex(16,Z) :- Z = flength([a,b,c,d,e,f,g]). % Z = 7
ex(17,Z) :- Z = fsum([1,3,3]).            % Z = 7
