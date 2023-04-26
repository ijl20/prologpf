
'$fun_f'([X,Y],a(X,Y)):-!.

'$fun_f'(PartArgs,lambda(RemArgs,'$fun_f'([X,Y],Result),Result)):-append(PartArgs,RemArgs,[X,Y]),!.

p(X,Y,Z):-'$fun_f'([X,Y],Result),Z=Result.

g(X):-('$fun_f'([1],Lambda),F=Lambda),write(Lambda),nl,'$fun_eval'(F@[2],Result),X=Result.
