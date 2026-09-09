;;; themes.el --- Manage themes and icons -*- lexical-binding: t; no-byte-compile: nil -*-
;;; Commentary:
;; This file will define themes: General theme, modeline theme, delimiters, ligatures, icons.

;;; Code:

;; Open in fullscreen & set transparency
;;(add-to-list 'initial-frame-alist '(alpha-background . 90))
;;(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; Themes
(add-to-list 'custom-theme-load-path (expand-file-name "themes" user-emacs-directory))
(load-theme 'doom-rose-pine t)

;; Icons & Modeline
(use-package nerd-icons
  :ensure t)

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode)
  :custom
  (doom-modeline-height 28)
  (doom-modeline-bar-width 4)
  (doom-modeline-icon t))

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

;; Ligatures
(use-package ligature
  :config
  (ligature-set-ligatures 'prog-mode '("|||>" "<Calculated>" "==" "!=" "===" "!==" "=>" "->" "::"))
  (global-ligature-mode t))

(provide 'themes)
;;; themes.el ends here;
