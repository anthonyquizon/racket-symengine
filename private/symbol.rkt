#lang racket

(provide (struct-out Sym)
         val
         symbol->string)

(require (prefix-in ffi: "ffi.rkt")
         racket/struct)

(struct Sym (value) 
  #:methods gen:equal+hash 
  [(define (equal-proc a b equal?-recur) (= (ffi:basic_eq (Sym-value a) (Sym-value b)) 1))
   (define (hash-proc a hash-recur) 1)
   (define (hash2-proc a hash-recur) 1)]

  #:methods gen:custom-write  
  [(define write-proc
     (make-constructor-style-printer 
       (lambda [_s] 'Symbol) 
       (lambda [s] (list (symbol->string s)))))])

(define (val s) (Sym-value s))

(define (symbol->string s)
  (ffi:basic_str (val s)))

