
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 30
	doom-modeline-bar-width 5
	doom-modeline-support-imenu t
	doom-modeline-buffer-file-name-style 'relative-from-project
	doom-modeline-persp-name t
	doom-modeline-icon t
	doom-modeline-major-mode-icon t
	doom-modeline-minor-modes nil
	doom-modeline-enable-word-count t ; Для org-mode и text-mode
	doom-modeline-indent-info t
	doom-modeline-persp-icon t))

(provide 'doom-line-mod)
