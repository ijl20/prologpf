:- dynamic compiler_name/1.

main.
main(_).
main(_,_).


compiler_name(wamcc).
wam_version('2.21').
wam_year(1994).


halt(S):-
	(unix(argv([])) -> (S==0 -> true ; abort)
                        ;  unix(exit(S))).


halt_or_else(S,P):-
	(unix(argv([])) -> call(P)
                        ;  unix(exit(S))).



append([],L,L).

append([X|L1],L2,[X|L3]):-
	append(L1,L2,L3).




member(X,[H|T]):-
	X=H ; member(X,T).



formata(A,L):-
	name(A,S),
	format(S,L).





/* from const.pl */


atom_length(A,L):-
	name(A,S),
	length(S,L).




atom_concat(A1,A2,A3):-
	(nonvar(A1) -> atom_codes(A1,LCodeA1) ; true),
	(nonvar(A2) -> atom_codes(A2,LCodeA2) ; true),
	(nonvar(A3) -> atom_codes(A3,LCodeA3) ; true),
        append(LCodeA1,LCodeA2,LCodeA3),
        atom_codes(A1,LCodeA1),
        atom_codes(A2,LCodeA2),
        atom_codes(A3,LCodeA3).




sub_atom(A,S,L,A1):-
        atom_codes(A,LCodeA),
        atom_length(A,N),
        (integer(S) -> true
                    ;  list_i_j(1,N,SL), member(S,SL)),
        NX0 is S-1,
        (integer(L) -> true
                    ;
                       MaxL is N-NX0,
                       list_i_j(0,MaxL,LL), member(L,LL)),
        length(LCodeA1,L),
        length(X0,NX0),
        NX2 is N-L-NX0,
        length(X2,NX2),
        append(X1,X2,LCodeA),
        append(X0,LCodeA1,X1),
        atom_codes(A1,LCodeA1).




list_i_j(I,J,L):-
        (I>J -> L=[]
              ;
                 I1 is I+1,
                 L=[I|L1],
                 list_i_j(I1,J,L1)).




char_code(Char,Code):-
        name(Char,[Code]).




number_atom(N,A):-
	(number(N) -> number_chars(N,LCode),
	              atom_chars(A,LCode)
                   ;
                      atom_chars(A,LCode),
		      number_chars(N,LCode)).


atom_codes(A,LCode):-
	atom_chars(A,LCode).





chars_codes([],[]).

chars_codes([Char|LChar],[Code|LCode]):-
        char_code(Char,Code),
        chars_codes(LChar,LCode).




number_codes(N,LCode):-
	number_chars(N,LCode).





/* g_vars */

:- dynamic gvar/2.

g_assign(Var,Value):-
	(retract(gvar(Var,_)) ; true),
	!,
	asserta(gvar(Var,Value)).

g_read(Var,Value):-
	(gvar(Var,Value1) ; Value1=0),
	!,
        Value=Value1.





gensym(X):-
        gensym('$sym',X).



gensym(Prefix,X):-
        g_read(Prefix,Count),
        Count1 is Count+1,
        g_assign(Prefix,Count1),
        number_atom(Count,X1),
        atom_concat(Prefix,X1,X).
