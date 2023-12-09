;;; nodalynn.com - Personal Website of Lynn Noda
;;;
;;; Copyright © 2023 Lynn Noda <lynn@nodalynn.com>
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

(define-module (builders page)
  #:use-module (extension)
  #:use-module (haunt artifact)
  #:use-module (haunt builder blog)
  #:use-module (haunt html)
  #:use-module (haunt reader)
  #:use-module (haunt reader commonmark)
  #:use-module (themes page-theme)
  #:export (page))

(define* (page file output #:key (reader commonmark-reader))
  (lambda (site posts)
    `(,(serialized-artifact
         output
         (render-post page-theme site (extended-post (read-post reader file '())))
         sxml->html))))
