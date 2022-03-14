/* routes cst ex 4 */

:- main([f_utils, o_utils]).

% val pairs = [(1,2),(2,3),(3,4),(1,5),(5,4),(1,6),(1,4),(1,3),(2,4)];

val(pairs,[(1,2),(2,3),(3,4),(1,5),(5,4),(1,6),(1,4),(1,3),(2,4)]).

/* startpoints */

%fun sps([],z)           = []
% |  sps((x,y)::pairs,z) = if (y<>z)
%                                  then sps(pairs,z)
%                                  else x::sps(pairs,z);

fun sps([],Z)            = [];
    sps([(X,Y)|Pairs],Z) = if (Y \== Z)
                           then sps(Pairs,Z)
                           else [X|sps(Pairs,Z)].

/* endpoints */

%fun eps(z,[])           = []
% |  eps(z,(x,y)::pairs) = if (x<>z)
%                                  then eps(z,pairs)
%                                  else y::eps(z,pairs);


fun eps(Z,[])            = [];
    eps(Z,[(X,Y)|Pairs]) = if (X \== Z)
                           then eps(Z,Pairs)
                           else [Y|eps(Z,Pairs)].
                   
%fun allpairs([],ys)     = []
% |  allpairs(x::xs,ys)  =
%      let fun pairx([])    = []
%           |  pairx(y::ys) = (x,y)::pairx(ys)
%      in
%        pairx(ys)@allpairs(xs,ys)
%      end;

fun append(X,Y) =           % example of relation call within function
        if append(X,Y,Z)
        then Z
        else fail.

fun pairx(_,[])     = [];
    pairx(X,[Y|Ys]) = [(X,Y)|pairx(X,Ys)].

fun allpairs([],_)      = [];
    allpairs([X|Xs],Ys) = append(pairx(X,Ys),allpairs(Xs,Ys)).

%infix 5 mem;

%fun x mem []      = false 
% |  x mem (y::ys) = (x=y) orelse (x mem ys);

%fun addnew((x,y),[]) = [(x,y)]
% |  addnew((x,y),pairs) = 
%      let
%        fun addall([],pairs)    = pairs
%         |  addall(p::ps,pairs) = addall(ps,addnew(p,pairs))
%      in
%        if ( (x,y) mem pairs ) orelse (x=y)
%        then pairs
%        else addall(allpairs(sps(pairs,x),[y])@allpairs([x],eps(y,pairs)),(x,y)::pairs)
%      end;

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

%$fun_addnew([Pair,[]],[Pair]) :-
%    $get_bc_reg(_19615),
%    $cut(_19615).

%$fun_addnew([(X,Y),Pairs],Z) :-
%    $get_bc_reg(_19650),
%    $fun_aux_if((member((X,Y),Pairs);X=Y),
%                Z=Pairs,
%                ($fun_sps([Pairs,X],Z1),
%                 $fun_allpairs([Z1,[Y]],Z2),
%                 $fun_eps([Y,Pairs],Z3),
%                 $fun_allpairs([[X],Z3],Z4),
%                 $fun_append([Z2,Z4],Z5),
%                 $fun_addall([Z5,[(X,Y)|Pairs]],Z6),
%                 Z=Z6
%                )),
%    $cut(_19650).

%$fun_addnew(_6206,lambda(_6201,$fun_addnew([_6185,_6187],_6190),_6190)) :-
%    $get_bc_reg(_19695),
%    append(_6206,_6201,[_6185,_6187]),
%    $cut(_19695).


%fun routes [] = []
% |  routes ((x,y)::pairs) = addnew((x,y),routes(pairs));

fun routes([]) = [];
    routes([(X,Y)|Pairs]) = addnew((X,Y),routes(Pairs)).

query :- true.    % catch-all for ocode

ex(1,P) :- val(pairs,Pairs), P = sps(Pairs,2). % P = [1]
ex(2,P) :- val(pairs,Pairs), P = eps(2,Pairs). % P = [3,4]
ex(3,Z) :- Z = append([a,b,c],[1,2,3]).        % Z = [a,b,c,1,2,3]
ex(4,Z) :- Z = pairx(a,[1,2,3]).               % Z = [(a,1),(a,2),(a,3)]
ex(5,Z) :- Z = allpairs([a,b,c],[1,2]).        % Z = [(a,1),(a,2),(b,1)...]
ex(6,Z) :- Z = addnew((a,b),[(b,c),(b,d)]).    % Z = [(a,b),(a,c),(a,d)...]
ex(7,Z) :- Z = routes([(1,2),(2,3),(2,4),(4,5)]).

% ex(7,Z) should return:
%      Z = [(1,4),(1,5),(1,3),(1,2),(2,3),(2,5),(2,4),(4,5)]

ex(71,X,Z) :- Z = routes(X).

ex(8,Xs,Ys,Z) :- 
    Z1 = allpairs(Xs),
    write('Z1 = '),
    write(Z1),
    nl,
    Z = Z1 @ [Ys]. 
