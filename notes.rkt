#lang racket
; Week 1
(and #f (/ 1 0)) ; OK, short circut; and not a func
(define (myand a b) (and a b))
; (myand #f (/ 1 0)) ; not OK, eager eval
(define a (cons 1 2))
(list? a) ; #f. a pair, not a list

; Week 2
; Lab1
(list) ; '()
(append) ; '()
(append '(1) 2) ; OK, '(1 . 2)
; (length) ; error
; (define foo foo) ; error, foo undefined
(define (bar) bar) ; OK, bar already defined
; (define baz (baz)) ; error, baz undefined
(define (qux) (qux)) ; OK 
qux ; #<procedure:qux>
; (qux) ; infinite loop