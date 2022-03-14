/* routes cst ex 4 */

:- main([f_utils]).

% val pairs = [(1,2),(2,3),(3,4),(1,5),(5,4),(1,6),(1,4),(1,3),(2,4)];

val(pairs,[(1,2),(2,3),(3,4),(1,5),(5,4),(1,6),(1,4),(1,3),(2,4)]).

/* startpoints */

%fun sps([],z)           = []
% |  sps((x,y)::pairs,z) = if (y<>z)
%                                  then sps(pairs,z)
%                                  else x::sps(pairs,z);

fun sps(Pairs,Z) =
        if  (Pairs = [(X,Y)|Pairs1])
        then ( if (Z = Y)
               then  [X|sps(Pairs1,Z)]
               else  sps(Pairs1,Z)
             )
        else [].

/* endpoints */

%fun eps(z,[])           = []
% |  eps(z,(x,y)::pairs) = if (x<>z)
%                                  then eps(z,pairs)
%                                  else y::eps(z,pairs);

fun eps(Z,Pairs) =
        if (Pairs = [(X,Y)|Pairs1])
        then ( if (Z = X)
               then [Y|eps(Z,Pairs1)]
               else eps(Z,Pairs1)
             )
        else [].


%fun allpairs([],ys)     = []
% |  allpairs(x::xs,ys)  =
%      let fun pairx([])    = []
%           |  pairx(y::ys) = (x,y)::pairx(ys)
%      in
%        pairx(ys)@allpairs(xs,ys)
%      end;

fun append(X,Y) =
        if append(X,Y,Z)
        then Z
        else fail.

fun pairx(X,Ys) =
        if (Ys = [Y|Yss])
        then [(X,Y)|pairx(X,Yss)]
        else [].

fun allpairs(Xs,Ys) =
        if (Xs = [X|Xss])
        then append( pairx(X,Ys), allpairs(Xss,Ys))
        else [].
    
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

fun addall(Pairs1,Pairs2) =
        if  (Pairs1 = [P|Ps])
        then addall(Ps, addnew @ [P, Pairs2])
        else Pairs2.

fun addnew((X,Y),Pairs) =
        if (Pairs = [])
        then [(X,Y)]
        else ( if member((X,Y),Pairs)
               then Pairs
               else (if (X = Y)
                     then Pairs
                     else addall( append( allpairs( sps(Pairs,X), [Y]),
			          	  allpairs( [X], eps(Y,Pairs))
                                        ),
                                  [(X,Y)|Pairs])
                    )
             ).

%fun routes [] = []
% |  routes ((x,y)::pairs) = addnew((x,y),routes(pairs));

fun routes(Pairs) =
        if (Pairs = [(X,Y)|Pairs1])
        then addnew( (X,Y), routes(Pairs1))
        else [].

query :- true.    % catch-all for ocode

ex(1,P) :- val(pairs,Pairs), P = sps(Pairs,2). % P = [1]
ex(2,P) :- val(pairs,Pairs), P = eps(2,Pairs). % P = [3,4]
ex(3,Z) :- Z = append([a,b,c],[1,2,3]).        % Z = [a,b,c,1,2,3]
ex(4,Z) :- Z = pairx(a,[1,2,3]).               % Z = [(a,1),(a,2),(a,3)]
ex(5,Z) :- Z = allpairs([a,b,c],[1,2]).        % Z = [(a,1),(a,2),(b,1)...]
ex(6,(X,Y),Pairs,Z) :- Z = addnew((X,Y),Pairs).
ex(7,X,Z) :- Z = routes(X).

% ex(71,Z) should return:
%      Z = [(1,4),(1,5),(1,3),(1,2),(2,3),(2,5),(2,4),(4,5)]

ex(71,Z) :- Z = routes([(1,2),(2,3),(2,4),(4,5)]).

ex(8,Xs,Ys,Z) :- 
    Z1 = allpairs(Xs),
    write('Z1 = '),
    write(Z1),
    nl,
    Z = Z1 @ [Ys]. 
