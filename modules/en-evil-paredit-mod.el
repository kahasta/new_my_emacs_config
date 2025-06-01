(use-package enhanced-evil-paredit
  :ensure t
  :config
  (add-hook 'paredit-mode-hook #'enhanced-evil-paredit-mode))
(provide 'en-evil-paredit-mod)
