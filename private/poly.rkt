#lang racket

(require (prefix-in ffi: "ffi.rkt")
         (prefix-in r: racket)
         (prefix-in s: "symbol.rkt"))

(provide (rename-out [sym-exp exp]))

(module+ test
  (require rackunit))

(define (sym-exp a)
  (define s (ffi:basic_new_heap))
  (ffi:basic_exp s (val a))
  (Sym s))

