;; Basics
(setq inhibit-startup-message t)
(display-battery-mode 1)
(setq frame-resize-pixelwise t) ; Crucial for tiling window managers
(electric-indent-mode -1)       ; Disable auto-indentation as requested

;; Backup management - Keep the working directory clean
(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa"  . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents (package-refresh-contents))
(unless (package-installed-p 'use-package) (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Ensure system PATH is inherited
(use-package exec-path-from-shell
  :if (memq window-system '(mac ns x))
  :config
  (exec-path-from-shell-initialize))

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-tokyo-night t)
  (doom-themes-org-config))

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :custom 
  (doom-modeline-height 30)
  :config 
  (setq doom-modeline-enable-word-count t))

;; UI cleanup and behavior
(set-fringe-mode 5)
(save-place-mode +1)
(recentf-mode +1)
(savehist-mode +1)
(delete-selection-mode t)
(global-visual-line-mode t)
(electric-pair-mode 1)

;; Line numbers
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

;; Typography
(set-face-attribute 'default nil :family "Iosevka Nerd Font" :height 150)

(use-package vertico
  :custom (vertico-cycle t)
  :init (vertico-mode))

(use-package marginalia
  :after vertico
  :init (marginalia-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package markdown-mode)
(use-package magit)

(use-package company
  :init (global-company-mode))

(use-package flycheck
  :init (global-flycheck-mode))

;; Python environment management
(use-package pet
  :hook (python-mode . pet-mode-init))

;; LSP Eglot Hooks
(add-hook 'rust-mode-hook 'eglot-ensure)
(add-hook 'python-mode-hook 'eglot-ensure)
(add-hook 'c-mode-hook 'eglot-ensure)

;; Disable line numbers for specific modes
(dolist (mode '(org-mode-hook vterm-mode-hook term-mode-hook 
                shell-mode-hook eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode)
  :custom (org-bullets-bullet-list '("▶" "▷" "◆" "◇" "▪" "▪" "▪")))

(use-package rainbow-delimiters
  :hook (prog-mode emacs-lisp-mode clojure-mode))

(use-package rainbow-mode
  :diminish
  :hook (org-mode prog-mode))
