;;; Ivy Counsel module
;;;  Ivy, a generic completion mechanism for Emacs.
;;;  Counsel, a collection of Ivy-enhanced versions of common Emacs commands.
;;;  Ivy-rich allows us to add descriptions alongside the commands in M-x.

(progn
  (use-package ivy
    :ensure t
    :demand t
    :bind
    ;; ivy-resume resumes the last Ivy-based completion.
    (("C-c C-r" . ivy-resume)
     ;; ("C-s" . #'swiper-isearch)
     ("C-x B" . ivy-switch-buffer-other-window))
    :custom
    ;; Группировка результатов
    (setq ivy-rich-group-functions
	  '(ivy-rich-group-buffer
            ivy-rich-group-file))
    ;; Быстрые действия в ivy
    (setq ivy-read-action-function 'ivy-read-action-by-key)
    (setq ivy-re-builders-alist
	  '((t . ivy--regex-plus)))  ; Использовать умный regex

    ;; Показывать превью для файлов
    (setq ivy-extra-directories nil
          ivy-display-style 'fancy)
    (setq ivy-use-virtual-buffers t)
    (setq ivy-count-format "(%d/%d) ")
    (setq enable-recursive-minibuffers t)
    :config
    (ivy-mode 1)
    (message "Ivy initialized"))

  (use-package counsel
    :ensure t
    :after ivy
    :config
    (counsel-mode 1)
    (setq ivy-initial-inputs-alist nil)  ; Полностью отключает начальные символы
    (setq counsel-M-x-history-display-style 'reverse)
    ;; Сохранять больше элементов истории
    (setq history-length 1000)
    (setq history-delete-duplicates t)
    (setq ivy-sort-functions-alist
	  '((counsel-M-x . ivy--sort-by-frequency)))
    (message "Counsel initialized"))


  (use-package ivy-rich
    :ensure t
    :after ivy
    :init
    (setq ivy-rich-switch-buffer-align-virtual-buffer t
	  ivy-rich-path-style 'abbrev)
    :config
    (ivy-rich-mode 1)
    (ivy-set-display-transformer 'ivy-switch-buffer
				 'ivy-rich-switch-buffer-transformer)
    (message "Ivy-rich initialized"))  ; Для отладки


  (use-package all-the-icons-ivy-rich
    :ensure t
    :after (ivy ivy-rich)  ; Загружаем после обоих пакетов
    :config
    (all-the-icons-ivy-rich-mode 1)
    (message "All-the-icons-ivy-rich initialized"))

  (use-package smex
    :ensure t
    :after ivy
    :init
    (smex-initialize)
    :config
    ;; Использовать Ivy для completion
    (setq smex-history-length 35
          smex-auto-update t
          smex-save-file (expand-file-name "smex-items" user-emacs-directory)
          smex-prompt-string "M-x "
          smex-show-unbound-commands t)  ; Показывать даже непривязанные команды

    ;; Интеграция с Ivy
    (setq smex-completion-method 'ivy
          ivy-re-builders-alist '((smex . ivy--regex-fuzzy)
				  (t . ivy--regex-plus)))

    (setq smex-prompt-string "Команда: "
          smex-ido-cache-max-length 10
          smex-auto-update-interval 60)  ;; Автообновление кэша каждые 60 сек

    ;; Автообновление кэша
    (run-with-idle-timer 300 t #'smex-update)
    ;; Дополнительные настройки сортировки
    (setq ivy-re-builders-alist
          '((smex . ivy--regex-plus)
            (t . ivy--regex-fuzzy))))
  (message "Ivy + Counsel initializing complete.")
  )

(provide 'ivy-counsel-mod)
