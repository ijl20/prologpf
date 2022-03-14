PROLOGF
Prolog extended with higher-order functions

FILES
=====

These files provide a complete sequence converting 'functional prolog' (a.k.a. prologf)
to regular prolog.

f_utils.pl:
  provides operator precedences to support functional syntax (e.g. '@', 'fun', 'if', 'then', 'else')
  provides utility predicates called at runtime by the transformed program, such as
  '$fun_aux_if' which simulates the behaviour of a functional if-then-else.
  
pl2fcode.pl: 
  provides prog_to_fcode(Prog,Prog2)
  where Prog is the input source (as a prolog term) containing 'functional prolog'
  and Prog2 is that program transformed ('flattened') with prolog clauses replacing the functions
  
files.pl:
  provides fmake(Filename)
  which READS the file Filename.pl (in 'functional prolog')
  and WRITES the file Filename_fcode.pl (as 'flattened' regular prolog)
  
SAMPLE PROLOGF TRANSLATION/EXECUTION STEPS
==========================================

1) Launch gprolog
2) consult('f_utils.pl').
3) consult('files.pl').
4) consult('pl2fcode.pl').
5) fmake('examples\\primes').
6) consult('examples\\primes_fcode.pl').
7) ex(92,N,X). % ---will return the Nth prime as X, e.g. ex(92,99,X) -> X = 523

If you look at the examples\primes.pl source, you will see multiple exercise questions e.g. ex(1,X) etc...

EXAMPLE PROLOGF -> PROLOG TRANSLATION
=====================================
1) Example prologf function DEFINITION:

    fun inc(X) = X + 1. 

Translates to the following prolog:

    '$fun_inc'([X],Y):-
        !,
        '$fun_+'([X,1],Y). % note f_utils.pl library function call '+'

    % This additional lambda definition is to support CURRYING. See later.
    '$fun_inc'(GivenArgs,lambda(MissingArgs,'$fun_inc'([X],Y),Y)):-
        append(GivenArgs,MissingArgs,[X]),
        !.

2) Example prologpf function CALL:

    inc_goal(X,Y) :- Y = inc(X).    % example of function CALL

Translates to the following prolog:

    inc_goal(X,Z):-
        '$fun_inc'([X],Y),
        Z=Y.
