/* routes cst ex 4 */

:- main([f_utils]).

% val pairs = [(1,2),(2,3),(3,4),(1,5),(5,4),(1,6),(1,4),(1,3),(2,4)];

val(pairs,[(1,2),(2,3),(3,4),(1,5),(5,4),(1,6),(1,4),(1,3),(2,4)]).

/* startpoints */

%fun sps([],z)           = []
% |  sps((x,y)::pairs,z) = if (y<>z)
%                                  then sps(pairs,z)
%                                  else x::sps(pairs,z);

fun(sps(Pairs,Z),
    if( Pairs = [(X,Y)|Pairs1],
        if( Z = Y,
            [X|sps(Pairs1,Z)],
            sps(Pairs1,Z)
          ),
        []
      )).

/* endpoints */

%fun eps(z,[])           = []
% |  eps(z,(x,y)::pairs) = if (x<>z)
%                                  then eps(z,pairs)
%                                  else y::eps(z,pairs);

fun(eps(Z,Pairs),
    if( Pairs = [(X,Y)|Pairs1],
        if( Z = X,
            [Y|eps(Z,Pairs1)],
            eps(Z,Pairs1)
          ),
        []
      )).

%fun allpairs([],ys)     = []
% |  allpairs(x::xs,ys)  =
%      let fun pairx([])    = []
%           |  pairx(y::ys) = (x,y)::pairx(ys)
%      in
%        pairx(ys)@allpairs(xs,ys)
%      end;

fun( append(X,Y),
     if( append(X,Y,Z),
         Z,
         fail
       )).

fun( pairx(X,Ys),
     if( Ys = [Y|Yss],
         [(X,Y)|pairx(X,Yss)],
         []
       )).

fun( allpairs(Xs,Ys),
     if( Xs = [X|Xss],
         append( pairx(X,Ys), allpairs(Xss,Ys)),
         []
       )).
    
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

fun( addall(Pairs1,Pairs2),
     if( Pairs1 = [P|Ps],
         addall(Ps, addnew @ [P, Pairs2]),
         Pairs2
       )).

fun( addnew((X,Y),Pairs),
     if( Pairs = [],
         [(X,Y)],
         if( member((X,Y),Pairs),
             Pairs,
             if( X = Y,
                 Pairs,
                 addall( append( allpairs( sps(Pairs,X), [Y]),
			  	 allpairs( [X], eps(Y,Pairs))
                               ),
                         [(X,Y)|Pairs])
               )
            )
        )).

%fun routes [] = []
% |  routes ((x,y)::pairs) = addnew((x,y),routes(pairs));

fun( routes(Pairs),
     if( Pairs = [(X,Y)|Pairs1],
         addnew( (X,Y), routes(Pairs1)),
         []
       )).

query :- true.    % catch-all for ocode

ex(1,Z,P) :- val(pairs,Pairs), P = sps(Pairs,Z).
ex(2,Z,P) :- val(pairs,Pairs), P = eps(Z,Pairs).
ex(3,X,Y,Z) :- Z = append(X,Y).
ex(4,X,Ys,Z) :- Z = pairx(X,Ys).
ex(5,Xs,Ys,Z) :- Z = allpairs(Xs,Ys).
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
