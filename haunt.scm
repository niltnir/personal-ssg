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

(use-modules (haunt site)
             (haunt reader commonmark)
             (haunt builder assets)
             (builders page)
             (builders prose)
             (builders atom)
             (themes prose-theme))

(site #:title "Lynn Noda"
      #:domain "nodalynn.com"
      #:default-metadata
      '((author . "Lynn Noda")
	(email  . "lynn@nodalynn.com"))
      #:readers (list commonmark-reader)
      #:builders (list (page "pages/index.md" "index.html")
                       (page "pages/contact.md" "contact.html")
                       (page "pages/math.md" "math/index.html")
                       (page "pages/cs.md" "cs/index.html")
                       (page "pages/cs/software.md" "cs/software.html")
                       (page "pages/art.md" "art/index.html")
                       (page "pages/prose.md" "prose/index.html")
                       (page "pages/hobbies.md" "hobbies/index.html")
                       (page "pages/lambdus.md" "misc/lambdus.html")
                       (page "pages/legal.md" "legal.html")
                       (prose "pages/prose/blog" "prose/blog" #:title "Blog")
                       (prose "pages/prose/essay" "prose/essay" #:title "Essays")
                       (static-directory "assets" "assets")
                       (static-directory "images" "images")
                       (atom-feed "pages/prose" #:file-name "feeds/feed.xml")
                       (atom-feed "pages/prose/blog" #:file-name "feeds/blog.xml" #:subtitle "Recent Updates")
                       (atom-feed "pages/prose/essay" #:file-name "feeds/essay.xml" #:subtitle "Recent Essays")
                       (atom-feeds-by-tag "pages/prose")))
