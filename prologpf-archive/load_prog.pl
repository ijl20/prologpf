
/* load a prolog source file 'File' into a list term 'Src' */

load_prog(File, Src) :- 
    open(File,read,ID),
    read_file(ID,Src),
    close(ID).

    % read a term into the head of the result list,
    % then recursively call again to add rest of source to tail of list
read_file(ID,[Clause|Rest_of_file]) :-
    read_term(ID,Clause,[]), Clause \= end_of_file,!,
    write(Clause), nl,
    read_file(ID, Rest_of_file).
    
read_file(_,[]). % this clause is only reached when above fails at end_of_file