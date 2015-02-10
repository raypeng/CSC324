#| Assignment 1 - Racket Query Language (due February 11, noon)

***Write the names and CDF accounts for each of your group members below.***
Rui Peng, c5pengru
Siqi Wu,  g3orion
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
         SELECT)

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

#|
(list-index e lst)
  e: an arbitrary value
  list: a list

  Returns the index of 'e' in 'lst' if 'e' in 'lst', else return -1

(list-index 3 '(2 8 3))
|#

(define (list-index e lst)
  (if (empty? lst)
      -1
      (if (equal? e (car lst))
          0
          (if (= (list-index e (cdr lst)) -1)
              -1
              (+ 1 (list-index e (cdr lst)))))))

#|
(find-attr lattr attr tuple)
A function that takes: 
  - a list of attributes
  - a string (representing an attribute)
  - a tuple

  and returns the value of the tuple corresponding to that attribute.

Helper function used by 'find-attrs'.

(find-attr '("Name" "Age" "LikesChocolate") "Age" '("David" 20 #t))
|#

(define (find-attr lattr attr tuple)
  (list-ref tuple (list-index attr lattr)))

#|
(find-attrs lattr attrs tuple)
A function that takes: 
  - a list of all attributes
  - a list of wanted attributes
  - a tuple

  and returns the values of the tuple corresponding to the wanted attributes.

Helper function used by 'find-attrs-table'.

(find-attrs '("Name" "Age" "LikesChocolate") '("Name" "Age") '("David" 20 #t))
|#

(define (find-attrs lattr attrs tuple)
  (map (lambda (attr)
         (find-attr lattr attr tuple))
       attrs))

#|
(find-attrs-table attrs table)
A function that takes: 
  - a list of wanted attributes
  - a table

  and returns part of the table with only wanted attributes.

Directly used for 'SELECT <attrs> FROM <table>'.

(find-attrs-table '("Name" "Age") Person)
|#

(define (find-attrs-table attrs table)
  (cons attrs
        (map (lambda (tuple)
               (find-attrs (attributes table) attrs tuple))
             (tuples table))))

#|
(cartesian-product t1 t2)
A function that takes: 
  - a list of records in table t1
  - a list of records in table t2

  and returns the cartesian product of records.

Used for performing table joins by 'join'.

(cartesian-product (tuples Person) (tuples Teaching))
|#

(define (cartesian-product t1 t2)
  (if (empty? t1)
      '()
      (append (map (lambda (lst)
                     (append (car t1) lst))
                   t2)
              (cartesian-product (cdr t1) t2))))

#|
(join ltable)
A function that takes: 
  - a list of tables to be joined

  and returns the INNER JOIN of the tables.

Used by 'find-allattrs-table-mult' for 'SELECT * FROM <table>'.

(join (list (tuples Person) (tuples Teaching) (tuples Teaching)))
|#

(define (join ltable)
  (if (empty? (cdr ltable))
      (car ltable)
      (cartesian-product (car ltable)
                         (join (cdr ltable)))))

#|
(duplicate-attr? attr lattrs)
A function that takes:
  - a value representing the attribute name to be examined
  - a list of attributes

  and returns #t if number of occurrences of the value in the list > 1.

Used for checking duplicate names in table joins.

(duplicate-attr? "Name" '(("Name" "Age") ("Name" "Count")))
-> 2
|#

(define (duplicate-attr? attr lattrs)
  (> (length (filter (lambda (x) (eq? attr x))
                     (apply append lattrs)))
     1))

#|
(make-lattr-partial lattr lattrs name)
A function that takes:
  - a list of attributes
  - a list of lists of attributes
  - a string representing the potential renaming prefix,
    or -1 representing no renaming prefix provided

  and returns a list of renamed attributes if needed.

Used by 'make-lattr' for partially adding prefixes.

(make-lattr-partial '("Name" "Age")
                    '(("Name" "Age") ("Name" "Course"))
                    "P")
-> '("P.Name" "Age")

(make-lattr-partial '("Name" "Age")
                    '(("Name" "Age") ("Name" "Course"))
                    -1)
-> '("Name" "Age")
|#

(define (make-lattr-partial lattr lattrs name)
  (define (append-name attr)
    (if (and (not (eq? attr -1))
             (duplicate-attr? attr lattrs))
        (string-append name "." attr)
        attr))
  (map append-name lattr))

#|
(make-lattr lattrs lnames)
A function that takes:
  - a list of lists of attributes
  - a list of potential renaming prefix

  and returns a list of renamed attributes if needed.

Used by 'find-allattrs-table-mult' as new table attribute list.

(make-lattr '(("Name" "Age") ("Name" "Course"))
            '("P" "T"))
-> '("P.Name" "Age" "T.Name" "Course")
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
(find-allattrs-table-mult tablepairs)
A function that takes:
  - a list of table, prefix pairs (prefix = -1 if no name specified)

  and returns a joined table with correct name prefixes.

Directly used for 'SELECT * FROM <table1> <table2> ...'.
|#

(define (find-allattrs-table-mult tablepairs)
  (let* ([tables (map car tablepairs)]
         [records (join (map tuples tables))]
         [lattr (make-lattr (map attributes tables)
                            (map cdr tablepairs))])
    (cons lattr records)))

#|
(filter-table f table)
A function that takes:
  - f: a unary function that takes a tuple and returns a boolean value
  - table: a valid table

  and returns a new table containing only the tuples in 'table'
  that satisfy 'f'.

Used by 'where' macro to implement filtering.
|#

(define (filter-table f table)
  (cons (attributes table)
        (filter f (tuples table))))

#|
(sort-table keyfunc table)
A function that takes:
  - keyfunc: a function that specifies the #:key within a tuple for sorting   
  - table: a valid table

  and returns a new table sorted decendingly according to keyfunc.

Used by 'order' macro to implement sorting.
|#

(define (sort-table keyfunc table)
  (cons (attributes table)
        (sort (tuples table)
              gt?
              #:key keyfunc)))

#|
(replace-attr x lattr)
A function 'replace-attr' that takes:
  - x 
  - a list of attributes

  and returns a function 'f' which takes a tuple and does the following:
    - If 'x' is in the list of attributes, return the corresponding value 
      in the tuple.
    - Otherwise, just ignore the tuple and return 'x'.

Used by 'replace' macro a lot.

((replace-attr "Name" '("Age" "Name")) '(12 "David"))
-> "David"

((replace-attr "wtf" '("Age" "Name")) '(12 "David"))
-> "wtf"
|#

(define (replace-attr x lattr)
  (lambda (tuple)
    (if (>= (list-index x lattr) 0)
        (find-attr lattr x tuple)
        x)))

#|
(gt? a b)
A generic greater than function that deals with strings or numbers.
Assumes input a and b are always the same type.

Used for implementing sorting of table in ORDER BY.

(gt? 2 1)
(gt? "David" "Jane")
|#

(define (gt? a b)
  (if (string? a)
      (string>? a b)
      (> a b)))

#|
ToPair:
a macro that transforms
[Teaching "T"] ... to (Teaching . "T") ...
Teaching ... to (Teaching . -1) ...
in order to reorganize tables and names info for further processing.

Used by 'find-allattrs-table-mult' as tables, names representation.

(ToPair Person Teaching)

(ToPair [Person "P"] [Teaching "T"])
|#

(define-syntax ToPair
  (syntax-rules ()
    [(ToPair [<table1> <name1>])
     (list (cons <table1> <name1>))]
    [(ToPair <table>)
     (list (cons <table> -1))]
    [(ToPair <entry> ...)
     (append (ToPair <entry>)
             ...)]
    ))

#|
replace:
a macro that uses 'replace-attr' recursively to transform
(> "Age" 20) to (> 30 20) by replacing proper attribute values
so that the expression reduce to a value for future use (filter/sort).

Used by 'where' and 'order' macro directly.
|#

(define-syntax replace
  (syntax-rules ()
    [(replace (expr ...) lattr)
     (lambda (tuple)
       (if (empty? tuple)
           tuple
           (let ([sexpr (list ((replace expr lattr) tuple)
                              ...)])
             (apply (car sexpr) (cdr sexpr)))))]
    [(replace expr lattr)
     (lambda (tuple)
       (if (empty? tuple)
           tuple
           ((replace-attr expr lattr) tuple)))]))

#|
where:
a macro that deals with 'WHERE <cond>' and dispathes work to 'replace'.
|#

(define-syntax where
  (syntax-rules ()
    [(where <expr> <table>)
     (filter-table (replace <expr> (attributes <table>))
                   <table>)]))

#|
order:
a macro that deals with 'ORDER BY <value>' and dispatches work to 'replace'.
|#

(define-syntax order
  (syntax-rules ()
    [(order <expr> <table>)
     (sort-table (replace <expr> (attributes <table>))
                 <table>)]))

#|
SELECT syntaxes

order to execution:
FROM -> WHERE -> ORDER BY -> SELECT
|#
(define-syntax SELECT
  (syntax-rules (* FROM WHERE ORDER BY)
    ; FROM -> WHERE -> ORDER BY -> SELECT
    [(SELECT <attrs> FROM <table> ... WHERE <cond> ORDER BY <order>)
     (SELECT <attrs> FROM
             (order <order>
                    (where <cond> 
                           (SELECT * FROM <table> ...))))]
    ; FROM -> ORDER BY -> SELECT
    [(SELECT <attrs> FROM <table> ... ORDER BY <order>)
     (SELECT <attrs> FROM
             (order <order>
                    (SELECT * FROM <table> ...)))]       
    ; FROM -> WHERE -> SELECT
    [(SELECT <attrs> FROM <table> ... WHERE <cond>)
     (SELECT <attrs> FROM 
             (where <cond>
                    (SELECT * FROM <table> ...)))]
    ; FROM: base case, all attrs
    [(SELECT * FROM <table>)
     <table>]
    ; FROM -> SELECT: single table, attrs
    [(SELECT <attrs> FROM <table>)
     (find-attrs-table <attrs> <table>)]
    ; FROM -> SELECT: multiple table, all attrs
    [(SELECT * FROM <entry1> <entry2> ...)
     (find-allattrs-table-mult (ToPair <entry1> <entry2> ...))]    
    ; FROM -> SELECT: multiple table, attrs
    [(SELECT <attrs> FROM <entry1> <entry2> ...)
     (SELECT <attrs> FROM 
             (find-allattrs-table-mult (ToPair <entry1> <entry2> ...)))]
))
