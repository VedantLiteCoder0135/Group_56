---
name: prolog-dev
description: SWI-Prolog 9.x development, testing, and review guidance for Group 56 PoPL Assignment 2 problems P1 and P2.
---

# Prolog development skill (Group 56)

## Environment and assignment contract
- Use **SWI-Prolog 9.x**. Keep files at `code/56_q1.pl` and `code/56_q2.pl`.
- Allowed libraries: `lists`, `apply`, `yall`, `aggregate` only. Do not use `assert/1`, `retract/1`, or global variables (`b_setval`, `nb_setval`, etc.).
- Code files contain **definitions only**: no `initialization` directives or top-level calls, no `halt/0`, and no load-time printing.
- Use one AI request per predicate, test file, or review, not a complete-problem request. Keep actual prompts verbatim in `prompts/P1.md` and `prompts/P2.md`.
- Preserve the incremental Git history; commit genuine changes and tests as units are completed.

## Style and declarative reading
- Use lowercase `snake_case` predicate names; use descriptive `CamelCase` variables and `_` for truly unused arguments.
- Comment each predicate with its purpose and argument modes (`+Input`, `-Output`, `?Either`). Explain what relation it holds, not just how it runs.
- Keep predicates short and deterministic when appropriate; permit backtracking deliberately for generators.
- Prefer unification and relations over procedural shortcuts. Keep output separate from logic.
- Do not confuse `=` (unification), `==` (term identity), `=:=` (numeric equality), `is` (arithmetic evaluation), and `\=` (non-unification).

## P1 invariants
- Each candidate is exactly four `p(Name, Department, Language, Project)` terms, in Alex, Ben, Carla, Dana order.
- Departments, languages, and projects must each be used exactly once. Preserve quoted atoms `'Alex'`, `'Ben'`, `'Carla'`, `'Dana'`, `'AI'`, and `'c++'`.
- Each `clue(N, Solution)` checks a fully populated solution. `count_solutions(Active,N)` enforces only the clues listed in `Active`.
- The ninth clue must appear directly after a `% CLUE 9:` English comment, contain no person's name, and leave one solution.
- `main/0` must print exactly four required lines, without debugging output.

## P2 invariants
- Each original nonnegative integer is used exactly once, in the given order; insert exactly one `=` with numbers on both sides.
- Arithmetic trees support binary `+`, `-`, `*`, `/`; no unary minus or digit concatenation. Intermediate results may be negative.
- Each division requires a nonzero divisor and zero remainder at that specific subtree. Never parse a generated string back into a term for evaluation.
- Canonical output is an SWI-Prolog **string**, with no spaces. Parenthesize a left child when it has lower precedence, and a right child when it has lower or equal precedence.
- `generate_equation/2` must fail cleanly when no equation exists, including lists of length zero or one. `all_equations/2` must return sorted, duplicate-free strings; `count_equations/2` counts that list.

## Run and test
From repository root:
```sh
swipl -q -f code/56_q1.pl -g main -t halt
swipl -q -f code/56_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8],N),writeln(N)" -t halt
swipl -q -f code/56_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8,9],N),writeln(N)" -t halt
swipl -q -f code/56_q2.pl -g "all_equations([4,2,5,3],Es),writeln(Es)" -t halt
swipl -q -f code/56_q2.pl -g "count_equations([2,4,8],N),writeln(N)" -t halt
swipl -q -s tests/q1_tests.pl -g run_tests -t halt
swipl -q -s tests/q2_tests.pl -g run_tests -t halt
```
Expected reference checks: P1 first eight clues count 3, first nine count 1; P2 `[4,2,5,3]` count 7, `[2,4,8]` count 1, `[2,3,4]` count 0. Verify actual results in SWI-Prolog.

## Self-review checklist before responding
1. Is the response limited to **one unit of work** (one predicate, function, test file, or review)?
2. Are all predicates callable by the grader in its documented modes and file paths?
3. Does code avoid forbidden state, initialization, printing, and libraries?
4. Can empty and unsatisfiable inputs fail or return `[]` as required, without errors or loops?
5. Do tests check duplicates, solution uniqueness, division-by-zero, non-exact division, precedence, parentheses, and repeated numbers where relevant?
6. Does the explanation distinguish verified tool execution from predicted results?
7. Are prompts recorded exactly as issued and commits attributed to genuine work?

## Common AI-generated Prolog failure modes
- Accidentally using `=` instead of arithmetic `=:=`, or calling `is` before its right-hand variables are bound.
- Using `\=` on variables before instantiation, unintentionally rejecting or allowing solutions.
- Adding cuts that prune valid answers, or producing duplicate solutions via multiple derivations.
- Failing to constrain both sides of the `=` to nonempty number sequences.
- Using floating-point `/` rather than exact integer division (`mod` followed by `//`).
- Ignoring division-by-zero in a nested subtree.
- Losing expression-tree distinctions through insufficient parentheses.
- Returning atoms instead of strings or sorting before formatting consistently.
- Hard-coding expected answers, including the ninth-clue result, instead of deriving them.
- Printing test/debug text from loaded files, which breaks exact-output grading.
