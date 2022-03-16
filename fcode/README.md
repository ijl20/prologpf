# PrologF fcode

Adding functions to Prolog

# Basic test

Functional support can be tested with:
```
?- [prologf].
true.

?- [ftest].
true.

?- ftest.

'max.pl consulted ok'
'max() test ok'
'map() test ok'
true.

?- fib(4,X).
X = 10.

?-
```

# Test with Fibonacci function

Create Fibonacci functional code e.g. in file `examples/fib.pf`:
```
fun fib(0) = 0;
    fib(1) = 1;
    fib(N) = N + fib(N-1).

fib(X,Y) :- Y = fib(X). % map the fib function to a convenient relation for ease of testing.
```
The `fib(X,Y)` relation is a testing convenience.

In `swipl`:
```
?- [prologf].
true.

?- fconsult('examples/fib.pf').
true.

?- fib(4,X).
X = 10.

?-
```
