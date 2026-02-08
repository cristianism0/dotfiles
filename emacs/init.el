;;; Hide startup message
(setq inhibit-startup-message t)

;;; Open in fullscreen
(add-to-list 'initial-frame-alist '(alpha-background . 75)'(fullscreen . maximized))

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
(load-file "~/.config/emacs/lisp/themes.el")
(load-file "~/.config/emacs/lisp/ui-basics.el")
(load-file "~/.config/emacs/lisp/org-mode.el")
(load-file "~/.config/emacs/lisp/motions.el")
(load-file "~/.config/emacs/lisp/ide.el")

;;; Enable System PATH
(use-package exec-path-from-shell)
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil)
 '(package-vc-selected-packages
   '((eglot-booster :vc-backend Git :url
                    "https://github.com/jdtsmith/eglot-booster.git"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


