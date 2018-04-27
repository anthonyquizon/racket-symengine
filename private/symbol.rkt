#lang racket

(provide (struct-out Sym)
         define-symbol
         symbol
         val
         symbol->string
         symbol?)

(require (prefix-in ffi: "ffi.rkt")
         (for-syntax syntax/to-string)
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

(define-syntax (define-symbol stx)
  (syntax-case stx ()
    [(_ var)
     (with-syntax ([s (syntax->string #'(var))])
       (identifier? #'var)
       (syntax/loc stx (define var (symbol s))))]
    [(_ v0 v ...)
      #'(begin
          (define-symbol v0)
          (define-symbol v ...))]))

(define (symbol str) 
  (define s (ffi:basic_new_heap))
  (ffi:symbol_set s str)
  (Sym s))

(define (val s) (Sym-value s))

(define (symbol->string s)
  (ffi:basic_str (val s)))

(define (symbol? s)
  (= (ffi:is_a_Symbol (val s)) 1))

