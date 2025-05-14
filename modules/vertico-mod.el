;;; package --- Vertico configuration
;;; Commentary:
;;; Minimal Vertico setup for completion

(progn
  (use-package vertico
    :ensure t
    :init
    (vertico-mode)
    :custom
    (vertico-cycle t) ; Циклический переход по кандидатам
    (vertico-count 10) ; Количество отображаемых кандидатов
    :bind (:map vertico-map
		("C-j" . vertico-next) ; Следующий кандидат
		("C-k" . vertico-previous) ; Предыдущий кандидат
		("RET" . vertico-directory-enter))) ; Вход в директорию


  (message "Vertico setup complete.")
  )
(provide 'vertico-mod)
