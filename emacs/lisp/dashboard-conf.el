;;; dashboard-conf.el --- Tela de boot estilo Doom -*- lexical-binding: t; no-byte-compile -*-
;;; Commentary:
;; The dashboard is the first buffer that appear on the startup.
;;; Code:
(use-package dashboard
  :ensure t
  :init
  (setq dashboard-banner-logo-title "Welcome again.")
  (setq dashboard-startup-banner (expand-file-name "lisp/ascii.txt" user-emacs-directory))
  (setq dashboard-center-content t
	dashboard-vertically-center-content nil
        dashboard-vertically-center-content t
        dashboard-items '((recents  . 5)
                          (bookmarks . 5)
                          (projects  . 5)
                          (agenda    . 5)))

  (setq dashboard-item-shortcuts '((recents   . "r")
                                   (bookmarks . "m")
                                   (projects  . "p")
                                   (agenda    . "a")))

  (setq dashboard-item-icons '((recents   . "")
                               (bookmarks . "")
                               (projects  . "")
                               (agenda    . "")))
  :config
  (dashboard-setup-startup-hook))

(provide 'dashboard-conf)
;;; dashboard-conf.el ends here;
