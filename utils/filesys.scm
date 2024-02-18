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

(define-module (utils filesys)
  #:use-module (utils util)
  #:use-module (extension)
  #:use-module (haunt site)
  #:use-module (haunt post)
  #:use-module (haunt reader)
  #:use-module (haunt reader commonmark)
  #:export (valid-file-name 
            directory->basename
            directory->title
            directories->posts
            directory->posts
            file-name))

(define (valid-file-name name)
  (and (string-any #\. name) (not (string-every #\. name)) 
       (any (lambda (extension) (string-suffix? "md" name)) 
            '("md" "mkd" "mdwn" "mdown" "mdtxt" "mdtext" "markdown" "text"))))

(define (directory->basename directory)
  (car (reverse! (string-split directory #\/))))

(define (directory->title directory)
  (string-titlecase (directory->basename directory)))

(define* (directory->posts directory #:key (readers (list commonmark-reader)))
  (map 
    (lambda (post) (extended-post post)) 
    (read-posts directory valid-file-name readers)))

(define* (directories->posts directories #:key (readers (list commonmark-reader)))
  (cond ((string? directories) (directory->posts directories))
        ((list? directories) 
         (apply append! 
           (map (lambda (directory) 
                  (directory->posts directory #:readers readers)) 
                directories)))
        (else #f)))

(define (file-name site post)
  (string-append (site-post-slug site post) ".html"))

