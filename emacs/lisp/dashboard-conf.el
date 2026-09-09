;;; dashboard-conf.el --- Tela de boot estilo Doom -*- lexical-binding: t; no-byte-compile: nil -*-
;;; Commentary:
;; The dashboard is the first buffer that appear on the startup.
;;; Code:
(use-package dashboard
  :ensure t
  :demand t
  :init
  (setq dashboard-banner-logo-title "Welcome again.")
  (setq dashboard-startup-banner (expand-file-name "lisp/ascii.txt" user-emacs-directory))

  (setq dashboard-center-content t
        dashboard-vertically-center-content t)

  (setq dashboard-show-shortcuts t
        dashboard-filter-agenda-entry 'dashboard-filter-agenda-by-time
        dashboard-set-heading-icons t
        dashboard-icon-type 'nerd-icons)
  (setq dashboard-item-names '(("Recent Files:" . "Recent Files: [SPC .]")
				("Bookmarks:"    . "Bookmarks: [SPC B]")
				("Agenda for the coming week:" . "Agenda: [SPC o a]")))

  (setq dashboard-items '((recents   . 3)
                          (bookmarks . 3)
                          (agenda    . 3)))

  (setq dashboard-startupify-list '(dashboard-insert-banner
                                    dashboard-insert-newline
                                    dashboard-insert-banner-title
                                    dashboard-insert-newline
                                    dashboard-insert-navigator
                                    dashboard-insert-newline
                                    dashboard-insert-init-info
                                    dashboard-insert-items))

  :config
  (dashboard-setup-startup-hook))

;; Allow dashboard on EmacsClient
(add-hook 'server-after-make-frame-hook (lambda () (dashboard-refresh-buffer)))

(provide 'dashboard-conf)
;;; dashboard-conf.el ends here
