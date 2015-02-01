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
          (+ 1 (list-index e (cdr lst))))))

#|
A function that takes: 
  - a list of attributes
  - a string (representing an attribute)
  - a tuple

  and returns the value of the tuple corresponding to that attribute.
|#

(define (find-attr lattr attr tuple)
  (list-ref tuple (list-index attr lattr)))

(define (find-attrs lattr attrs tuple)
  (map (lambda (attr) 
         (find-attr lattr attr tuple))
       attrs))

(define (find-attrs-table attrs table)
  (cons attrs
        (map (lambda (tuple)
               (find-attrs (attributes table) attrs tuple))
             (tuples table))))

#|
A function that takes:
  - f: a unary function that takes a tuple and returns a boolean value
  - table: a valid table

  and returns a new table containing only the tuples in 'table'
  that satisfy 'f'.
|#

(define filter-table filter)

#|
A function 'replace-attr' that takes:
  - x 
  - a list of attributes

  and returns a function 'f' which takes a tuple and does the following:
    - If 'x' is in the list of attributes, return the corresponding value 
      in the tuple.
    - Otherwise, just ignore the tuple and return 'x'.
|#

(define (replace-attr attr lattr)
  (lambda (tuple) 
    (if (>= (list-index attr lattr) 0)
        (find-attr attr lattr tuple)
        attr)))

; SELECT syntaxes

(define-syntax SELECT
  (syntax-rules (* FROM WHERE ORDER BY)
    [(SELECT * FROM <table>)
     (find-attrs-table (attributes <table>) <table>)]
    [(SELECT <attrs> FROM <table>)
     (find-attrs-table <attrs> <table>)]))
      
      
; Starter for Part 4; feel free to ignore!

; What should this macro do?
(define-syntax replace
  (syntax-rules ()
    ; The recursive step, when given a compound expression
    [(replace (expr ...) table)
     ; Change this!
     (void)]
    ; The base case, when given just an atom. This is easier!
    [(replace atom table)
     ; Change this!
     (void)]))

#|
(define-syntax SELECT *
  (syntax-rules (FROM)
    [(SELECT * FROM table)
     (map (lambda (tuple) (find-attrs lattr lattr tuple))
          table)]))
|#
