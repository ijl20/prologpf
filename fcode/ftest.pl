
% fprolog test script

% fprolog_test :- nl, [fprolog] -> print('fprolog loaded ok') ; print('fprolog load FAILED').

fconsult_test :- nl, fconsult('examples/max.pf') -> print('max.pf consulted ok') ; print('max.pf consult FAILED').

max_test :- nl, max([1,6,3,7,5,6,3],7) -> print('max() test ok') ; print('max() test FAILED').

map_test :- nl, fconsult('examples/map.pf'), 
            ( /* if */  q_map([ wrapped(a), wrapped(b), wrapped(c) ]) ->
                %            ( /* if */ a=a ->
              /* then */ print('map() test ok') ;
              /* else */ print('map() test FAILED')
            ).

ftest :- /* fprolog_test,*/ fconsult_test, max_test, map_test.

% :- initialization(ftest).
