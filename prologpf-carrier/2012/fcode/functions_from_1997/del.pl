
:- main.
del(X,[X|Y],Y).
del(X,[Y|Z], [Y|Z1]) :- del(X,Z,Z1).

