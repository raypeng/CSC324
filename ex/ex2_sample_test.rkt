#| Sample tests for Exercise 2.
Note the use of the "plai" language to use a more robust
testing framework.

All test expressions are in the form (test <actual> <expected>).

Note: these tests are only a subset of the tests we will run;
you are strongly advised to add to them on your own.
|#
#lang plai
(abridged-test-output #t)

; Import the module
(require "ex2.rkt")


; Tests for cartesian-product
(test (cartesian-product '((1 4) (2 10)) '((3 4 5) (2)))
      '((1 4 3 4 5) (1 4 2) (2 10 3 4 5) (2 10 2)))

(test (cartesian-product '((1 3)) '((1) (2) (3) (4)))
      '((1 3 1) (1 3 2) (1 3 3) (1 3 4)))

; Tests for functions-sort
; Note that in these tests, we're calling function-sort without
; wrapping it in a "test". If function-sort raises an error,
; none of the tests will run!

(define fs (function-sort (list (lambda (x) (+ x 3)) 
                                (lambda (x) (- 100 x))
                                (lambda (x) (* x 2)))
                          5))

(test ((first fs) 6)
      9)

(test ((second fs) 6)
      12)

(test ((third fs) 6)
      94)
