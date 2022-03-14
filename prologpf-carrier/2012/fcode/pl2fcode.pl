/************************************************************************* */
/* transform program into fcode                                            */
/************************************************************************* */
/* prog_to_fcode(ProgIn, ProgOut) */
/* prog is represented as list of clauses */

/* note operators @, fun, if, then, else defined in f_utils.pl,            */
/* which is loaded earlier in 'wamcc.pl'                                   */

/************************************************************ */
/* GLOBALS: */
%   def_funs: list of names of defined functions             
%             set to initial value in directive in f_utils.pl 

/************************************************************ */
/* modification to user code: */
/************************************************************ */
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
/************************************************************ */

:- public(prog_to_fcode/2).

/************************************************************************* */
/* transform program */

prog_to_fcode(Prog,Prog2) :-
    g_read(fcode,t),!,                  % fcode is a flag used to enable fcode processing (set in f_utils.pl or in options)
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

/************************************************************************* */
/* transform function declaration */

% Note "p :- ..., !, ..." will be "p :- $get_bc_reg(X), ..., $cut(X), ..."
% after 'sucre_syntaxique' pass transforms cuts

% function declaration is of the form:
%
% fun foo(Args1) = Function_term1 ;
%     foo(Args2) = Function_term2 ;
%      ...
%     .
/************************************************************************** */
/* GLOBAL: def_fun: used to record functor status as defined function      */
/*                  used in wamcc_fcode                                    */

f_code_init :- 
    g_assign(def_funs, [=,+,-,*,/,<,>,=<,>=,=..,if]),
    g_assign(fcode,t).

/************************************************************************** */
% Function definitions with alternates using '@'(separated by ';') e.g.
% fun f @ [a] = 1;
%     f @ [b] = 2.
% Given the PrologPF operator precedence (see pf_utils.pl), this function is
% equivalent to
% fun(;(=(@(f,[a]),1),=(@(f,[b]),2)))
% Note that these 'fun' terms have an argument with a principal functor of ';'
/************************************************************************** */

fun_decl_to_fcode((F @ A = B; G),Code) :-   % principal functor = ';'
    g_read(def_funs,Fs),
    g_assign(def_funs,[F|Fs]),              % record name of defined function
    % fmangle(F, F1),                         % foo -> $fun_foo 
    % set_pred_info(def,F1,2),                % specify pred_info(defined)
    % set_pred_info(pub,F1,2),                % specify all funcs 'public'
    fun_decl_to_fcode1((F @ A = B; G),FGCode), % build $fun_foo clauses
    make_lambda(F @ A,LCode),                  % add $fun_foo(..lambda..)
    append(FGCode,[LCode],Code),
    !.

/************************************************************************** */
% Single function definitions using '@' e.g.
% fun f @ [X] = 1.
% equivalent to fun(=(@(f,[X]),1))
/************************************************************************** */

fun_decl_to_fcode(F @ A = B, Code) :-    % principal functor = '='
    g_read(def_funs,Fs),
    g_assign(def_funs,[F|Fs]),           % record name of defined function
    % fmangle(F, F1),                      % foo -> $fun_foo 
    % set_pred_info(def,F1,2),             % specify pred_info(defined)
    % set_pred_info(pub,F1,2),             % specify all funcs 'public'
    fun_decl_to_fcode1(F @ A = B,FCode), % FCode = $fun_foo(..) :- ...
    make_lambda(F @ A, LCode),           % LCode = $fun_foo(..lambda..) :- ...
    append(FCode,[LCode],Code),
    !.

/************************************************************************** */
% Syntactic sugaring for function definitions as fun f(Args) = Expression, e.g.
% fun f(a) = 1;
%     f(b) = 2.
% converted to fun f @ [a] = 1; f @ [b] = 2. 
% parsed as fun(;(=(f(a),1),=(f(b),2))
/************************************************************************** */

fun_decl_to_fcode( (F = B; G), Code) :-  % principal functor ';' i.e. alternates
    F =.. [Func|Args],
    fun_decl_to_fcode((Func @ Args = B; G), Code),
    !.

fun_decl_to_fcode( F = B, Code) :-       % f(X) = B, convert to f @ [X] = B
    F =.. [Func|Args],
    fun_decl_to_fcode(Func @ Args = B, Code),
    !.

/******************************************************************************* */
% translate the function equalities

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

/*************************************************************************** */
% Each function relation ALSO has a lamba equivalent e.g.
% fun f(X,Y) = X + Y.
% -> '$fun_f'([X, Y], Result) :- 
%          !, 
%          '$fun_+'([X, Y], Result)
% and also 
% -> '$fun_f'(PartArgs, lambda(Rargs, '$fun_f'([X,Y], Z), Z)) :- 
%          append(PartArgs, Rargs, [X,Y]),
%          !.
% If both arguments are provided, then the first rule matches.
% Otherwise, the second rule is used, returning a lambda term.

make_lambda(Func @ Args, Code) :- 
    fmangle(Func, Func1),                   % foo -> $fun_foo
    args_to_var_list(Args,ArgVars),         % [X,1,2] -> X,Y,Z
    F_head =.. [Func1,ArgVars,Z] ,
    L_head =.. [Func1, PartArgs, lambda(Rargs,F_head,Z)],
    Code = (L_head :- append(PartArgs,Rargs,ArgVars), 
                      '!'),                 % build lambda clause
    !.

/************************************************************************ */

args_to_var_list([],[]).       % convert any list of args to a list of vars

args_to_var_list([_|A],[_|V]) :-
    args_to_var_list(A,V),
    !.

/************************************************************************* */
/* build rule for function */

% as above, cut (!) will be transformed to $get_bc_reg, $cut.

func_rule(Head, Code, (Head :- Codes)) :-
    list_to_comma(['!'|Code], Codes).

/************************************************************************* */
/* convert [pred,pred,pred] to (pred,pred,pred) */

list_to_comma([Code], Code) :- !.

list_to_comma([Code1|Code], (Code1,Codes)) :-
    list_to_comma(Code,Codes).

/************************************************************************* */
/************************************************************************* */
% flatten_term(Func_body, Code_body, Result_var)
%
% Simple process of 'flattening' of nested functional arguments e.g.
% if 'a' and 'b' are constructors (i.e. irreducible prolog atoms) and
% 'f' and 'g' are defined functions of one argument, then
% f(g(a(b)))
% ->
% '$fun_g'([a(b)],A), '$fun_f'([A],Result_var)
%
/************************************************************************* */
/************************************************************************* */

flatten_term(A, [], A) :- var(A), !.               /* variable */

flatten_term(fail,[fail],fail) :- !.               /* fail */

flatten_term(A, [], A) :- atomic(A), !.            /* constant or func/0 */

/************************************************************************ */
%
% Special support for IF-THEN-ELSE
% 
% if (<relation succeeds>) then <functional expression 1> else <functional expression 2> 
%
% condition relation can contain function calls in its arguments, so the if-then-else
% translates to
% <flattened relation args> $fun_aux_if(Cond_relation, flattened exp1, flattened exp2)

% syntax-sugared version with no 'else' clause
flatten_term(if(then(Cond,A)), Code, Z) :-    % if Cond then A
    (var(A); A \= else(_,_)),                 % not this rule if A is 'else' clause
    !,
    flatten_term((if) @ [Cond,A], Code, Z).   % call '@' version

% syntax-sugared version full if-then-else
flatten_term(if(then(Cond,else(A,B))), Code, Z) :- % if Cond then A else B
    flatten_term((if) @ [Cond,A,B], Code, Z),      % call '@' version
    !.

% '@' syntax 'if @ [Condition, Exp1, Exp2]' version
flatten_term((if) @ [Cond,A,B], Code, Z) :-          /* if @ [Cond,A,B] */
    fmangle(aux_if,Func_aux_if),
    flatten_pred(Cond, Cond_code, New_cond),
    flatten_term(A,A_code_list1,Result_A),
    append(A_code_list1,[Z=Result_A],A_code_list2),
    list_to_comma(A_code_list2, A_code),
    flatten_term(B,B_code_list1,Result_B),
    append(B_code_list1,[Z=Result_B],B_code_list2),
    list_to_comma(B_code_list2, B_code),
    AuxIfPred =.. [Func_aux_if, New_cond, A_code, B_code],
    append(Cond_code, [AuxIfPred], Code),
    !.

% '@' syntax if-then without else, i.e. if @ [Condition, Exp1]. 'else fail' is added.
flatten_term((if) @ [Cond,A], Code, Z) :-         % if Cond then A
    flatten_term((if) @ [Cond,A,fail], Code, Z),   % equivalent to "if Cond then A else fail"
    !.

/************************************************************************ */
% compiled function

flatten_term(Func @ Args, Code, Z) :-            /* compiled function */
    atom(Func),
    fmangle(Func, Func1),
    flatten_term(Args, Arg_code, New_args),
    New_func =.. [Func1, New_args, Z],
    append(Arg_code, [New_func], Code),
    !.

/************************************************************************ */
% function name is a variable

flatten_term(Func @ Args, Code, Z) :-            /* variable function */
    var(Func),
    flatten_term(Args, Arg_code, New_args),
    append(Arg_code, ['$fun_eval'(Func @ New_args, Z)], Code),
    !.

/************************************************************************ */
% term is a LIST of expressions
% recursively flatten head followed by tail...

flatten_term([Arg|Args], Code, [New_arg|New_args]) :-         /* list */
    flatten_term(Arg, Code1, New_arg),
    flatten_term(Args, Code2, New_args),
    append(Code1, Code2, Code),
    !.

/************************************************************************ */
% term is a FUNCTION APPLICATION where function is an expression
%
% function name (Func below) can itself be an expression to be flattened (-> F1)
% then flatten the arguments
% and call '$fun_eval' for the function

flatten_term(Func @ Args, Code, Z) :-            /* higher-order function */
    flatten_term(Func, Func_code, F1),
    flatten_term(Args, Arg_code, New_args),
    append(Func_code, Arg_code, Code1),
    append(Code1, ['$fun_eval'(F1 @ New_args, Z)], Code),
    !.

/************************************************************************ */
% Syntax-sugered format for function application
% i.e. f(X,Y,Z) where 'f' has a function declaration
% is translated to f @ [X,Y,z]

flatten_term(Compound_term, Arg_code, Z) :-      /* function call f(Args) -> f @ [Args] */
    Compound_term =.. [Func|Args],
    g_read(def_funs,Fs),
    member(Func,Fs),                      % check Func a defined function
    flatten_term(Func @ Args, Arg_code, Z),
    !.

/************************************************************************ */
% catch-all: principal functor of relation a CONSTRUCTOR - i.e. not a function
% so the functor remains unchanged but the arguments are recursively flattened

flatten_term(Constructor_term, Arg_code, New_constructor) :- /* constructor */
    Constructor_term =.. [Constructor|Args],
    flatten_term(Args, Arg_code, Z),
    New_constructor =.. [Constructor|Z],
    !.

/************************************************************************* */
/* flatten predicate - treated as constructor*/
/************************************************************************* */
% flatten_pred(Relation, Arg_code, New_relation) where Arg code is the flattened
% code to produce the arguments for the relation, referred to in the New_relation
% E.g. flatten_pred(a(1+2),Code,Pred) -> Code = ['$fun_+'([1,2],A)], Pred = a(A)
% the idea being the Prolog source will have the argument code preceding the new 
% relation.
% If the relation doesn't contain any references to declared functions in its
% arguments, the argument code will be empty (i.e. none is needed), e.g.
% flatten_pred(a(b,[c,d]),Code,Pred) -> Code = [], Pred = a(b,[c,d])

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

/************************************************************************* */
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

/************************************************************************ */

goals_to_fcode((P,Q),(P1,Q1)) :-
    goals_to_fcode(P,P1),
    goals_to_fcode(Q,Q1),
    !.

goals_to_fcode(P,P_code) :-
    flatten_pred(P,Arg_code,P1),
    append(Arg_code, [P1], P_code_list),
    list_to_comma(P_code_list,P_code),
    !.

/************************************************************************* */
/* Initialization code for this file */
:- initialization(f_code_init).

