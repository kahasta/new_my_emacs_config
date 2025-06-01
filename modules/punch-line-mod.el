(use-package punch-line
  :ensure t  ;; Install if missing
  :defer t   ;; Load lazily
  :config
  (setq
   punch-line-left-separator "  "
   punch-line-right-separator "  "
   punch-line-music-info '(:service apple)
   punch-line-music-max-length 80)
  ;; Optional: Delay mode activation until after init
  (add-hook 'after-init-hook #'punch-line-mode))

(provide 'punch-line-mod)
