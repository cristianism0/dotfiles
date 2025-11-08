;; Starting Org Babel and link to config.org
(require 'org)
(org-babel-load-file
  (expand-file-name
    "config.org"
    user-emacs-directory))

;; Hide startup message
(setq inhibit-startup-message t)

;; Fullscrenn
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; If custom.el
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(consult diminish doom-modeline eglot-booster magit markdown
             markdown-mode neotree ordeless orderless
             rainbow-delimiters rainbow-mode vertico vterm))
 '(package-vc-selected-packages
   '((eglot-booster :url "https://github.com/jdtsmith/eglot-booster"
                    :branch "main"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
