;; ~/.config/emacs/init.el

;; MELPA packages
;;
;; enable basic packaging support
(require 'package)

;; adds MELPA archive to the list of available repos
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)

;; initialize the package infrastructure
(package-initialize)

;; if there are no archived package contents, refresh
(when (not package-archive-contents)
  (package-refresh-contents))


;; install packages
;;
(defvar mypackages
  '(better-defaults              ;; better emacs defaults
    elpy                         ;; emacs lisp python env
    flycheck                     ;; on-the-fly syntax checking
    )
  )

;; install not already installed packages
(mapc #'(lambda (package)
	  (unless (package-installed-p package)
	    (package-install package)))
      mypackages)


;; basic customizations
(setq inhibit-startup-message t)     ;; hide the startup message
(setq diff-switches "-u")            ;; default to unified diffs
(setq require-final-newline 'query)  ;; always end with newline

;;; load themes in ~/.config/emacs/themes folder
(setq custom--inhibit-theme-enable nil)
;(add-to-list custom-theme-load-path "~/.emacs.d/themes/")
(load-file "~/.config/emacs/themes/afternoon-theme.el")

;; display line numbers on the left side
;;(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;;
;; enable elpy package
(elpy-enable)

;; enable flycheck
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; fix?
(setq python-shell-completion-native-disabled-interpreters '("python3"))

