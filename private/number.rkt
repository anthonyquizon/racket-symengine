#lang racket

(provide integer
         rational
         number?
         integer?
         rational?
         symbol?)
(require (prefix-in ffi: "ffi.rkt")
         (prefix-in r: racket)
         "symbol.rkt")

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

