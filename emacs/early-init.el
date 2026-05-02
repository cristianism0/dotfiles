;; Disable UI elements before the GUI init
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; Does'not allow emacs to resize the frame for the fonts 
(setq frame-inhibit-implied-resize t)

;; Block the GB to clean before the init
;; Increase Garbage Collection threshold during startup
(setq gc-cons-threshold most-positive-fixnum)

;; Reset it after startup
(add-hook 'emacs-startup-hook
          ;; you can higher the mupliplier operand to more 
          ;; but it will cost your RAM - currently in 16MB
          (lambda () (setq gc-cons-threshold (* 16 1024 1024))))
