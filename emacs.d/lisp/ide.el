;;; Markdown
(use-package markdown-mode
  :ensure t)

;;; Company -> Auto-complete
(use-package company
  :ensure t
  :init
  (global-company-mode))

;; Eglot-Booster -> eglot is already built in on Emacs 29+
(use-package eglot-booster
	:after eglot
	:config	(eglot-booster-mode))

(add-hook 'rust-mode-hook 'eglot-ensure)
(add-hook 'python-mode-hook 'eglot-ensure)
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)

;;; Flycheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;;; Neotree
;; C-x C-f can be used instead
;; (use-package neotree
;;   :ensure t
;;   :config
;;   (progn
;;     (setq neo-theme (if (display-graphic-p) 'nerd-icons 'arrow))
;;     (global-set-key [f8] 'neotree-toggle)))

;; Magit
(use-package magit)

