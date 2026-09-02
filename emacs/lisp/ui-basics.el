;;; ui-basics.el --- UI features -*- lexical-binding: t; no-byte-compile: t -*-

;;; Commentary:
;; This file is to define basic UI configratuions, since icos hidden to fonts choice.

;;; Code:
;; UI Icons:
(tool-bar-mode   -1)	                   ; Hide tools bar
(menu-bar-mode   -1)	                   ; Hide menu bar
(scroll-bar-mode -1)	                   ; Hide scroll bar
(set-fringe-mode  5)	                   ; Frame Edges (5px)
(save-place-mode +1)	                   ; Save cursor position
(delete-selection-mode t)                  ; Delete a selected line if write on it
(global-visual-line-mode t)                ; Line break
(setq-default indent-tabs-mode t) 	   ; Space indentations
(electric-pair-mode 1)                     ; Enable auto pair brackets
(transient-mark-mode 1)                    ; Shows the active region
(global-display-line-numbers-mode 1)       ; Show Number
(setq display-line-numbers-type 't)        ; Make numbers relative
(setq frame-resize-pixelwise t)            ; Resize on WM/Tillings
(display-battery-mode 0)                   ; Show the battery in the modeline
(setq-default fill-column 80)              ; Fix a line on 80's colummn
(global-hl-line-mode 1)                    ; Highlight the cursor line
(modify-all-frames-parameters '((internal-border-width . 12)))

;;; Fonts:
(set-face-attribute 'default nil
                    :family "Fira Code Nerd Font"
                    :height 140
                    :weight 'normal)
(set-face-attribute 'variable-pitch nil
                    :family "Inter"
                    :height 150)
(set-face-attribute 'fixed-pitch-serif nil
                    :family "Alegreya"
                    :height 160)
(set-fontset-font t 'symbol (font-spec :family "JuliaMono") nil 'append)

(add-hook 'before-save-hook #'delete-trailing-whitespace)

(use-package hl-todo
  :ensure t
  :hook (prog-mode . hl-todo-mode)
  :config
  (setq hl-todo-highlight-punctuation ":"
        hl-todo-keyword-faces
        '(("TODO"       . (warning bold))
          ("FIXME"      . (error bold))
          ("HACK"       . (font-lock-constant-face bold))
          ("REVIEW"     . (font-lock-keyword-face bold))
          ("NOTE"       . (success bold))
          ("DEPRECATED" . (font-lock-doc-face bold)))))

(provide 'ui-basics)
;;; ui-basics.el ends here
