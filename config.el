;;; Code:

(add-to-list 'load-path (concat my/config-dir "modules/"))

;;; Commentary:
;; 

(require 'elpaca-setup)
;; Убедимся, что use-package загружен перед использованием
(elpaca elpaca-use-package (elpaca-use-package-mode))
(add-hook 'after-init-hook
	  (lambda ()
	    ;;; ---------- add to this your modules

	    (require 'evil-mode-mod)
	   ;; (require 'meow-mod)
	    ;; (require 'company-mod)
	    (require 'eglot-mod)
	    (require 'autocomplete-mod)
	    ;; (require 'autocomplete-cvp-mod)
	    (require 'ivy-mod)
	    (require 'vertico-mod)
	    (require 'treemacs-mod)
	    (require 'magit-mod)
	    ;; (require 'awesome-tab-mod)

	    ;; --- Mode Line mods
	    (require 'doom-line-mod)
	    ;; (require 'punch-line-mod)
	    ;; (require 'moody-mod)
	    ;; (require 'smart-mode-line-mod)
	    ;; (require 'telephone-line-mod)
	    ;; --- Mode Line mods end
	    (require 'en-evil-paredit-mod)
	    (require 'centaur-tabs-mod)
	    ;; (require 'dirvish-mod)
	    ))

(setq visible-bell t)
;; Это дает скрол курсора не с самого низа или верха
(setq scroll-conservatively 10
      scroll-margin 15)
(winner-mode)
;; VPN enable
(setq url-gateway-method 'socks)
(setq socks-server '("Default server" "127.0.0.1" 8085 5))

(defun my/reload-config ()
  "Reload Emacs configuration safely."
  (interactive)
  (message "Reloading init file...")
  (load user-init-file nil 'nomessage)
  (message "Init file reloaded!"))

(defun my/toggle-comment ()
  (interactive)
  (if (region-active-p)
      (comment-or-uncomment-region (region-beginning) (region-end))
    (comment-or-uncomment-region (line-beginning-position) (line-end-position))))

;; (defun my/sudo-edit ()
;;  "Edit file as root with explicit bash shell"
;;  (interactive)
;;  (let ((file (or buffer-file-name (error "Not visiting a file"))))
;;    (find-file (format "/sudo::%s" file))))

(setq shell-file-name "/bin/bash")
(defun my/sudo-edit (&optional arg)
  "Редактировать текущий файл или ARG с правами sudo через TRAMP."
  (interactive "P")
  (find-file
   (if arg
       (read-file-name "Sudo file: ")
       (concat "/sudo::" (buffer-file-name)))))

(use-package general
  :ensure t
  :config
  (general-evil-setup)
  
  
  (general-create-definer kahasta/leader-keys
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "SPC" ;; set leader
    :global-prefix "M-SPC") ;; access leader in insert mode
  (kahasta/leader-keys
    "SPC" '(counsel-M-x :wk "M-x")
    "." '(find-file :wk "Find file")
    "f c" '((lambda () (interactive) (find-file (concat my/config-dir "config.org"))) :wk "Edit emacs config")
    "f r" '(counsel-recentf :wk "Find recent files")
    "TAB TAB" '(my/toggle-comment :wk "Comment lines")
    )

  (kahasta/leader-keys
    "b" '(:ignore t :wk "buffer") ;; :ignore t это чтоб игнорировать действие для дальнейших клавиш
    "b b" '(switch-to-buffer :wk "Switch buffer")
    "b c" '(clone-indirect-buffer :wk "Create indirect buffer copy in a split")
    "b C" '(clone-indirect-buffer-other-window :wk "Clone indirect buffer in new window")
    "b k" '(bookmark-delete :wk "Delete bookmark")
    "b i" '(ibuffer :wk "Ibuffer")
    "b d" '((lambda ()
	      (interactive) (kill-buffer (current-buffer))) :wk "Kill this buffer")
    "b D" '(kill-some-buffers :wk "Kill multiple buffers")
    "b l" '(list-bookmarks :wk "List bookmarks")
    "b m" '(bookmark-set :wk "Set bookmark")
    "b n" '(next-buffer :wk "Next buffer")
    "b p" '(previous-buffer :wk "Prev buffer")
    "b r" '(revert-buffer :wk "Reload buffer")
    "b R" '(rename-buffer :wk "Rename buffer")
    "b s" '(basic-save-buffer :wk "Save buffer")
    "b S" '(save-some-buffers :wk "Save multiple buffers")
    "b w" '(bookmark-save :wk "Save current bookmarks to bookmark file")
    )

  (kahasta/leader-keys
    "c" '(:ignore t :wk "Code")
    "c a" '(eglot-code-actions :wk "Code actions")
    "c d" '(xref-find-definitions :wk "Find definition")
    "c f" '(xref-find-references :wk "Find references")
    "c r" '(eglot-rename :wk "Rename")
    )

  (kahasta/leader-keys
    "d" '(:ignore t :wk "Dired")
    ;; "d d" '(dirvish :wk "Open dirvish")
    "d d" '(dired :wk "Open dired")
    ;; "d f" '(dired-narrow :wk "Filter dired")
    "d j" '(dired-jump :wk "Dired jump to current")
    "d v" '(peep-dired :wk "Peep dired toggle")
    ;; "d s" '(hydra-dired-quick-sort/body :wk "DIRED sort")
    ;; "d n" '(neotree-toggle :wk "Open directory in neotree")
    )

  (kahasta/leader-keys
    "e" '(:ignore t :wk "Evaluate")
    "e b" '(eval-buffer :wk "Evaluate elisp in buffer")
    "e d" '(eval-defun :wk "Evaluate defun containing or after point")
    "e e" '(eval-expression :wk "Evaluate and elisp expression")
    "e l" '(eval-last-sexp :wk "Evaluate elisp expression before point")
    "e r" '(eval-region :wk "Evaluate elisp in region")
    ;;     "e s" '(eshell :which-key "Eshell")
    )
  
  
  (kahasta/leader-keys
    "f u" '(my/sudo-edit :wk "my sudo edit"))

  (kahasta/leader-keys
    "g" '(:ignore t :wk "go to")
    "g g" '(magit-status :wk "Magit status")
    "g c" '(avy-goto-char :wk "Jump to char")
    "g d" '(my/hydra-jump-to-directory/body :wk "Jump to char")

    )

  (kahasta/leader-keys
    "h" '(:ignore t :wk "Help")
    "h f" '(describe-function :wk "Describe function")
    "h v" '(describe-variable :wk "Describe variable")
    "h r r" '((lambda () (interactive)
		(load-file (concat my/config-dir "init.el"))
		(ignore (elpaca-process-queues)))
	      :wk "Reload emacs config"))
  
  
  (kahasta/leader-keys
    "i" '(imenu :wk "Imenu")
    )
  
  (kahasta/leader-keys
    "l" '(:ignore t :wk "Lsp")
    "l f" '(format-all-buffer :wk "Formatting buffer")
    "l o" '(my/org-format-src-block :wk "Formatting org-mode buffer")
    )



  (kahasta/leader-keys
    "p" '(projectile-command-map :wk "Projectile")
    )
  
  (kahasta/leader-keys
    "o" '(:ignore t :wk "Open")
    "o a" '(emacs-run-launcher :wk "App-Launcher")
    "o e" '(eshell :wk "Eshell")
    "o h" '(counsel-esh-history :which-key "Eshell history")
    "o n" '(treemacs :wk "Treemacs")
    "o v" '(vterm-toggle :wk "Vterm"))

  (kahasta/leader-keys
    "t" '(:ignore t :wk "Toggle")
    "t a" '(aggressive-indent-mode :wk "Aggressive-indent toggle")
    "t e" '(eldoc-box-hover-at-point-mode :wk "Eldoc box hover toggle")
    "t l" '(display-line-numbers-mode :wk "Toggle line numbers")
    "t T" '(visual-line-mode :wk "Toggle truncated lines")
    "t t" '(load-theme :wk "Load theme")
    )

  (kahasta/leader-keys
    "u" '(:ignore t :wk "Utils")
    "u u" '(vundo :wk "Undo")
    )

  (kahasta/leader-keys
    "q" '(:ignore t :wk "My Hydra")
    "q z" '(my/hydra-zoom/body :wk "Zoom")
    "q w" '(my/hydra-window/body :wk "Windows")
    )

  (kahasta/leader-keys
    "w" '(:ignore t :wk "Windows")
    ;; Window splits
    "w c" '(evil-window-delete :wk "Close window")
    "w n" '(evil-window-new :wk "New window")
    "w s" '(evil-window-split :wk "Horizontal split window")
    "w v" '(evil-window-vsplit :wk "Vertical split window")
    ;; Window motions
    "w h" '(evil-window-left :wk "Window left")
    "w j" '(evil-window-down :wk "Window down")
    "w k" '(evil-window-up :wk "Window up")
    "w l" '(evil-window-right :wk "Window right")
    "w o" '(other-window :wk "Ace window")
    "w w" '(evil-window-next :wk "Goto next window")
    ))

(use-package ace-window
  :ensure t
  :init
  (progn
    (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))  ; Буквы для выбора окон
    (setq aw-scope 'frame)                       ; В рамках одного фрейма
    (global-set-key [remap other-window] 'ace-window))
  :config
  ;; Цвета для номеров окон
  (set-face-attribute 'aw-leading-char-face nil
                      :foreground "red"
                      :height 2.0)
  
  ;; Минимальный размер окна для выбора
  (setq aw-minibuffer-flag nil
        aw-ignore-on t
        aw-dispatch-always t)
  
  ;; Для работы с ivy/helm
  (setq aw-dispatch-algorithm 'aw-dispatch-algo-ivy))

  ;; Для отображения номеров окон
  (use-package window-numbering
    :ensure t
    :config
    (window-numbering-mode 1))

(use-package aggressive-indent
  :ensure t
  :init
  (global-aggressive-indent-mode 1))

(use-package app-launcher
  :ensure '(app-launcher :host github :repo "SebastienWae/app-launcher"))
;; create a global keyboard shortcut with the following code
;; emacsclient -cF "((visibility . nil))" -e "(emacs-run-launcher)"

(defun emacs-run-launcher ()
  "Create and select a frame called emacs-run-launcher which consists only of a minibuffer and has specific dimensions. Runs app-launcher-run-app on that frame, which is an emacs command that prompts you to select an app and open it in a dmenu like behaviour. Delete the frame after that command has exited"
  (interactive)
  (with-selected-frame
      (make-frame '((name . "emacs-run-launcher")
                    (minibuffer . only)
                    (fullscreen . 0) ; no fullscreen
                    (undecorated . t) ; remove title bar
                    ;;(auto-raise . t) ; focus on this frame
                    ;;(tool-bar-lines . 0)
                    ;;(menu-bar-lines . 0)
                    (internal-border-width . 10)
                    (width . 80)
                    (height . 11)))
    (unwind-protect
        (app-launcher-run-app)
      (delete-frame))))

(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

(use-package all-the-icons-dired
  :ensure t
  :hook (dired-mode . (lambda () (all-the-icons-dired-mode t))))

(use-package avy
  :ensure t
  :config
  (general-define-key
   :states '(normal visual)
   "s" 'avy-goto-char-timer)
  :bind (:map prog-mode-map ("C-'" . #'avy-goto-line))
  :bind (:map org-mode-map ("C-'" . #'avy-goto-line))
  :bind (("C-c l" . #'avy-goto-line)
         ("C-c j k" . #'avy-kill-whole-line)
         ("C-c j j" . #'avy-goto-line)
         ("C-c j h" . #'avy-kill-region)
         ("C-c j w" . #'avy-copy-line)
         ("C-z" . #'avy-goto-char)
         ("C-c v" . #'avy-goto-char)))

(use-package avy-zap
  :ensure t
  :bind (("C-c z" . #'avy-zap-to-char)
         ("C-c Z" . #'avy-zap-up-to-char)))

(use-package yaml-mode
  :ensure t
  :defer t)
(use-package dockerfile-mode
  :ensure t
  :defer t)
(use-package toml-mode
  :ensure t
  :defer t)
(use-package dhall-mode
  :ensure t)
(use-package terraform-mode
  :ensure t
  :defer t)

;; (global-completion-preview-mode)
;; (push 'org-self-insert-command completion-preview-commands)
;; (setf completion-styles '(basic flex)
;;       completion-auto-select t
;;       completion-auto-help 'visible
;;       completions-format 'one-column
;;       completions-sort 'historical
;;       completions-max-height 20
;;       completion-ignore-case t)

(use-package dashboard
  :ensure t
  :init
  (setq initial-buffer-choice 'dashboard-open)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-banner-logo-title "Emacs Is More Than A Text Editor!")
  ;;(setq dashboard-startup-banner 'logo) ;; use standard emacs logo as banner
  (setq dashboard-startup-banner (concat my/config-dir "images/emacs.png"))  ;; use custom image as banner
  (setq dashboard-center-content nil) ;; set to 't' for centered content
  (setq dashboard-items '((recents . 10)
                          (agenda . 5 )
                          (bookmarks . 3)
                          (projects . 5)
                          (registers . 3)))
  :custom
  (dashboard-modify-heading-icons '((recents . "file-text")
                                    (bookmarks . "book")))
  :config
  (dashboard-setup-startup-hook))

;; Добавляет загрузку пакета dired-x при инициализации Dired. dired-x расширяет возможности Dired, добавляя функции, такие как:
;;  *  Улучшенная работа с файлами (например, открытие по C-x C-f).
;;  *  Команды для массового переименования, копирования и перемещения.
;;  *  Поддержка дополнительных операций, вроде запуска внешних программ.
(add-hook 'dired-load-hook (function (lambda () (load "dired-x"))))

(with-eval-after-load 'dired-x
  (setq dired-omit-files
	(concat dired-omit-files "\\|^\\..+$"))
  (setq-default dired-dwim-target t)
  (setq dired-listing-switches "-alh")
  (setq dired-mouse-drag-files t)
  )

(use-package dired-open
  :ensure t
  :config
  (setf dired-kill-when-opening-new-dired-buffer t)
  (setq dired-open-extensions '(("gif" . "sxiv")
                                ("jpg" . "sxiv")
                                ("jpeg" . "sxiv")
                                ("png" . "sxiv")
                                ("png" . "sxiv")
                                ("mkv" . "mpv")
                                ("mp4" . "mpv"))))

(use-package dired-hacks-utils)
(use-package dired-narrow)

;; Additional syntax highlighting for dired
(use-package diredfl
  :hook
  ((dired-mode . diredfl-mode)
   ;; highlight parent and directory preview as well
   (dirvish-directory-view-mode . diredfl-mode))
  :config
  (set-face-attribute 'diredfl-dir-name nil :bold t))

;; Use `nerd-icons' as Dirvish's icon backend
(use-package nerd-icons)

(use-package dired-quick-sort
  :init
  (dired-quick-sort-setup))
(with-eval-after-load 'evil
(evil-define-key 'normal dired-mode-map (kbd "f") 'dired-narrow)
(evil-define-key 'normal dired-mode-map (kbd "F") 'revert-buffer)
(evil-define-key 'normal dired-mode-map (kbd ".") 'dired-omit-mode)
(evil-define-key 'normal dired-mode-map (kbd "s") 'hydra-dired-quick-sort/body)
)

(use-package peep-dired
  :ensure t
  :after dired
  :hook (evil-normalize-keymaps . peep-dired-hook)
  :config
  (evil-define-key 'normal dired-mode-map
    "h" 'dired-up-directory
    "l" 'dired-open-file
    "v" 'peep-dired)
  
  (evil-define-key 'normal peep-dired-mode-map
    "j" 'peep-dired-next-file
    "k" 'peep-dired-prev-file
    "q" 'peep-dired-quit
    "l" 'peep-dired-open-file)
  ;; (evil-define-key 'normal dired-mode-map (kbd "h") 'dired-up-directory)
  ;; (evil-define-key 'normal dired-mode-map (kbd "l") 'dired-open-file) ; use dired-find-file instead if not using dired-open package
  ;; (evil-define-key 'normal peep-dired-mode-map (kbd "j") 'peep-dired-next-file)
  ;; (evil-define-key 'normal peep-dired-mode-map (kbd "k") 'peep-dired-prev-file)
  (add-hook 'peep-dired-hook 'evil-normalize-keymaps)
  )

(use-package diminish :ensure t)

(use-package expand-region
  :ensure t
  :bind
  ("C-M-e" . er/contract-region)
  ("C-S-e" . er/expand-region)
  :config
  (setq er/try-expand-list (append er/try-expand-list
                                 '(mark-paragraph
                                   mark-whole-buffer)))
)

(use-package s
  :ensure t
  :defer t
  :init
  (message "Loading string manipulation utilities (s)..."))

(use-package dash
  :ensure t
  :defer t
  :config
  (when (fboundp 'pt/unbind-bad-keybindings)
    (pt/unbind-bad-keybindings))
  (message "Dash functional programming helpers ready"))

(use-package shut-up
  :ensure t
  :defer t
  :config
  (setq shut-up-ignore '*)
  (message "Output silencing package (shut-up) initialized"))

;; helpful — улучшенные describe-функции
(use-package helpful
  :ensure t
  :bind (([remap describe-function] . helpful-callable)
         ([remap describe-variable] . helpful-variable)
         ([remap describe-symbol]   . helpful-symbol)
         ([remap describe-key]      . helpful-key)))


(defun my-eldoc-manual ()
  (interactive)
  (eldoc-print-current-symbol-info))
(global-set-key (kbd "C-S-k") 'eldoc-print-current-symbol-info)
;; eldoc-box — всплывающая документация
(use-package eldoc-box
  :ensure t
   ;;:hook (
  ;; (prog-mode . eldoc-box-hover-mode)
   ;;      (emacs-lisp-mode . eldoc-box-hover-mode)
  	;; (prog-mode . eldoc-box-hover-at-point-mode)
   ;;)
  :custom
  (eldoc-idle-delay 1000000)
  ;;(global-set-key (kbd "K") #'my/show-doc-posframe)
  (eldoc-box-clear-with-C-g t)         ;; закрывать по C-g
  (eldoc-box-max-pixel-width 600)
  (eldoc-box-only-multi-line t)        ;; показывать, только если есть что показать
  (eldoc-echo-area-use-multiline-p nil)) ;; отключить echo-area


(defun my/eglot-doc-buffer ()
  "Показать документацию от Eglot в отдельном буфере, не обновляя автоматически."
  (interactive)
  (let ((eldoc-documentation-functions '(eglot--eldoc-function)))
    (eldoc--invoke-doc-functions
     eldoc-documentation-functions
     (lambda (doc)
       (when doc
         (let ((buf (get-buffer-create "*eglot-doc*")))
           (with-current-buffer buf
             (read-only-mode -1)
             (erase-buffer)
             (insert doc)
             (read-only-mode 1))
           (display-buffer buf)))))))



;; Опционально: embak для контекстных действий
(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)
   ;; ("K" .  eldoc-box-help-at-point)
   ("C-h B" . embark-bindings)))

(use-package iedit
  :ensure t
  :after evil
  :bind (:map evil-normal-state-map
              ("C-c i" . iedit-mode)))

(use-package flycheck
  :ensure t
  :defer t
  :diminish
  :init (global-flycheck-mode))

;; (use-package flymake
;;   :ensure t
;;   :config
;;   (setq elisp-flymake-byte-compile-load-path nil)
;;   :hook ((emacs-lisp-mode . flymake-mode)))

(defun my/setup-my-fonts ()
  "Настройка шрифтов"
  (interactive)
  (let ((font-size 15)  ; Размер по умолчанию
         (main-font "JetBrains Mono")
        ;;(main-font "Iosevka")
         (var-font "Noto Serif")
        ;;(var-font "Iosevka Aile")
	        (line-spacing-size 0.12))
    
    ;; Проверка графического режима
    (when (display-graphic-p)
      ;; Основные настройки шрифтов
      (set-face-attribute 'default nil
                         :font main-font
                         :height (* 10 font-size)
                         :weight 'medium)
      
      (set-face-attribute 'variable-pitch nil
                         :font var-font
                         :height (* 10 (+ font-size 1)))
      
      (set-face-attribute 'fixed-pitch nil
                         :font main-font
                         :height (* 10 font-size))
      
      ;; Настройки для фреймов
      (add-to-list 'initial-frame-alist
                  `(font . ,(format "%s-%d" main-font font-size)))
      (add-to-list 'default-frame-alist
                  `(font . ,(format "%s-%d" main-font font-size)))
      
      ;; Стили для комментариев и ключевых слов
      (set-face-attribute 'font-lock-comment-face nil
			    :slant 'italic
			    :font var-font)
      (set-face-attribute 'font-lock-keyword-face nil
			    :slant 'italic
			    :font var-font)
      
      ;; Межстрочный интервал
      (setq-default line-spacing line-spacing-size)))

  ;; Инициализация при загрузке
  (message "Fonts initializing complete")
)


(add-hook 'after-init-hook 'my/setup-my-fonts)
;; (add-hook 'emacs-startup-hook 'my/setup-font)

(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

(use-package format-all
  :ensure t
  :hook ((prog-mode . format-all-ensure-formatter)
         (before-save . format-all-buffer)))

(defun my/org-format-src-block ()
  "Форматировать текущий блок кода в Org-mode."
  (interactive)
  (when (org-in-src-block-p)
    (org-edit-special)
    (indent-region (point-min) (point-max))
    (org-edit-src-exit)))

(use-package highlight-indent-guides
  :ensure t
  :hook (prog-mode . highlight-indent-guides-mode))

(use-package hydra
  :ensure t
  :config
  (defhydra my/hydra-zoom ()
    "zoom"
    ("k" text-scale-increase "in")
    ("j" text-scale-decrease "out"))

  ;; Определим hydra для управления окнами
  (defhydra my/hydra-window (:hint nil)
    "
^Навигация^      ^Разделение^           ^Размер^                ^Прочее^
^^^^^^^^------------------------------------------------------------------
_h_ ←       _v_ вертикально     _H_ уменьшить ширину     _o_ другое окно
_j_ ↓       _s_ горизонтально   _L_ увеличить ширину     _q_ выйти
_k_ ↑       _d_ удалить окно    _J_ уменьшить высоту
_l_ →                          _K_ увеличить высоту
"
    ("h" windmove-left)
    ("j" windmove-down)
    ("k" windmove-up)
    ("l" windmove-right)
    ("v" split-window-right)
    ("s" split-window-below)
    ("d" delete-window)
    ("H" shrink-window-horizontally)
    ("L" enlarge-window-horizontally)
    ("J" shrink-window)
    ("K" enlarge-window)
    ;; ("u" (winner-undo))
    ;; ("r" (winner-redo))
    ("o" other-window)
    ("q" nil :exit t))

  (defhydra my/hydra-jump-to-directory
    (:color amaranth)
    "Jump to directory"
    ("p" (find-file "/home/kahasta/Projects") "Projects" :exit t)
    ("c" (find-file "/home/kahasta/.config") ".config" :exit t)
    ("q" nil "Quit" :color blue))
  )

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(global-display-line-numbers-mode 1)
(column-number-mode 1)
(global-visual-line-mode t)
(delete-selection-mode 1)

(use-package android-mode
  :ensure t
  :config
  (setq android-mode-sdk-dir "~/Android/Sdk"))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((c-mode c-ts-mode c++-mode c++-ts-mode) . ("ccls" "--init" "{\"compilationDatabaseDirectory\": \"build\"}"))))

(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c-ts-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)
(add-hook 'c++-ts-mode-hook 'eglot-ensure)

;; (use-package kotlin-mode)

(use-package lua-mode :ensure t)

(use-package rust-mode
  :ensure t
  :hook (rust-mode . (lambda ()
                      (setq indent-tabs-mode nil
                            tab-width 4)))
  :config
  (setq rust-format-on-save t))

(use-package cargo
  :ensure t
  :hook (rust-mode . cargo-minor-mode))

(with-eval-after-load 'general
  (general-define-key
   :states '(normal)
   :keymaps 'rust-mode-map
   :prefix "SPC m"
   "" '(:ignore t :wk "Mode functions")
   "r" '(rust-run :wk "Run")
   "t" '(rust-test :wk "Run test")
   "c" '(rust-run-clippy :wk "Run clippy")
   "C r" '(rust-compile-release :wk "compile release")
   "C c" '(rust-compile :wk "compile release")
)
)

(use-package dart-mode
  ;; Optional
  :ensure t
  :hook (dart-mode . flutter-test-mode))

(use-package flutter
  :ensure t
  :after dart-mode
  :bind (:map dart-mode-map
              ("C-M-x" . #'flutter-run-or-hot-reload))
  :custom
  (flutter-sdk-path "/home/kahasta/development/flutter/"))

(with-eval-after-load 'general
(general-define-key
   :states '(normal) ; Для normal-состояния Evil
   :keymaps 'dart-mode-map ; Только в org-mode
   :prefix "SPC m" ; Лидер-ключ SPC m
   "" '(:ignore t :which-key "Mode functions")
   "s" '(flutter-run :wk "Flutter run")
   "r" '(flutter-hot-reload :wk "Flutter Hot reload")
   "R" '(flutter-hot-restart :wk "Flutter Hot restart")
   "q" '(flutter-quit :wk "Flutter quit")
))

(with-eval-after-load 'general
  (general-define-key
   :states '(normal)
   :keymaps 'org-mode-map
   :prefix "SPC m"
   "" '(:ignore t :wk "Mode functions")
   "a" '(org-agenda :wk "Org agenda")
   "b" '(:ignore t :wk "Tables")
   "b -" '(org-table-insert-hline :wk "Insert hline in table")
   "d" '(:ignore t :wk "Date/deadline")
   "d t" '(org-time-stamp :wk "Org time stamp")
   "e" '(org-export-dispatch :wk "Org export dispatch")
   "i" '(org-toggle-item :wk "Org toggle item")
   "t" '(org-todo :wk "Org todo")
   "B" '(org-babel-tangle :wk "Org babel tangle")
   "T" '(org-todo-list :wk "Org todo list")
   ))

(use-package toc-org
  :ensure t
  :commands toc-org-enable
  :init (add-hook 'org-mode-hook 'toc-org-enable))

(use-package org-modern
  :ensure t
  :custom
  (org-modern-fold-stars '(("▶" . "▼") ("▷" . "▽") ("▹" . "▿") ("▸" . "▾")))
  :config
  (with-eval-after-load 'org (global-org-modern-mode)))

(add-hook 'org-mode-hook 'org-indent-mode)
(use-package org-bullets :ensure t)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(electric-indent-mode -1)
(setq org-edit-src-content-indentation 0)

(require 'org-tempo)
(with-eval-after-load 'org-tempo
  (add-to-list 'org-structure-template-alist '("se" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("sp" . "src python"))
  (add-to-list 'org-structure-template-alist '("sc" . "src c++"))
  )

(setq org-imenu-depth 4) ; Показывать заголовки до 4-го уровня

(use-package projectile
  :ensure t
  :config
  (setq projectile-completion-system 'ivy)
  (projectile-mode 1))

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode)
  :config
  (setq rainbow-delimiters-max-face-count 5))

(use-package rainbow-mode
  :ensure t
  :hook
  ((org-mode prog-mode) . rainbow-mode))

(use-package eshell-syntax-highlighting
  :ensure t
  :after esh-mode
  :config
  (eshell-syntax-highlighting-global-mode +1))

;; eshell-syntax-highlighting -- adds fish/zsh-like syntax highlighting.
;; eshell-rc-script -- your profile for eshell; like a bashrc for eshell.
;; eshell-aliases-file -- sets an aliases file for the eshell.
  
(setq eshell-rc-script (concat user-emacs-directory "eshll/profile") ;; в этом файле автозапуск команд
      eshell-aliases-file (concat user-emacs-directory "eshell/aliases")
      eshell-history-size 5000
      eshell-buffer-maximum-lines 5000
      eshell-hist-ignoredups t
      eshell-scroll-to-bottom-on-input t
      eshell-destroy-buffer-when-process-dies t
      eshell-visual-commands'("bash" "fish" "nushell" "htop" "ssh" "top" "zsh"))

(use-package vterm
:ensure t
:config
(setq shell-file-name "/usr/bin/zsh"
      vterm-max-scrollback 5000))

(use-package vterm-toggle
  :ensure t
  :after vterm
  :config
  (setq vterm-toggle-fullscreen-p nil)
  (setq vterm-toggle-scope 'project)
  (add-to-list 'display-buffer-alist
               '((lambda (buffer-or-name _)
                     (let ((buffer (get-buffer buffer-or-name)))
                       (with-current-buffer buffer
                         (or (equal major-mode 'vterm-mode)
                             (string-prefix-p vterm-buffer-name (buffer-name buffer))))))
                  (display-buffer-reuse-window display-buffer-at-bottom)
                  ;;(display-buffer-reuse-window display-buffer-in-direction)
                  ;;display-buffer-in-direction/direction/dedicated is added in emacs27
                  ;;(direction . bottom)
                  ;;(dedicated . t) ;dedicated is supported in emacs27
                  (reusable-frames . visible)
                  (window-height . 0.3))))

(use-package smartparens
  :ensure t
  :hook (prog-mode . smartparens-mode)
  :config
  (require 'smartparens-config)
  ;; Автозакрытие парных символов
  (setq sp-autoescape-string-quote nil)
  ;; Позволяет удалять парные символы сразу
  (sp-local-pair 'emacs-lisp-mode "'" nil :actions nil)
  (sp-local-pair 'web-mode "<" ">"))

(use-package smooth-scroll
  :ensure t
  :config
  (smooth-scroll-mode 1))

;; Включение режима вкладок
;; (tab-bar-mode 1)

;; Открытие нового файла в новой вкладке
;; (advice-add 'find-file :around
;;             (lambda (orig-fun &rest args)
;;               (tab-bar-new-tab)
;;               (apply orig-fun args)))

(use-package telega
  :ensure t
  :commands (telega)
  :config
  (setq
   telega-translate-to-language-by-default "ru")
  :hook
  ('telega-chat-pre-message . #'telega-msg-ignore-blocked-sender)
  :defer t)
(with-eval-after-load 'telega
  (define-key global-map (kbd "C-c t") telega-prefix-map))

(use-package doom-themes
      :ensure t
      :config
      ;; Global settings (defaults)
      (load-theme 'doom-one t)

      ;; Enable flashing mode-line on errors
      (doom-themes-visual-bell-config)
      ;; Enable custom neotree theme (nerd-icons must be installed!)
      (doom-themes-neotree-config)
      ;; or for treemacs users
      (setq doom-themes-treemacs-theme "doom-one") ; use "doom-colors" for less minimal icon theme
      (doom-themes-treemacs-config)
      ;; Corrects (and improves) org-mode's native fontification.
      (doom-themes-org-config)
      :custom
      (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
            doom-themes-enable-italic t) ; if nil, italics is universally disabled
)

;; (use-package tramp
;;   :ensure t
;;   :config
;;   (setq tramp-default-method "sudo")
;;   (setq tramp-shell-prompt-pattern "^[^$>\n]*[#$%>] *")
;;   (setq tramp-use-ssh-controlmaster-options nil)
;;   (setq tramp-verbose 1)
;;   (add-to-list 'tramp-connection-properties
;;                (list (regexp-quote ".*") "shell" "/bin/bash"))
;;   (setq password-cache-expiry nil)
;;   (add-to-list 'tramp-methods
;;                '("sudo"
;;                  (tramp-login-program "sudo")
;;                  (tramp-login-args (("-u" "%u") ("-i")))
;;                  (tramp-remote-shell "/bin/bash")
;;                  (tramp-remote-shell-args ("-c"))))
;;   )
;; (setq tramp-shell-file-name "/bin/bash")
;; (setq shell-file-name "/bin/bash")
;; (setq explicit-shell-file-name "/bin/bash")
;; (setq eshell-shell-file-name "/bin/bash")
;; ;; Настройки для nushell в TRAMP
;; (with-eval-after-load 'tramp
;;   (add-to-list 'tramp-remote-path "/bin")
;;   (add-to-list 'tramp-remote-path "/usr/bin")
;;   (add-to-list 'tramp-remote-path "/sbin")
;;   (setq tramp-remote-process-environment
;;         (append tramp-remote-process-environment
;;                '("SHELL=/bin/bash"  ;; Форсируем bash для TRAMP
;;                  "TERM=dumb"
;;                  "INSIDE_EMACS=tramp"))))

;; (use-package tree-sitter
;;   :ensure t
;;   :init
;;   (global-tree-sitter-mode 1))
;; Установка tree-sitter

(use-package tree-sitter-langs
  :ensure t)

;; Tree-sitter
(use-package tree-sitter
  :defer t
  :config
  (use-package tree-sitter-langs
    :ensure t)
  (setq tree-sitter-debug-jump-buttons t
        tree-sitter-debug-highlight-jump-region t))

;; evil-textobj-tree-sitter
(use-package evil-textobj-tree-sitter
  :defer t
  :after tree-sitter
  :config
  (defvar +tree-sitter-inner-text-objects-map (make-sparse-keymap))
  (defvar +tree-sitter-outer-text-objects-map (make-sparse-keymap))
  (defvar +tree-sitter-goto-previous-map (make-sparse-keymap))
  (defvar +tree-sitter-goto-next-map (make-sparse-keymap))

  (evil-define-key '(visual operator) 'tree-sitter-mode
    "i" +tree-sitter-inner-text-objects-map
    "a" +tree-sitter-outer-text-objects-map)
  (evil-define-key 'normal 'tree-sitter-mode
    "[g" +tree-sitter-goto-previous-map
    "]g" +tree-sitter-goto-next-map)

  (defun +tree-sitter-get-textobj (query)
    `(evil-textobj-tree-sitter-get-textobj ,query))

  (defun +tree-sitter-goto-textobj (query &optional backwards)
    `(evil-textobj-tree-sitter-goto-textobj ,query ,backwards))

  ;; Привязки клавиш (map!)
  (define-key +tree-sitter-inner-text-objects-map "A" (+tree-sitter-get-textobj '("parameter.inner" "call.inner")))
  (define-key +tree-sitter-inner-text-objects-map "f" (+tree-sitter-get-textobj "function.inner"))
  (define-key +tree-sitter-inner-text-objects-map "F" (+tree-sitter-get-textobj "call.inner"))
  (define-key +tree-sitter-inner-text-objects-map "C" (+tree-sitter-get-textobj "class.inner"))
  (define-key +tree-sitter-inner-text-objects-map "v" (+tree-sitter-get-textobj "conditional.inner"))
  (define-key +tree-sitter-inner-text-objects-map "l" (+tree-sitter-get-textobj "loop.inner"))

  (define-key +tree-sitter-outer-text-objects-map "A" (+tree-sitter-get-textobj '("parameter.outer" "call.outer")))
  (define-key +tree-sitter-outer-text-objects-map "f" (+tree-sitter-get-textobj "function.outer"))
  (define-key +tree-sitter-outer-text-objects-map "F" (+tree-sitter-get-textobj "call.outer"))
  (define-key +tree-sitter-outer-text-objects-map "C" (+tree-sitter-get-textobj "class.outer"))
  (define-key +tree-sitter-outer-text-objects-map "c" (+tree-sitter-get-textobj "comment.outer"))
  (define-key +tree-sitter-outer-text-objects-map "v" (+tree-sitter-get-textobj "conditional.outer"))
  (define-key +tree-sitter-outer-text-objects-map "l" (+tree-sitter-get-textobj "loop.outer"))

  (define-key +tree-sitter-goto-previous-map "a" (+tree-sitter-goto-textobj "parameter.outer" t))
  (define-key +tree-sitter-goto-previous-map "f" (+tree-sitter-goto-textobj "function.outer" t))
  (define-key +tree-sitter-goto-previous-map "F" (+tree-sitter-goto-textobj "call.outer" t))
  (define-key +tree-sitter-goto-previous-map "C" (+tree-sitter-goto-textobj "class.outer" t))
  (define-key +tree-sitter-goto-previous-map "c" (+tree-sitter-goto-textobj "comment.outer" t))
  (define-key +tree-sitter-goto-previous-map "v" (+tree-sitter-goto-textobj "conditional.outer" t))
  (define-key +tree-sitter-goto-previous-map "l" (+tree-sitter-goto-textobj "loop.outer" t))

  (define-key +tree-sitter-goto-next-map "a" (+tree-sitter-goto-textobj "parameter.outer"))
  (define-key +tree-sitter-goto-next-map "f" (+tree-sitter-goto-textobj "function.outer"))
  (define-key +tree-sitter-goto-next-map "F" (+tree-sitter-goto-textobj "call.outer"))
  (define-key +tree-sitter-goto-next-map "C" (+tree-sitter-goto-textobj "class.outer"))
  (define-key +tree-sitter-goto-next-map "c" (+tree-sitter-goto-textobj "comment.outer"))
  (define-key +tree-sitter-goto-next-map "v" (+tree-sitter-goto-textobj "conditional.outer"))
  (define-key +tree-sitter-goto-next-map "l" (+tree-sitter-goto-textobj "loop.outer")))

;; which-key настройка (опционально)
(with-eval-after-load 'which-key
  (setq which-key-allow-multiple-replacements t)
  (add-to-list 'which-key-replacement-alist
               '((nil . "\\`+?evil-textobj-tree-sitter-function--\\(.*\\)\\(?:.inner\\|.outer\\)")
                 . (nil . "\\1"))))

(use-package yasnippet
  :ensure t         ; Install yasnippet if not already present
  :defer t          ; Defer loading for faster startup, loads when first needed
  :bind ("M-/" . yas-expand) ; Optional: Bind M-/ to manually expand snippet
  :config
  ;; Code here runs AFTER yasnippet is loaded

  (yas-global-mode 1) ; Enable yasnippet globally in all buffers

  ;; Optional: Add a custom directory for your own snippets
  ;; Replace "~/my-snippets" with the actual path to your custom snippets directory
  ;; (yas-add-dir "~/my-snippets")

  ;; Optional: If you have snippets organized by major mode outside of default locations
  ;; (yas-add-dir "/path/to/more/snippets/" 'recursive)

  ;; Optional: Customize snippet indentation behavior (e.g., inherit parent)
  ;; (setq yas-indent-line 'auto)

  ;; Optional: Choose when snippets should be candidates for expansion
  ;; 't (default): Always a candidate if prefix matches
  ;; 'real-prefix: Only if the full snippet name is typed
  ;; 'no-prefix: Never automatically, must use yas-expand
  ;; (setq yas-trigger-key 'tab) ; Default trigger is TAB after snippet name
  )

(use-package vundo
  :ensure t
  :diminish
  ;; :bind* (("C-c _" . vundo))
  :custom (vundo-glyph-alist vundo-unicode-symbols))

(use-package which-key
  :init
  (which-key-mode 1)
  :config
  (setq which-key-side-window-location 'bottom
  which-key-sort-order #'which-key-key-order-alpha
  which-key-sort-uppercase-first nil
  which-key-add-column-padding 1
  which-key-max-display-columns nil
  which-key-min-display-lines 6
  which-key-side-window-slot -10
  which-key-side-window-max-height 0.25
  which-key-idle-delay 0.8
  which-key-max-description-length 25
  which-key-allow-imprecise-window-fit nil
  which-key-separator " → "
 ))

(windmove-default-keybindings 'meta)
(global-set-key (kbd "M-h") 'windmove-left)
(global-set-key (kbd "M-j") 'windmove-down)
(global-set-key (kbd "M-k") 'windmove-up)
(global-set-key (kbd "M-l") 'windmove-right)
