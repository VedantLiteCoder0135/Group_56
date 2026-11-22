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

% evaluate_tree(+Tree, -Value)
% Evaluate a generated expression tree using integer arithmetic only.
% Division fails when the divisor is zero or the quotient is not integral.
evaluate_tree(num(N), N) :-
    integer(N),
    N >= 0.

evaluate_tree(op('+', Left, Right), Value) :-
    evaluate_tree(Left, LeftValue),
    evaluate_tree(Right, RightValue),
    Value is LeftValue + RightValue.

evaluate_tree(op('-', Left, Right), Value) :-
    evaluate_tree(Left, LeftValue),
    evaluate_tree(Right, RightValue),
    Value is LeftValue - RightValue.

evaluate_tree(op('*', Left, Right), Value) :-
    evaluate_tree(Left, LeftValue),
    evaluate_tree(Right, RightValue),
    Value is LeftValue * RightValue.

evaluate_tree(op('/', Left, Right), Value) :-
    evaluate_tree(Left, LeftValue),
    evaluate_tree(Right, RightValue),
    RightValue =\= 0,
    0 is LeftValue mod RightValue,
    Value is LeftValue // RightValue.
