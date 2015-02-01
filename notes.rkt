#lang racket
; Week 1
(and #f (/ 1 0)) ; OK, short circut; and not a func
(define (myand a b) (and a b))
; (myand #f (/ 1 0)) ; not OK, eager eval
(define a (cons 1 2))
(list? a) ; #f. a pair, not a list

; Week 2
; tail recursion and tail call elimination
(define (f-rec n)
  (if (= n 0)
      0
      (f-rec (- n 1))))
(f-rec 10000) ; no stack overflow due to Tail Call Elimination

(define (sum-helper lst acc)
  (if (empty? lst)
      acc
      (sum-helper (cdr lst) (+ acc (car lst)))))
; not tail recursion!
(define (sum lst)
  (sum-helper lst 0))
(sum '(1 2 3 4 5))

; higher order function
(define (apply-twice f x)
  (f (f x)))
(apply-twice sqr 2)

; delaying evaluation
(define (my-and x y)
  (and (x) (y)))
(my-and (lambda () #f) (lambda () (/ 1 0)))

; Week 3
; higher order list function
(map (lambda (x) (* 3 x))
     '(1 2 3 4))
(filter (lambda (x) (> x 1))
        '(4 -1 0 15))
(define (sum-easy lst)
  (foldl + 0 lst))
(sum-easy '(1 2 3 4))

; definition of foldl and foldr
(define (my-foldl proc init lst)
  (if (empty? lst)
      init
      (my-foldl proc
                (proc (car lst) init)
                (cdr lst))))
(define (my-foldr proc init lst)
  (if (empty? lst)
      init
      (proc (car lst)
            (my-foldr proc init (cdr lst)))))
(my-foldl + 0 '(1 2 3)) ; (+ 3 (+ 2 (+ 1 0)))
(my-foldr + 0 '(1 2 3)) ; (+ 1 (+ 2 (+ 3 0)))

; define map and filter using foldl
(define (my-filter pred lst)
  (foldl (lambda (x acc)
           (if (pred x)
               (append acc (list x))
               acc))
         '()
         lst))
(my-filter (lambda (x) (> x 0)) '(4 0 1 -15))
(define (my-map proc lst)
  (foldl (lambda (x acc)
           (append acc (list (proc x))))
         '()
         lst))
(my-map (lambda (x) (* 2 x)) '(1 2 3))

; reverse list with foldl
(define (list-reverse lst)
  (foldl cons '() lst))
(list-reverse '(1 2 3 4))

; let, let*, letrec
(define (f1 x)
  (let ([y 3]
        [z (+ x 1)]) ; OK, x in function scope
    (+ x y z)))
(define (f2 x)
  (let* ([y 3]
         [z (+ y 1)]) ; OK, let* allows a local name
    (+ x y z)))
(define (fact x)
  (letrec ([fact (lambda (n)
                   (if (equal? n 0)
                       1
                       (* n (fact (- n 1)))))])
    (fact x)))
(fact 10)

; Week 4
; rest: variable num of args
(define fff
  (lambda args (length args))) ; usual use (lambda (a b c) ...

(define-syntax my-or-2
  (syntax-rules ()
    [(my-or-2 x y) ; query-replace
     (or x y)]))
(my-or-2 #t (/ 1 0)) ; macro expansion -> (or #t (/ 1 0))

; macro expansion before execution
(define-syntax pick-first
  (syntax-rules ()
    [(pick-first x y)
     x]))
(pick-first 3 (/ 1 0))
; custom behavior, skipping function call

(map (lambda (x) (* 2 x))
     '(1 2 3))
; want to have (list-comp (* 2 x) for x in '(1 2 3)) python syntax
(define-syntax list-comp
  (syntax-rules ()
    [(list-comp <expr> for <var> in <lst>)
     (map (lambda (<var>) <expr>) <lst>)]))
; all 5 identifiers are wildcard, don't want this!
(list-comp (* 2 x) for x in '(1 2 3))
(list-comp (* 2 x) alice x bob '(1 2 3))

(define-syntax list-comp-better
  (syntax-rules (for in)
    [(list-comp-better <expr> for <var> in <lst>)
     (map (lambda (<var>) <expr>) <lst>)]))
(list-comp-better (* 2 x) for x in '(1 2 3))
; (list-comp-better (* 2 x) alice x bob '(1 2 3)) bad syntax!
; want to treat for in as literals

(define-syntax list-comp-full
  (syntax-rules (for in if)
    [(list-comp-full <expr> for <var> in <lst>)
     (map (lambda (<var>) <expr>) <lst>)]
    [(list-comp-full <expr> for <var> in <lst> if <pred>)
     ; (map (lambda (<var>) <expr>) 
     ;      (filter (lambda (<var>) <pred>) <lst>))]))
     (list-comp-full <expr> for <var> in
                     (filter (lambda (<var>) <pred>) <lst>))]))
(list-comp-full (* 2 x) for x in '(1 2 3))
(list-comp-full (* 2 x) for x in '(1 2 3) if (odd? x))
; [2 * x for x in [1, 2, 3] if x % 2 == 1]

; c macros, text sub, dynamic scoping
; racket macros, smart, lexical scoping
(define x 10)
(define-syntax add-x
  (syntax-rules ()
    [(add-x y)
     (+ x y)])) ; x binded at the time macro is defined
(let ([x 50])
  (add-x 100))
; 10 + 100 lexical scope <-
; 50 + 100 (+ x 100) dynamic scope

(define-syntax my-or
  (syntax-rules ()
    [(my-or x y)
     (or x y)]
    [(my-or x y z)
     (my-or (my-or x y) z)]
    ; ... you can give 200 cases, not exhaustive
    ))
(my-or #t (/ 1 0))
(my-or #t #f (/ 1 0))

(define-syntax my-or-rec
  (syntax-rules ()
    [(my-or-rec x)
     x]
    [(my-or-rec x y)
     (or x y)]
    [(my-or-rec x y ...)
     (my-or-rec x (my-or-rec y ...))]
    ; [(my-or-rec x ...)
    ;  (my-or-rec x (my-or-rec ...))] ; err: x ... must both be present
    ;  (my-or-rec x) ; err
    ;  (my-or-rec ...) ; err
    ))
(my-or-rec #t (/ 1 0))
(my-or-rec #t #f (/ 1 0))
; macro expansion start from top
; similar for function: rest syntax
; ex: define macro or that works from right, might be on final

(define (Pt x y)
  (lambda (msg)
    (cond [(equal? "x" msg) x]
          [(equal? "y" msg) y]
          [else "Unrecognized msg!"])))
; really cumbersome

(define-syntax class
  (syntax-rules ()
    [(class <Class> <attr> ...)
     (define (<Class> <attr> ...)
       (lambda (msg)
         (cond [(equal? (symbol->string (quote <attr>))
                        msg)
                <attr>]
               ...
               [else "Unrecognized msg!"])))]))
    
; want to have:
(class Float x)
(define f (Float 2))
(f "x")
(class Point x y)
(define p (Point 2 3))
(p "x")
(p "y")

; for magic of elipsis, watch video!
; end of Racket
