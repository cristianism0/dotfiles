;;; themes.el --- Manage themes and icons -*- lexical-binding: t; no-byte-compile: t -*-
;;; Commentary:
;; This file will define themes: General theme, modeline theme, delimiters, ligatures, icons.

;;; Code:

;; Open in fullscreen & set transparency
;;(add-to-list 'initial-frame-alist '(alpha-background . 90))
;;(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; Themes
(use-package doom-themes
  :ensure t
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  :config
  (doom-themes-org-config)
  (load-theme 'doom-ayu-mirage t))

;; Icons & Modeline
(use-package nerd-icons
  :ensure t)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
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
