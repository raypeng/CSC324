#| A Macro-Generating Macro

Someone asked me after class if we could modify our
class macro to actually produce instances that can
handle identifiers as messages rather than strings:

> (class Point x y z)
> (define p (Point 10 5 3))
> (p x)
10

Indeed you can, although to prevent an unidentified
identifier error from being raised, we must have "p"
be a macro rather than a function. That is, "class"
should be a macro that produces a macro "Point", which
produces a macro "p", that acts like an object. Whew!

I spent an hour or two adjacent to UofTHacks producing
such a macro; brownie points for anyone offering a 
simpler implementation. It goes without saying that
this is optional. :)
|#
#lang racket

(define-syntax class
  (syntax-rules ()
    [(class <Class> <attr> ...)
     (define-syntax <Class>
       (syntax-rules (=:)
         [(<Class> <arg> (... ...) =: <id>)
          (instance <id>
                    (<arg> (... ...))
                    (<attr> ...))]))]))

(define-syntax instance
  (syntax-rules ()
    [(instance <id> (<arg> ...) (<attr> ...))
     (define-syntax <id>
       (syntax-rules ()
         [(<id> <msg>)
          (cond [(equal? (quote <msg>) (quote <attr>))
                 <arg>]
                ...
                [else "Unrecognized message!"])
          ]))]))

(class Point x y z)
(Point 1 2 3 =: p)
(p x)
(p y)
(p z)
(p w)