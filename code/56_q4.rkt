#lang racket/base

;; Count the elements at the top level of a list.
;; Nested lists count as single elements.
(define (my-length lst)
  (let loop ((remaining lst) (count 0))
    (if (null? remaining)
        count
        (loop (cdr remaining) (+ count 1)))))

;; Apply a function to each top-level element, preserving list order.
(define (my-map f lst)
  (if (null? lst)
      '()
      (cons (f (car lst))
            (my-map f (cdr lst)))))
