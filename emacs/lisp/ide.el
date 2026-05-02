;;; Markdown
(use-package markdown-mode
  :ensure t)

;;; Company -> Auto-complete
(use-package company
  :ensure t
  :init
  (global-company-mode))

(add-hook 'rust-mode-hook 'eglot-ensure)
(add-hook 'python-mode-hook 'eglot-ensure)
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'go-mode-hook 'eglot-ensure)

;;; Flycheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; Magit
(use-package magit)

;; Python venvs
(use-package pet
  :ensure t
  :config
  (add-hook 'python-mode-hook 'pet-mode-init))


(use-package vterm
    :ensure t)
