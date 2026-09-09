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

;; Add an limit and idle time to recentf
(use-package recentf
  :config
  (setq recentf-max-saved-items 200
        recentf-max-menu-items 15)
  (run-with-idle-timer 1 nil (lambda ()
                               (recentf-mode 1)
                               (recentf-cleanup))))

;; Package.el
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t
      use-package-always-defer t)

;; This allow me to load all files inside ~/.config/emacs/lisp/ directory.
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(require 'ui-basics)
(require 'motions)
(require 'dashboard-conf)
(require 'themes)

;; Put the heavier modules inside an lambda function to load after init.
(add-hook 'emacs-startup-hook
          (lambda ()
            (require 'org-mode)
            (require 'ide)))

;; Since Emacs v23 it can compile and read compiled `.el` files which is way faster than the .el file reading.
;; This function is to compile all files inside the lisp directory each time we modify and save them.
;; This is to avoid the noise to save and manually M-x byte-compile-file, the reading priority is higher than the .el files
;; So, it can easily mismatch versions if the compiled are not up to date.
(defun my/auto-compile-lisp ()
"Compile automatically all .el files inside the `lisp` directory upon saving."
  (when (and (eq major-mode 'emacs-lisp-mode)
             (buffer-file-name)
             (string-match-p "/lisp/.*\\.el\\'" (buffer-file-name)))
    (byte-compile-file (buffer-file-name))))

(add-hook 'after-save-hook #'my/auto-compile-lisp)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(company consult dashboard doom-modeline doom-themes evil-collection
	     evil-commentary evil-org flycheck-eglot format-all gcmh general
	     ghostel go-mod-ts-mode haskell-mode hl-todo ligature magit
	     marginalia orderless org-bullets pet pyvenv rainbow-delimiters
	     rustic treesit-auto undo-fu vertico)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;;; init.el ends here;
