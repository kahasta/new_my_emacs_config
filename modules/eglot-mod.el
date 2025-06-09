(progn
  (use-package eglot
    :ensure nil  ; Встроен в Emacs 29+
    :init
    (setq eglot-sync-connect 1
          eglot-autoshutdown t
	  eglot-connect-timeout 30
	  eglot-eldoc-enable-hover nil
          ;; NOTE: We disable eglot-auto-display-help-buffer because :select t in
          ;;   its popup rule causes eglot to steal focus too often.
          eglot-auto-display-help-buffer nil)
    :hook
    ((python-mode js-mode rust-mode dart-mode ) . eglot-ensure)

    :config
    (add-to-list 'display-buffer-alist
		 '("^\\*eglot-help"
		   (display-buffer-reuse-window
                    display-buffer-pop-up-window)
		   (window-height . 0.15)))
    (with-eval-after-load 'eglot
      (define-key eglot-mode-map [remap xref-find-definitions] #'xref-find-definitions)
      (define-key eglot-mode-map [remap xref-find-references] #'xref-find-references)
      (define-key eglot-mode-map (kbd "M-i") #'eglot-find-implementation)
      (define-key eglot-mode-map (kbd "M-t") #'eglot-find-typeDefinition)

      ;; Если у тебя есть функция `+eglot-lookup-documentation`, нужно её явно определить.
      ;; В противном случае можно использовать встроенную:
      (define-key eglot-mode-map (kbd "M-d") 'eldoc))
    (add-to-list 'eglot-server-programs
		 '(rust-mode . ("rust-analyzer"))
		 ;; '(kotlin-mode . ("kotlin-language-server"))
		 '(dart-mode . ("dart" "`langauge-server" "--client-id=emacs.eglot")))
    ;; Оптимизации для Rust
    (setq eglot-ignored-server-capabilities
          '(:documentFormattingProvider))
    (setq eglot-autoshutdown t
          eglot-send-changes-idle-time 0.5))

  (use-package consult-eglot
    :ensure t
    :after eglot
    :bind (:map eglot-mode-map
		([remap xref-find-apropos] . consult-eglot-symbols)))


  (use-package flycheck-eglot
    :ensure t
    :after (flycheck eglot)
    :hook (eglot-managed-mode . flycheck-eglot-mode))
  (message "Eglot initializing complete.")
  )

(provide 'eglot-mod)
