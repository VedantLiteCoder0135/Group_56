#lang racket/base

;; Q3 test suite. Run from the repository root:
;;   racket tests/q3_tests.rkt
;; Racket's testing libraries are used only here, not in code/56_q3.rkt.
(require rackunit
         rackunit/text-ui
         racket/runtime-path
         racket/port)

(define-runtime-path q3-file "../code/56_q3.rkt")
(dynamic-require q3-file #f)
(define q3-namespace (module->namespace q3-file))

;; Access definitions without requiring any exports from the submission file.
(define (q3-function name)
  (parameterize ([current-namespace q3-namespace])
    (eval name)))

(define print-inorder (q3-function 'print-inorder))
(define print-all-traversals (q3-function 'print-all-traversals))
(define print-height-and-leaves (q3-function 'print-height-and-leaves))

(define (capture function tree)
  (with-output-to-string (lambda () (function tree))))

(define balanced
  '(4 (2 (1 () ()) (3 () ()))
      (6 (5 () ()) (7 () ()))))
(define right-skewed '(1 () (2 () (3 () ()))))
(define left-skewed '(3 (2 (1 () ()) ()) ()))
(define symbols '(a (b () ()) (c () ())))
(define singleton '(9 () ()))
(define empty '())

(define suite
  (test-suite
   "Q3 Binary Tree Traversals"

   (test-case "balanced tree: inorder"
     (check-equal? (capture print-inorder balanced)
                   "(1 2 3 4 5 6 7)\n"))
   (test-case "balanced tree: all traversals"
     (check-equal? (capture print-all-traversals balanced)
                   "(1 2 3 4 5 6 7)\n(4 2 1 3 6 5 7)\n(1 3 2 5 7 6 4)\n"))
   (test-case "balanced tree: height and leaves"
     (check-equal? (capture print-height-and-leaves balanced) "(3 4)\n"))

   (test-case "right-skewed tree: inorder"
     (check-equal? (capture print-inorder right-skewed) "(1 2 3)\n"))
   (test-case "right-skewed tree: all traversals"
     (check-equal? (capture print-all-traversals right-skewed)
                   "(1 2 3)\n(1 2 3)\n(3 2 1)\n"))
   (test-case "right-skewed tree: height and leaves"
     (check-equal? (capture print-height-and-leaves right-skewed) "(3 1)\n"))

   (test-case "left-skewed tree: all traversals"
     (check-equal? (capture print-all-traversals left-skewed)
                   "(1 2 3)\n(3 2 1)\n(1 2 3)\n"))
   (test-case "left-skewed tree: height and leaves"
     (check-equal? (capture print-height-and-leaves left-skewed) "(3 1)\n"))

   (test-case "symbol-valued tree: inorder"
     (check-equal? (capture print-inorder symbols) "(b a c)\n"))
   (test-case "symbol-valued tree: all traversals"
     (check-equal? (capture print-all-traversals symbols)
                   "(b a c)\n(a b c)\n(b c a)\n"))
   (test-case "symbol-valued tree: height and leaves"
     (check-equal? (capture print-height-and-leaves symbols) "(2 2)\n"))

   (test-case "single node: inorder"
     (check-equal? (capture print-inorder singleton) "(9)\n"))
   (test-case "single node: all traversals"
     (check-equal? (capture print-all-traversals singleton)
                   "(9)\n(9)\n(9)\n"))
   (test-case "single node: height and leaves"
     (check-equal? (capture print-height-and-leaves singleton) "(1 1)\n"))

   (test-case "empty tree: inorder"
     (check-equal? (capture print-inorder empty) "()\n"))
   (test-case "empty tree: all traversals"
     (check-equal? (capture print-all-traversals empty) "()\n()\n()\n"))
   (test-case "empty tree: height and leaves"
     (check-equal? (capture print-height-and-leaves empty) "(0 0)\n"))))

(define failures (run-tests suite))
(exit (if (zero? failures) 0 1))
