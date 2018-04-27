#lang racket

(provide free_symbols)

(require (prefix-in ffi: "ffi.rkt")
         "symbol.rkt"
         "set.rkt")

(module+ test
  (require rackunit
           quickcheck
           (prefix-in n: "number.rkt")
           (prefix-in a: "arith.rkt")))

(define (free_symbols s)
  (define s-set (ffi:setbasic_new))
  (ffi:basic_free_symbols (val s) s-set)
  (setbasic->set s-set))

(module+ test
  (test-begin
    (define a (symbol "a"))
    (define b (symbol "b"))
    (define e (a:+ (a:+ a b) (n:integer 1)))

    (check-equal?
      (free_symbols e)
      (set (symbol "a") (symbol "b")))))
