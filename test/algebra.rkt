#lang racket

(require rackunit
         rackunit/quickcheck
         quickcheck
         (prefix-in sym: "../main.rkt"))

(test-case 
  "x = x/1"
  (check-true 
    (sym:= 
      (sym:symbol "x")   
      (sym:/ (sym:symbol "x") (sym:integer 1)) )))

(test-case 
  "x * x = 2 * x"
  (check-true 
    (sym:= 
      (sym:+ (sym:symbol "x") (sym:symbol "x")) 
      (sym:* (sym:integer 2)  (sym:symbol "x")))))

