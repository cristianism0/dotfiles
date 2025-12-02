;;; Hide startup message
(setq inhibit-startup-message t)

;;; Open in fullscreen
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;;; Show battery
(display-battery-mode 1)

;;; Remove backup files
(setq make-backup-files nil)

;;; Turn off emacs auto identation
(electric-indent-mode -1)

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

;;; Enable custom files
(load-file "~/.emacs.d/lisp/mappings.el")
(load-file "~/.emacs.d/lisp/themes.el")
(load-file "~/.emacs.d/lisp/ui-basics.el")
(load-file "~/.emacs.d/lisp/org-mode.el")
(load-file "~/.emacs.d/lisp/motions.el")
(load-file "~/.emacs.d/lisp/ide.el")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(company consult diminish doom-modeline doom-themes eglot-booster
             flycheck magit marginalia markdown-mode neotree orderless
             org-bullets rainbow-delimiters rainbow-mode vertico vterm))
 '(package-vc-selected-packages
   '((eglot-booster :vc-backend Git :url
                    "https://github.com/jdtsmith/eglot-booster.git"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


