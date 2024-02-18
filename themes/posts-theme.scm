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

(define-module (themes posts-theme)
  #:use-module (srfi srfi-9)
  #:use-module (srfi srfi-19)
  #:use-module (utils external)
  #:use-module (utils sxml)
  #:use-module (haunt site)
  #:use-module (haunt post)
  #:use-module (haunt builder blog)
  #:use-module (themes layouts main-layout)
  #:export (posts-theme))

;;; FEED
(define %feed-prefix "/feeds/tags")

(define %rss-icon 
  "https://upload.wikimedia.org/wikipedia/commons/2/20/Cib-rss_%28CoreUI_Icons_v1.0.0%29.svg")

;;; POSTS
(define (post-uri site post prefix)
  (string-append (or prefix "") "/"
                 (site-post-slug site post) ".html"))

(define (post-data post)
  `(,(date->string 
       (post-date post) "⏲ ~B ~d, ~Y")
     " ｜ 🏷 Tags: "
     ,@(intersperse
         (map (lambda (tag)
                `(a (@ (href ,(tag-uri %feed-prefix tag ".xml"))) ,tag))
              (post-ref post 'tags))
         ", ")))

;;; TEMPLATES
(define (collection-template posts-path)
  (lambda (site title posts basename)
    `((div (@ (class "align-vertical"))
           (h1 ,title)
           (a (@ (href ,(string-append "/feeds/" basename ".xml"))
                 (class "align-vertical") (style "margin-left: auto;"))
              (img (@ (src ,%rss-icon) (class "icon")))))
      ,(map (lambda (post)
            (let ((uri (post-uri site post (string-append "/" posts-path))))
              `(div (hr (@ (class "posts")))
                    (h2 (@ (style "margin-bottom: .1em;"))  (a (@ (href ,uri)) ,(post-ref post 'title)))
                    ,@(post-data post) 
                    (div (@ (style "margin-bottom: .4em; margin-top: .4em"))
                         ,(first-paragraph (post-sxml post)))
                    (a (@ (href ,uri)) "read more ➤"))))
            (posts/reverse-chronological posts)))))

(define (post-template post)
  "Return the SHTML for POST's contents."
  `((h1 ,(post-ref post 'title))
    (div (@ (class "metadata")) ,@(post-data post))
    (hr)
    (article ,(post-sxml post))))

(define* (posts-theme posts-path)
  (theme
    #:name "Posts"
    #:layout (main-layout)
    #:collection-template (collection-template posts-path)
    #:post-template post-template))
