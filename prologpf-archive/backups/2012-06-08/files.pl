
/* load a prolog source file 'File' into a list term 'Src' */

input_file(File, Src) :- 
    open(File,read,ID),
    read_file(ID,Src),
    close(ID).

    % read a term into the head of the result list,
    % then recursively call again to add rest of source to tail of list
read_file(ID,[Clause|Rest_of_file]) :-
    read_term(ID,Clause,[]), Clause \= end_of_file,!,
    writeq(Clause),write(.), nl,
    read_file(ID, Rest_of_file).
    
read_file(_,[]). % this clause is only reached when above fails at end_of_file

/* write a list of Prolog clause terms to a file */

output_file(File, Src) :-
    open(File,write,ID),
    write_file(ID, Src),
    close(ID).

write_file(ID, [Clause|Rest_of_file]) :-
    pretty_write(ID,Clause), 
    !,
    write_file(ID,Rest_of_file).

write_file(_,[]).

pretty_write(ID,(Head :- Body)) :-
    !,
    writeq(ID,Head), 
    write(ID,':-'), nl(ID),
    pretty_write_body(ID,Body),
    write(ID,.), nl(ID), nl(ID). % write a period and blank line after each clause

pretty_write(ID,Goal) :- 
    writeq(ID,Goal), 
    write(ID,.), nl(ID), nl(ID).

pretty_write_body(ID,(A,B)) :-
    !,
    write(ID,'    '),
    writeq(ID,A), 
    write(ID,','), nl(ID),
    pretty_write_body(ID,B).

pretty_write_body(ID,Term) :-
    write(ID,'    '),
    writeq(ID,Term).
    
/* Assert all the clauses in a list to current Prolog database */

assert_list([]).
assert_list([X|Rest]) :- assertz(X),assert_list(Rest).
