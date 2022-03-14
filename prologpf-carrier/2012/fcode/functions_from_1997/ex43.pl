/* routes cst ex 4 */

:- main([f_utils, o_utils]).

:- public o_query/0.

val(pairs,[(1,2),(2,3),(3,4),(1,5),(5,4),(1,6),(1,4),(1,3),(2,4)]).

/* startpoints */

fun sps([],Z)            = [];
    sps([(X,Y)|Pairs],Z) = if (Y \== Z)
                           then sps(Pairs,Z)
                           else [X|sps(Pairs,Z)].

/* endpoints */

fun eps(Z,[])            = [];
    eps(Z,[(X,Y)|Pairs]) = if (X \== Z)
                           then eps(Z,Pairs)
                           else [Y|eps(Z,Pairs)].
                   
fun append(X,Y) =           % example of relation call within function
        if append(X,Y,Z)
        then Z
        else fail.

fun pairx(_,[])     = [];
    pairx(X,[Y|Ys]) = [(X,Y)|pairx(X,Ys)].

fun allpairs([],_)      = [];
    allpairs([X|Xs],Ys) = append(pairx(X,Ys),allpairs(Xs,Ys)).

fun addall([],Pairs)     = Pairs;
    addall([P|Ps],Pairs) = addall(Ps,addnew @ [P,Pairs]). % note explicit '@'

fun addnew(Pair,[]) = [Pair];
    addnew((X,Y),Pairs) = if (member((X,Y),Pairs); X=Y)
                          then Pairs
                          else addall( append( allpairs( sps(Pairs,X), [Y]),
			          	       allpairs( [X], eps(Y,Pairs))
                                             ),
                                       [(X,Y)|Pairs]
                                     ).

fun routes([]) = [];
    routes([(X,Y)|Pairs]) = addnew((X,Y),routes(Pairs)).

o_query :- ex7(Z), write(Z).

ex1(P) :- val(pairs,Pairs), P = sps(Pairs,2). % P = [1]
ex2(P) :- val(pairs,Pairs), P = eps(2,Pairs). % P = [3,4]
ex3(Z) :- Z = append([a,b,c],[1,2,3]).        % Z = [a,b,c,1,2,3]
ex4(Z) :- Z = pairx(a,[1,2,3]).               % Z = [(a,1),(a,2),(a,3)]
ex5(Z) :- Z = allpairs([a,b,c],[1,2]).        % Z = [(a,1),(a,2),(b,1)...]
ex6(Z) :- Z = addnew((a,b),[(b,c),(b,d)]).    % Z = [(a,b),(a,c),(a,d)...]
ex7(Z) :- Z = routes([(1,2),(2,3),(2,4),(4,5)]).

% ex7(Z) should return:
%      Z = [(1,4),(1,5),(1,3),(1,2),(2,3),(2,5),(2,4),(4,5)]

ex71(X,Z) :- Z = routes(X).

ex8(Xs,Ys,Z) :- 
    Z1 = allpairs(Xs),
    write('Z1 = '),
    write(Z1),
    nl,
    Z = Z1 @ [Ys]. 
