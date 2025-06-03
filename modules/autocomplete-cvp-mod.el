(use-package prescient
  :config
  (prescient-persist-mode 1)) ; Сохраняем статистику на диск, чтобы не терять историю

(use-package corfu-prescient
  :demand t
  :after corfu prescient
  :custom
  (corfu-prescient-enable-sorting t) ; Включаем сортировку
  (corfu-prescient-enable-filtering nil) ; Фильтрацию оставляем orderless
  :config
  (corfu-prescient-mode 1))

(use-package vertico-prescient
  :demand t
  :after vertico prescient
  :custom
  (vertico-prescient-enable-sorting t) ; Включаем сортировку
  (vertico-prescient-enable-filtering nil) ; Фильтрацию оставляем orderless
  :config
  (vertico-prescient-mode 1))

(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

(use-package kind-icon
  :ensure t
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default) ; Чтобы иконки соответствовали стилю corfu
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package all-the-icons-completion
  :ensure t
  :after all-the-icons marginalia
  :hook (marginalia-mode . all-the-icons-completion-marginalia-setup)
  :init
  (all-the-icons-completion-mode 1))

(use-package highlight-indent-guides
  :ensure t
  :hook (prog-mode . highlight-indent-guides-mode))

(use-package vertico
  :init
  (vertico-mode 1))

(use-package corfu
  :custom
  (corfu-auto t)          ; Автоматически вызывать автодополнение
  (corfu-auto-prefix 1)   ; Начинать автодополнение после 2 символов
  (corfu-auto-delay 0.1)  ; Задержка перед показом (в секундах)
  (corfu-popupinfo-delay 0.5) ; Задержка для всплывающей документации
  :init
  (global-corfu-mode 1)
  (corfu-popupinfo-mode 1))

(use-package orderless
  :init
  (setq completion-styles '(orderless basic))) ; orderless для фильтрации

(with-eval-after-load 'prescient
  (setopt completion-preview-sort-function #'prescient-completion-sort))

(provide 'autocomplete-cvp-mod)
