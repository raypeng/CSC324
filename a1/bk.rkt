#| Assignment 1 - Racket Query Language (due February 11, noon)

***Write the names and CDF accounts for each of your group members below.***
<Name>, <CDF>
<Name>, <CDF>
|#
#lang racket

(define Person
  '(("Name" "Age" "LikesChocolate")
    ("David" 20 #t)
    ("Jen" 30 #t) 
    ("Paul" 100 #f)))

(define Teaching
  '(("Name" "Course")
    ("David" "CSC324")
    ("Paul" "CSC108")
    ("David" "CSC343")))

; Function versions for common syntactic forms.
; *Use these in your queries instead of the syntactic forms!!!*
(define (And x y) (and x y))
(define (Or x y) (or x y))
(define (If x y z) (if x y z))

; TODO: After you have defined your macro(s), make sure you add each one
; to the provide statement.
(provide attributes
         tuples
         size
         SELECT) ; just for testing

; Part 0: Semantic aliases

#|
(attributes table)
  table: a valid table (i.e., a list of lists as specified by assigment)

  Returns a list of the attributes in 'table', in the order they appear.
|#

(define attributes car)

#|
(tuples table)
  table: a valid table

  Returns a list of all tuples in 'table', in the order they appear.
  Note: it is possible for 'table' to contain no tuples.
|#

(define tuples cdr)

#|
(size table)
  table: a valid table

  Returns the number of tuples in 'table'.
|#

(define (size x) 
  (length (tuples x)))

; Part I "WHERE" helpers; you may or may not wish to implement these.

(define (list-index e lst)
  (if (empty? lst)
      -1
      (if (equal? e (car lst))
          0
          (if (= (list-index e (cdr lst)) -1)
              -1
              (+ 1 (list-index e (cdr lst)))))))

; (list-index 3 '(2 8 3))

#|
A function that takes: 
  - a list of attributes
  - a string (representing an attribute)
  - a tuple

  and returns the value of the tuple corresponding to that attribute.
|#

(define (find-attr lattr attr tuple)
  (list-ref tuple (list-index attr lattr)))

; (find-attr '("Name" "Age" "LikesChocolate") "Age" '("David" 20 #t))

(define (find-attrs lattr attrs tuple)
  (map (lambda (attr)
         (find-attr lattr attr tuple))
       attrs))

; (find-attrs '("Name" "Age" "LikesChocolate") '("Name" "Age") '("David" 20 #t))

(define (find-attrs-table attrs table)
  (cons attrs
        (map (lambda (tuple)
               (find-attrs (attributes table) attrs tuple))
             (tuples table))))

; (find-attrs-table '("Name" "Age") Person)

(define (cartesian-product t1 t2)
  (if (empty? t1)
      '()
      (append (map (lambda (lst)
                     (append (car t1) lst))
                   t2)
              (cartesian-product (cdr t1) t2))))

(define (join ltable)
  (if (empty? (cdr ltable))
      (car ltable)
      (cartesian-product (car ltable)
                         (join (cdr ltable)))))

; (join (list (tuples Person) (tuples Teaching) (tuples Teaching)))

(define (num-occur attr lattrs)
  (length (filter (lambda (x) (eq? attr x))
                  (apply append lattrs))))

; (num-occur 1 '((1 2) (3 4 1) (2 1)))

(define (make-lattr-partial lattr lattrs name)
  (define (append-name attr)
    (if (> (num-occur attr lattrs) 1)
        (string-append name "." attr)
        attr))
  (map append-name lattr))

#|
(make-lattr-partial '("Name" "Age")
                    '(("Name" "Age") ("Name" "Course"))
                    "P")
|#
                      
(define (make-lattr lattrs lnames)
  (define (make-lattr-help lattrs lattrs-bk lnames)
    (if (empty? lattrs)
        '()
        (cons (make-lattr-partial (car lattrs)
                                  lattrs-bk
                                  (car lnames))
              (make-lattr-help (cdr lattrs)
                               lattrs-bk
                               (cdr lnames)))))
  (apply append (make-lattr-help lattrs lattrs lnames)))

#|
(make-lattr '(("Name" "Age") ("Name" "Course"))
            '("P" "T"))
|#

(define (find-allattrs-table-mult tablepairs)
  (define tables (map car tablepairs))
  (define records (join (map tuples tables)))
  (define lattr (make-lattr (map attributes tables)
                            (map cdr tablepairs)))
  (cons lattr records))

; (find-allattrs-table-mult ... TODO

(define (find-attrs-table-mult attrs tablepairs)
  (find-attrs-table attrs
                    (find-allattrs-table-mult tablepairs)))

; (find-attrs-table-mult '("P.Name" "Course" "Age") ... TODO

#|
A function that takes:
  - f: a unary function that takes a tuple and returns a boolean value
  - table: a valid table

  and returns a new table containing only the tuples in 'table'
  that satisfy 'f'.
|#

(define (filter-table f table)
  (cons (attributes table)
        (filter f (tuples table))))

#|
A function 'replace-attr' that takes:
  - x 
  - a list of attributes

  and returns a function 'f' which takes a tuple and does the following:
    - If 'x' is in the list of attributes, return the corresponding value 
      in the tuple.
    - Otherwise, just ignore the tuple and return 'x'.
|#

(define (replace-attr x lattr)
  (lambda (tuple)
    (if (>= (list-index x lattr) 0)
        (find-attr lattr x tuple)
        x)))

; ((replace-attr "Name" '("Age" "Name")) '(12 "David"))

; generic gt? with string and number
(define (gt? a b)
  (if (string? a)
      (string>? a b)
      (> a b)))

; SELECT syntaxes

(define-syntax ToPair
  (syntax-rules ()
    [(ToPair [<table1> <name1>])
     (list (cons <table1> <name1>))]
    [(ToPair <table>)
     (list <table>)]
    [(ToPair [<table1> <name1>] ...)
     (append (list (cons <table1> <name1>))
           ...)]))

(define-syntax SELECT
  (syntax-rules (* FROM WHERE ORDER BY)
    [(SELECT <attrs> FROM <table> ... WHERE <cond> ORDER BY <order>)
     (SELECT <attrs> FROM
             (order <order> (replace <cond> (SELECT * FROM <table> ...))))]
    [(SELECT <attrs> FROM <table> ... ORDER BY <order>)
     (SELECT <attrs> FROM
             (order <order> (SELECT * FROM <table> ...)))]             
    [(SELECT <attrs> FROM <table> ... WHERE <cond>)
     (SELECT <attrs> FROM 
             (replace <cond> (SELECT * FROM <table> ...)))]
    [(SELECT * FROM <table>)
     <table>]
    [(SELECT <attrs> FROM <table>)
     (find-attrs-table <attrs> <table>)]
    [(SELECT * FROM <pair1> <pair2> ...)
     (find-allattrs-table-mult (ToPair <pair1> <pair2> ...))]
    [(SELECT <attrs> FROM <pair1> <pair2> ...)
     (find-attrs-table-mult <attrs> (ToPair <pair1> <pair2> ...))]
))

; Starter for Part 4; feel free to ignore!

#|
(define-syntax Filter
  (syntax-rules ()
    [(Filter (expr ...) <table>)
     (cons (attributes <table>)
           (filter (FilterCond (expr ...) (attributes <table>))
                   (tuples <table>)))]
    [(Filter expr <table>)
     (cons (attributes <table>)
           (filter (FilterCond expr (attributes <table>))
                   (tuples <table>)))]))

(define-syntax OrderFunc
  (syntax-rules ()
    [(OrderFunc (expr ...) lattr)
     (lambda (tuple)
       (if (empty? tuple)
           tuple
           (let ([sexpr (list ((replace-attr expr lattr) tuple)
                              ...)])
             (apply (car sexpr) (cdr sexpr)))))]
    [(OrderFunc expr lattr)
     (lambda (tuple)
       (if (empty? tuple)
           tuple
           ((replace-attr expr lattr) tuple)))]))
|#

(define-syntax Sub
  (syntax-rules ()
    [(Sub (expr ...) lattr)
     (lambda (tuple)
       (if (empty? tuple)
           tuple
           (let ([sexpr (list ((Sub expr lattr) tuple)
                              ...)])
             (apply (car sexpr) (cdr sexpr)))))]
    [(Sub expr lattr)
     (lambda (tuple)
       (if (empty? tuple)
           tuple
           ((replace-attr expr lattr) tuple)))]))

(define-syntax order
  (syntax-rules ()
    [(order (expr ...) <table>)
     (cons (attributes <table>)
           (sort (tuples <table>) gt? #:key
                 (Sub (expr ...) (attributes <table>))))]
    [(order expr <table>)
     (cons (attributes <table>)
           (sort (tuples <table>) gt? #:key
                 (Sub expr (attributes <table>))))]))

; What should this macro do?
(define-syntax replace
  (syntax-rules ()
    ; The recursive step, when given a compound expression
    [(replace (expr ...) <table>)
     ; Change this!
     (cons (attributes <table>)
           (filter (Sub (expr ...) (attributes <table>))
                   (tuples <table>)))]
    ; The base case, when given just an atom. This is easier!
    [(replace expr <table>)
     ; Change this!
     (cons (attributes <table>)
           (filter (Sub expr (attributes <table>))
                   (tuples <table>)))]))


#|
(SELECT '("T.Name" "Age") FROM [Person "P"] [Teaching "T"])
(find-attrs-table '("Name" "Age") Person)
(SELECT '("Name" "Age") FROM Person)
(SELECT * FROM Person)
(ToPair Person)
(SELECT '("A" "B")
        FROM '(("C" "A" "B" "D")
               (1 "Hi" 5 #t)
               (2 "Bye" 5 #f)
               (3 "Hi" 10 #t)))
(SELECT * FROM [Person "P"] [Teaching "T"])

(Sub (> "Age" 25) '("Name" "Age" "LikesChocolate"))
((Sub (> "Age" 25) '("Name" "Age" "LikesChocolate")) '("David" 20 #t))

(SELECT * FROM Person WHERE (> "Age" 25))
(SELECT '() FROM Teaching)
(SELECT * FROM Teaching WHERE (equal? "Name" "David"))
(SELECT '() FROM Teaching WHERE (equal? "Name" "David"))

(SELECT * FROM Teaching WHERE (And #t (equal? "Name" "David")))

(SELECT '("P1.Name" "P1.LikesChocolate" "P.Age" "Course")
        FROM [Person "P"] [Teaching "T"] [Person "P1"]
        WHERE (And "P.LikesChocolate" (equal? "P1.Name" "T.Name")))

(cons
 (attributes (SELECT * FROM Teaching))
 (filter
  (Sub
   (And #t (equal? "Name" "David"))
   (attributes (SELECT * FROM Teaching)))
  (tuples (SELECT * FROM Teaching))))

(Sub #t (attributes Teaching))
((Sub #t (attributes Teaching)) '("David" "CSC343"))

((Sub "LikesChocolate" (attributes Person)) '("David" 20 #f))
(SELECT * FROM Person WHERE "LikesChocolate")

(SELECT * FROM Person ORDER BY "Age")

(SELECT * FROM Teaching WHERE (And #t (equal? "Name" "David")))

Teaching

(replace
 (And #t (equal? "Name" "David"))
 Teaching)

(SELECT * FROM Teaching ORDER BY
 (+ (string-length "Name") (string-length "Course")))
|#
