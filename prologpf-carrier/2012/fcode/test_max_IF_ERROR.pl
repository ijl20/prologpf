'$fun_max_list'([[X]],X):-!.

'$fun_max_list'([[Head|Tail]],Result):-!,
    '$fun_max_list'([Tail],Tail_Max),
    '$fun_='([M,Tail_Max],EqTrueFalse),
    '$fun_aux_if'(Head>M,M1=Head,M1=M),
    '$fun_if'([EqTrueFalse then M1],Result).
    
'$fun_max_list'(_669,lambda(_664,'$fun_max_list'([_652],_658),_658)):-append(_669,_664,[_652]),!.

max_goal(_144):-'$fun_max_list'([[3,8,2,9,1,6]],_712),_144=_712.
