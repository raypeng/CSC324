#| Exercise 3 - More Higher-Order Functions (due January 31, noon)

General exercise instructions:
- Exercises must be done *individually*.
- You may not import any Racket libraries, unless explicitly told to.
- You may not use mutation or any iterative constructs (for/*).
- You may write helper functions freely; in fact, you are encouraged
  to do so to keep your code easy to understand.
- Your grade will be determined by our automated testing.
  You can find some sample tests on the course webpage.
- Submit early and often! MarkUs is rather slow when many people
  submit at once. It is your responsibility to make sure your work is
  submitted on time.
- No late submissions will be accepted!

Implement the three functions below. Note that these functions both
return new functions. Don't make your code too complex; even though
the ideas may be new, each function can be implemented in just a
few lines of code, same as before.
|#
#lang racket

(provide list-ref-keyed curry-2 curry-n)

#|
(list-ref-keyed f x)
  f: a unary function that returns non-negative integers
  x: a *valid* argument to 'f'

  Returns a new function that takes a list, and returns the
  item at position (f x) in that list, or (void) if (f x)
  is out of bounds.

> (define get-third (list-ref-keyed (lambda (x) (+ x 1)) 1))
> (get-third '(5 10 20))
20
> (get-third '(1))
; void, nothing printed
|#

(define (list-ref-keyed f x)
  (lambda (lst)
    (if (>= (f x) (length lst))
        (void)
        (list-ref lst (f x)))))

#|
(curry-2 f)
  f: a *binary* function
  
  Returns a unary function g that takes an argument x, and returns a
  new unary function h that takes an argument y, such that 
  (h y) is equivalent to (f x y).

> (define (add2 x y) (+ 2 x y))
> (define func (curry-2 add2))
> ((func 10) 20)
32
|#

(define (curry-2 f)
  (lambda (y)
    (lambda (x)
      (f x y))))

#|
(curry-n f n)
  f: a function that takes 'n' arguments
  n: a positive integer >= 2

  A generalization of curry-2, except now 'f' takes 'n' arguments; 
  curry-n returns a unary function g that takes an argument x, 
  and outputs a new function which is the curried version of the function 
  (lambda (x2 ... xn) (f x x2 ... xn)).

> (define (add7 w x y z) (+ 7 w x y z))
> (define func (curry-n add7 4))
> ((((func 4) 6) 10) 100)
127

Note: it is possible to define curry-2 in terms of curry-n:
(define (curry-2 f) (curry-n f 2))
|#

(define (curry-n f n)
  (define (curry-helper f n args)
    (if (= n 0)
        (apply f args)
        (lambda (arg)
          (curry-helper f (- n 1) (append args (list arg))))))
  (curry-helper f n '()))
