#lang racket

(require (prefix-in ffi: "ffi.rkt")
         (prefix-in r: racket)
         (for-syntax syntax/to-string)
         "symbol.rkt")

(provide (struct-out Sym)
         define-symbol
         integer
         rational
         symbol
         number?
         integer?
         rational?
         symbol?)

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

(define (integer i)
  (cond 
    [(r:integer? i) 
     (define s (ffi:basic_new_heap))
     (ffi:integer_set_si s i)
     (Sym s)]
    [(integer? i) i]
    [else (raise 'sym-type-error "integer")]))

(define (real i)
  (cond 
    [(r:real? i) 
     (define s (ffi:basic_new_heap))
     (ffi:real_double_set_d s i)
     (Sym s)]
    [else (raise 'sym-type-error "real")]))

(define (set_rational i j)
  (define s (ffi:basic_new_heap))
  (define m (integer i))
  (define n (integer j))

  (ffi:rational_set s (val m) (val n))
  (Sym s))

(define (rational i [j null])
  (cond 
    [(and (null? j) (r:rational? i)) 
     (set_rational (r:numerator i) (r:denominator i))]
    [(and (or (r:integer? i) (integer? i))
          (or (r:integer? j) (integer? j)))
     (set_rational i j)]
    [else (raise 'sym-type-error "rational must be of integer integer or integer/integer")]))

(define (integer-value s)
  (cond 
    [(integer? s) (ffi:integer_get_si (val s))]
    [else (raise 'sym-type-error #t)]))

;; TODO use contracts
(define (number? s)
  (= (ffi:is_a_Number (val s)) 1))

(define (integer? s)
  (= (ffi:is_a_Integer (val s)) 1))

(define (rational? s)
  (= (ffi:is_a_Rational (val s)) 1))

;(define (complex? s)
  ;(= (ffi:is_a_Complex (val s)) 1))

(define (symbol? s)
  (= (ffi:is_a_Symbol (val s)) 1))

