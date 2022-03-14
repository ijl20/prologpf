%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% PrologPF
%%%
%%%  definitions for functional evaluation
%%%
%%%  Ian Lewis - June 2009
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% operator precendence for FUNCTION DEFINITION and APPLICATION

:-op(1150,fx,fun).
:-op(180,xfx,@).

%%% operator precedence for IF-THEN-ELSE

:-op(660,fx,if).
:-op(650,xfx,then).
:-op(640,xfx,else).

%%% eval rules for basic ARITHMETIC

eval(+(X,Y),Z):- eval(X,X1), eval(Y,Y1), Z is X1+Y1,!.
eval(-(X,Y),Z):- eval(X,X1), eval(Y,Y1), Z is X1-Y1,!.
eval(*(X,Y),Z):- eval(X,X1), eval(Y,Y1), Z is X1*Y1,!.
eval(/(X,Y),Z):- eval(X,X1), eval(Y,Y1), Z is X1/Y1,!.

%%% eval rules for LIST EVALUATION

% eval([],[]). is already defined as atom([]) succeeds
eval([X|Y],[Q|Z]):- eval(X,Q), eval(Y,Z),!.

%%% eval rule for IF-THEN-ELSE

eval(if A then B else C,X) :- A -> eval(B,X),!;eval(C,X),!.

%%% eval rule for FUNCTION APPLICATION

eval(Func @ Args,Z):- eval(Args, Args1), fun(Func @ Args1 = X), eval(X,Z),!.

%%% eval rule to treat a COMPOUND TERM (e.g. fact(5)) as a function application fact @ [5] if 'fun' definition exists

eval(Func_app,Z) :- compound(Func_app), Func_app =.. [Func|Args], fun(Func @ _ = _), eval(Func @ Args,Z),!.

%%% final eval rule to return the ORIGINAL VALUE

eval(X,X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% SAMPLE FUNCTION DEFINITIONS

% Basic format is "fun function_name @ arg_list = expression."

fun inc@[X] = X + 1.

fun fact@[X] = if (X=1) then 1 else X * fact @ [X-1].

fun map@[F,L] = if (L=[H|T]) then [F@[H]|map@[F,T]] else [].

