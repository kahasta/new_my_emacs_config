(use-package corfu
  :ensure t
  :custom ((corfu-auto t)
	   (corfu-auto-delay 0)
	   (corfu-auto-prefix 1)
	   (corfu-cycle t)
	   (corfu-on-exact-match nil)
	   (tab-always-indent 'complete))
  :bind (nil
	 :map corfu-map
	 ("TAB" . corfu-cycle)
	 ("<tab>" . corfu-cycle)
	 ("RET" . corfu-insert)
	 ("<return>" . corfu-insert))
  :init
  (global-corfu-mode +1)
  :config
  (defun my/corfu-remap-tab-command ()
    (global-set-key [remap c-indent-line-or-region] #'indent-for-tab-command))
  (add-hook 'java-mode-hook #'my/corfu-remap-tab-command)

  ;; https://github.com/minad/corfu#completing-in-the-minibuffer
  (defun corfu-enable-always-in-minibuffer ()
    "Enable Corfu in the minibuffer if Vertico/Mct are not active."
    (unless (or (bound-and-true-p mct--active)
		(bound-and-true-p vertico--input))
      ;; (setq-local corfu-auto nil) ;; Enable/disable auto completion
      (setq-local corfu-echo-delay nil ;; Disable automatic echo and popup
		  corfu-popupinfo-delay nil)
      (corfu-mode 1)))
  (add-hook 'minibuffer-setup-hook #'corfu-enable-always-in-minibuffer 1)

  (with-eval-after-load 'lsp-mode
    (setq lsp-completion-provider :none)))

(use-package tabnine
  :ensure t
  :hook ((prog-mode . tabnine-mode)
	 (text-mode . tabnine-mode)
	 (kill-emacs . tabnine-kill-process))
  :bind (:map  tabnine-completion-map
	       ("TAB" . nil)
	       ("<tab>" . nil))
  :init
  (global-tabnine-mode +1))

(use-package cape
  :ensure t
  :hook (((prog-mode
	   text-mode
	   conf-mode
	   eglot-managed-mode
	   lsp-completion-mode) . my/set-super-capf))
  :config
  (setq cape-dabbrev-check-other-buffers nil)

  (defun my/set-super-capf (&optional arg)
    (setq-local completion-at-point-functions
		(list (cape-capf-noninterruptible
		       (cape-capf-buster
			(cape-capf-properties
			 (cape-capf-super
			  (if arg
			      arg
			    (car completion-at-point-functions))
			  #'tempel-complete
			  #'tabnine-completion-at-point
			  #'cape-dabbrev
			  #'cape-file)
			 :sort t
			 :exclusive 'no))))))

  (add-to-list 'completion-at-point-functions #'tempel-complete)
  (add-to-list 'completion-at-point-functions #'tabnine-completion-at-point)
  (add-to-list 'completion-at-point-functions #'cape-file t)
  (add-to-list 'completion-at-point-functions #'cape-tex t)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev t)
  (add-to-list 'completion-at-point-functions #'cape-keyword t))

(use-package orderless
  :ensure t
  :init
  (setq completion-styles '(orderless basic)
	completion-category-defaults nil
	completion-category-overrides nil)

  :config
  ;; migemoでローマ字検索を有効にする
  (with-eval-after-load 'migemo
    (defun orderless-migemo (component)
      (let ((pattern (downcase (migemo-get-pattern component))))
	(condition-case nil
	    (progn (string-match-p pattern "") pattern)
	  (invalid-regexp nil))))
    (add-to-list 'orderless-matching-styles 'orderless-migemo))

  ;; corfuはorderless-flexで絞り込む
  (with-eval-after-load 'corfu
    (add-hook 'corfu-mode-hook
	      (lambda ()
		(setq-local orderless-matching-styles '(orderless-flex))))))

(use-package prescient
  :ensure t
  :config
  (setq prescient-aggressive-file-save t)
  (prescient-persist-mode +1))

(use-package corfu-prescient
  :ensure t
  :after corfu
  :config
  (with-eval-after-load 'orderless
    (setq corfu-prescient-enable-filtering nil))
  (corfu-prescient-mode +1))

(use-package kind-icon
  :ensure t
  :after corfu
  :custom (kind-icon-default-face 'corfu-default) ; to compute blended backgrounds correctly
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package tempel
  :ensure t
  :bind (("M-+" . tempel-complete) ;; Alternative tempel-expand
	 ("M-*" . tempel-insert)))

(provide 'autocomplete-mod)
