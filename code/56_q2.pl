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

% operator_precedence(+Operator, -Precedence)
% Larger numbers bind more tightly.
operator_precedence('+', 1).
operator_precedence('-', 1).
operator_precedence('*', 2).
operator_precedence('/', 2).

% format_tree(+Tree, -Text)
% Turn a tree into its unique canonical, space-free Prolog string.
format_tree(num(N), Text) :-
    number_string(N, Text).

format_tree(op(Operator, Left, Right), Text) :-
    operator_precedence(Operator, ParentPrec),
    format_child(Left, ParentPrec, left, LeftText),
    format_child(Right, ParentPrec, right, RightText),
    atom_string(Operator, OperatorText),
    string_concat(LeftText, OperatorText, Prefix),
    string_concat(Prefix, RightText, Text).

% Left child: parentheses only at lower precedence.
% Right child: parentheses at lower OR equal precedence.
format_child(Tree, ParentPrec, Side, Text) :-
    format_tree(Tree, BareText),
    (   Tree = op(ChildOperator, _, _),
        operator_precedence(ChildOperator, ChildPrec),
        (   ChildPrec < ParentPrec
        ;   Side == right, ChildPrec =:= ParentPrec
        )
    ->  string_concat("(", BareText, Opened),
        string_concat(Opened, ")", Text)
    ;   Text = BareText
    ).
