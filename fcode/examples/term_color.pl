%
% testing Linux terminal ascii escape sequences for color characters
%
test :- char_code(X,27), print(X), print('['),print('48;5;95;38;5;214mhello world'),print(X),print('[0m').
