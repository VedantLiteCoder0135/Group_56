% Run from the repository root:
% swipl -q -s tests/q1_tests.pl -g run_tests -t halt
:- consult('../code/56_q1.pl').

:- begin_tests(q1).

test(all_candidates_count) :-
    findall(S, candidate_solution(S), Solutions),
    length(Solutions, 13824).

test(candidate_has_correct_order_and_distinct_attributes) :-
    once(candidate_solution([
        p('Alex', D1, L1, P1), p('Ben', D2, L2, P2),
        p('Carla', D3, L3, P3), p('Dana', D4, L4, P4)
    ])),
    sort([D1,D2,D3,D4], [design,development,research,testing]),
    sort([L1,L2,L3,L4], ['c++',java,javascript,python]),
    sort([P1,P2,P3,P4], ['AI',data,embedded,web]).

test(original_clues_count) :-
    count_solutions([1,2,3,4,5,6,7,8], 3).

test(repaired_clues_count) :-
    count_solutions([1,2,3,4,5,6,7,8,9], 1).

test(no_clues_count) :-
    count_solutions([], 13824).

test(repaired_solution_is_expected) :-
    once((candidate_solution(S),
          forall(between(1,9,N), clue(N,S)))),
    assertion(S == [
        p('Alex',design,java,embedded),
        p('Ben',development,javascript,web),
        p('Carla',testing,python,'AI'),
        p('Dana',research,'c++',data)
    ]).

test(main_outputs_exactly_four_lines) :-
    with_output_to(string(Output), main),
    split_string(Output, "\n", "\n", Lines),
    assertion(Lines = [_,_,_,_]),
    sub_string(Output, 0, _, _, "Alex = ["),
    sub_string(Output, _, _, _, "Ben = ["),
    sub_string(Output, _, _, _, "Carla = ["),
    sub_string(Output, _, _, _, "Dana = [").

:- end_tests(q1).
