;;; motions.el --- Manage keybing and motions -*- lexical-binding: t; no-byte-compile: t -*-
;;; Commentary:
;; This file is to manage the motions like: Evil, define keybindings and use packages to help the motions and Dired.

;;; Code:
;; Vertico
;; Vertical use of M-x
(use-package vertico
      :ensure t
      :custom
      (vertico-cycle t)
      :init
      (vertico-mode))

;; Marginalia
;; Content on the margin
(use-package marginalia
    :after vertico
    :custom
    (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-ligh nil))
    :init
    (marginalia-mode))

;; Orderless
;; Fuzzy search
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; Which key
(use-package which-key
  :ensure t
  :init (which-key-mode)
  :custom
  (which-key-idle-delay 1.0))

;; Consul
(use-package consult
  :bind (
         ("C-s" . consult-line)
         ("C-x b" . consult-buffer)
         ("M-y" . consult-yank-pop)
         ("M-g g" . consult-goto-line)
         ("M-g i" . consult-imenu)
         ("C-c r" . consult-ripgrep))
  :init
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)
  :config
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-line :preview-key '(:debounce 0.1 any)))

;; Undo Fu
(use-package undo-fu
  :ensure t)

;; Evil Mode (Vim Keybindings)
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump t)
  (setq evil-want-fine-undo t)
  (setq evil-undo-system 'undo-redo)

  :config
  (evil-mode 1)
  (setq evil-move-cursor-back nil))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package general
  :ensure t
  :after evil
  :config
  (general-create-definer my-leader
    :states '(normal visual motion emacs)
    :keymaps 'override
    :prefix "SPC")

  (my-leader
    "SPC" '(execute-extended-command :which-key "M-x")
    "."   '(consult-recent-file :which-key "Recent files")
    "f"   '(:ignore t :which-key "File")
    "f f" '(find-file :which-key "Find file")
    "f s" '(save-buffer :which-key "Save buffer")
    "b"   '(:ignore t :which-key "Buffer")
    "b b" '(switch-to-buffer :which-key "Switch buffer")
    "b k" '(kill-current-buffer :which-key "Kill buffer")))

(provide 'motions)
;;; motions.el ends here;
