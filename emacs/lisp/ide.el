;;; ide.el --- IDE Related Configs -*- lexical-binding: t; no-byte-compile: t -*-

;;; Commentary:
;; This file is used to configure all IDE-related packages and configs.

;;; Code:
;; Markdown
(use-package markdown-mode
  :ensure t)

;; Company -> Auto-complete
(use-package company
  :ensure t
  :init
  (global-company-mode))

(add-hook 'python-mode-hook 'eglot-ensure)
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'go-mode-hook 'eglot-ensure)
(add-hook 'rust-mode-hook 'eglot-ensure)
(add-hook 'rust-ts-mode-hook 'eglot-ensure)
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

;; Magit
(use-package magit)

;; Python Venv
(use-package pet
  :ensure t
  :config
  (add-hook 'python-mode-hook 'pet-mode-init))

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
;;; ide.el ends here;
