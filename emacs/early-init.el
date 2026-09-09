;;; early-init.el --- Performatice starter file -*- lexical-binding: t; no-byte-compile: t -*-
;;; Commentary:
;; This file will load before any other file in ~/.emacs directory.
;; Almost every content here is for start-up performance, inspired by Doom's early-init.el:
;; Check more: https://github.com/doomemacs/core/blob/master/early-init.el

;;; Code:
;; Only trigger the GC when there is something to clean.
(setq gc-cons-threshold (* 256 1024 1024)
      gc-cons-percentage 0.6)

;; Set a permanent, healthy post-boot threshold (32MB) to prevent sudden freezes.
(dolist (hook '(after-init-hook emacs-startup-hook))
  (add-hook hook
            (lambda ()
              (setq gc-cons-threshold (* 64 1024 1024)
                    gc-cons-percentage 0.1))))

;; Disable Emacs native REGEX seach during the boot time and activates again after startup.
(defvar my/saved-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq file-name-handler-alist my/saved-file-name-handler-alist)))

;; Increase the data chunck from back-ending process to Emacs to 64KB for better optimization.
(setq read-process-output-max (* 64 1024))
(setq load-prefer-newer nil)
(setq auto-mode-case-fold nil)

;; Forces the menu, tool and scroll bar to be disabled on the frame before the window is drawn eliminating flickering.
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)

;; Stops Emacs from recalculating dimensions on start-up.
(setq frame-inhibit-implied-resize t)

;; Hide splash-screen and message function avoiding any I/O working during the boot.
(setq inhibit-startup-screen t
      inhibit-startup-echo-area-message user-login-name
      initial-major-mode 'fundamental-mode
      initial-scratch-message nil)
(advice-add #'display-startup-echo-area-message :override #'ignore)
(advice-add #'display-startup-screen :override #'ignore)

;; Mute internal erros and enable package.el
(setq ad-redefinition-action 'accept)
(put 'if-let 'byte-obsolete-info nil)
(put 'when-let 'byte-obsolete-info nil)
(setq warning-suppress-types '((defvaralias) (lexical-binding)))
(setq warning-inhibit-types '((files missing-lexbind-cookie)))
(setq package-enable-at-startup t)


;; Identify and use native compilation if its enabled
(when (featurep 'native-compile)
  (setq native-comp-jit-compilation t)
  (setq native-comp-speed 2))

;; Add background color to prevent that white screen flashbang.
(add-to-list 'default-frame-alist '(background-color . "#191724"))
(add-to-list 'initial-frame-alist '(background-color . "#191724"))

(provide 'early-init)
;;; early-init.el ends here
