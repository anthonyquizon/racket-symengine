#lang racket

(require "../main.rkt"
         rackunit)

(test-begin
  (define-symbolic x y)

  (check-true
    (= (+ x x) (* (integer 2) x)))

  (check-true
    (!= (+ x x) (* (integer 3) x)))
  
  )
