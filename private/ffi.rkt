#lang racket

(require ffi/unsafe
         ffi/unsafe/define
         ffi/unsafe/alloc)

(provide basic_new_heap
         basic_add
         basic_mul
         basic_eq
         basic_str
         basic_exp
         basic_neg
         symbol_set 
         integer_set_si
         integer_get_si

         real_double_set_d

         rational_set
         complex_set
         
         is_a_Number
         is_a_Integer
         is_a_Rational
         is_a_Symbol
         is_a_Complex
         is_a_RealDouble
         )

(define-ffi-definer define-symengine (ffi-lib "libsymengine"))

(define _BASIC_STRUCT-pointer (_cpointer 'BASIC_STRUCT))
(define _TEUCHOS_HANDLE-pointer (_cpointer 'TEUCHOS_HANDLE))
(define-cstruct _BASIC ([teuchos_handle _TEUCHOS_HANDLE-pointer]
                        [teuchos_strength _int]))

(define-symengine basic_free_stack (_fun _BASIC -> _void))
(define-symengine basic_new_stack (_fun _BASIC -> _void))

(define-symengine basic_free_heap (_fun _BASIC_STRUCT-pointer -> _int)
  #:wrap (deallocator))
 
(define-symengine basic_new_heap (_fun -> _BASIC_STRUCT-pointer)
  #:wrap (allocator basic_free_heap))

(define-symengine symbol_set (_fun _BASIC_STRUCT-pointer _string -> _int))
(define-symengine is_a_Number (_fun _BASIC_STRUCT-pointer -> _int))
(define-symengine is_a_Rational (_fun _BASIC_STRUCT-pointer -> _int))
(define-symengine is_a_Integer (_fun _BASIC_STRUCT-pointer -> _int))
(define-symengine is_a_Complex (_fun _BASIC_STRUCT-pointer -> _int))
(define-symengine is_a_Symbol (_fun _BASIC_STRUCT-pointer -> _int))
(define-symengine is_a_RealDouble (_fun _BASIC_STRUCT-pointer -> _int))

(define-symengine integer_set_si (_fun _BASIC_STRUCT-pointer _sllong -> _int))
(define-symengine integer_get_si (_fun _BASIC_STRUCT-pointer -> _sllong))

(define-symengine real_double_set_d (_fun _BASIC_STRUCT-pointer _double -> _int))

(define-symengine rational_set(_fun _BASIC_STRUCT-pointer _BASIC_STRUCT-pointer _BASIC_STRUCT-pointer -> _int))
(define-symengine complex_set(_fun _BASIC_STRUCT-pointer _BASIC_STRUCT-pointer _BASIC_STRUCT-pointer -> _int))

(define-symengine basic_add (_fun _BASIC_STRUCT-pointer _BASIC_STRUCT-pointer _BASIC_STRUCT-pointer -> _int))
(define-symengine basic_mul (_fun _BASIC_STRUCT-pointer _BASIC_STRUCT-pointer _BASIC_STRUCT-pointer -> _int))

(define-symengine basic_eq (_fun _BASIC_STRUCT-pointer _BASIC_STRUCT-pointer -> _int))

(define-symengine basic_str (_fun _BASIC_STRUCT-pointer -> _string/utf-8 ))
(define-symengine basic_exp (_fun _BASIC_STRUCT-pointer _BASIC_STRUCT-pointer -> _int))
(define-symengine basic_neg (_fun _BASIC_STRUCT-pointer _BASIC_STRUCT-pointer -> _int))


