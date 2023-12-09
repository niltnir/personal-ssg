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

(define-module (themes page-theme)
  #:use-module (haunt builder blog)
  #:use-module (haunt post)
  #:use-module (themes layouts main-layout)
  #:export (page-theme))

(define* page-theme
  (theme
    #:layout (main-layout)
    #:post-template (lambda (post) (post-sxml post))))
