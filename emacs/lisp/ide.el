;;; ide.el --- IDE Related Configs -*- lexical-binding: t; no-byte-compile: nil -*-

;;; Commentary:
;; This file is used to configure all IDE-related packages and configs.

;;; Code:
;; Markdown
(use-package markdown-mode
  :ensure t)

;; Ghostel - terminal emulator
(use-package ghostel
  :ensure t)

(setq ghostel-shell "/usr/bin/zsh")

;; Company -> Auto-complete
(use-package company
  :ensure t
  :init
  (global-company-mode)
  :config
  (set-face-attribute 'company-tooltip-selection nil
                      :foreground 'unspecified
                      :weight 'bold))

;; Treesitters and basic modes.
(use-package treesit-auto
  :config
  (global-treesit-auto-mode))

(add-hook 'prog-mode-hook 'eglot-ensure)

;; Advanced LSP configs.
;; Rust
(use-package rustic
  :ensure t
  :mode ("\\.rs\\'" . rustic-mode)
  :custom
  (rustic-lsp-client 'eglot)
  (rustic-format-on-save t)
  :config
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '((rustic-mode rust-ts-mode rust-mode) .
                   ("rust-analyzer" :initializationOptions (:check (:command "clippy")))))))

;; Haskell - need HSL on PATH.
(use-package haskell-mode
  :ensure t)

;; Go - just to help Emacs to identify and activate ts-mode and GoPls.
(use-package go-ts-mode
  :mode ("\\.go\\'" . go-ts-mode))

;; Magit
(use-package magit)

;; Python Venv
(use-package pyvenv
  :ensure t
  :init
  (pyvenv-mode t)
  :config
  (setq pyvenv-post-activate-hooks
        (list (lambda ()
                (setq python-shell-interpreter (concat pyvenv-virtual-env "bin/python3"))))))

;; Formatter
(use-package format-all
  :ensure t
  :hook (prog-mode . format-all-mode))


;; Flycheck + Eglot
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package flycheck-eglot
  :ensure t
  :after (flycheck eglot)
  :config
  (global-flycheck-eglot-mode 1))

(provide 'ide)
;;; ide.el ends here
