/***************************************************************************/
/* transform program into fcode                                            */
/***************************************************************************/
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

:- public prog_to_fcode/2.

/***************************************************************************/
/* transform program */

prog_to_fcode(Prog,Prog2) :-
    g_read(fcode,t),!,
    fun_decls_to_fcode(Prog,ProgFuns),
    prog_bodies_to_fcode(Prog,ProgFlat),
    append(ProgFuns, ProgFlat, Prog2).

prog_to_fcode(Prog,Prog).

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
    g_read(def_funs,Fs),
    g_assign(def_funs,[F|Fs]),              % record name of defined function
    fmangle(F, F1),                         % foo -> $fun_foo 
    set_pred_info(def,F1,2),                % specify pred_info(defined)
    set_pred_info(pub,F1,2),                % specify all funcs 'public'
    fun_decl_to_fcode1((F @ A = B; G),FGCode), % build $fun_foo clauses
    make_lambda(F @ A,LCode),                  % add $fun_foo(..lambda..)
    append(FGCode,[LCode],Code),
    !.

fun_decl_to_fcode(F @ A = B, Code) :-    % principal functor = '='
    g_read(def_funs,Fs),
    g_assign(def_funs,[F|Fs]),           % record name of defined function
    fmangle(F, F1),                      % foo -> $fun_foo 
    set_pred_info(def,F1,2),             % specify pred_info(defined)
    set_pred_info(pub,F1,2),             % specify all funcs 'public'
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
    g_read(def_funs,Fs),
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

goals_to_fcode(P,P_code) :-
    flatten_pred(P,Arg_code,P1),
    append(Arg_code, [P1], P_code_list),
    list_to_comma(P_code_list,P_code),
    !.

/***************************************************************************/

