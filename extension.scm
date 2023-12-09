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

(define-module (extension)
  #:use-module (utils util)
  #:use-module (srfi srfi-9)
  #:use-module (srfi srfi-19)
  #:use-module (ice-9 ftw)
  #:use-module (haunt post)
  #:export (extended-post inject sidenote gallery slide))

;;; PATHS AND LINKS
(define img-path (string-append (getcwd) "/images/"))

(define (img-url rest-of-path)
  (string-append "/images/" rest-of-path))

;;; MARKDOWN EXTENSION HACK
(define extensions
  (list "inject" "sidenote" "gallery"))

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
    (let* ((tag (car sxml))
           (attributes (if (attribute? (cadr sxml)) (cadr sxml) '()))
           (contents (if (null? attributes) (cdr sxml) (cddr sxml))))
      (cond ((null? sxml) '())
            ((and (equal? tag 'code) (null? attributes)) ; no nesting of sxml in 'code' tag
             ;; therefore contents MUST be a list of strings
             (if (parseable-strings? contents) (eval (parsed-sexp contents) (current-module)) sxml))
            (else (append
                    (node-header tag attributes)
                    (map (lambda (content) 
                           (if (string? content) content (embedded-sxml content)))
                         contents)))))))

(define (remove-bad-p-tags sxml)
  "Within SXML, look for degenerate uses of paragraph tags and replace them
  with their contents. So far, these include p tags that only contain a single
  sxml node, and li/blockquote tags that wrap inner content with p tags."
  (cond ((null? sxml) '())
        ((node-list? sxml) (map (lambda (node) (remove-bad-p-tags node)) sxml))
        ((and (equal? (tag sxml) 'p) (null? (attributes sxml)) 
              (= (length (contents sxml)) 1) (list? (car (contents sxml))))
         (contents sxml))
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
  (scandir (string-append  img-path directory-path)))

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
                    (style "height: auto; object-fit: contain;") 
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

