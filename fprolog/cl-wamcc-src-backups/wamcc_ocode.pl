/***************************************************************************/
/* transform program into ocode */
/***************************************************************************/
/* prog_to_ocode(ProgIn, ProgOut) */
/* prog is represented as list of clauses */

/**************************************************************/
/* modification to user code: */
/**************************************************************/
/*                                                            */
/*  heads go to: a(Clause#,Oracle_so_far-Hole,New_hole,args)  */
/*                                                            */
/*  a(args...).  -->  a(n,A,[n|E],E,args...). {n=clause#}     */
/*                                                            */
/*  a(a_args...) :- b(b_args...).                             */
/*               -->                                          */
/*  a(n,A,[n|E],En,a_args...) :- o_read(N),                   */
/*                               b(N,A,E,En,b_args...).       */
/*                                                            */
/*  a(a_args...) :- b(b_args...), c(c_args...).               */
/*         -->                                                */
/*  a(n,A,[n|E],En,a_args...) :- o_read(N1),                  */
/*                               b(N1,A,E,E1,b_args...),      */
/*                               o_read(N2),                  */
/*                               c(N2,A,E1,En,c_args...).     */
/*                                                            */
/**************************************************************/

:- public prog_to_ocode/2.

/***************************************************************************/
/* transform program */

prog_to_ocode(Prog,Prog2) :- 
    prog_heads_to_ocode(Prog,ProgH),
    prog_bodies_to_ocode(ProgH,Prog1),
    append(Prog,Prog1,Prog2).

/* transform all clause heads, and accumulate clause counts */

prog_heads_to_ocode([Cl|Prog],[Cl1|Prog1]) :- 
    cl_head_to_ocode(Cl,Cl1), !,
    prog_heads_to_ocode(Prog,Prog1).

prog_heads_to_ocode([_|Prog],Prog1) :- 
    prog_heads_to_ocode(Prog,Prog1).

prog_heads_to_ocode([],[]).

/***************************************************************************/
/*transform clause head*/

/* symbol mangling  a/2 --> $orc_2_a */

mangle(Func,Arity,Func1) :-
    atom_chars(Func,Fs),
    number_chars(Arity,As),
    append(As,['_'|Fs],Fs1),
    atom_chars(Func1,['$',o,r,c,'_'|Fs1]).

/* case 1: directives as "$exe_n :- goal" unchanged */

cl_head_to_ocode((H:-_),_) :-
    functor(H,Func,_),
    atom_chars(Func,['$',e,x,e,'_'|_]),
    !,
    fail.

/* case 2: rule "H:-B" with cuts already found in body */

cl_head_to_ocode((H:-_),_) :-
    functor(H,Func,A), mangle(Func,A,Func1),
    proc_info_cuts(Func1),
    !,
    fail.    

/* case 3: rule "H:-B" with cuts in body */

cl_head_to_ocode((H:-B),_) :-
    cuts_in_body(B),
    functor(H,Func,A), mangle(Func,A,Func1),
    proc_info_add_real(Func1),
    !,
    fail.

/* case 4: rule "H:-B" */
 
cl_head_to_ocode((H:-B),[rule,A,E,En,(H1:-B)]) :-
    H =.. [Func|Args], functor(H,_,Arity), mangle(Func,Arity,Func1),
    proc_info_add(Func1,Cl_num),
    H1 =.. [Func1,Cl_num,A,[Cl_num|E],En|Args],
    !.

/* case 5: fact i.e. no body.  Arity/0 */

cl_head_to_ocode(H,[fact,H]) :-
    functor(H,_,0),
    !,
    fail. /* ocode unchanged, so original used in append of Prog */

/* case 6: fact with args, but cuts already found in proc earlier */

cl_head_to_ocode(H,_) :-
    functor(H,Func,A), mangle(Func,A,Func1),
    proc_info_cuts(Func1),
    !,
    fail.

/* case 7: fact with args. */

cl_head_to_ocode(H,[fact,H1]) :-
    H =.. [Func|Args], functor(H,_,A), mangle(Func,A,Func1),
    proc_info_add(Func1, Cl_num),
    H1 =.. [Func1,Cl_num,_,[Cl_num|E],E|Args].

/**** cuts_in_body(X) succeeds if cut '!' found in arg term */

cuts_in_body((P,_)) :- cuts_in_body(P),!.

cuts_in_body((_,Q)) :- cuts_in_body(Q),!.

cuts_in_body((P;_)) :- cuts_in_body(P),!.

cuts_in_body((_;Q)) :- cuts_in_body(Q),!.

cuts_in_body(!) :- !.

cuts_in_body((_ -> _)) :- !.


/***************************************************************************/
/* transform all clause bodies */

prog_bodies_to_ocode([Cl|Prog],[Cl1|Prog1]) :-
    cl_body_to_ocode(Cl,Cl1),!,
    prog_bodies_to_ocode(Prog,Prog1).

prog_bodies_to_ocode([_|Prog],Prog1) :-
    prog_bodies_to_ocode(Prog,Prog1).

prog_bodies_to_ocode([],[]).

/***************************************************************************/
/* transform clause body */

/* case 1: picks up [rule..] clauses built in good faith by                */
/*         cl_head_to_ocode before cuts found in later clauses             */

cl_body_to_ocode([rule,_,_,_,(H:-_)],_) :-
    functor(H,Func,_),
    proc_info_real(Func),
    !,
    fail.    

/* case 2: normal "H:-B" rule */

cl_body_to_ocode([rule,A,E,En,(H:-B)],(H:-B1)) :-
    goals_to_ocode(A,E,En,B,B1).

/* case 3: fact in procedure with cuts */

cl_body_to_ocode([fact,F],_) :-
    functor(F,Func,_),
    proc_info_real(Func),
    !,
    fail.

/* case 4: fact */

cl_body_to_ocode([fact,F],F).

/**************************************************************************/

goals_to_ocode(A,E,En,(P,Q),(P1,Q1)) :-
    goals_to_ocode(A,E,E1,P,P1),
    goals_to_ocode(A,E1,En,Q,Q1),
    !.

goals_to_ocode(A,E,En,P,P1) :-
    goal_to_ocode(A,E,En,P,P1).

goal_to_ocode(A,E,E1,P,(o_next(N,A),P1)) :-
    P =.. [Func|Args], functor(P,_,Arity), mangle(Func,Arity,Func1),
    proc_info_ocode(Func1),       /* test Func is defined in user prog     */
                                  /* and has no cuts                       */
    P1 =.. [Func1,N,A,E,E1|Args],
    !.
   
goal_to_ocode(_,E,E,P,P).        /* if Func not user then no change        */

/***************************************************************************/

/* procedure info  calls used to accumulate clause counts and flag         */
/*                 procedures which contain cuts                           */
/* data accumulated into global '$orc_proc_info' which is not accessed     */
/* directly elsewhere */

proc_info_load([X|Y]) :- g_read('$orc_proc_info',[X|Y]), !.
proc_info_load([]) :- g_assign('$orc_proc_info',[]).

/* lookup: given Func, Proc_info,  returns C (count) and remainder list T */

proc_info_lookup(Func,[[Func,C]|T],C1,T) :- !, C = C1.
proc_info_lookup(Func,[H|T],C,[H|T1]) :- proc_info_lookup(Func,T,C,T1).
proc_info_lookup(_,[],0,[]).
 
/* info_add: increment count for func, and return value */

proc_info_add(Func,Count) :-
    proc_info_load(Proc_info),
    proc_info_lookup(Func,Proc_info,C,Rem),
    Count is C + 1,
    g_assign('$orc_proc_info', [[Func,Count] | Rem]),
    !.

/* info_add_real: set count to -1, to flag no ocode wanted */

proc_info_add_real(Func) :- 
    proc_info_load(Proc_info),
    proc_info_lookup(Func,Proc_info,_,Rem),
    g_assign('$orc_proc_info',[[Func,-1]|Rem]).

/* info_count: return count */

proc_info_count(Func, Count) :- 
    proc_info_load(Proc_info),
    proc_info_lookup(Func,Proc_info,Count,_).

/* info_cuts: succeed if Func proc has cuts (i.e. no ocode) */

proc_info_cuts(Func) :- proc_info_count(Func,-1).

/* info_real: succeed if Func is real-only (i.e. no ocode) */

proc_info_real(Func) :- proc_info_count(Func,0). /* proc not defined by user */
proc_info_real(Func) :- proc_info_cuts(Func). /* or proc has cuts   */

/* info_ocode */

proc_info_ocode(Func) :- proc_info_count(Func,C), C > 0.



