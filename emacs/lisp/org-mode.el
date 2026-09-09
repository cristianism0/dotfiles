;;; ord-mode.el --- Config the Org mode -*- lexical-binding: t; no-byte-compile: nil -*-
;;; Commentary:
;; This file contain all configurations to all Org config, since roam to agenda.

;;; Code:
(use-package org
  :ensure nil
  :custom
  (org-startup-folded 'content)
  (org-ellipsis " ▾")
  (org-pretty-entities t)
  (org-src-fontify-natively t)
  (org-src-tab-acts-natively t)
  (org-confirm-babel-evaluate nil))

(add-hook 'org-mode-hook #'org-indent-mode)
(add-hook 'org-mode-hook #'visual-line-mode)
(add-hook 'org-mode-hook (lambda () (display-line-numbers-mode 0)))

(use-package org-bullets
  :ensure t
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("▶" "▷" "◆" "◇" "▪" "▪" "▪")))

(provide 'org-mode)
;;; org-mode.el ends here;
