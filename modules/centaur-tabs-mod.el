(use-package all-the-icons
  :ensure t
  :config
  (unless (member "all-the-icons" (font-family-list))
    (all-the-icons-install-fonts t)))



(use-package centaur-tabs
  :ensure t
  :demand t
  :config
  (centaur-tabs-mode t)
  (centaur-tabs-headline-match)
  :custom
  (centaur-tabs-style "bar")
  (centaur-tabs-set-icons t)
  (centaur-tabs-height 32)
  (centaur-tabs-set-bar 'under)
  :bind
  (:map evil-normal-state-map
        ("gt" . centaur-tabs-forward)
        ("gT" . centaur-tabs-backward)))

(provide 'centaur-tabs-mod)
