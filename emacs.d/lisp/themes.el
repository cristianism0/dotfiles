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
