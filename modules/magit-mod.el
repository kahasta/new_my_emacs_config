(progn
  (use-package transient :ensure t)
  (use-package magit
    :ensure t
    :diminish magit-auto-revert-mode
    :diminish auto-revert-mode
    :bind (("C-c g" . #'magit-status))
    :custom
    (magit-diff-refine-hunk t)
    (magit-repository-directories '(("~/src" . 1)))
    (magit-list-refs-sortby "-creatordate")
    :config
    (defun pt/commit-hook () (set-fill-column 80))
    (add-hook 'git-commit-setup-hook #'pt/commit-hook)
    (add-to-list 'magit-no-confirm 'stage-all-changes))

  ;; (use-package forge
  ;;   :ensure t
  ;;   :after magit
  ;;   :config
  ;;   ;; Явно добавляем forge команды в magit-dispatch
  ;;   (with-eval-after-load 'magit
  ;;     (transient-append-suffix 'magit-dispatch "n"
  ;; 	'("N" "Forge" forge-dispatch))))

					; (use-package diff-hl
					;   :ensure t
					;   :init (require 'diff-hl-flydiff)
					;   :config
					;   (global-diff-hl-mode)
					;   (diff-hl-flydiff-mode)
					;   ;; (set-fringe-mode 10) ;; Включаем боковую панель
					;   (diff-hl-margin-mode)
					;   (setq-default left-margin-width 5)
					;   ;;
					;   (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
					;   (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
					;
					;   (set-face-attribute 'diff-hl-insert nil :background "dark green" :foreground "dark green")
					;   (set-face-attribute 'diff-hl-delete nil :background "dark red" :foreground "dark red")
					;   (set-face-attribute 'diff-hl-change nil :background "dark orange" :foreground "dark orange")
					;   :custom
					;   (diff-hl-disable-on-remote t)
					;   (diff-hl-margin-symbols-alist
					;    '((insert . "+")
					;      (delete . "-")
					;      (change . "~")
					;      (unknown . "?")
					;      (ignored . "i"))))

  (use-package git-gutter
    :ensure t
    :config
    (global-git-gutter-mode +1))

  (use-package emojify
    :ensure t
    :config
    (global-emojify-mode))
  (message "Magit initializing complete.")
  )

(provide 'magit-mod)
