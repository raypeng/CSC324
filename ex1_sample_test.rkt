#| Sample tests for Exercise 1.
Note the use of the "plai" language to use a robust testing framework.

All test expressions are in the form (test <actual> <expected>).

Note: these tests are only a subset of the tests we will run;
you are strongly advised to add to them on your own.
|#
#lang plai
(abridged-test-output #t)

; Import the module for exercise 1. Note that the filename must be "ex1.rkt"!
(require "ex1.rkt")


; Tests for search-table
(test (search-table '((1 2 3) (4 2) (3 3 4) (5 3 2 1)) 1)
      '((1 2 3) (5 3 2 1)))

(test (search-table '((1 2 3) (4 2) (3 3 4) (5 3 2 1)) 10)
      '())


; Tests for search-table-2
(test (search-table-2 '((1 2 3) (4 2) (3 3 4) (5 3 2 1)) 1 3)
      '((5 3 2 1)))

; Tests for max-sublist
(test (max-sublist '(-1 10 -4 5 3 -100 6))
      14)
(test (max-sublist '(-4 -1 -2 -3))
      0)