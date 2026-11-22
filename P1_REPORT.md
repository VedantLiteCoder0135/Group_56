# P1 Report: Department Assignment Puzzle

## Number of solutions for clues 1–8

Query:

```prolog
?- count_solutions([1,2,3,4,5,6,7,8], N).
```

**N = 3.** Therefore, the eight original clues do not determine a unique assignment: three complete assignments satisfy them.

## Repair with clue 9

Added clue:

> The friend who prefers AI projects works in the testing department.

Query:

```prolog
?- count_solutions([1,2,3,4,5,6,7,8,9], N).
```

**N = 1.** The ninth clue distinguishes one of the three assignments without referring to a friend by name.

The unique repaired solution is:

```text
Alex = [design, java, embedded]
Ben = [development, javascript, web]
Carla = [testing, python, AI]
Dana = [research, c++, data]
```

Counts and repaired solution were checked by independent enumeration of all assignments. Verify again with SWI-Prolog 9.x before submission.
