(progn
  (use-package transient :ensure t)
  (elpaca-process-queues)
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

  (use-package forge
    :ensure t
    :after magit)

  (use-package diff-hl
    :ensure t
    :config
    (global-diff-hl-mode)
    (diff-hl-flydiff-mode)
    (diff-hl-margin-mode)
    (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
    (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
    :custom
    (diff-hl-disable-on-remote t)
    (diff-hl-margin-symbols-alist
     '((insert . " ")
       (delete . " ")
       (change . " ")
       (unknown . "?")
       (ignored . "i"))))

  (use-package emojify :ensure t)
  )

(provide 'magit-mod)
