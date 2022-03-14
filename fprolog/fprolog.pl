  
/***************************************************************************/
/* f_utils: utility relations for function processing                      */
/***************************************************************************/

% 2019-03-05 syntax fixes for swipl
% 2018-07-25 syntax fixes for gprolog
% 1997-06-05 original file from ijl20 PhD - designed to work with wamcc Prolog  compiler

/* function application operator - also defined in wamcc_fcode.pl */

:- op(600,yfx,@).

/* 'fun' operator, and 'if..then..else' operators */

:- op(675,fx,if).
:- op(650,xfx,then).
:- op(625,xfx,else).

:- op(1200,fx,fun).

:- public(fmangle/2).

/***************************************************************************/
/* GLOBAL: def_fun: used to record functor status as defined function      */
/*                  used in wamcc_fcode                                    */

:- initialization(assign_global_var(def_funs, [=,+,-,*,/,<,>,=<,>=,=..,if])).

/***************************************************************************/
/* Utility functions                                                       */
/***************************************************************************/

%
% Read/Write global variables, gprolog and swipl compatible
%
% Global var 'Atom' is set to value 'Value'
assign_global_var(Atom,Value) :- /* if */ current_predicate(nb_setval/_) ->
                                 /* then */ nb_setval(Atom,Value);
                                 /* else */ g_assign(Atom,Value).

% Value of global var 'Atom' is read into Value
read_global_var(Atom,Value) :- /* if */ current_predicate(nb_setval/_) ->
                                 /* then */ nb_getval(Atom,Value);
                                 /* else */ g_read(Atom,Value).

%
% Read a file 'Filename' which contains an fprolog program, into list Prog
%
read_fprolog_file(Filename,Prog) :- open(Filename,read,Stream), 
                                    read_fprolog_stream(Stream,Prog), 
                                    close(Stream).

% Utility relation used by read_fprolog_file, which reads fprolog code from
% stream.
read_fprolog_stream(Stream,[X|L]) :- read(Stream,X), 
                                     ( /* if */ at_end_of_stream(Stream) -> 
                                       /* then */ L = [] ; 
                                       /* else */ read_fprolog_stream(Stream,L)
                                     ).

% Utility relation, assert all clauses of an fprolog program, in order.
assert_list([]).
assert_list([X|L]) :- assertz(X), assert_list(L).

%
% Consult an fprolog file
%
fconsult(Filename) :- read_fprolog_file(Filename, Prog),
                      % Prog contains the code as a list of Prolog clauses
                      % Now we convert the function definitions to relations
                      % and flatten clause bodies containing function calls
                      % into the equivalent preceding relational calls.
                      prog_to_fcode(Prog, Fcode),
                      % And finally we assert the resulting Prolog clauses
                      % into the database.
                      assert_list(Fcode).

/***************************************************************************/

:- public( [ '$fun_='/2, 
             '$fun_+'/2, 
             '$fun_-'/2, 
             '$fun_*'/2,
             '$fun_/'/2,
             '$fun_<'/2,
             '$fun_>'/2,
             '$fun_=<'/2,
             '$fun_>='/2,
             '$fun_=..'/2 ]).

/***************************************************************************/
/* Various pre-defined functions in fprolog relational format              */

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

/***************************************************************************/
/* If-then-else support                                                    */
/***************************************************************************/
%
%  example:
%    fun(fact @ [X], if @ [ X = 1,
%                           1,
%                           '*' @ [X, fact @ [foo @ [X,1]]]
%                         ]).
%  transforms to:
%    fact([X],Z) :- $fun_aux_if( X = 1,
%                                Z = 1,
%                                ($fun_-([X,1],Z1),
%                                 $fun_fact([Z1],Z2),
%                                 $fun_*([X,Z2],Z))).
%
/***************************************************************************/

:- public('$fun_aux_if'/3).

'$fun_aux_if'(R,Goal_true,_) :- 
    call(R),
    !,
    call(Goal_true).

'$fun_aux_if'(_,_,Goal_false) :- 
    call(Goal_false).

/***************************************************************************/
/* Higher order programming */
/***************************************************************************/
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
/***************************************************************************/

/***************************************************************************/
/* note 'fmangle/2' also used in 'wamcc_fcode.pl' */

fmangle(Func,Func1) :-
    atom_chars(Func,Fs),
    atom_chars(Func1,['$',f,u,n,'_'|Fs]).

:- public('$fun_eval'/2).

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



  
/***************************************************************************/
/* transform program into fcode                                            */
/***************************************************************************/

% 2018-07-25 syntax fixes for gprolog
% 1997-06-05 original 'wamcc' version from ijl20 PhD

/* prog_to_fcode(ProgIn, ProgOut) */
/* prog is represented as list of clauses */

/* note operators @, fun, if, then, else defined in f_utils.pl,            */
/* which is loaded earlier in 'wamcc.pl'                                   */

/**************************************************************/
/* GLOBALS: */
%   def_funs: list of names of defined functions             
%             set to initial value in directive in f_utils.pl 

/**************************************************************/
/* modification to user code: */
/**************************************************************/
%
%   example (function definition):
%      fun(foo @ [X,Y,Z], Expr).
%
%   transforms to:
%      :- public $fun_foo/2.
%
%      $fun_foo([X,Y,Z], A) :- flattened Expr with result in A.
%
%      $fun_foo(Args,lambda(Rargs, foo([X,Y,Z],A),A)) :-
%                               append(Args,Rargs,[X,Y,Z]), !.
%
%   example (function call):
%      bah(X) :- poo(foo @ [X]).
%
%   transforms to:
%      bah(X) :- $fun_foo([X],Z), poo(Z).
%
/**************************************************************/

:- public(prog_to_fcode/2).

/***************************************************************************/
/* transform program */

prog_to_fcode(Prog,Prog2) :-
    fun_decls_to_fcode(Prog,ProgFuns),
    prog_bodies_to_fcode(Prog,ProgFlat),
    append(ProgFuns, ProgFlat, Prog2).

%prog_to_fcode(Prog,Prog).

/* transform all function declarations */

fun_decls_to_fcode([fun(F)|Prog], Prog2) :-
    fun_decl_to_fcode(F,Fcode), !,
    fun_decls_to_fcode(Prog,Prog1),
    append(Fcode,Prog1,Prog2).

fun_decls_to_fcode([_|Prog],Prog1) :-
    fun_decls_to_fcode(Prog,Prog1).

fun_decls_to_fcode([],[]).

%fmangle(X,Y) :-        /* version for SWI prolog, main version in f_utils */
%    name(X,Ascii_X),
%    string_to_list('$fun_', Ascii_prefix),
%    append(Ascii_prefix,Ascii_X,Ascii_Y),
%    name(Y,Ascii_Y).

/***************************************************************************/
/* transform function declaration */

% Note "p :- ..., !, ..." will be "p :- $get_bc_reg(X), ..., $cut(X), ..."
% after 'sucre_syntaxique' pass transforms cuts

% function declaration is of the form:
%
% fun foo(Args1) = Function_term1 ;
%     foo(Args2) = Function_term2 ;
%      ...
%     .

fun_decl_to_fcode((F @ A = B; G),Code) :-   % principal functor = ';'
    read_global_var(def_funs,Fs),
    assign_global_var(def_funs,[F|Fs]),              % record name of defined function
    %    fmangle(F, F1),                         % foo -> $fun_foo 
    %    set_pred_info(def,F1,2),                % specify pred_info(defined)
    %    set_pred_info(pub,F1,2),                % specify all funcs 'public'
    fun_decl_to_fcode1((F @ A = B; G),FGCode), % build $fun_foo clauses
    make_lambda(F @ A,LCode),                  % add $fun_foo(..lambda..)
    append(FGCode,[LCode],Code),
    !.

fun_decl_to_fcode(F @ A = B, Code) :-    % principal functor = '='
    read_global_var(def_funs,Fs),
    assign_global_var(def_funs,[F|Fs]),           % record name of defined function
    % fmangle(F, F1),                      % foo -> $fun_foo 
    % set_pred_info(def,F1,2),             % specify pred_info(defined)
    % set_pred_info(pub,F1,2),             % specify all funcs 'public'
    fun_decl_to_fcode1(F @ A = B,FCode), % FCode = $fun_foo(..) :- ...
    make_lambda(F @ A, LCode),           % LCode = $fun_foo(..lambda..) :- ...
    append(FCode,[LCode],Code),
    !.

fun_decl_to_fcode( (F = B; G), Code) :-  % alternate syntax w/';'
    F =.. [Func|Args],
    fun_decl_to_fcode((Func @ Args = B; G), Code),
    !.

fun_decl_to_fcode( F = B, Code) :-       % alternate syntax
    F =.. [Func|Args],
    fun_decl_to_fcode(Func @ Args = B, Code),
    !.

fun_decl_to_fcode1(Func @ Args = Func_body, [Code]) :- %principal functor = '='
    fmangle(Func, Func1),                   % foo -> $fun_foo 
    flatten_term(Func_body, Code_body, Z),  % flatten func body
    Code_head =.. [Func1,Args,Z],
    func_rule(Code_head,Code_body,Code),    % build clause
    !.

fun_decl_to_fcode1((F;G),Code) :-
    fun_decl_to_fcode1(F,FCode),
    fun_decl_to_fcode1(G,GCode),
    append(FCode,GCode,Code),
    !.

fun_decl_to_fcode1(Func = Func_body, Code) :-   % alternate syntax foo(X) = ...
    Func =.. [Fname | Args],
    fun_decl_to_fcode1(Fname @ Args = Func_body, Code),
    !.

make_lambda(Func @ Args, Code) :- 
    fmangle(Func, Func1),                   % foo -> $fun_foo
    args_to_var_list(Args,ArgVars),         % [X,1,2] -> X,Y,Z
    F_head =.. [Func1,ArgVars,Z] ,
    L_head =.. [Func1, PartArgs, lambda(Rargs,F_head,Z)],
    Code = (L_head :- append(PartArgs,Rargs,ArgVars), 
                      '!'),                 % build lambda clause
    !.

args_to_var_list([],[]).       % convert any list of args to a list of vars

args_to_var_list([_|A],[_|V]) :-
    args_to_var_list(A,V),
    !.

/***************************************************************************/
/* build rule for function */

% as above, cut (!) will be transformed to $get_bc_reg, $cut.

func_rule(Head, Code, (Head :- Codes)) :-
    list_to_comma(['!'|Code], Codes).

/***************************************************************************/
/* convert [pred,pred,pred] to (pred,pred,pred) */

list_to_comma([Code], Code) :- !.

list_to_comma([Code1|Code], (Code1,Codes)) :-
    list_to_comma(Code,Codes).

/***************************************************************************/
/* flatten_term(Term, Flat_code, New_term, Result_var)                     */

flatten_term(A, [], A) :- var(A), !.               /* variable */

flatten_term(fail,[fail],fail) :- !.               /* fail */

flatten_term(A, [], A) :- atomic(A), !.            /* constant or func/0 */

% flatten_term([], [], []) :- !.                   /* nil */

flatten_term(if(then(Cond,else(A,B))), Code, Z) :- /* if syntax 1 */
    flatten_term((if) @ [Cond,A,B], Code, Z),
    !.

flatten_term((if) @ [Cond,A,B], Code, Z) :-          /* if syntax 2 */
    fmangle(aux_if,Func_aux_if),
    flatten_pred(Cond, Cond_code, New_cond),
    flatten_term(A,A_code_list1,ZA),
    append(A_code_list1,[Z=ZA],A_code_list2),
    list_to_comma(A_code_list2, A_code),
    flatten_term(B,B_code_list1,ZB),
    append(B_code_list1,[Z=ZB],B_code_list2),
    list_to_comma(B_code_list2, B_code),
    AuxIfPred =.. [Func_aux_if, New_cond, A_code, B_code],
    append(Cond_code, [AuxIfPred], Code),
    !.

flatten_term(Func @ Args, Code, Z) :-            /* compiled function */
    atom(Func),
    fmangle(Func, Func1),
    flatten_term(Args, Arg_code, New_args),
    New_func =.. [Func1, New_args, Z],
    append(Arg_code, [New_func], Code),
    !.

flatten_term(Func @ Args, Code, Z) :-            /* variable function */
    var(Func),
    flatten_term(Args, Arg_code, New_args),
    append(Arg_code, ['$fun_eval'(Func @ New_args, Z)], Code),
    !.

flatten_term(Func @ Args, Code, Z) :-            /* higher-order function */
    flatten_term(Func, Func_code, F1),
    flatten_term(Args, Arg_code, New_args),
    append(Func_code, Arg_code, Code1),
    append(Code1, ['$fun_eval'(F1 @ New_args, Z)], Code),
    !.

flatten_term([Arg|Args], Code, [New_arg|New_args]) :-         /* list */
    flatten_term(Arg, Code1, New_arg),
    flatten_term(Args, Code2, New_args),
    append(Code1, Code2, Code),
    !.

flatten_term(Compound_term, Arg_code, Z) :-      /* alternate syntax */
    Compound_term =.. [Func|Args],
    read_global_var(def_funs,Fs),
    member(Func,Fs),                      % check Func a defined function
    flatten_term(Func @ Args, Arg_code, Z),
    !.

flatten_term(Constructor_term, Arg_code, New_constructor) :- /* constructor */
    Constructor_term =.. [Func|Args],
    flatten_term(Args, Arg_code, Z),
    New_constructor =.. [Func|Z],
    !.

/***************************************************************************/
/* flatten predicate - treated as constructor*/

flatten_pred(Pred_term, [], Pred_term) :-
    var(Pred_term),
    !.
    
flatten_pred((P,Q), [], (P3,Q3)) :-
    flatten_pred(P,Pcode,P1),
    append(Pcode,[P1],P2),
    list_to_comma(P2,P3),
    flatten_pred(Q,Qcode,Q1),
    append(Qcode,[Q1],Q2),
    list_to_comma(Q2,Q3),
    !.

flatten_pred((P;Q), [], (P3;Q3)) :-
    flatten_pred(P,Pcode,P1),
    append(Pcode,[P1],P2),
    list_to_comma(P2,P3),
    flatten_pred(Q,Qcode,Q1),
    append(Qcode,[Q1],Q2),
    list_to_comma(Q2,Q3),
    !.

flatten_pred(Pred_term, Arg_code, New_pred) :-
    Pred_term =.. [Func|Args],
    flatten_term(Args, Arg_code, Z),
    New_pred =.. [Func|Z].

/***************************************************************************/
/* transform all clause bodies */

prog_bodies_to_fcode([(H :- B)|Prog],[(H :- B1)|Prog1]) :-        /* rules */
    goals_to_fcode(B,B1),
    !,
    prog_bodies_to_fcode(Prog,Prog1).

prog_bodies_to_fcode([Cl|Prog],Prog1) :-                      /* drop funs */
    functor(Cl,(fun),_),
    !,
    prog_bodies_to_fcode(Prog,Prog1).

prog_bodies_to_fcode([Cl|Prog],[Cl|Prog1]) :-                /* skip facts */
    !,
    prog_bodies_to_fcode(Prog,Prog1).

prog_bodies_to_fcode([],[]).

/**************************************************************************/

goals_to_fcode((P,Q),(P1,Q1)) :-
    goals_to_fcode(P,P1),
    goals_to_fcode(Q,Q1),
    !.

goals_to_fcode((P;Q),(P1;Q1)) :-
    goals_to_fcode(P,P1),
    goals_to_fcode(Q,Q1),
    !.

goals_to_fcode((P->Q),(P1->Q1)) :-
    goals_to_fcode(P,P1),
    goals_to_fcode(Q,Q1),
    !.

goals_to_fcode(P,P_code) :-
    flatten_pred(P,Arg_code,P1),
    append(Arg_code, [P1], P_code_list),
    list_to_comma(P_code_list,P_code),
    !.

/***************************************************************************/

