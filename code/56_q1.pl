:- use_module(library(lists)).

% Generate every complete assignment, with each attribute used exactly once.
% The four people always appear in the required order.
candidate_solution([
    p('Alex', AlexDept, AlexLang, AlexProject),
    p('Ben', BenDept, BenLang, BenProject),
    p('Carla', CarlaDept, CarlaLang, CarlaProject),
    p('Dana', DanaDept, DanaLang, DanaProject)
]) :-
    permutation([research, development, design, testing],
                [AlexDept, BenDept, CarlaDept, DanaDept]),
    permutation([python, java, 'c++', javascript],
                [AlexLang, BenLang, CarlaLang, DanaLang]),
    permutation(['AI', web, embedded, data],
                [AlexProject, BenProject, CarlaProject, DanaProject]).

% Clue 1: The AI-project friend is neither in research nor Dana.
clue(1, Solution) :-
    member(p(Name, Dept, _, 'AI'), Solution),
    Name \= 'Dana',
    Dept \= research.

% Clue 2: Alex is not in development and does not prefer C++.
clue(2, Solution) :-
    member(p('Alex', Dept, Lang, _), Solution),
    Dept \= development,
    Lang \= 'c++'.

% Clue 3: The testing-department friend likes Python.
clue(3, Solution) :-
    member(p(_, testing, python, _), Solution).

% Clue 4: Ben prefers web projects and does not work in testing.
clue(4, Solution) :-
    member(p('Ben', Dept, _, web), Solution),
    Dept \= testing.

% Clue 5: The Java-speaking friend works in design.
clue(5, Solution) :-
    member(p(_, design, java, _), Solution).

% Clue 6: Carla does not prefer embedded and is not in development.
clue(6, Solution) :-
    member(p('Carla', Dept, _, Project), Solution),
    Project \= embedded,
    Dept \= development.

% Clue 7: Dana does not use Java and works in research or testing.
clue(7, Solution) :-
    member(p('Dana', Dept, Lang, _), Solution),
    Lang \= java,
    (Dept = research ; Dept = testing).

% Clue 8: The data-project friend works in research and does not use JavaScript.
clue(8, Solution) :-
    member(p(_, research, Lang, data), Solution),
    Lang \= javascript.


% Keep only complete assignments satisfying all original eight clues.
valid_solution(Solution) :-
    candidate_solution(Solution),
    clue(1, Solution),
    clue(2, Solution),
    clue(3, Solution),
    clue(4, Solution),
    clue(5, Solution),
    clue(6, Solution),
    clue(7, Solution),
    clue(8, Solution).

% Print the first valid solution in the prescribed four-line format.
main :-
    once(valid_solution([
        p('Alex', AD, AL, AP),
        p('Ben', BD, BL, BP),
        p('Carla', CD, CL, CP),
        p('Dana', DD, DL, DP)
    ])),
    format('Alex = [~w, ~w, ~w]~n', [AD, AL, AP]),
    format('Ben = [~w, ~w, ~w]~n', [BD, BL, BP]),
    format('Carla = [~w, ~w, ~w]~n', [CD, CL, CP]),
    format('Dana = [~w, ~w, ~w]~n', [DD, DL, DP]).

% Count assignments satisfying precisely the clue numbers listed in Active.
% An empty Active list imposes no clues.
count_solutions(Active, N) :-
    findall(Solution,
            (candidate_solution(Solution),
             forall(member(Number, Active), clue(Number, Solution))),
            Solutions),
    length(Solutions, N).

% CLUE 9: The friend who prefers AI projects works in the testing department.
clue(9, Solution) :-
    member(p(_, testing, _, 'AI'), Solution).
