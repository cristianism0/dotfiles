;;; init.el -- The emacs core -*- lexical-binding: t; no-byte-compile: t -*-
;;; Commentary:
;; This file is the heart of Emacs, here contain main configs that are not suitable for modularization.

;;; Code:
;; Hide startup message
(setq inhibit-startup-message t)

;; Remove backup files
(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; Turn off emacs auto indentation - allow LSP only.
(electric-indent-mode -1)                  ; Emacs builtin indent
(recentf-mode 1)                           ; Enable recent files
(savehist-mode   +1)	                   ; Enable history saving

;; Package.el
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org") t)

(require 'use-package)
(setq use-package-always-ensure t)

(use-package gcmh
  :ensure t
  :init
  (setq gcmh-idle-delay 5
        gcmh-high-cons-threshold (* 64 1024 1024))
  :config
  (gcmh-mode 1))

;; This allow me to load all files inside ~/.config/emacs/lisp/ directory.
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(require 'themes)
(require 'ui-basics)
(require 'motions)
(require 'org-mode)
(require 'ide)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; init.el ends here;
