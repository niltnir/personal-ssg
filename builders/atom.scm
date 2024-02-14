;;; nodalynn.com - Personal Website of Lynn Noda
;;;
;;; Copyright © 2015 David Thompson <davet@gnu.org>
;;; Copyright © 2016 Christopher Allan Webber <cwebber@dustycloud.org>
;;; Modifications Copyright © 2023-2024 Lynn Noda <lynn@nodalynn.com>
;;;
;;; 202e--12-01: Modified 'atom-feeds' and 'atom-feeds-by-tag' to take an
;;; optional 'input-directory' parameter specifying a path to relevant posts.
;;; These paths are then used to generate post objects instead of the default
;;; "/posts" directory.
;;;
;;; 2023-11-30: Removed unnecessary functions and module imports from the
;;; "builder/atom" module 
;;;
;;; This file is modified from the "builder/atom" module in Haunt Static Site
;;; Generator (https://dthompson.us/projects/haunt.html).
;;;
;;; This program is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by the Free
;;; Software Foundation; either version 3 of the License, or (at your option)
;;; any later version.
;;;
;;; This program is distributed in the hope that it will be useful, but WITHOUT
;;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
;;; FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
;;; more details.
;;;
;;; You should have received a copy of the GNU General Public License along
;;; with this program. If not, see <http://www.gnu.org/licenses/>.

(define-module (builders atom)
  #:use-module (utils filesys)
  #:use-module (srfi srfi-19)
  #:use-module (srfi srfi-26)
  #:use-module (ice-9 match)
  #:use-module (sxml simple)
  #:use-module (haunt artifact)
  #:use-module (haunt site)
  #:use-module (haunt post)
  #:use-module (haunt utils)
  #:use-module (haunt html)
  #:use-module (web uri)
  #:export (atom-feed
            atom-feeds-by-tag))

(define (sxml->xml* sxml port)
  "Write SXML to PORT, preceded by an <?xml> tag."
  (display "<?xml version=\"1.0\" encoding=\"utf-8\"?>" port)
  (sxml->xml sxml port))

(define (date->string* date)
  "Convert date to RFC-3339 formatted string."
  (date->string date "~Y-~m-~dT~H:~M:~SZ"))

(define* (post->atom-entry site post #:key (blog-prefix ""))
  "Convert POST into an Atom <entry> XML node."
  (let ((uri (uri->string
              (build-uri (site-scheme site)
                         #:host (site-domain site)
                         #:path (string-append blog-prefix "/"
                                               (site-post-slug site post)
                                               ".html")))))
    `(entry
      (title ,(post-ref post 'title))
      (id ,uri)
      (author
       (name ,(post-ref post 'author))
       ,(let ((email (post-ref post 'email)))
          (if email `(email ,email) '())))
      (updated ,(date->string* (post-date post)))
      (link (@ (href ,uri) (rel "alternate")))
      (summary (@ (type "html"))
               ,(sxml->html-string (post-sxml post)))
      ,@(map (lambda (enclosure)
               `(link (@ (rel "enclosure")
                         (title ,(enclosure-title enclosure))
                         (href ,(enclosure-url enclosure))
                         (type ,(enclosure-mime-type enclosure))
                         ,@(map (match-lambda
                                  ((key . value)
                                   (list key value)))
                                (enclosure-extra enclosure)))))
             (post-ref-all post 'enclosure)))))

(define* (atom-feed #:optional input-directories #:key
                    (file-name "feed.xml")
                    (subtitle "Recent Posts")
                    (filter posts/reverse-chronological)
                    (max-entries 20)
                    (blog-prefix ""))
  "Return a builder procedure that renders a list of posts as an Atom
feed.  All arguments are optional:

FILE-NAME: The page file name
SUBTITLE: The feed subtitle
FILTER: The procedure called to manipulate the posts list before rendering
MAX-ENTRIES: The maximum number of posts to render in the feed"
(lambda (site backup-posts)
  (let ((posts (or (directories->posts input-directories) backup-posts))
        (uri (uri->string
               (build-uri (site-scheme site)
                          #:host (site-domain site)
                          #:path (string-append "/" file-name)))))
    (serialized-artifact file-name
                         `(feed (@ (xmlns "http://www.w3.org/2005/Atom"))
                                (title ,(site-title site))
                                (id ,uri)
                                (subtitle ,subtitle)
                                (updated ,(date->string* (current-date)))
                                (link (@ (href ,(string-append (site-domain site)
                                                               "/" file-name))
                                         (rel "self")))
                                (link (@ (href ,(site-domain site))))
                                ,@(map (cut post->atom-entry site <>
                                            #:blog-prefix blog-prefix)
                                       (take-up-to max-entries (filter posts))))
                         sxml->xml*))))

(define* (atom-feeds-by-tag #:optional input-directories #:key
                            (prefix "feeds/tags")
                            (filter posts/reverse-chronological)
                            (max-entries 20)
                            (blog-prefix ""))
  "Return a builder procedure that renders an atom feed for every tag
used in a post.  All arguments are optional:

PREFIX: The directory in which to write the feeds
FILTER: The procedure called to manipulate the posts list before rendering
MAX-ENTRIES: The maximum number of posts to render in each feed"
(lambda (site backup-posts)
  (let* ((posts (or (directories->posts input-directories) backup-posts))
         (tag-groups (posts/group-by-tag posts)))
    (map (match-lambda
           ((tag . posts)
            ((atom-feed #:file-name (string-append prefix "/" tag ".xml")
                        #:subtitle (string-append "Tag: " tag)
                        #:filter filter
                        #:max-entries max-entries
                        #:blog-prefix blog-prefix)
             site posts)))
         tag-groups))))
