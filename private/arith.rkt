#lang racket

(provide (rename-out [sym/* *]
                     [sym/+ +]
                     [sym/div /]
                     [sym/= =]
                     [sym/!= !=]
                     [sym/negate negate]
                     ))

(require (prefix-in ffi: "ffi.rkt")
         (prefix-in r: racket)
         "symbol.rkt")

(module+ test
  (require rackunit
           rackunit/quickcheck
           quickcheck
           "number.rkt"))

(define (sym/+ a b)
  (define s (ffi:basic_new_heap))
  (ffi:basic_add s (val a) (val b))
  (Sym s))

(module+ test
  (test-case 
    "+"
    (check-property
      (property ([x arbitrary-integer]
                 [y arbitrary-integer])
                (equal? (sym/+ (integer x) (integer y))
                        (integer (+ x y)))))))

(define (sym/* a b)
  (define s (ffi:basic_new_heap))
  (ffi:basic_mul s (val a) (val b))
  (Sym s))

(module+ test
  (test-case 
    "*"
    (check-property
      (property ([x arbitrary-integer]
                 [y arbitrary-integer])
                (equal? (sym/* (integer x) (integer y))
                        (integer (* x y)))))))

(define (sym/div a b)
  (define s (ffi:basic_new_heap))
  (ffi:basic_div s (val a) (val b))
  (Sym s))

(module+ test
  (test-case 
    "/"
    (check-property
      (property ([n arbitrary-integer]
                 [m arbitrary-integer])
                (define m^ 
                  (if (= m 0) 1 m))

                (equal? (sym/div (integer n) (integer m^))
                        (rational (/ n m^)))))))

(define (sym/= a b)
 (= (ffi:basic_eq (val a) (val b)) 1) )

(module+ test
  (test-case 
    "="
    (check-property
      (property ([x arbitrary-integer])
                (sym/= (integer x) (integer x))))))

(define (sym/!= a b)
  (= (ffi:basic_eq (val a) (val b)) 0))

(module+ test
  (test-case 
    "not equal integer"
    (check-property
        (property ([x arbitrary-integer])
                  (not (sym/!= (integer x) (integer x)))))))

(define (sym/negate a)
  (define s (ffi:basic_new_heap))
  (ffi:basic_neg s (val a))
  (Sym s))

(module+ test
  (test-case 
    "negate"
    (check-property
        (property ([x arbitrary-integer])
                  (equal? (sym/negate (integer x))
                          (integer (- x))))))

  (test-case 
    "negate"
    (check-property
      (property ([x arbitrary-integer])
                (equal? (sym/negate (sym/negate (integer x)))
                        (integer x))))))

