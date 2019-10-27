#lang racket

(provide (rename-out [sym* *]
                     [sym+ +]
                     [sym/ /]
                     [sym= =]
                     [sym!= !=]
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

;;TODO contracts
(define (sym+ a b)
  (define s (ffi:basic_new_heap))
  (ffi:basic_add s (val a) (val b))
  (Sym s))

(module+ test
  (check-equal?
    (sym+ (integer 1) (integer 2))
    (integer 3)))

(define (sym* a b)
  (define s (ffi:basic_new_heap))
  (ffi:basic_mul s (val a) (val b))
  (Sym s))

(module+ test
  (check-equal?
    (sym* (integer 2) (integer 2))
    (integer 4)))

(define (sym/ a b)
  (define s (ffi:basic_new_heap))
  (ffi:basic_div s (val a) (val b))
  (Sym s))

(module+ test
  (check-equal?
    (sym/ (integer 5) (integer 2))
    (rational 5/2)))

(define (sym= a b)
 (= (ffi:basic_eq (val a) (val b)) 1) )

(module+ test
  (check-true
    (sym= (integer 2) (integer 2)))

  (check-false
    (sym= (integer 2) (integer 5))))

(define (sym!= a b)
  (= (ffi:basic_eq (val a) (val b)) 0))

(module+ test
  (test-case 
    "not equal integer"
    (check-property
        (property ([x arbitrary-integer])
                  (not (sym!= (integer x) (integer x)))))))

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

