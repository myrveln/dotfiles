;; .emacs

;;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

;; enable visual feedback on selections
;(setq transient-mark-mode t)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
(setq diff-switches "-u")

;; always end a file with a newline
;(setq require-final-newline 'query)

;;; uncomment for CJK utf-8 support for non-Asian users
;; (require 'un-define)

;;; load themes in ~/emacs.d/themes/ folder
(setq custom--inhibit-theme-enable nil)
;(add-to-list custom-theme-load-path "~/.emacs.d/themes/")
(load-file "~/.config/emacs/themes/afternoon-theme.el")
