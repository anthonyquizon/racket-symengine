#lang racket

(require "../private/wrapper.rkt"
         rackunit)

(test-case 
  "rational"

  (check-equal?
    (rational 1/2)
    () ;;TODO string version of rational
    )
  )
