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
  ()

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package general
  :after evil
  :config
  (general-evil-setup t))

  (general-create-definer my-doom-leader-def
    :states '(normal visual motion emacs)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "M-SPC")

  (my-doom-leader-def
    "."   '(find-file :which-key "Find file")
    ","   '(switch-to-buffer :which-key "Switch buffer")
    "SPC" '(execute-extended-command :which-key "M-x")

    "b"   '(:ignore t :which-key "buffer")
    "b b" '(switch-to-buffer :which-key "Switch buffer")
    "b d" '(kill-current-buffer :which-key "Kill buffer")
    "b n" '(next-buffer :which-key "Next buffer")
    "b p" '(previous-buffer :which-key "Previous buffer")

    "f"   '(:ignore t :which-key "file")
    "f f" '(find-file :which-key "Find file")
    "f s" '(save-buffer :which-key "Save file")
    "f r" '(recentf-open-files :which-key "Recent files")

    "w"   '(:ignore t :which-key "window")
    "w s" '(split-window-below :which-key "Split horizontal")
    "w v" '(split-window-right :which-key "Split vertical")
    "w w" '(other-window :which-key "Other window")
    "w d" '(delete-window :which-key "Delete window"))

(provide 'motions)
;;; motions.el ends here;
