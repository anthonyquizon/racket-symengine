#lang racket

(provide setbasic->set)

(require (prefix-in ffi: "ffi.rkt")
         "symbol.rkt" 
         racket/set) 

(module+ test
  (require rackunit
           quickcheck
           "symbol.rkt"))

(define (setbasic->set s-set) 
  (define n (ffi:setbasic_size s-set))
  (for/set 
    ([i (range n)])
    (define s (ffi:basic_new_heap))
    (ffi:setbasic_get s-set i s)
    (Sym s)))

(module+ test)
