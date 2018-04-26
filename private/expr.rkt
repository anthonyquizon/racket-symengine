#lang racket

(provide free_symbols)

(require (prefix-in ffi: "ffi.rkt")
         "set.rkt")

(define (free_symbols s)
  (define s-set (ffi:setbasic_new))
  (ffi:basic_free_symbols (val s) s-set)
  (setbasic->set s-set))
