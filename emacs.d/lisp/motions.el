;;; Vertico
;; Vertical use of M-x
(use-package vertico
      :ensure t
      :custom
      (vertico-cycle t)
      :init
      (vertico-mode))

;;; Marginalia
;; Content on the margin
(use-package marginalia
    :after vertico
    :custom
    (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-ligh nil))
    :init
    (marginalia-mode))

;;; Orderless
;; Fuzzy search
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))
