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

;; Insert x at the front of every list shorter than n.
;; Measure each list before inserting; recurse into nested lists,
;; including empty lists.
(define (insert-if-short x lst n)
  (let ((updated
         (my-map (lambda (item)
                   (if (or (pair? item) (null? item))
                       (insert-if-short x item n)
                       item))
                 lst)))
    (if (< (my-length lst) n)
        (cons x updated)
        updated)))

;; Build a recursive list transformer using a length predicate.
;; The list length is checked before any insertion takes place.
(define (make-inserter x len-ok?)
  (letrec ((insert-list
            (lambda (lst)
              (let ((updated
                     (my-map (lambda (item)
                               (if (or (pair? item) (null? item))
                                   (insert-list item)
                                   item))
                             lst)))
                (if (len-ok? (my-length lst))
                    (cons x updated)
                    updated)))))
    insert-list))
