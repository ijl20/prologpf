%
% Example fprolog program
%
% relation max(L,N) returns with N as largest element of list L, using a function.
%

% Function max2(X,Y) returns greater of X or Y
fun max2(X,Y) = if (X > Y) then X else Y.

% Function max(L) returns maximum element in list L
fun max([X]) = X;
    max([X|L]) = max2(X,max(L)).

% Relation max(L,N) succeeds if N is the maximum element in list L
max(L,N) :- N = max(L).

% The fprolog code above converts to Prolog as follows:
%
% '$fun_max2'([A,B],C) :- !, '$fun_aux_if'(A>B,C=A,C=B).
% 
% % Lambda version
% '$fun_max2'(D,lambda(E,'$fun_max2'([F,G],H),H)) :- append(D,E,[F,G]), !.
%
% '$fun_max'([[I]],I):- !.
% '$fun_max'([[I|J]],K):-!,'$fun_max'([J],L),'$fun_max2'([I,L],K).
%
% % Lambda version
% '$fun_max'(M,lambda(N,'$fun_max'([O],Q),Q)):-append(M,N,[O]),!.
%
% max(R,S):-'$fun_max'([R],T),S=T.
