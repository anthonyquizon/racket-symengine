#lang racket

(provide (rename-out [sym* *]
                     [sym+ +]
                     [sym/ /]
                     [sym= =]
                     [sym!= !=]))

(require (prefix-in ffi: "ffi.rkt")
         (prefix-in r: racket)
         "symbol.rkt")

(module+ test
  (require rackunit))

;;TODO contracts
(define (sym+ a b)
  (define s (ffi:basic_new_heap))
  (ffi:basic_add s (val a) (val b))
  (Sym s))

(define (sym* a b)
  (define s (ffi:basic_new_heap))
  (ffi:basic_mul s (val a) (val b))
  (Sym s))

(define (sym/ a b)
  (define s (ffi:basic_new_heap))
  (ffi:basic_div s (val a) (val b))
  (Sym s))

(define (sym-exp a)
  (define s (ffi:basic_new_heap))
  (ffi:basic_exp s (val a))
  (Sym s))

(define (sym= a b)
 (= (ffi:basic_eq (val a) (val b)) 1) )

(define (sym!= a b)
  (= (ffi:basic_eq (val a) (val b)) 0))

(define (negate a)
  (define s (ffi:basic_new_heap))
  (ffi:basic_neg s (val a))
  (Sym s))

