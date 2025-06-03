
(setq evil-want-keybinding nil)
(setq evil-want-integration t)
;; Убедимся, что use-package загружен перед использованием
;;(elpaca elpaca-use-package (elpaca-use-package-mode))

;; Установка evil с явным ожиданием загрузки
(use-package evil
  :ensure t
  :demand t  ; Загружать немедленно
  :init
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-want-C-u-scroll t)
  (evil-mode))  ; Явное включение режима

;; Evil Collection должен загружаться ПОСЛЕ evil
(use-package evil-collection
  :ensure t
  :after evil
  :demand t
  :config
  ;; (setq evil-collection-mode-list '(dashboard dired ibuffer eshell org))
  (evil-collection-init))

(use-package evil-matchit
  :ensure t
  :after evil
  :config
  (global-evil-matchit-mode 1))

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

(use-package evil-org
  :ensure t
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (evil-org-set-key-theme '(navigation insert textobjects additional)))

(use-package evil-nerd-commenter
  :ensure t
  :after evil
  :config
  (define-key evil-normal-state-map "gc" 'evilnc-comment-or-uncomment-lines))

(with-eval-after-load 'lsp-mode
  (define-key evil-normal-state-map (kbd "K") nil))  ; Отключаем их обработчик


;; (defun my/disable-comma-key ()
;;   "Убрать любые привязки к клавише `,` в evil."
;;   (dolist (map (list
;;                 evil-normal-state-map
;;                 evil-visual-state-map
;;                 evil-motion-state-map
;;                 evil-insert-state-map
;;                 evil-replace-state-map
;;                 evil-emacs-state-map))
;;     (when map
;;       (define-key map (kbd ",") nil))))

;; ;; выполнить после полной загрузки evil и его плагинов
;; (with-eval-after-load 'evil
;;   (my/disable-comma-key))

;; (with-eval-after-load 'evil-collection
;;   (my/disable-comma-key))

;; (with-eval-after-load 'evil-leader
;;   (my/disable-comma-key))

;; (with-eval-after-load 'devil
;;   (global-set-key (kbd "C-,") 'global-devil-mode))
(provide 'evil-mode-mod)
