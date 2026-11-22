% Run from the repository root:
% swipl -q -s tests/q2_tests.pl -g run_tests -t halt
:- consult('../code/56_q2.pl').

:- begin_tests(q2).

% Check the generator before filtering expressions by their arithmetic values.
test(two_number_expression_trees) :-
    findall(Tree, expression_tree([4,2], Tree), Trees),
    length(Trees, 4).

test(input_order_preserved) :-
    findall(Text,
            (expression_tree([1,2,3], Tree),
             format_tree(Tree, Text)),
            Texts),
    assertion(member("1+2*3", Texts)),
    assertion(\+ member("2+1*3", Texts)).

% Arithmetic is integer-only; invalid subexpression divisions fail.
test(exact_division) :-
    evaluate_tree(op('/',num(8),num(4)), 2).

test(non_exact_division, [fail]) :-
    evaluate_tree(op('/',num(5),num(2)), _).

test(divide_by_zero, [fail]) :-
    evaluate_tree(op('/',num(5),num(0)), _).

test(nested_non_exact_division, [fail]) :-
    evaluate_tree(op('+',num(1),op('/',num(5),num(2))), _).

test(negative_intermediate_result) :-
    evaluate_tree(op('*',op('-',num(3),num(5)),num(2)), -4).

% Canonical strings distinguish the two different parse trees.
test(parenthesize_left_lower_precedence) :-
    format_tree(op('*',op('+',num(4),num(2)),num(3)), "(4+2)*3").

test(omit_unneeded_parentheses) :-
    format_tree(op('+',num(4),op('*',num(2),num(3))), "4+2*3").

test(parenthesize_right_equal_precedence) :-
    format_tree(op('-',num(1),op('-',num(2),num(3))), "1-(2-3)").

test(left_associative_no_parentheses) :-
    format_tree(op('-',op('-',num(1),num(2)),num(3)), "1-2-3").

test(parenthesize_right_multiplication) :-
    format_tree(op('/',num(8),op('*',num(4),num(2))), "8/(4*2)").

test(multiplication_left_associative) :-
    format_tree(op('*',op('/',num(8),num(4)),num(2)), "8/4*2").

test(format_returns_string) :-
    format_tree(op('+',num(1),num(2)), Text),
    assertion(string(Text)).

% Official assignment examples and an additional repeated-number case.
test(official_seven_equations) :-
    Expected = ["4*2-5=3", "4*2=5+3", "4-2=5-3", "4/2=5-3",
                "4=2*(5-3)", "4=2+(5-3)", "4=2+5-3"],
    all_equations([4,2,5,3], Actual),
    assertion(Actual == Expected),
    count_equations([4,2,5,3], 7).

test(official_single_equation) :-
    all_equations([2,4,8], ["2*4=8"]),
    count_equations([2,4,8], 1).

test(official_no_equations) :-
    all_equations([2,3,4], []),
    count_equations([2,3,4], 0).

test(empty_list) :-
    all_equations([], []),
    count_equations([], 0).

test(singleton_list) :-
    all_equations([5], []),
    count_equations([5], 0).

test(generate_empty_fails, [fail]) :-
    generate_equation([], _).

test(generate_singleton_fails, [fail]) :-
    generate_equation([5], _).

test(generate_unsolvable_fails, [fail]) :-
    generate_equation([2,3,4], _).

test(generate_valid_equation) :-
    once(generate_equation([4,2,5,3], Equation)),
    all_equations([4,2,5,3], Equations),
    assertion(member(Equation, Equations)),
    assertion(string(Equation)).

test(repeated_numbers) :-
    all_equations([1,1], ["1=1"]),
    count_equations([1,1], 1).

test(zero_values) :-
    all_equations([0,0], ["0=0"]),
    count_equations([0,0], 1).

test(sorted_without_duplicates) :-
    all_equations([4,2,5,3], Equations),
    sort(Equations, Equations).

:- end_tests(q2).
