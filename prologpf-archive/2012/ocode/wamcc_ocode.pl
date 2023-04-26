/***************************************************************************/
/* transform program into ocode using C oracle support                     */
/***************************************************************************/
/* prog_to_ocode(ProgIn, ProgOut) */
/* prog is represented as list of clauses */

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%             TRANSFORMATION:                                               %%
%%                                                                           %%
%%   ORIGINAL CODE:                                                          %%
%%       a(X).                                                               %%
%%       a(X) :- c(X), d(X).                                                 %%
%%                                                                           %%
%%   TRANSFORMED CODE:                                                       %%
%%       a(X,1) :- o_build(1).                                               %%
%%       a(X,2) :- o_build(2), o_follow(N1), c(X,N1), o_follow(N2), d(X,N2). %%
%%                                                                           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- public prog_to_ocode/2.

/***************************************************************************/
/* transform program */

prog_to_ocode(Prog,Prog2) :- 
    g_read(ocode,t), !,              % transform if -ocode option set
    set_pred_info(pub,o_query,0),    % make o_query/0 public
    ocode_pass1(Prog),               % phase 1: scan rules
    add_o_query(Prog,Prog1),         % add fact "o_query" if no o_query
    ocode_pass2(Prog1,Prog2).        % phase 2: transform rules

prog_to_ocode(Prog,Prog).            % if no -ocode then no change

/***************************************************************************/
/* pass 1: scan clauses, accumulate clause counts & cuts */

ocode_pass1([]) :- !.

ocode_pass1([Cl|Prog]) :- 
    ocode_scan(Cl), !,
    ocode_pass1(Prog).

/***************************************************************************/
/* pass 2: transform each clause */

ocode_pass2([],[]) :- !.

ocode_pass2([Cl|Prog],[Cl1|Prog1]) :-
    clause_to_ocode(Cl,Cl1),
    ocode_pass2(Prog,Prog1).

/***************************************************************************/
/*  BFP strategy calls user proc "o_query", so add it if user has not      */

add_o_query(Prog,Prog) :-          % count = 1, => user has included o_query 
    mangle(o_query,0,Func),
    proc_info_count(Func,1),
    !.

add_o_query(Prog,[o_query|Prog]).  % count != 1, so add "o_query" fact

/***************************************************************************/
/* symbol mangling  foo/2 --> $orc_2_foo */

mangle(Func,Arity,Func1) :-
    atom_chars(Func,Fs),
    number_chars(Arity,As),
    append(As,['_'|Fs],Fs1),
    atom_chars(Func1,['$',o,r,c,'_'|Fs1]).

/***************************************************************************/

% rule = $exe_n :- ...      => skip

ocode_scan((H:-_)) :-
    functor(H,Func,_),
    atom_chars(Func,['$',e,x,e,'_'|_]),
    !.

% rule with cuts in body    => record cuts

ocode_scan((H:-B)) :-
    cuts_in_body(B),
    functor(H,Func,A), mangle(Func,A,Func1),
    proc_info_add_real(Func1),
    !.

% rule "H:-B" with cuts already found in body  => skip

ocode_scan((H:-_)) :-
    functor(H,Func,A), mangle(Func,A,Func1),
    proc_info_cuts(Func1),
    !.

% rule "H:-B", no cuts already found  => add to rule count

ocode_scan((H:-_)) :-
    functor(H,Func,Arity), mangle(Func,Arity,Func1),
    proc_info_add(Func1),
    !.

% fact arity/0    => skip

ocode_scan(H) :-
    functor(H,_,0),
    !.
         
% fact arity > 0 but cuts found earlier  => skip

ocode_scan(H) :-
    functor(H,Func,Arity), mangle(Func,Arity,Func1),
    proc_info_cuts(Func1),
    !.

% fact arity > 0, no cuts found earlier

ocode_scan(H) :-
    functor(H,Func,Arity), mangle(Func,Arity,Func1),
    proc_info_add(Func1),
    !.

/***************************************************************************/
/*transform clause */

% directive $exe_n :- A(X),B(X),C(X)  ---> $exe_n :- o_set_build, o_set_l(10000), 
%                                                    o_follow(N1), a(X,N1),
%                                                    o_follow(N2), b(X,N2),
%                                                    o_follow(N3), c(X,N3).

clause_to_ocode((H:-B), (H:-B1)) :-
    functor(H,Func,_),
    atom_chars(Func,['$',e,x,e,'_'|_]),
    !,
    goals_to_ocode(B,B1).
        
% clause in procedure containing cuts, only one clause, or not defined by user

clause_to_ocode((H:-B), (H:-B1)) :-
    functor(H,Func,A), mangle(Func,A,Func1),
    proc_info_real(Func1),
    !,
    goals_to_ocode(B,B1).

% clause in procedure with no cuts and more than one clause

clause_to_ocode((H:-B), (H1:- (o_build(N),B1))) :-
    functor(H,Func,A), mangle(Func,A,Func1),
    proc_info_ocode(Func1),
    !,
    proc_info_next(Func1,N),
    H =.. [_|Args],
    append(Args,[N],Args1),
    H1 =.. [Func1|Args1],
    goals_to_ocode(B,B1).

% fact arity 0, or cuts elsewhere in procedure

clause_to_ocode(H,H) :-
    functor(H,Func,Arity), mangle(Func,Arity,Func1),
    proc_info_real(Func1),
    !.

% fact requiring ocode support

clause_to_ocode(H, (H1 :- o_build(N))) :-
    functor(H,Func,Arity), mangle(Func,Arity,Func1),
    proc_info_ocode(Func1),
    proc_info_next(Func1,N),
    H =.. [_|Args],
    append(Args,[N],Args1),
    H1 =.. [Func1|Args1],
    !.    


/**** cuts_in_body(X) succeeds if cut '!' found in arg term */

cuts_in_body((P,_)) :- cuts_in_body(P),!.

cuts_in_body((_,Q)) :- cuts_in_body(Q),!.

cuts_in_body((P;_)) :- cuts_in_body(P),!.

cuts_in_body((_;Q)) :- cuts_in_body(Q),!.

cuts_in_body('$cut'(_)) :- !.

cuts_in_body(!) :- !.

cuts_in_body((_ -> _)) :- !.

/**************************************************************************/

goals_to_ocode((P,Q),(P1,Q1)) :-
    goals_to_ocode(P,P1),
    goals_to_ocode(Q,Q1),
    !.

goals_to_ocode(P,P1) :-
    goal_to_ocode(P,P1).

goal_to_ocode(P,(o_follow(N),P1)) :-
    P =.. [Func|Args], functor(P,_,Arity), mangle(Func,Arity,Func1),
    proc_info_ocode(Func1),       /* test Func is defined in user prog     */
                                  /* and has no cuts                       */
    append(Args,[N],Args1),
    P1 =.. [Func1|Args1],
    !.
   
goal_to_ocode(P,P).               /* if Func not user then no change        */

/***************************************************************************/

/* procedure info  calls used to accumulate clause counts and flag         */
/*                 procedures which contain cuts                           */
/* data accumulated into global '$orc_proc_info' which is not accessed     */
/* directly elsewhere */

% $orc_proc_info = [ [Func, [Clause_count, Next_clause_number]] ... ]

proc_info_load([X|Y]) :- g_read('$orc_proc_info',[X|Y]), !.
proc_info_load([]) :- g_assign('$orc_proc_info',[]).

/* lookup: given Func, Proc_info,  returns C (count) and remainder list T */

proc_info_lookup(Func,[[Func,C]|T],C1,T) :- !, C = C1.
proc_info_lookup(Func,[H|T],C,[H|T1]) :- proc_info_lookup(Func,T,C,T1).
proc_info_lookup(_,[],[0,0],[]).
 
/* info_add: increment count for func, and return value */

proc_info_add(Func) :-
    proc_info_load(Proc_info),
    proc_info_lookup(Func,Proc_info,[C,_],Rem),
    Count is C + 1,
    g_assign('$orc_proc_info', [[Func,[Count,1]] | Rem]),
    !.

/* info_add_real: set count to -1, to flag no ocode wanted */

proc_info_add_real(Func) :- 
    proc_info_load(Proc_info),
    proc_info_lookup(Func,Proc_info,_,Rem),
    g_assign('$orc_proc_info',[[Func,[-1,0]]|Rem]).

/* info_count: return count */

proc_info_count(Func, Count) :- 
    proc_info_load(Proc_info),
    proc_info_lookup(Func,Proc_info,[Count,_],_).

/* proc_info_next: return next clause number and increment */

proc_info_next(Func, Next) :- 
    proc_info_load(Proc_info),
    proc_info_lookup(Func,Proc_info,[Count,Next],Rem),
    Next1 is Next + 1,
    g_assign('$orc_proc_info',[[Func,[Count,Next1]]|Rem]).


/* info_cuts: succeed if Func proc has cuts (i.e. no ocode) */

proc_info_cuts(Func) :- proc_info_count(Func,-1).

/* info_real: succeed if Func is real-only (i.e. no ocode) */

proc_info_real(Func) :- proc_info_count(Func,1),!. /* proc only one clause */
proc_info_real(Func) :- proc_info_count(Func,0),!. /* proc not defined by user */
proc_info_real(Func) :- proc_info_cuts(Func). /* or proc has cuts   */

/* info_ocode */

proc_info_ocode(Func) :- proc_info_count(Func,C), C > 1.



