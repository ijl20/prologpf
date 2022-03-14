
/* transform program into ocode */

/**************************************************************/
/* modification to user code: */
/**************************************************************/
/*                                                            */
/*  heads go to: a(Clause#,Oracle_so_far-Hole,New_hole,args)  */
/*                                                            */
/*  a(args...).  -->  a(n,A-[n|E],E,args...). {n=clause#}     */
/*                                                            */
/*  a(a_args...) :- b(b_args...).                             */
/*         -->                                                */
/*  a(n,A-[n|E],En,a_args...) :- o_read(N),                   */
/*                               b(N,A-E,En,b_args...).       */
/*                                                            */
/*  a(a_args...) :- b(b_args...), c(c_args...).               */
/*         -->                                                */
/*  a(n,A-[n|E],En,a_args...) :- o_read(N1),                  */
/*                               b(N1,A-E,E1,b_args...),      */
/*                               o_read(N2),                  */
/*                               c(N2,A-E1,En,c_args...).     */
/*                                                            */
/**************************************************************/

/***************************************************************************/
/* transform program */

prog_to_ocode(Prog,Prog1) :- 
    prog_heads_to_ocode(Prog,ProgH),
    prog_bodies_to_ocode(ProgH,Prog1),
    !.

/* transform all clause heads, and accumulate clause counts */

prog_heads_to_ocode([Cl|Prog],[Cl1|Prog1]) :- 
    cl_head_to_ocode(Cl,Cl1),
    prog_heads_to_ocode(Prog,Prog1).

prog_heads_to_ocode([],[]).

/***************************************************************************/
/*transform clause head*/

cl_head_to_ocode((H:-B),[rule,A,E,En,(H1:-B)]) :-
    H =.. [Func|Args],
    g_read(Func,Cl_num), Cl_num1 is Cl_num + 1, g_assign(Func,Cl_num1),
    H1 =.. [Func,Cl_num1,A-[Cl_num1|E],En|Args],
    !.

cl_head_to_ocode(H,[fact,H]) :-
    functor(H,_,0),
    !.

cl_head_to_ocode(H,[fact,H1]) :-
    H =.. [Func|Args],
    g_read(Func,Cl_num), Cl_num1 is Cl_num + 1, g_assign(Func,Cl_num1),
    H1 =.. [Func,Cl_num1,_-[Cl_num1|E],E|Args].

/***************************************************************************/
/* transform all clause bodies */

prog_bodies_to_ocode([Cl|Prog],[Cl1|Prog1]) :-
    cl_body_to_ocode(Cl,Cl1),
    prog_bodies_to_ocode(Prog,Prog1).

prog_bodies_to_ocode([],[]).

/***************************************************************************/
/* transform clause body */

cl_body_to_ocode([rule,A,E,En,(H:-B)],(H:-B1)) :-
    goals_to_ocode(A,E,En,B,B1).

cl_body_to_ocode([fact,F],F).
    
goals_to_ocode(A,E,En,(P,Q),(P1,Q1)) :-
    goal_to_ocode(A,E,E1,P,P1),
    goals_to_ocode(A,E1,En,Q,Q1),
    !.

goals_to_ocode(A,E,En,P,P1) :-
    goal_to_ocode(A,E,En,P,P1).

goal_to_ocode(A,E,E1,P,(o_next(N,A),P1)) :-
    P =.. [Func|Args],
    g_read(Func,C), C > 0,       /* test Func is defined in user prog      */
    P1 =.. [Func,N,A-E,E1|Args],
    !.
   
goal_to_ocode(_,_,_,P,P).        /* if Func not user then no change        */

/***************************************************************************/

/*  some debug utilities  */

print_prog([Cl|Prog]) :- write(Cl), nl, print_prog(Prog).

print_prog([]).






