'$fun_a'([_76],e(_76)):-!.
'$fun_a'(_252,lambda(_247,'$fun_a'([_235],_241),_241)):-append(_252,_247,[_235]),!.
'$fun_b'([_91],f(_351)):-!,'$fun_a'([_91],_351).
'$fun_b'(_471,lambda(_466,'$fun_b'([_454],_460),_460)):-append(_471,_466,[_454]),!.
c(_108):-'$fun_b'([1],_521),_108=g(_521).
