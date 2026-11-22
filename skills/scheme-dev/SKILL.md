---
name: scheme-dev
description: Develop, test, and review Group 56's Scheme solutions for CS F301 Assignment 2 (S1 binary trees and S2 nested-list insertion).
---

# Scheme Development Skill — Group 56

## Environment and scope
- Target Racket **8.x**, using `#lang racket/base` in `code/56_q3.rkt` and `code/56_q4.rkt`.
- Implement one function, test file, or review at a time. Preserve existing working definitions.
- Solution files contain **definitions only**: no `require`, top-level examples, output, `provide`, or calls to the assignment functions. The grader supplies its own calls.
- Name functions descriptively (`inorder-values`, `my-length`, `make-inserter`). Explain recursive base cases and the meaning of parameters in short comments.
- Do not use mutation; pass information by parameters and return values.

## Permitted Scheme forms and built-ins
Only use the following in **solution files**:
- `define`, `lambda`, `let`, `let*`, `letrec`, named `let`, `if`, `cond` (with `else`), `and`, `or`, `not`, `begin`, `'` (quote)
- `cons`, `car`, `cdr`, `list`, and `car`/`cdr` compositions up to four levels (such as `cadr`, `caddr`, `cdddr`)
- `null?`, `pair?`, `eq?`, `assq`, `assoc`
- `+`, `-`, `*`, `<`, `>`, `<=`, `>=`, `=`, `max`
- `display`, `newline`; additionally `read` for S2 only

Forbidden in solution files: `set!` and other mutation, vectors, hash tables, strings, `do`/`for` loops, and built-ins `length`, `append`, `reverse`, `map`, `filter`, `member`, `memq`, `list-ref`, `list-tail`. Write recursive helpers (e.g. `my-length`, `my-map`) instead. Do not import testing libraries into solution files.

## S1 (Q3): Binary Tree Traversals
- Tree is `()` or `(value left right)`. Visit the left subtree before the right.
- Inorder = left, node, right; preorder = node, left, right; postorder = left, right, node.
- Height of empty tree = 0; otherwise `1 + max(left height, right height)`.
- A leaf has both subtrees empty; empty tree has zero leaves.
- `(print-inorder tree)` prints one list and newline.
- `(print-all-traversals tree)` prints inorder, preorder, postorder lists on **three separate lines**, each ending in newline.
- `(print-height-and-leaves tree)` prints `(height leaf-count)` followed by newline.
- Avoid quadratic repeated appending in traversal helpers; use accumulator-based recursion where appropriate.

## S2 (Q4): Conditional Nested-List Insertion
- `(my-length lst)` counts **top-level** elements, including nested sublists as single elements.
- `(my-map f lst)` maps a function over top-level elements in original order.
- Every list at every nesting depth, **including the top-level list and empty lists**, is eligible for insertion.
- Base each insertion decision on the list's **original** length, before insertion. Process nested sublists recursively; leave atoms unchanged.
- `(make-inserter x len-ok?)` returns a function that transforms a list recursively according to predicate `len-ok?`.
- The final `(insert-if-short x lst n)` must use `make-inserter`, with exactly **one** definition remaining.
- `(print-insert-result)` reads `x`, `lst`, `n` in that order using `read`, and prints only the resulting list and a newline. Never call it at top level.
- Stress-test 10,000-element lists and nesting depth 100, and avoid unnecessary multiple traversals.

## Running and testing
From the repository root:
```sh
racket code/56_q3.rkt
racket code/56_q4.rkt
racket tests/q3_tests.rkt
racket tests/q4_tests.rkt
```
Loading either solution directly should print **nothing**.

For interactive checks, enter the module namespace:
```sh
racket -i -e '(enter! "code/56_q3.rkt")'
racket -i -e '(enter! "code/56_q4.rkt")'
```
Run each command in a separate session. For Q4 stdin testing, invoke `(print-insert-result)` in the REPL and then supply the three data values; do not add top-level calls to the solution.

Tests may use `rackunit`, `rackunit/text-ui`, `racket/runtime-path`, and `racket/port` (for `with-output-to-string`), but these are **test-file-only** dependencies. A test file must import or load the solution appropriately without requiring solution-file exports that are not present.

## Self-review checklist before proposing a change
1. Is the requested work scoped to one function, one test file, or one review?
2. Are all solution built-ins explicitly permitted? Are there any accidental `require`, `set!`, `map`, `append`, or `length` calls?
3. Do `()` and single-element structures behave correctly?
4. Are output lines, spaces, list notation and final newlines exact?
5. Does Q4 evaluate original list lengths, recurse into empty sublists, and avoid treating atoms as lists?
6. Does Q4 retain only one `insert-if-short` definition using `make-inserter`?
7. Are there no top-level calls or printed messages in either solution file?
8. Do the example, edge-case and stress tests pass under the target Racket version?
9. Are prompt records the exact messages actually used, rather than reconstructed or polished substitutes?
10. Does each Git commit reflect a real, reviewable increment attributable to its contributor?

## Common AI failure modes
- Using convenient but **forbidden** built-ins (`append`, `reverse`, built-in `map`, `length`, `filter`).
- Confusing inorder/preorder/postorder, or computing leaf count as the number of nodes.
- Losing output newlines or printing test/debug output upon module load.
- Failing to process the top-level list or `()` as an insertable list.
- Checking lengths after inserting, causing wrong nested results.
- Treating an empty nested list as an atom, or recursing into atoms.
- Leaving an outdated duplicate definition of `insert-if-short`.
- Making algorithms excessively slow on long inputs, or assuming hidden tests are tiny.
- Writing tests that use `with-output-to-string` without importing `racket/port`.
- Running a `#lang racket/base` module with `racket -i -f` and assuming internal definitions automatically enter the REPL.
- Recording AI prompts that were never actually submitted, or grouping several unrelated functions in a single prompt.
