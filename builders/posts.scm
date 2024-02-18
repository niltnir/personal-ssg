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

(define-module (builders posts)
  #:use-module (utils filesys)
  #:use-module (haunt artifact)
  #:use-module (haunt site)
  #:use-module (haunt post)
  #:use-module (haunt builder blog)
  #:use-module (haunt html)
  #:use-module (haunt reader)
  #:use-module (haunt reader commonmark)
  #:use-module (themes posts-theme)
  #:export (posts))

(define (make-index theme site title posts destination-directory)
  (serialized-artifact
    (string-append destination-directory "/index.html")
    (render-collection theme site title posts (directory->basename destination-directory))
    sxml->html))

(define* (posts input-directory destination-directory #:key 
               (title (directory->title destination-directory)) (reader commonmark-reader))
  (let ((articles (directory->posts input-directory))
        (post-theme (posts-theme destination-directory)))
    (lambda (site posts)
      (append (list (make-index post-theme site title articles destination-directory))
              (map (lambda (post) 
                     (serialized-artifact
                       (string-append destination-directory "/"
                                      (file-name site post))
                       (render-post post-theme site post)
                       sxml->html))
                   articles)))))
