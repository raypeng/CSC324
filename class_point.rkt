#lang racket
(define (Point x y)
  (lambda (msg)
    (cond [(equal? msg "x") x]
          [(equal? msg "y") y]
          [(equal? msg "distance")
           (lambda (other-point)
             (let ([dx (- x (other-point "x"))]
                   [dy (- y (other-point "y"))])
               (sqrt (+ (* dx dx) (* dy dy)))))]
          )))

(define p (Point 2 3))
(define q (Point 4 5))
(p "x")
(q "y")
((p "distance") q)
