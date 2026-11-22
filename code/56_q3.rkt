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

;; Print the inorder traversal on one line.
(define (print-inorder tree)
  (display (inorder-values tree))
  (newline))

;; Print inorder, preorder, and postorder traversals on separate lines.
(define (print-all-traversals tree)
  (display (inorder-values tree))
  (newline)
  (display (preorder-values tree))
  (newline)
  (display (postorder-values tree))
  (newline))

;; The empty tree has height 0; otherwise take the taller subtree.
(define (tree-height tree)
  (if (null? tree)
      0
      (+ 1 (max (tree-height (cadr tree))
                (tree-height (caddr tree))))))

;; A leaf is a nonempty node with both subtrees empty.
(define (leaf-count tree)
  (cond
    ((null? tree) 0)
    ((and (null? (cadr tree)) (null? (caddr tree))) 1)
    (else (+ (leaf-count (cadr tree))
             (leaf-count (caddr tree))))))

;; Print (height leaf-count) on one line.
(define (print-height-and-leaves tree)
  (display (list (tree-height tree) (leaf-count tree)))
  (newline))
