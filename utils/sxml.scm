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

(define-module (utils sxml)
  #:use-module (srfi srfi-1)
  #:export (node-header 
            tag 
            attribute? 
            attributes 
            attribute-list
            class-attribute
            contents 
            node-list? 
            first-paragraph))

(define (node-header tag attributes) 
  (if (null? attributes)
    (list tag)
    (list tag attributes)))

(define (tag sxml)
  (car sxml))

(define (attribute? attribute)
  (and (list? attribute) (equal? (car attribute) '@)))

(define (attributes sxml)
  (if (attribute? (cadr sxml)) (cadr sxml) '()))

(define (attribute-list sxml)
  (cdr (attributes sxml)))

(define (class-attribute sxml)
  (let ((class-pair (filter (lambda (attr) (equal? (tag attr) 'class))
                            (attribute-list sxml))))
    (if (null? class-pair) '()
      (cadar class-pair))))

(define (contents sxml)
  (cond ((null? sxml) sxml)
        ((null? (cdr sxml)) '())
        ((null? (attributes sxml)) (cdr sxml))
        (else (cddr sxml))))

(define (node-list? sxml)
  (list? (tag sxml)))

(define (first-paragraph sxml) 
  (if (node-list? sxml)
    (let ((candidates (map (lambda (node) (first-paragraph node)) sxml)))
      (or (find (lambda (node) (not (null? node))) candidates) '()))
    (cond ((or (null? sxml) (null? (contents sxml))) '())
          ((equal? (tag sxml) 'p) sxml)
          ((list? (car (contents sxml))) (first-paragraph (contents sxml)))
          (else '()))))

