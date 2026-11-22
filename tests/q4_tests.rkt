#lang racket/base

;; Test harness only. The submitted solution remains definitions-only.
(require rackunit
         rackunit/text-ui
         racket/runtime-path)

(define-runtime-path solution-file "../code/56_q4.rkt")
(define module-id `(file ,(path->string solution-file)))
(dynamic-require module-id #f)
(define solution-ns (module->namespace module-id))

;; Access private definitions without adding provide forms to the solution.
(define (solution-function name)
  (parameterize ([current-namespace solution-ns])
    (eval name)))

(define my-length (solution-function 'my-length))
(define my-map (solution-function 'my-map))
(define insert-if-short (solution-function 'insert-if-short))
(define make-inserter (solution-function 'make-inserter))
(define print-insert-result (solution-function 'print-insert-result))

(define (capture-run input-text)
  (define output (open-output-string))
  (parameterize ([current-input-port (open-input-string input-text)]
                 [current-output-port output])
    (print-insert-result))
  (get-output-string output))

(define q4-tests
  (test-suite
   "Q4: nested conditional insertion"

   (test-case "my-length: empty" (check-equal? (my-length '()) 0))
   (test-case "my-length: nested lists count once"
     (check-equal? (my-length '((1 2) () (3 (4)) a)) 4))
   (test-case "my-map: empty" (check-equal? (my-map (lambda (x) x) '()) '()))
   (test-case "my-map: order and transformation"
     (check-equal? (my-map (lambda (x) (* x 2)) '(1 2 3)) '(2 4 6)))

   (test-case "official example 1"
     (check-equal? (insert-if-short 42 '((1 2) (3 4 5) (6) ()) 3)
                   '((42 1 2) (3 4 5) (42 6) (42))))
   (test-case "official example 2"
     (check-equal? (insert-if-short 0 '(((1) 2) (3) ((4 5 6) ())) 3)
                   '((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))))
   (test-case "official example 3: empty root inserted"
     (check-equal? (insert-if-short 7 '() 3) '(7)))
   (test-case "official example 4: threshold zero"
     (check-equal? (insert-if-short 7 '() 0) '()))

   (test-case "empty nested lists are transformed"
     (check-equal? (insert-if-short 'x '(() (())) 3)
                   '(x (x) (x (x)))))
   (test-case "root treated like every nested list"
     (check-equal? (insert-if-short 'x '(a (b)) 3)
                   '(x a (x b))))
   (test-case "list exactly at threshold unchanged"
     (check-equal? (insert-if-short 'x '(a b) 2) '(a b)))
   (test-case "original lengths used, not post-insertion lengths"
     (check-equal? (insert-if-short 'x '((a) (b)) 3)
                   '(x (x a) (x b))))
   (test-case "all atom types preserved"
     (check-equal? (insert-if-short 'z '(a 12 (b 4)) 3)
                   '(a 12 (z b 4))))
   (test-case "n = 0 leaves nested structure unchanged"
     (check-equal? (insert-if-short 9 '((1) () ((2))) 0)
                   '((1) () ((2)))))

   (test-case "make-inserter: custom equality predicate"
     (define transformer (make-inserter 'x (lambda (len) (= len 1))))
     (check-equal? (transformer '(a (b) ())) '(a (x b) ())))
   (test-case "make-inserter: predicate never true"
     (check-equal? ((make-inserter 'x (lambda (len) (< len 0))) '((a) ()))
                   '((a) ())))

   (test-case "print-insert-result: exact stdout, example 1"
     (check-equal? (capture-run "42\n((1 2) (3 4 5) (6) ())\n3\n")
                   "((42 1 2) (3 4 5) (42 6) (42))\n"))
   (test-case "print-insert-result: empty root"
     (check-equal? (capture-run "7\n()\n3\n") "(7)\n"))
   (test-case "print-insert-result: n zero"
     (check-equal? (capture-run "7\n()\n0\n") "()\n"))

   (test-case "10,000 top-level elements remain unchanged at threshold 1"
     (define input (build-list 10000 (lambda (i) i)))
     (check-equal? (insert-if-short 'x input 1) input))
   (test-case "10,000 top-level elements receive exactly one insertion"
     (define input (build-list 10000 (lambda (i) i)))
     (check-equal? (insert-if-short 'x input 10001) (cons 'x input)))
   (test-case "100 nested levels, all short lists transformed"
     (define input
       (for/fold ([current '()]) ([i (in-range 100)])
         (list current)))
     (define expected
       (for/fold ([current '(x)]) ([i (in-range 100)])
         (list 'x current)))
     (check-equal? (insert-if-short 'x input 2) expected))))

(define failures (run-tests q4-tests))
(when (positive? failures) (exit 1))
