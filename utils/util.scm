;;; nodalynn.com - Personal Website of Lynn Noda
;;;
;;; Copyright © 2023-2024 Lynn Noda <lynn@nodalynn.com>
;;;
;;; This program is free software: you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation, either version 3 of the License, or
;;; (at your option) any later version.
;;;
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define-module (utils util)
  #:export (random-in-range 
            generate-id
            accumulate
            every
            any
            matching-prefix?
            valid-parens?
            number->english
            0->n
            n->0
            index-map))

(define (random-in-range min max)
  (+ (random (- max min)) min))

(define (generate-id prefix)
  (string-append prefix "-" (number->string (random-in-range 100000 1000000))
                 "-" (number->string (random-in-range 100000 1000000))))

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define (every predicate elements)
  (accumulate (lambda (el acc) (and (predicate el) acc)) #t elements))

(define (any predicate elements)
  (accumulate (lambda (el acc) (or (predicate el) acc)) #f elements))

(define (matching-prefix? string prefixes)
  (any (lambda (prefix) (string-prefix? prefix string)) prefixes))

(define (valid-parens? string)
  (let* ((chars (reverse! (string->list string)))
         (result (accumulate 
                   (lambda (char acc) 
                     (let ((num (car acc)) (bool (cdr acc)))
                       (cond ((or (< num 0) (equal? bool #f)) 
                              (cons -1 #f))
                             ((equal? #\( char) (cons (+ num 1) #t)) 
                             ((equal? #\) char) (cons (- num 1) (>= (- num 1) 0)))
                             (else acc))))
                   (cons 0 #t) chars)))
    (and (= (car result) 0) (cdr result))))

(define (number->english integer)
  (format #f "~R" integer))

(define (n->0 n)
  (cond ((= n 0) '())
        (else (cons (- n 1) (n->0 (- n 1))))))

(define (0->n n) 
  (reverse! (n->0 n)))

(define (index-map proc lst)
  (map (lambda (el index) (proc el index)) lst (0->n (length lst))))

