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

(define-module (extension)
  #:use-module (utils util)
  #:use-module (srfi srfi-9)
  #:use-module (srfi srfi-19)
  #:use-module (ice-9 ftw)
  #:use-module (ice-9 textual-ports)
  #:use-module (haunt post)
  #:export (extended-post inject sidenote gallery slide oly))

;;; PATHS AND LINKS
(define img-path (string-append (getcwd) "/images/"))

(define (img-url rest-of-path)
  (string-append "/images/" rest-of-path))

(define oly-path (string-append (getcwd) "/.tmp/oly/"))

;;; MARKDOWN EXTENSION HACK
(define extensions
  (list "inject" "sidenote" "gallery" "oly"))

(define extension-prefixes
  (map (lambda (extension-string) (string-append "(" extension-string)) extensions))

(define (parseable-strings? strings) 
  (let ((string (string-delete #\space (apply string-append strings))))
    (and (matching-prefix? string extension-prefixes)
         (valid-parens? string))))

(define (parsed-sexp strings)
  (let ((string (apply string-append strings)))
    (read (open-input-string string))))

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

(define (contents sxml)
  (if (null? (attributes sxml)) (cdr sxml) (cddr sxml)))

; (code (@ (some-att "hello")) "This is some code!")
; (h2 (p (@ (class "sxml")) "some sxml here!") "more code here")
(define (node-list? sxml)
  (list? (tag sxml)))

(define (embedded-sxml sxml) 
  "Within SXML, looks for 'code' tags with parseable s-expressions and
  returns a new document which directly replaces those tags with the eval of
  those inner expressions."
  ; (format #t "THE SXML: ~a~%" sxml)
  (use-modules (extension))
  (if (node-list? sxml)
    (map (lambda (node) (embedded-sxml node)) sxml)
    (let* ((tg (tag sxml)) (attr (attributes sxml)) (cntnts (contents sxml)))
      (cond ((null? sxml) '())
            ((and (equal? tg 'code) (null? attr)) ; no nesting of sxml in 'code' tag
             ;; therefore contents MUST be a list of strings
             (if (parseable-strings? cntnts) (eval (parsed-sexp cntnts) (current-module)) sxml))
            ((equal? tg 'pre) ; math codeblock for KaTex
             (let ((replacement (contents (car cntnts))))
               `(p ,@replacement)))
            (else (append
                    (node-header tg attr)
                    (map (lambda (content) 
                           (if (string? content) content (embedded-sxml content)))
                         cntnts)))))))

;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! FIX !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;; the random ((evaled node p "blah blah blah")) in the output sxml is because
;; initially, the code used to look like 
;; (p (code "(oly \"japan-2010-4\" 0)"))
;; and the initial 'p' is replaced by its contents but keeps the nesting...
(define (remove-bad-p-tags sxml)
  "Within SXML, look for degenerate uses of paragraph tags and replace them
  with their contents. So far, these include p tags that only contain a single
  sxml node, and li/blockquote tags that wrap inner content with p tags."
  (cond ((null? sxml) '())
        ((node-list? sxml) (map (lambda (node) (remove-bad-p-tags node)) sxml))
        ((and (equal? (tag sxml) 'p) (null? (attributes sxml)) 
              (= (length (contents sxml)) 1) (list? (car (contents sxml))))
         (car (contents sxml)))
        ((or (equal? (tag sxml) 'li) (equal? (tag sxml) 'blockquote))
         (let ((new-content (accumulate 
                              (lambda (content accum) 
                                ;; we look at the contents of an li/blockquote node and see if any have
                                ;; degenerate p tags inside
                                (cond ((and (list? content) (equal? (tag content) 'p) (not (attribute? content)))
                                       (append (contents content) accum))
                                      ((list? content) (append (list (remove-bad-p-tags content)) accum))
                                      (else (append (list content) accum)))) '() (contents sxml))))
           (append (node-header (tag sxml) (attributes sxml)) new-content)))
        (else (append
                (node-header (tag sxml) (attributes sxml))
                (map (lambda (content) 
                       (if (string? content) content (remove-bad-p-tags content)))
                     (contents sxml))))))

(define (extended-sxml sxml)
  (remove-bad-p-tags (embedded-sxml sxml)))

(define (extended-post post)
  (let ((file-name (post-file-name post))
        (metadata (post-metadata post))
        (sxml (extended-sxml (post-sxml post))))
    (make-post file-name metadata sxml)))

;;; INJECT
(define (inject sxml)
  sxml)

;;; SIDENOTE
(define (sidenote sxml)
  (let ((sidenote-id (generate-id "sn")))
    `((label (@ (for ,sidenote-id) (class "margin-toggle sidenote-number")))
      (input (@ (type "checkbox") (id ,sidenote-id) (class "margin-toggle")))
      (span (@ (class "sidenote")) ,sxml))))

;;; GALLERY
(define (valid-img-names names)
  (filter (lambda (name) (and (string-any #\. name) (not (string-every #\. name)))) names))

(define (directory-files directory-path)
  (scandir (string-append img-path directory-path)))

(define (img-names->img-paths directory-path img-names)
  (map (lambda (name) (string-append directory-path "/" name)) img-names))

(define (external-link? path)
  (and (string-prefix? "http" path) (string-any #\: path)))

(define-record-type <slide>
  (slide path title caption description)
  slide?
  (path slide-path)
  (title slide-title)
  (caption slide-caption)
  (description slide-description))

(define* (img-names->slide-data directory-path img-names)
  (map (lambda (name) 
         (slide (string-append directory-path "/" name) #f #f #f)) 
       img-names))

; `(gallery "creations/posters")`
; '(gallery ("creations/posters" "Title of Gallery" "Gallery Caption" "Description of Gallery"))'
; `(gallery ("test/hello.jpg" "Title of Hello" "Caption Here" "Description of things going on here.")
;           ("foo.jpg" "Foo" "The foo entered the bar..."))`

(define gallery
  (case-lambda*

    ((directory-path) ;test (-> ../assets/imgs/test)
      (let ((img-names (valid-img-names (directory-files directory-path))))
        (if (> (length img-names) 1)
          (apply gallery (img-names->slide-data directory-path img-names)))))

    ((#:rest slides) ;test/balloon.jpg (-> /assets/imgs/test/balloon.jpg)
     (let ((gallery-id (generate-id "gal")))

       (define (slide-id index)
         (string-append gallery-id "-" (number->string index)))

       (define (slide-hash index)
         (string-append "#" (slide-id index)))

       (define (slide-figure path caption)
         (if (external-link? path)
           `(iframe (@ (src ,path) (style "width: 640px; height: 360px;") 
                       (autoplay "0") (autostart "0") 
                       (allowfullscreen "true") (loading "lazy")))
           `(img (@ (src ,(img-url path)) (alt ,caption) 
                    (style "width: auto; height: auto; object-fit: contain;") 
                    (loading "lazy")))))

       (define* (slide-view slide index)
         (let* ((path (slide-path slide))
                (title (slide-title slide))
                (caption (slide-caption slide))
                (description (slide-description slide))
                (header (if title `((header (h2 ,title))) '()))
                (figcaption (if caption `((figcaption ,caption)) '()))
                (extra (if description `((p ,description)) '())))
           `(article (@ (id ,(slide-id index)) (class "slide no-hashtag"))
                      ,@header
                      (figure (@ (class "gallery-figure"))
                        ,(slide-figure path caption)
                        ,@figcaption)
                      (nav (a (@ (href "#nowhere") (rel "parent")) "Article")
                           (a (@ (href ,(slide-hash (- index 1))) (rel "prev")) "Previous")
                           (a (@ (href ,(slide-hash (+ index 1))) (rel "next")) "Next"))
                      (article (@ (class "roomy")) ,@extra))))

       `(div (@ (class "gallery")) 
             (div (@ (id "image-container") (class "flex two four-500 six-800"))
                  ,@(index-map 
                      (lambda (slide index) 
                        (let* ((title (slide-title slide))
                               (link-label (if title title (string-append "Image " (number->string index)))))
                          `(a (@ (href ,(slide-hash index)) (class "gallery button")) ,link-label)))
                     slides))
             ,@(index-map (lambda (slide index) (slide-view slide index)) slides))))))

;;; MATH
; `(oly "japan-2010-4" 0)` 
(define (oly title block-index)
  ;title is a string of the form "contest-year-number"
  (let* ((filename (string-append 
                    oly-path title "-" (number->string block-index) ".md"))
         (port (open-input-file filename))
         (textblock (get-string-all port)))
         (close-port port)
         (if (string? textblock)
           `(p ,textblock)
           (error "The file for '~A' cannot be found. Make sure the build contains the specified problem from von." title))))


