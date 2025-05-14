;; company module
;; Company is a text completion framework for Emacs. The name stands for “complete anything”.  Completion will start automatically after you type a few letters. Use M-n and M-p to select, <return> to complete or <tab> to complete the common part.

(progn
  (use-package company
    :ensure t
    :hook (after-init . global-company-mode)
    :defer 2
    :diminish
    :init
    (setq company-minimum-prefix-length 1
          company-tooltip-limit 20
	  company-show-numbers t
          company-tooltip-align-annotations t
          company-require-match 'never
          company-idle-delay 0.2
          company-global-modes
          '(not erc-mode
		circe-mode
		message-mode
		help-mode
		gud-mode
		vterm-mode)
          company-frontends '(company-pseudo-tooltip-frontend  ; always show candidates in overlay tooltip
			      company-echo-metadata-frontend)  ; show selected candidate docs in echo area

          ;; Buffer-local backends will be computed when loading a major mode, so
          ;; only specify a global default here.
          company-backends '(company-capf
			     company-files
			     company-dabbrev-code
			     company-dabbrev
			     company-keywords
			     )

          ;; These auto-complete the current selection when
          ;; `company-auto-commit-chars' is typed. This is too magical. We
          ;; already have the much more explicit RET and TAB.
          company-auto-commit nil

          ;; Only search the current buffer for `company-dabbrev' (a backend that
          ;; suggests text your open buffers). This prevents Company from causing
          ;; lag once you have a lot of buffers open.
          company-dabbrev-other-buffers nil
          ;; Make `company-dabbrev' fully case-sensitive, to improve UX with
          ;; domain-specific words with particular casing.
          company-dabbrev-ignore-case nil
          company-dabbrev-downcase nil)
    :config
    (with-eval-after-load 'eldoc
      (eldoc-add-command 'company-complete-selection
			 'company-complete-common
			 'company-capf
			 'company-abort)
      )
    :custom
    (company-dabbrev-downcase nil) ; не понижать регистр при дополнении
    (company-selection-wrap-around t) ; циклическая навигация
    (company-begin-commands '(self-insert-command))
    (company-idle-delay .1)
    (company-tooltip-limit 15)
    (company-minimum-prefix-length 2)
    (company-show-numbers t)
    (company-tooltip-align-annotations 't)
    (global-company-mode t))

  ;; Расширенный вариант с company-flx (для гибкого фуззи-поиска)
  (use-package company-flx
    :ensure t
    :after company
    :config
    (company-flx-mode +1))

  (use-package company-box
    :ensure t
    :after company
    :diminish
    :hook (company-mode . company-box-mode))

  (use-package company-quickhelp
    :ensure t
    :after company
    :init (company-quickhelp-mode)
    :config
    (setq company-quickhelp-delay .2)
    )
  (with-eval-after-load 'company-files
    ;; Fix `company-files' completion for org file:* links
    (add-to-list 'company-files--regexps "file:\\(\\(?:\\.\\{1,2\\}/\\|~/\\|/\\)[^\]\n]*\\)"))

  (use-package cape
    :ensure t
    :init
    (add-to-list 'company-backends #'cape-file)
    (add-to-list 'company-backends #'cape-dabbrev)
    (add-to-list 'company-backends #'cape-symbol)
    (add-to-list 'company-backends #'cape-keyword)
    (add-hook 'text-mode-hook
              (lambda () (add-to-list 'company-backends #'cape-ispell))))
  (message "Company initializing complete.")
  )

(setq auto-complete-mode #'company-mode)
(provide 'company-mod)
