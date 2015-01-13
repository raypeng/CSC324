#lang racket

(define (num-evens lst)
  (if (empty? lst)
      0
      (+ (num-evens (cdr lst))
         (if (even? (car lst))
             1
             0))))

(define (add-to-all lst item)
  (if (empty? lst)
      '()
      (cons (cons item (car lst))
            (add-to-all (cdr lst) item))))

(define (subsets lst)
  (define (helper lst sofar)
    (if (empty? lst)
        sofar
        (helper (cdr lst)
                (append sofar
                        (add-to-all sofar (car lst))))))
  (helper lst '(())))

(define (subsets2 lst [k -1])
  (if (= k -1)
      (subsets lst)
      (filter (lambda (item)
                (= k (length item)))
              (subsets lst))))

(num-evens '(1 2 3 4 5)) 
(add-to-all '((1 2 3) () (4) (5 6)) 10)
(subsets '(1 2 3))
(subsets2 '(1 2 3) 3)
(subsets2 '(1 2 3) 2)
(subsets2 '(1 2 3) 1)
(subsets2 '(1 2 3) 0)