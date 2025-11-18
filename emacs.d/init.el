;;; Hide startup message
(setq inhibit-startup-message t)

;; Remove backup files
(setq make-backup-files nil)

;; Turn off emacs auto identation
(electric-indent-mode -1)

;; UI features
(tool-bar-mode   -1)	                  ; Hide tools bar
(menu-bar-mode   -1)	                  ; Hide menu bar
(scroll-bar-mode -1)	                  ; Hide scroll bar
(tooltip-mode    -1)        	          ; Hide tooltips
(set-fringe-mode  5)	                  ; Frame Edges (5px)
(save-place-mode +1)	                  ; Save cursor position
(recentf-mode    +1)	                  ; Recent Files
(savehist-mode   +1)	                  ; Enable history saving
(delete-selection-mode t)                 ; Delete a selected line if write on it
(global-visual-line-mode t)               ; Line break
(setq-default indent-tabs-mode nil)	  ; Space indentations
(electric-pair-mode 1)                    ; Enable auto pair brackets
(transient-mark-mode 1)                   ; Shows the active region
(global-display-line-numbers-mode 1)      ; Show Number
(setq display-line-numbers-type 'relative) ; Make numbers relative

;;; Org Mode (i'll note use it)

;;(dolist (mode '(org-mode-hook
;;                 vterm-mode-hook
;;                 term-mode-hook
;;                 shell-mode-hook
;;                 eshell-mode-hook))
;;   (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; (add-hook 'org-mode-hook 'org-indent-mode)
;; (use-package org-bullets
;; :custom
;; (org-bullets-bullet-list '("▶" "▷" "◆" "◇" "▪" "▪" "▪")))
;; (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;; (use-package rainbow-delimiters
;;     :hook ((prog-mode . rainbow-delimiters-mode)
;;            (emacs-lisp-mode . rainbow-delimiters-mode)
;;            (clojure-mode . rainbow-delimiters-mode)))

;; (use-package rainbow-mode
;;   :diminish
;;   :hook org-mode prog-mode)

;;; Fonts
(set-face-attribute 'default nil :font "Fira Code" :height 150)

;;; Themes
(use-package doom-themes
  :ensure t
  :custom
 ;; Global settings (defaults)
   (doom-themes-enable-bold t)   
   (doom-themes-enable-italic t)  

   (doom-themes-org-config))
 ;; Choose theme here:
 (load-theme 'doom-tokyo-night t)

;;; Modeline
(use-package doom-modeline
  :ensure t
  :hook
  (after-init . doom-modeline-mode)
  :custom
  (doom-modeline-height 30) 
  :config
  (setq doom-modeline-enable-word-count t))

;;; Package.el
;; Require and keep it up to date
(require 'package)         
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                        ("elpa"  . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;;; Motions
;; Vertico
(use-package vertico
      :ensure t
      :bind (:map vertico-map
            ("C-j" . vertico-next)
            ("C-k" . vertico-previous)
            ("C-f" . vertico-exit)	           ; Close Mini-buffer - Better than ESC
  	  :map minibuffer-local-map
            ("M-h" . backward-kill-word))
      :custom
      (vertico-cycle t)
      :init
      (vertico-mode))

;; Marginalia
(use-package marginalia
    :after vertico
    :custom
    (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-ligh nil))
    :init
    (marginalia-mode))

;; Orderless
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;;; IDE Packages
;; Markdown
(use-package markdown-mode
  :ensure t)

;; Company - Auto-complete
(use-package company
  :ensure t
  :init
  (global-company-mode))

;; Eglot - Booster -> eglot is already built in on Emacs 29+
(use-package eglot-booster
	:after eglot
	:config	(eglot-booster-mode))

;; Neotree
(use-package neotree
  :ensure t
  :config
  (progn
    (setq neo-theme (if (display-graphic-p) 'nerd-icons 'arrow))
    (global-set-key [f8] 'neotree-toggle)))

;; Magit
(use-package magit)

;; Flycheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

