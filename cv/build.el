#!/usr/bin/env sh
":" ; pushd "$(dirname ${0})"; emacs -Q --script "$(basename ${0})" -- "${@}"; exit ${?} # -*- emacs-lisp -*-
;;; build.el --- Build script for Org-made documents -*- lexical-binding: t; -*-

;; Copyright (C) 2026 Sidney PEPO

;; Author: Sidney PEPO <sidneypepo@disroot.org>

;; Version: 20260630
;; Keywords: webpage, curriculum vitae, cv, resume

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Script for building Org-made webpages, Curriculum Vitaes, resumes and other
;; related academic/professional documents

;;; Code:

(message "[*] Initializing build environment...")

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (> (string-to-number emacs-version) 29.0)
  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package)))

(require 'use-package-ensure)
(setq use-package-always-ensure t)

(use-package ox
  :ensure nil)
(use-package ox-html
  :ensure nil)
(use-package ox-latex
  :ensure nil)
(use-package ox-publish
  :ensure nil)

(use-package org
  :custom
  (org-export-with-sub-superscripts '{})

  :config
  (add-to-list 'org-latex-packages-alist
	       '("en" "babel" t nil) t)
  (add-to-list 'org-latex-packages-alist
	       '("a4paper, top=19mm, left=12.925mm, right=12.925mm, bottom=43mm" "geometry" t nil) t)
  (add-to-list 'org-latex-packages-alist
	       '("" "eso-pic" t nil) t)
  (add-to-list 'org-latex-packages-alist
	       '("" "titlesec" t nil) t)
  (add-to-list 'org-latex-packages-alist
	       '("" "multicol" t nil) t)
  (add-to-list 'org-latex-packages-alist
	       '("" "indentfirst" t nil) t)
  (add-to-list 'org-latex-packages-alist
	       '("skip=1pt, indent=10pt" "parskip" t nil) t)
  (add-to-list 'org-latex-packages-alist
	       '("inline" "enumitem" t nil) t)
  (add-to-list 'org-latex-packages-alist
	       '("dvipsnames" "xcolor" t nil) t)
  (add-to-list 'org-latex-packages-alist
	       '("" "fontawesome5" t nil) t)
  (add-to-list 'org-latex-packages-alist
	       '("" "fdsymbol" t nil) t)
  (add-to-list 'org-latex-packages-alist
	       '"
\\newcommand{\\placetextbox}[4]{
  \\setbox0=\\hbox{#4}
  \\AddToShipoutPictureFG*{
    \\if#3r
    \\put(\\LenToUnit{\\paperwidth-#1},\\LenToUnit{\\paperheight-#2}){\\vtop{{\\null}\\makebox[0pt][r]{\\begin{tabular}{r}#4\\end{tabular}}}}
    \\else
    \\put(\\LenToUnit{#1},\\LenToUnit{\\paperheight-#2}){\\vtop{{\\null}\\makebox[0pt][l]{\\begin{tabular}{l}#4\\end{tabular}}}}
    \\fi
  }
}
\\titleformat*{\\section}{\\normalfont\\normalsize\\centering\\scshape}
\\titlespacing*{\\section}{0pt}{10pt}{5pt}
\\setlist[itemize]{leftmargin=10pt}
\\definecolor{inv}{HTML}{FFFFFE}
\\definecolor{x-acs-dark-red}{HTML}{CC0000}
\\definecolor{x-acs-dark-blue}{HTML}{0033CC}
\\pagenumbering{gobble}
\\newcommand{\\sep}{\\textbf{|} }" t )

  (add-to-list 'org-publish-project-alist
	       '("pdf"
		 :base-directory "."
		 :publishing-directory "."
		 :base-extension ""
		 :include ("cv.org")
		 :recursive t
		 :publishing-function org-latex-publish-to-pdf

		 :latex-class "article"
		 :latex-class-options "[a4paper,10pt]"
		 :latex-hyperref-template "\\hypersetup{
  colorlinks=true,
  linkcolor=x-acs-dark-blue,
  filecolor=x-acs-dark-blue,
  urlcolor=x-acs-dark-blue
}
"
		 :section-numbers nil
		 :with-special-strings nil
		 :with-statistics-cookies nil
		 :with-toc nil
		 :with-title nil)))

(message "[*] Starting build...")

(org-publish "pdf")

(message "[+] Build finished!")

;;; build.el ends here
