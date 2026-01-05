;;; Markdown
(use-package markdown-mode
  :ensure t)

;;; For Python Venvs
(use-package pyvenv)

;;; Company -> Auto-complete
(use-package company
  :ensure t
  :init
  (global-company-mode))

(add-hook 'rust-mode-hook 'eglot-ensure)
(add-hook 'python-mode-hook 'eglot-ensure)
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'typescript-ts-mode 'eglot-ensure)
(add-hook 'go-ts-mode 'eglot-ensure)


;;; Flycheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; Magit
(use-package magit)

