#lang racket/base

;; Count the elements at the top level of a list.
;; Nested lists count as single elements.
(define (my-length lst)
  (let loop ((remaining lst) (count 0))
    (if (null? remaining)
        count
        (loop (cdr remaining) (+ count 1)))))
