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

(define-module (themes layouts main-layout)
  #:use-module (srfi srfi-9)
  #:use-module (srfi srfi-19)
  #:use-module (ice-9 ftw)
  #:use-module (haunt asset)
  #:use-module (haunt artifact)
  #:use-module (haunt site)
  #:use-module (haunt post)
  #:use-module (haunt builder blog)
  #:use-module (haunt builder atom)
  #:use-module (haunt builder assets)
  #:use-module (haunt html)
  #:use-module (haunt reader)
  #:use-module (haunt reader commonmark)
  #:export (main-layout))

;;; COMPONENTS
(define (css name)
  `(link (@ (rel "stylesheet")
            (href ,(string-append "/assets/css/" name ".css")))))

(define %license-text
  '(small (@ (xmlns:cc "http://creativecommons.org/ns#") (xmlns:dct "http://purl.org/dc/terms/"))
      (a (@ (property "dct:title") (rel "cc:attributionURL") (href "/legal.html"))
         "This website")
      " is licensed under "
      (a (@ (href "http://creativecommons.org/licenses/by-nc-sa/4.0/?ref=chooser-v1")
            (target "_blank") (rel "license noopener noreferrer")
            (style "display:inline-flex;"))
         "CC BY-NC-SA 4.0 International")
      "  •  © 2023 Lynn Noda"))

(define %rss-icon 
  "https://upload.wikimedia.org/wikipedia/commons/2/20/Cib-rss_%28CoreUI_Icons_v1.0.0%29.svg")

(define %default-header
  `(header (@ (id "header"))
     (nav (@ (id "header-nav") (class "picnic"))
       (a (@ (class "pseudo button brand-link") (href "/"))
          (h2 (@ (id "brand-label")) "Lynn Noda"))
       (div (@ (id "header-menu") (class "menu"))
            (a (@ (href "/feeds/feed.xml") (id "feed") (class "align-vertical pseudo button"))
               (img (@ (src ,%rss-icon) (width "20px") (height "20px"))))))))

(define %default-footer
  `(footer (@ (id "page-footer")) 
           (div (@ (id "footer-right"))
                ,%license-text)))

;;; HTML BOOLEAN-ATTRIBUTES
(define (boolean-attribute predicate name)
  (if (equal? predicate #t) `((,name "true")) '()))

(define* (checked-option stack-name option-name href #:key (checked? #f))
  (let ((checked-attribute (boolean-attribute checked? 'checked)))
    `(label (@ (class "stack"))
            (input (@ (name ,stack-name) (type "radio") ,@checked-attribute))
            (a (@ (class "toggle pseudo button") (href ,href))
               (span ,option-name)))))

;;; NAVIGATION
(define title-data
  '(("About" "/" #f)
    ("Math" "/math" #f)
    ("Computing & Software" "/cs" #f)
    ("Software Projects" "/cs/software.html" #t)
    ("Art & Design" "/art" #f)
    ("Prose" "/prose" #f)
    ("Blog" "/prose/blog" #t)
    ("Essays" "/prose/essay" #t)
    ("Hobbies" "/hobbies" #f)
    ("Contact" "/contact.html" #f)))

(define (title title-datum)
  (car title-datum))

(define (title-slug title-datum)
  (cadr title-datum))

(define (title-sub? title-datum)
  (caddr title-datum))

(define* (navoption option-name href #:optional suboption? #:key (checked? #f))
  (let ((name-display (if suboption? (string-append "  •  " option-name) option-name)))
    (checked-option "navoption" name-display href #:checked? checked?)))

(define (make-navoptions selected-page-title)
  (map (lambda (entry) 
          (if (equal? (title entry) selected-page-title)
            (navoption (title entry) (title-slug entry) (title-sub? entry) #:checked? #t)
           (navoption (title entry) (title-slug entry) (title-sub? entry)))) title-data))

(define (navstack selected-page-title)
  `(div (@ (class "navstack")) 
        ,@(make-navoptions selected-page-title)))

;;; LAYOUT
(define* (main-layout #:key (header %default-header) (content identity) (footer %default-footer))
   (lambda (site title body)
     `((doctype "html")
       (head
        (meta (@ (charset "utf-8")))
        (meta (@ (name "viewport") (content "width=device-width, initial-scale=1.0")))
        (link (@ (rel "icon") (type "image/x-icon") (href "/images/favicon.ico")))
        (link (@ (rel "icon") (type "image/png") (sizes "32x32") (href "/images/favicon-32x32.png")))
        (link (@ (rel "icon") (type "image/png") (sizes "16x16") (href "/images/favicon-16x16.png")))
        (link (@ (rel "apple-touch-icon") (sizes "180x180") (href "/images/apple-touch-icon.png")))
        (link (@ (rel "manifest") (href "/images/site.webmanifest")))
        ,(css "picnic")
        ,(css "tufte")
        ,(css "custom")
        ,(css "takefive")
        (script "\"Stop crbug.com/332189 and crbug.com/167083\";")
        (title ,(string-append title " — " (site-title site))))
       (body 
         ,header
         (section (@ (id "body") (class "container flex five"))
            (div (@ (id "nav-container") (class "full fifth-1000"))
              (aside (@ (id "side-nav"))
                     (label (@ (id "hamburger-icon") (for "ham-toggle") (class "pseudo button")) "☰")
                     (input (@ (type "checkbox") (id "ham-toggle")))
                     ,(navstack title)))
            (section (@ (id "content-section") 
                        (class "full four-fifth-1000"))
                     (article (@ (id "page-content")) 
                              ,(content body))))
         ,footer))))
