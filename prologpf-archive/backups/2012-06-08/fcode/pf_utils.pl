/**************************************************** */
/* f_utils: utility relations for function processing                      */
/**************************************************** */
% This file is needed at runtime for PrologF programs, i.e. those that define and 
% call functions.

% The file provides Prolog routines for the following main areas needed:
%
% 1. Define the 'operators' given special meaning in the functional syntax.
%     e.g. for "fun f(X) = if (X=1) then 10 else 20.
%
% 2. Defines a library of 'functions' (i.e. Prolog procedures that result from
%     the translation of functions using the PrologPF syntax) e.g. for comparison
%     operators (so we have '$fun_<'(X,Y,Result).
%
% 3. Defines an auxiliary 'if' 'function' (i.e. '$fun_aux_if') that supports the
%     form '$fun_aux_if'(Condition_Relation, Goal_if_true, Goal_if_false)
%
% 4. Defines the 'eval' function, i.e. $fun_eval(Expression,Result) which is 
%      embedded in the flattened form of the translated clause bodies.

/* function application operator - also defined in wamcc_fcode.pl */

:- op(600,yfx,@).

/* 'fun' operator, and 'if..then..else' operators */

:- op(675,fx,if).
:- op(650,xfx,then).
:- op(625,xfx,else).

:- op(1200,fx,fun).

:- public(fmangle/2).

/***************************************************************************/

:- public('$fun_='/2, '$fun_+'/2, '$fun_-'/2, '$fun_*'/2,
    '$fun_/'/2).

:- public('$fun_<'/2).
:- public('$fun_>'/2).
:- public('$fun_=<'/2).
:- public('$fun_>='/2).
:- public('$fun_=..'/2).

/***************************************************************************/

'$fun_='([X,X],true) :- !.
'$fun_='(_, false).

 '$fun_+'([X,Y],Z) :- Z is X + Y, !.
 '$fun_+'(PartArgs,lambda(RemArgs,'$fun_+'([X,Y],Z),Z)) :-
    append(PartArgs,RemArgs,[X,Y]),
    !.

'$fun_-'([X,Y],Z) :- Z is X - Y, !.
'$fun_-'(PartArgs,lambda(RemArgs,'$fun_-'([X,Y],Z),Z)) :-
    append(PartArgs,RemArgs,[X,Y]),
    !.

'$fun_*'([X,Y],Z) :- Z is X * Y, !.
'$fun_*'(PartArgs,lambda(RemArgs,'$fun_*'([X,Y],Z),Z)) :-
    append(PartArgs,RemArgs,[X,Y]),
    !.

'$fun_/'([X,Y],Z) :- Z is X // Y, !.
'$fun_/'(PartArgs,lambda(RemArgs,'$fun_/'([X,Y],Z),Z)) :-
    append(PartArgs,RemArgs,[X,Y]),
    !.

'$fun_<'([X,Y],true) :- X < Y, !.
'$fun_<'([_,_],false) :- !.
'$fun_<'(PartArgs,lambda(RemArgs,'$fun_<'([X,Y],Z),Z)) :-
    append(PartArgs,RemArgs,[X,Y]),
    !.

'$fun_>'([X,Y],true) :- X > Y, !.
'$fun_>'([_,_],false) :- !.
'$fun_>'(PartArgs,lambda(RemArgs,'$fun_>'([X,Y],Z),Z)) :-
    append(PartArgs,RemArgs,[X,Y]),
    !.

'$fun_=<'([X,Y],true) :- X =< Y, !.
'$fun_=<'([_,_],false) :- !.
'$fun_=<'(PartArgs,lambda(RemArgs,'$fun_=<'([X,Y],Z),Z)) :-
    append(PartArgs,RemArgs,[X,Y]),
    !.

'$fun_>='([X,Y],true) :- X >= Y, !.
'$fun_>='([_,_],false) :- !.
'$fun_>='(PartArgs,lambda(RemArgs,'$fun_>='([X,Y],Z),Z)) :-
    append(PartArgs,RemArgs,[X,Y]),
    !.

'$fun_=..'([X],Y) :- Y =.. X, !.
'$fun_=..'(PartArgs,lambda(RemArgs,'$fun_=..'([X],Z),Z)) :-
    append(PartArgs,RemArgs,[X]),
    !.

/************************************************/
/* If-then-else support                                                    */
/************************************************/
%
%  example:
%       fun fact(X) = if (X=1) then 1 else X*fact(X-1).
%
% which is converted pre-translation to:
%       fun(fact @ [X], if @ [ X = 1,
%                           1,
%                           '*' @ [X, fact @ [foo @ [X,1]]]
%                         ]).
%
%  transforms to:
%    $fun_fact([X],Z) :- $fun_aux_if( X = 1,
%                                Z = 1,
%                                ($fun_-([X,1],Z1),
%                                 $fun_fact([Z1],Z2),
%                                 $fun_*([X,Z2],Z))).
%
/************************************************/

:- public('$fun_aux_if'/3).

'$fun_aux_if'(R,Goal_true,_) :- 
    call(R),
    !,
    call(Goal_true).

'$fun_aux_if'(_,_,Goal_false) :- 
    call(Goal_false).

/*******************************************************/
/* Higher order programming */
/*******************************************************/
%  example:  
%     fun(plus_3 @ [X,Y,Z], sys_add @ [sys_add @ [X,Y],Z]).
%
%  transforms to:
%     fun_plus_3([X,Y,Z], A) :- sys_add([X,Y],A1), sys_add([A1,Z],A), !.
%
%     fun_plus_3(Args,lambda(Rargs, fun_plus_3([X,Y,Z],A),A)) :- 
%        append(Args,Rargs,[X,Y,Z]), !.
%
%  with the second rule generating:
%
%     fun_plus_3([X,Y], lambda([Z],fun_plus_3([X,Y,Z],A),A)), !.
%
%     fun_plus_3([X], lambda([Y,Z],fun_plus_3([X,Y,Z],A),A)), !.
%
/****************************************************/
% Function Evaluation
% Defined with the '$fun_eval'(Expression,Result) procedure
%
/****************************************************/
/* note 'fmangle/2' also used in 'wamcc_fcode.pl' */

fmangle(Func,Func1) :-
    atom_chars(Func,Fs),
    atom_chars(Func1,['$',f,u,n,'_'|Fs]).

:- public('$fun_eval'/2).

% fun eval(F@X) =   if (var(F)) 
%                                then F@X 
%                                else fail.
'$fun_eval'(F @ X, F @ X) :-     % F a variable => residuation
    var(F),
    !. 

'$fun_eval'(F @ Args, Z) :-      % F an atom => call(F...)
    atom(F),
    fmangle(F,F1),
    FCall =.. [F1,Args,Z],
    call(FCall),
    !.

'$fun_eval'(F @ G @ Args, Z) :-  % nested applications
    '$fun_eval'(F @ G, Z1),
    '$fun_eval'(Z1 @ Args, Z),
    !.

                % Lambda functions:

                % all args => call
'$fun_eval'(lambda(Args,F,Z) @ Args1, Z1) :-
    copy_term(lambda(Args,F,Z), lambda(Args1,F1,Z1)),
    call(F1),
    !.
                % length(Args2) > length(Args)
                % e.g. lambda([X],$fun_compose([append,i,X],Z),Z) @ [1,2]
'$fun_eval'(lambda(Args,F,Z) @ Args2, Z2) :-
    copy_term(lambda(Args,F,Z), lambda(Args1,F1,Z1)),          % rename
    append(Args1,RemArgs,Args2),              % match outermost args
    call(F1),
    '$fun_eval'(Z1 @ RemArgs, Z2),
    !.

                                 % too few args => return lambda func
'$fun_eval'(lambda(AllArgs,F,Z) @ ActualArgs, lambda(RemArgs,F1,Z1)) :-
    copy_term(lambda(AllArgs,F,Z), lambda(AllArgs1,F1,Z1)),
    append(ActualArgs, RemArgs, AllArgs1),
    !. 

  
