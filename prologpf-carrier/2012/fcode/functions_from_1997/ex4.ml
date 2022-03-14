(* routes cst ex 4 *)

val pairs = [(1,2),(2,3),(3,4),(1,5),(5,4),(1,6),(1,4),(1,3),(2,4)];

(* startpoints *)

fun sps([],z)           = []
 |  sps((x,y)::pairs,z) = if (y<>z)
                                  then sps(pairs,z)
                                  else x::sps(pairs,z);
(* endpoints *)

fun eps(z,[])           = []
 |  eps(z,(x,y)::pairs) = if (x<>z)
                                  then eps(z,pairs)
                                  else y::eps(z,pairs);

fun allpairs([],ys)     = []
 |  allpairs(x::xs,ys)  =
      let fun pairx([])    = []
           |  pairx(y::ys) = (x,y)::pairx(ys)
      in
        pairx(ys)@allpairs(xs,ys)
      end;

infix 5 mem;

fun x mem []      = false 
 |  x mem (y::ys) = (x=y) orelse (x mem ys);

fun addnew((x,y),[]) = [(x,y)]
 |  addnew((x,y),pairs) = 
      let
        fun addall([],pairs)    = pairs
         |  addall(p::ps,pairs) = addall(ps,addnew(p,pairs))
      in
        if ( (x,y) mem pairs ) orelse (x=y)
        then pairs
        else addall(allpairs(sps(pairs,x),[y])@allpairs([x],eps(y,pairs)),(x,y)::pairs)
      end;

fun routes [] = []
 |  routes ((x,y)::pairs) = addnew((x,y),routes(pairs));

