;; UI features
(tool-bar-mode   -1)	                   ; Hide tools bar
(menu-bar-mode   -1)	                   ; Hide menu bar
(scroll-bar-mode -1)	                   ; Hide scroll bar
(set-fringe-mode  5)	                   ; Frame Edges (5px)
(save-place-mode +1)	                   ; Save cursor position
(recentf-mode    +1)	                   ; Recent Files
(savehist-mode   +1)	                   ; Enable history saving
(delete-selection-mode t)                  ; Delete a selected line if write on it
(global-visual-line-mode t)                ; Line break
(setq-default indent-tabs-mode nil) 	   ; Space indentations
(electric-pair-mode 1)                     ; Enable auto pair brackets
(transient-mark-mode 1)                    ; Shows the active region
(global-display-line-numbers-mode 1)       ; Show Number
(setq display-line-numbers-type 'relative) ; Make numbers relative

;;; Fonts
(set-face-attribute 'default nil :font "Fira Code" :height 175)
