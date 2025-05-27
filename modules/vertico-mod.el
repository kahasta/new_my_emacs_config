;;; package --- Vertico configuration
;;; Commentary:
;;; Minimal Vertico setup for completion
(progn
  (use-package vertico
    :ensure t
    :hook
    (elpaca-after-init . vertico-mode)
    :custom
    (vertico-cycle t) ; Циклический переход по кандидатам
    (vertico-count 15) ; Количество отображаемых кандидатов
    (vertico-resize nil)
    :bind (:map vertico-map
		("C-j" . vertico-next) ; Следующий кандидат
		("C-k" . vertico-previous) ; Предыдущий кандидат
		("RET" . vertico-directory-enter))) ; Вход в директорию


  (use-package vertico-prescient
    :ensure t
    :after vertico
    :init
    (vertico-prescient-mode 1)
    (prescient-persist-mode 1))

  ;; We follow a suggestion by company maintainer u/hvis:
  ;; https://www.reddit.com/r/emacs/comments/nichkl/comment/gz1jr3s/
  (defun company-completion-styles (capf-fn &rest args)
    (let ((completion-styles '(basic flex partial-completion)))
      (apply capf-fn args)))

  (advice-add 'company-capf :around #'company-completion-styles)

  ;; 2. Orderless — умный фильтр (разделение пробелами, без строго порядка)
  (use-package orderless
    :ensure t
    :init
    (setq completion-styles '(orderless basic flex)
          completion-category-defaults nil
          completion-category-overrides '((file (styles basic partial-completion)))))

  ;; 4. Consult — набор мощных команд поиска
  (use-package consult
    :ensure t
    :config
    ;; Use consult for completion inside minibuffer, for example when
    ;; searching for a file.
    (setq completion-in-region-function #'consult-completion-in-region)
    :bind
    (
     ("C-s" . consult-line)
     ("C-x b" . consult-buffer)
     ("M-y" . consult-yank-pop)))

  (use-package consult-yasnippet
    :ensure t
    :defer t)

  ;; 6. Embark-consult — связка consult + embark (обновляет предпросмотр)
  (use-package embark-consult
    :after (embark consult)
    :ensure t)


  (message "Vertico setup complete.")
  )
(provide 'vertico-mod)
