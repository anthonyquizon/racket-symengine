#lang racket

(require (prefix-in ffi: "private/ffi.rkt")
         (prefix-in r: racket)
         racket/struct)

(provide symbol)

(struct Sym (value) 
  #:methods 
  gen:custom-write
  [(define write-proc
     (make-constructor-style-printer 
       (lambda [_s] 'Sym)
       (lambda [s] (print-sym s))))])

(define (print-sym s)
  (cond
    [(integer? s) `(Integer ,(ffi:integer_get_ui (val s)))]
    [else null]))

(module+ test
  (require rackunit))

(define val Sym-value)

(define (symbol str)
  (define s (ffi:basic_new_heap))
  (ffi:symbol_set s str)
  (Sym s))

(define (integer i)
  (cond 
    [(r:integer? i) 
     (define s (ffi:basic_new_heap))
     (ffi:integer_set_ui s i)
     (Sym s)]
    [else (raise 'sym-type-error #t)]))

(define (real i)
  (cond 
    [(r:real? i) 
     (define s (ffi:basic_new_heap))
     (ffi:real_double_set_d s i)
     (Sym s)]
    [else (raise 'sym-type-error #t)]))

(define (set_rational i j)
   (define s (ffi:basic_new_heap))
   (define n (ffi:basic_new_heap))
   (define m (ffi:basic_new_heap))

   (ffi:integer_set_ui n )
   (ffi:integer_set_ui m )

   (ffi:rational_set s n m)
   (Sym s))

(define (rational i [j null])
  (cond 
    [(r:rational? i) 
     (set_rational (r:numerator i) (r:denominator i))]
    [(and (r:integer i) (r:integer j))
     (set_rational i j)]
    [else (raise 'sym-type-error #t)]))

(define (number x)
  (cond
    [(r:integer? x) (integer x)]
    [(r:real? x) (real x)]
    [(or (real? x) (integer? x)) x]
    [else (raise 'sym-type-error #t)]))

(define (complex re im)
  ;;TODO rationals?
  (define re^ (number re))
  (define im^ (number im))

  (define s (ffi:basic_new_heap))
  (ffi:complex_set s re^ im^)
  (Sym s))

(define (integer-value s)
  (cond 
    [(integer? s) (ffi:integer_get_ui (val s))]
    [else (raise 'sym-type-error #t)]))

(define (+sym a b)
  (define s (ffi:basic_new_heap))
  (ffi:basic_add s (val a) (val b))
  (Sym s))

(define (*sym a b)
  (define s (ffi:basic_new_heap))
  (ffi:basic_mul s (val a) (val b))
  (Sym s))

(define (=sym a b)
  (= (ffi:basic_eq (val a) (val b)) 1))

(module+ test 
  (let ([x (symbol "x")]
        [i (integer 2)])
    (check-true 
      (=sym (+sym x x) (*sym i x)))))

(define (number? s)
  (= (ffi:is_a_Number (val s)) 1))

(define (integer? s)
  (= (ffi:is_a_Integer (val s)) 1))

(define (rational? s)
  (= (ffi:is_a_Rational (val s)) 1))

(define (complex? s)
  (= (ffi:is_a_Complex (val s)) 1))

(define (symbol? s)
  (= (ffi:is_a_Symbol (val s)) 1))

(define (real? s)
  (= (ffi:is_a_ReadDouble (val s)) 1))

