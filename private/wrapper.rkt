#lang racket

(require (prefix-in ffi: "ffi.rkt")
         (prefix-in r: racket)
         (for-syntax syntax/to-string)
         racket/struct)

(provide (struct-out Sym)
         define-symbolic
         integer
         symbol
         basic->string
         (rename-out [sym/* *] 
                     [sym/+ +] 
                     [sym/= =] 
                     [sym/!= !=]))

(module+ test
  (require rackunit))

(struct Sym (value) 
  #:methods 
  gen:custom-write
  [(define write-proc
     (make-constructor-style-printer 
       (lambda [_s] 'Symbol) 
       (lambda [s] (list (basic->string s)))))])

(define (val s) (Sym-value s))

(define (symbol str) 
  (define s (ffi:basic_new_heap))
  (ffi:symbol_set s str)
  (Sym s))

(define-syntax (define-symbolic stx)
  (syntax-case stx ()
    [(_ var)
     (with-syntax ([s (syntax->string #'(var))])
       (identifier? #'var)
       (syntax/loc stx (define var (symbol s))))]
    [(_ v0 v ...)
      #'(begin
          (define-symbolic v0)
          (define-symbolic v ...))]))

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

;(define (rational i [j null])
  ;(cond 
    ;[(r:rational? i) 
     ;(set_rational (r:numerator i) (r:denominator i))]
    ;[(and (r:integer? i) (r:integer? j))
     ;(set_rational i j)]
    ;[else (raise 'sym-type-error #t)]))

(define (integer-value s)
  (cond 
    [(integer? s) (ffi:integer_get_ui (val s))]
    [else (raise 'sym-type-error #t)]))

;;TODO generics 
(define (sym/+ a b)
  (define s (ffi:basic_new_heap))
  (ffi:basic_add s (val a) (val b))
  (Sym s))

(define (sym/* a b)
  (define s (ffi:basic_new_heap))
  (ffi:basic_mul s (val a) (val b))
  (Sym s))

(define (sym/exp a)
  (define s (ffi:basic_new_heap))
  (ffi:basic_exp s (val a))
  (Sym s))

(define (sym/= a b)
  (= (ffi:basic_eq (val a) (val b)) 1))

(define (sym/!= a b)
  (= (ffi:basic_eq (val a) (val b)) 0))

;(module+ test 
  ;(let ([x (symbol "x")]
        ;[i (integer 2)])
    ;(check-true 
      ;(=sym (+sym x x) (*sym i x)))))

(define (number? s)
  (= (ffi:is_a_Number (val s)) 1))

(define (integer? s)
  (= (ffi:is_a_Integer (val s)) 1))

;(define (rational? s)
  ;(= (ffi:is_a_Rational (val s)) 1))

;(define (complex? s)
  ;(= (ffi:is_a_Complex (val s)) 1))

(define (symbol? s)
  (= (ffi:is_a_Symbol (val s)) 1))

(define (basic->string s)
  (ffi:basic_str (val s)))

;(define (real? s)
  ;(= (ffi:is_a_ReadDouble (val s)) 1))

