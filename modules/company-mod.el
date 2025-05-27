;; company module
;; Company is a text completion framework for Emacs. The name stands for “complete anything”.  Completion will start automatically after you type a few letters. Use M-n and M-p to select, <return> to complete or <tab> to complete the common part.
(progn
  ;; Company
  (use-package company
    :ensure t
    :init
    (setq company-idle-delay 0.1
          company-tooltip-limit 15
	  company-tooltip-align-annotations t
	  company-require-match 'never
          company-selection-wrap-around t
          company-dabbrev-other-buffers nil
          company-dabbrev-ignore-case nil
          company-dabbrev-downcase nil
          company-minimum-prefix-length 1)
    (setq company-backends '(company-capf company-files company-dabbrev company-keywords))
    :hook (after-init . global-company-mode)
    :config
    (define-key company-active-map (kbd "C-n") 'company-select-next)
    (define-key company-active-map (kbd "C-p") 'company-select-previous))




  ;; Company-flx для fuzzy-поиска
  (use-package company-flx
    :ensure t
    :after company
    :config
    (company-flx-mode +1))

  ;; Company-box для красивого интерфейса
  (use-package company-box
    :ensure t
    :after company
    :diminish
    :hook (company-mode . company-box-mode))

  ;; Company-quickhelp для подсказок
  (use-package company-quickhelp
    :ensure t
    :after company
    :config
    (company-quickhelp-mode)
    (setq company-quickhelp-delay 0.2))

  ;; Исправление company-files для org-ссылок
  (with-eval-after-load 'company-files
    (add-to-list 'company-files--regexps "file:\\(\\(?:\\.\\{1,2\\}/\\|~/\\|/\\)[^\]\n]*\\)"))

  ;; Cape для дополнительных бэкендов
  ;; Cape

  ;; Логирование для отладки
  (add-hook 'company-mode-hook
            (lambda ()
	      (message "Company backends in %s: %s" major-mode company-backends)))
  (message "Company initializing complete.")
  )
;; enable global company mode
(setq auto-complete-mode #'company-mode)
(provide 'company-mod)
