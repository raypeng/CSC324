#| Sample tests for Exercise 3.
Note the use of the "plai" language to use a more robust
testing framework.

All test expressions are in the form (test <actual> <expected>).

Note: these tests are only a subset of the tests we will run;
you are strongly advised to add to them on your own.

**WARNING**: because we use your functions outside of the tests,
if your functions raise an error, no tests will be run, and you
will get a 0 on this exercise! Make extra sure that your functions
do not raise errors when called.
|#
#lang plai

; Import the module
(require "ex3.rkt")
(abridged-test-output #t)

; Tests for list-ref-keyed
(define get-third (list-ref-keyed (lambda (x) (+ x 1)) 1))

(test (get-third '(5 10 20)) 
      20)
(test (get-third '(1)) 
      (void))

; Tests for curry-2
(define (add2 x y) (+ 2 x y))
(define func (curry-2 add2))
(define (div x y) (/ x y))
(define func1 (curry-2 div))

(test ((func 10) 20) 
      32)
(test ((func1 10) 2)
      5)

; Tests for curry-n
(define g (curry-n add2 2))

(test ((g 15) -1)
      16)
(test ((g 0) 0)
      2)
