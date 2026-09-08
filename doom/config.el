;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-font (font-spec :family "Fira Code Nerd Font" :size 16 :weight 'normal)
      doom-variable-pitch-font (font-spec :family "Inter" :size 15)
      doom-serif-font (font-spec :family "Alegreya" :size 16))

(set-fontset-font t 'symbol (font-spec :family "JuliaMono") nil 'append)

(setq doom-theme 'doom-rose-pine)

(setq display-line-numbers-type t)

(setq org-directory "~/org/")
(setq org-agenda-files "~/agenda")
