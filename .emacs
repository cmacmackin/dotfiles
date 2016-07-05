;;; package -- summary

;;; Commentary:
;;; My personal Emacs customization file.

;;; Code:

;; Make sure plugin files visible to Emacs
(add-to-list 'load-path "~/.emacs.d/site-lisp")

;; ---------------------------------------------------------------

;; Setup gnuplot mode
(require 'gnuplot-mode)

;; specify the gnuplot executable (if other than /usr/bin/gnuplot)
;; (setq gnuplot-program "/sw/bin/gnuplot")

;; automatically open files ending with .gp or .gnuplot in gnuplot mode
(setq auto-mode-alist
(append '(("\\.\\(gp\\|gnuplot\\)$" . gnuplot-mode)) auto-mode-alist))

;; ---------------------------------------------------------------

;; Mode for working with the Markdown lightweight markup language
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; ---------------------------------------------------------------

;; Set to follow symlinks to version-controlled files with only a
;; warning.
(setq vc-follow-symlinks nil)

;; ---------------------------------------------------------------

;; Enable parentheses matching/highlighting
(show-paren-mode 1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.40")
 '(inhibit-startup-screen t)
 '(safe-local-variable-values
   (quote
    ((TeX-master . "report")
     (eval setq flycheck-gfortran-include-path
	   (mapcar
	    (lambda
	      (p)
	      (expand-file-name p my-project-path))
	    (quote
	     ("~/.local/include/" "../mod" "./mod"))))
     (eval setq flycheck-gfortran-include-path
	   (mapcar
	    (lambda
	      (p)
	      (expand-file-name p my-project-path))
	    (quote
	     ("~/.local/include/" "./mod" "./tests/mod"))))
     (eval setq flycheck-gfortran-include-path
	   (mapcar
	    (lambda
	      (p)
	      (expand-file-name p my-project-path))
	    (quote
	     ("~/.local/include/" "../mod" "../factual/mod" "./mod"))))
     (eval setq flycheck-gfortran-args
	   (concat "-J"
		   (expand-file-name
		    (quote "./mod")
		    my-project-path)))
     (eval setq flycheck-gfortran-args
	   (concat "-J"
		   (expand-file-name "./mod" my-project-path)))
     (eval setq flycheck-gfortran-args
	   (concat "-J"
		   (expand-file-name my-project-path "./mod")))
     (eval message "Gfortran arguments set to `%s'." flycheck-gfortran-args)
     (eval setq flycheck-gfortran-args
	   (concat "-J"
		   (expand-file-name my-project-path ".mod")))
     (eval setq flycheck-gfortran-include-path
	   (mapcar
	    (lambda
	      (p)
	      (expand-file-name p my-project-path))
	    (quote
	     ("~/.local/include/" "./mod" "./factual/mod" "./tests/mod"))))
     (eval setq flycheck-gfortran-include-path
	   (mapcar
	    (lambda
	      (p)
	      (expand-file-name p
				(my-project-path)))
	    (quote
	     ("~/.local/include/" "./mod" "./factual/mod" "./tests/mod"))))
     (eval message "Include directories set to `%s'." flycheck-gfortran-include-path)
     (eval setq flycheck-gfortran-include-path
	   (mapcar
	    (lambda
	      (p)
	      (expand-file-name p
				(my-project-path))
	      (quote
	       ("~/.local/include/" "./mod" "./factual/mod" "./tests/mod")))))
     (eval setq flycheck-gfortran-include-path
	   (mapcar
	    (lambda
	      (p)
	      (expand-file-name p
				(my-project-path))
	      ((expand-file-name "~/.local/include/")
	       (expand-file-name "./mod")
	       (expand-file-name "./factual/mod")
	       (expand-file-name "./tests/mod")))))
     (eval message "Project directory set to `%s'." my-project-path)
     (eval set
	   (make-local-variable
	    (quote my-project-path))
	   (file-name-directory
	    (let
		((d
		  (dir-locals-find-file ".")))
	      (if
		  (stringp d)
		  d
		(car d)))))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-latex-sectioning-5-face ((t (:inherit (default variable-pitch) :foreground "yellow" :weight bold))) t)
 '(font-latex-slide-title-face ((t (:inherit font-lock-type-face :weight bold :height 1.2))) t)
 '(font-latex-verbatim-face ((t (:inherit (default fixed-pitch) :foreground "sienna"))) t))

;; ---------------------------------------------------------------

;; Set font
(set-default-font "Monofur")
(set-face-attribute 'default nil :height 125)

;; Enable buffer list colour-coding
(defalias 'list-buffers 'ibuffer)
;; make buffer switch command show suggestions
(ido-mode 1)

;; Provide a line duplication feature
(defun duplicate-line()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank)
)
(global-set-key (kbd "\C-c\C-d") 'duplicate-line)

;; -----------------------------------------------------------------

;; Turn on flyspell by default in text-editing modes
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'text-mode-hook 'auto-fill-mode)

;; -----------------------------------------------------------------

;; Add the emacs package manager
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
;;(add-hook 'after-init-hook (lambda () (load "post-init.el")))

(setq package-enable-at-startup nil)
(package-initialize)

;; -----------------------------------------------------------------

;; Turn on flycheck by default in code-editing modes
(add-hook 'after-init-hook 'global-flycheck-mode)
(add-hook 'f90-mode-hook
          (lambda () (setq flycheck-gfortran-include-path
                           (list (expand-file-name "~/.local/include/")))))
(add-hook 'f90-mode-hook
          (lambda () (setq flycheck-gfortran-language-standard "f2008")))
(require 'flycheck-nim)
(eval-after-load 'flycheck (flycheck-pos-tip-mode))
;(eval-after-load "flycheck"
;  '(add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode))

;; -----------------------------------------------------------------

;; Auto-indent-mode
(setq auto-indent-on-visit-file t)
(require 'auto-indent-mode)
(setq auto-indent-indent-style 'conservative)
(auto-indent-global-mode)

;; -----------------------------------------------------------------

;; Company mode
(add-hook 'nim-mode-hook 'company-mode)

;; -----------------------------------------------------------------

;; Nim features
(add-to-list 'load-path "/home/chris/.emacs.d/site-lisp/nim-mode")
(require 'nim-mode)
(setq auto-mode-alist
      (append '(("\\.nim\\'" . nim-mode)) auto-mode-alist))
(setq nim-nimsuggest-path "/opt/nimble/bin/nimsuggest")
(require 'company-nim)
(add-to-list 'company-backends
             '(company-nim :with company-nim-builtin))
(add-to-list 'auto-indent-multiple-indent-modes 'nim-mode)

;; -----------------------------------------------------------------

;; Load CEDET
;;;(load "config/cedet.el")

;; Load ECB
;;;(add-to-list 'load-path (expand-file-name
;;;      "~/.emacs.d/site-lisp/ecb/"))
;;;(require 'ecb)

;;(add-to-list 'semantic-default-submodes 'global-semantic-decoration-mode)
;;(add-to-list 'semantic-default-submodes 'global-semantic-idle-local-symbol-highlight-mode)
;;(add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)
;;(add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode)

;;(require 'semantic/ia)
;;(require 'semantic/bovine/gcc)

;; -----------------------------------------------------------------

;; Colour theme
(load-theme 'dark-blue2 t t)
(enable-theme 'dark-blue2)
;;(powerline-default-theme)

;; ---------------------------------------------------------------

;; Fortpy configuration
(add-to-list 'load-path "~/.emacs.d/fortpy-el")
(autoload 'fortpy-setup "fortpy" nil t)
;(autoload 'fortpy-install-server "fortpy" nil t)
(add-hook 'f90-mode-hook 'fortpy-setup)
(setq fortpy-complete-on-percent t)
(setq fortpy-complete-on-bracket t)
(add-to-list 'auto-mode-alist '("\\.pf\\'" . f90-mode))

;; ----------------------------------------------------------------

;; LaTeX configuration
(add-to-list 'auto-mode-alist '("\\.tex\\'" . LaTeX-mode))
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
(add-hook 'LaTeX-mode-hook 'auto-fill-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'reftex-mode)
(setq reftex-plug-into-AUCTeX t)
(setq LaTeX-PDF-mode t)
(setq TeX-source-correlate-mode t)
(setq-default TeX-master nil)
(defun guess-TeX-master (filename)
  "Guess the master file for FILENAME from currently open .tex files."
  (let ((candidate nil)
        (filename (file-name-nondirectory filename)))
    (save-excursion
      (dolist (buffer (buffer-list))
        (with-current-buffer buffer
          (let ((name (buffer-name))
                (file buffer-file-name))
            (if (and file (string-match "\\.tex$" file))
                (progn
                  (goto-char (point-min))
                  (if (re-search-forward (concat "\\\\input{" filename "}") nil t)
                      (setq candidate file))
                  (if (re-search-forward (concat "\\\\include{" (file-name-sans-extension filename) "}") nil t)
                      (setq candidate file))))))))
    (message "TeX master document: %s" (file-name-nondirectory candidate))
    candidate))
;(add-hook 'LaTeX-mode-hook '(lambda () (setq TeX-master (guess-TeX-master buffer-file-name))))
(require 'ac-math)
(add-to-list 'ac-modes 'latex-mode)
(defun ac-latex-mode-setup ()
   (setq ac-sources
     (append '(ac-source-math-latex ac-source-latex-commands)
               ac-sources)))
(add-hook 'LaTeX-mode-hook 'auto-complete-mode)
(add-hook 'LaTeX-mode-hook 'ac-latex-mode-setup)
(ac-flyspell-workaround)
(add-to-list 'load-path "~/.emacs.d/predictive")
(add-to-list 'load-path "~/.emacs.d/predictive/html")
(add-to-list 'load-path "~/.emacs.d/predictive/texinfo")
(add-to-list 'load-path "~/.emacs.d/predictive/misc")
(add-to-list 'load-path "~/.emacs.d/predictive/latex")
(autoload 'predictive-mode "~/.emacs.d/predictive/predictive"
            "Turn on Predictive Completion Mode." t)

;; -----------------------------------------------------------------

;;; .emacs ends here
