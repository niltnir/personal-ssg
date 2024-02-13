;;; nodalynn.com - Personal Website of Lynn Noda
;;;
;;; Copyright © 2019 - 2020 Jakob L. Kreuze <zerodaysfordays@sdf.org>
;;; Modifications Copyright © 2023-2024 Lynn Noda <lynn@nodalynn.com>
;;;
;;; 2023-2024-12-01: Isolated the 'intersperse' function from the "jakob/utils"
;;; module and the 'tag-uri' function from the "jakob/utils/tags" module into
;;; new "utils/external" module.
;;;
;;; This file aggregates functions from the "jakob/utils/tags" and
;;; "jakob/utils" modules from source code of 'The Personal Website of Jakob L.
;;; Kreuze' (https://git.sr.ht/~jakob/blog).
;;;
;;; This program is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by the Free
;;; Software Foundation; either version 3 of the License, or (at your option)
;;; any later version.
;;;
;;; This program is distributed in the hope that it will be useful, but WITHOUT
;;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
;;; FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
;;; more details.
;;;
;;; You should have received a copy of the GNU General Public License along
;;; with this program. If not, see <http://www.gnu.org/licenses/>.

(define-module (utils external)
  #:export (intersperse
            tag-uri))

(define (intersperse lst delim)
  "Return the elements of LST delimited by DELIM, such that the resultant list
is of an odd length and every second element is DELIM."
  (if (<= (length lst) 1)
      lst
      (cons* (car lst)
             delim
             (intersperse (cdr lst) delim))))

(define* (tag-uri prefix tag #:optional (extension ".html"))
  "Return a URI relative to the site's root for a page listing entries in PREFIX
that are tagged with TAG."
  (string-append prefix "/" tag extension))
