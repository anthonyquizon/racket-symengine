#lang racket

(provide (rename-out [sym-exp exp]))

(require (prefix-in ffi: "ffi.rkt")
         (prefix-in r: racket)
         (prefix-in s: "symbol.rkt"))

(module+ test
  (require rackunit))

(define (sym-exp a)
  (define s (ffi:basic_new_heap))
  (ffi:basic_exp s (val a))
  (Sym s))

