#lang racket/base

;; Return the inorder values of a tree: left, node, right.
;; A tree is either '() or (value left-subtree right-subtree).
;; Using an accumulator avoids forbidden append and reverse.
(define (inorder-values tree)
  (letrec ((visit
            (lambda (node rest)
              (if (null? node)
                  rest
                  (visit (cadr node)
                         (cons (car node)
                               (visit (caddr node) rest)))))))
    (visit tree '())))

;; Return preorder values: node, left, right.
(define (preorder-values tree)
  (letrec ((visit
            (lambda (node rest)
              (if (null? node)
                  rest
                  (cons (car node)
                        (visit (cadr node)
                               (visit (caddr node) rest)))))))
    (visit tree '())))

;; Return postorder values: left, right, node.
(define (postorder-values tree)
  (letrec ((visit
            (lambda (node rest)
              (if (null? node)
                  rest
                  (visit (cadr node)
                         (visit (caddr node)
                                (cons (car node) rest)))))))
    (visit tree '())))
