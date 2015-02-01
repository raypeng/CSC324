#lang plai
(define-syntax my-or
  (syntax-rules ()
    [(my-or p q)
     (if p #t q)]))

(test 
 (my-or (> 10 3) (/ 1 0))
 #t)

; Write a macro for "my-and"
(define-syntax my-and
  (syntax-rules ()
    [(my-and p q)
     (if p q #f)]))

(test
 (my-and (> 10 3) (< 1 2))
 #t)
(test
 (my-and (> 10 3) (< 2 2))
 #f)

; Recursive macro for "or"
(define-syntax my-or-rec
  (syntax-rules ()
    [(my-or-rec p) p]
    [(my-or-rec p q ...)
     (if p #t (my-or-rec q ...))]))

(test
 (my-or-rec #f #f)
 #f)
(test
 (my-or-rec #t #f #t #f)
 #t)
