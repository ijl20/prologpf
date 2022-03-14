
format_list(List,VarInfo,OutList) :-
    format_vars(List,VarInfo,OutList),
    format_nonvars(List,VarInfo,OutList).

lookup_the_var(VarInfo,V) :- var(VarInfo), !, VarInfo = [V|_].

lookup_the_var([v(Y,Info)|_],v(X,Info)) :- X == Y, !.

lookup_the_var([_|VarInfo], V) :- lookup_the_var(VarInfo,V).

format_vars([],_,[]).

format_vars([Var|List],VarInfo,[var(Info,PremOcc)|OutList]) :-
    var(Var),
    lookup_the_var(VarInfo,v(Var,Info)),
    ( var(Info) -> Info = info('var=',Var), PremOcc = t;
                   PremOcc = f),
    format_vars(List,VarInfo,OutList),
    !.

format_vars([_|List],VarInfo,[_|OutList]) :-
    format_vars(List,VarInfo,OutList).

format_nonvars([],_,[]).

format_nonvars([Var|List],VarInfo,[_|OutList]) :-
    var(Var),
    !,
    format_nonvars(List, VarInfo, OutList).

format_nonvars([NonVar|List],VarInfo,[NonVar1|OutList]) :-
    format_nonvar(NonVar,VarInfo,NonVar1),
    format_nonvars(List,VarInfo,OutList).

format_nonvar(NonVar,VarInfo,NonVar1) :-
    NonVar =.. [Func|Args],
    format_list(Args,VarInfo,Args1),
    NonVar1 = stc(Func,Args1).


