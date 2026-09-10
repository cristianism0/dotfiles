;;; motions.el --- Manage keybing and motions -*- lexical-binding: t; no-byte-compile: nil -*-
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
    (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
    :init
    (marginalia-mode))

;; Orderless
;; Fuzzy search
(use-package orderless
  :ensure t
  :demand t
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
  :ensure t
  :demand t)

;; Evil Mode (Vim Keybindings)
(use-package evil
  :ensure t
  :demand t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump t)
  (setq evil-want-fine-undo t)
  (setq evil-undo-system 'undo-fu)

  :config
  (evil-mode 1)
  (setq evil-move-cursor-back nil))

;; Leave the direc standard
(evil-set-initial-state 'dired-mode 'emacs)

(use-package evil-collection
  :ensure t
  :after evil
  :config
  (evil-collection-init))

;; Comment (like vim-commentary): gcc comments a line, gc is the operator
;; (e.g. gcip comments a paragraph, gc + visual selection comments it).
(use-package evil-commentary
  :ensure t
  :after evil
  :config
  (evil-commentary-mode))

(use-package evil-org
  :ensure t
  :after org
  :hook (org-mode . evil-org-mode)
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))


(use-package general
  :ensure t
  :demand t
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
    "b k" '(kill-current-buffer :which-key "Kill buffer")
    "w"   '(:ignore t :which-key "Window")
    "w v" '(split-window-right :which-key "Split vertical")
    "w s" '(split-window-below :which-key "Split horizontal")
    "w c" '(delete-window :which-key "Close split")
    "w o" '(delete-other-windows :which-key "Close other splits")
    "w w" '(other-window :which-key "Switch window")
    "d"   '(:ignore t :which-key "Dired")
    "d d" '(dired :which-key "Open dired")
    "d j" '(dired-jump :which-key "Dired at current file")
    "o"   '(:ignore t :which-key "Org")
    "o a" '(org-agenda :which-key "Agenda")
    "o c" '(org-capture :which-key "Capture")
    "o l" '(org-store-link :which-key "Store link")
    "o t" '(org-todo :which-key "Cycle TODO")
    "o s" '(org-schedule :which-key "Schedule")
    "o d" '(org-deadline :which-key "Deadline")
    "o r" '(org-refile :which-key "Refile")
    "B"   '(:ignore t :which-key "Bookmark")
    "B m" '(bookmark-bmenu-list :which-key "List Bookmarks")
    "B j" '(bookmark-jump :which-key "Jump to Bookmark")

    "g"   '(:ignore t :which-key "Ghostel")
    "g g" '(ghostel :which-key "Open a new Ghostel frame")
))

(provide 'motions)
;;; motions.el ends here.
