:- use_module(library(lists)).

% expression_tree(+Numbers, -Tree)
% Build all binary arithmetic trees while keeping Numbers in their original order.
% A leaf is num(N); an internal node is op(Operator, LeftTree, RightTree).
expression_tree([N], num(N)) :-
    integer(N),
    N >= 0.

expression_tree(Numbers, op(Operator, LeftTree, RightTree)) :-
    append(LeftNumbers, RightNumbers, Numbers),
    LeftNumbers = [_|_],
    RightNumbers = [_|_],
    expression_tree(LeftNumbers, LeftTree),
    expression_tree(RightNumbers, RightTree),
    member(Operator, ['+', '-', '*', '/']).
