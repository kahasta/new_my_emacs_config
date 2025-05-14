(add-to-list 'load-path (concat my/config-dir "modules/"))

(require 'elpaca-setup)
(add-hook 'after-init-hook
	  (lambda ()
	    ;; add to this your modules
(require 'treemacs-mod)
(require 'magit-mod)
))

;; (add-hook 'after-init-hook
;;	  (lambda ()
;;	    (progn
;;	      (load-file "~/.my-emacs.d/init.el")
;;	      (ignore (elpaca-process-queues))
;;	    (message "Reload second"))))

(setq evil-want-keybinding nil)
(setq evil-want-integration t)
;; Убедимся, что use-package загружен перед использованием
(elpaca elpaca-use-package (elpaca-use-package-mode))

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
    ;; (setq evil-collection-mode-list '(dashboard dired ibuffer eshell help-mode magit org))
    (evil-collection-init))

(defun my/reload-config ()
  "Reload Emacs configuration safely."
  (interactive)
  (message "Reloading init file...")
  (load user-init-file nil 'nomessage)
  (message "Init file reloaded!"))

(defun my/sudo-edit ()
 "Edit file as root with explicit bash shell"
 (interactive)
 (let ((file (or buffer-file-name (error "Not visiting a file"))))
   (find-file (format "/sudo::%s" file))))

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
    "SPC" '(counsel-M-x :wk "Counsel M-x")
    "." '(find-file :wk "Find file")
    "f c" '((lambda () (interactive) (find-file (concat my/config-dir "config.org"))) :wk "Edit emacs config")
    "f r" '(counsel-recentf :wk "Find recent files")
    "TAB TAB" '(comment-line :wk "Comment lines"))

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
    "d d" '(dired :wk "Open dired")
    "d j" '(dired-jump :wk "Dired jump to current")
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
    "g c" '(avy-goto-char :wk "Jump to char"))

  (kahasta/leader-keys
    "h" '(:ignore t :wk "Help")
    "h f" '(describe-function :wk "Describe function")
    "h v" '(describe-variable :wk "Describe variable")
    "h r r" '((lambda () (interactive)
		(load-file (concat my/config-dir "init.el"))
		(ignore (elpaca-process-queues)))
	      :wk "Reload emacs config"))
  
  (kahasta/leader-keys
    "m" '(:ignore t :wk "Org")
    "m a" '(org-agenda :wk "Org agenda")
    "m e" '(org-export-dispatch :wk "Org export dispatch")
    "m i" '(org-toggle-item :wk "Org toggle item")
    "m t" '(org-todo :wk "Org todo")
    "m B" '(org-babel-tangle :wk "Org babel tangle")
    "m T" '(org-todo-list :wk "Org todo list"))
  

  (kahasta/leader-keys
    "l" '(:ignore t :wk "Lsp")
    "l f" '(format-all-buffer :wk "Formatting buffer")
    )

  (kahasta/leader-keys
    "m b" '(:ignore t :wk "Tables")
    "m b -" '(org-table-insert-hline :wk "Insert hline in table"))

  (kahasta/leader-keys
    "m d" '(:ignore t :wk "Date/deadline")
    "m d t" '(org-time-stamp :wk "Org time stamp"))

  (kahasta/leader-keys
    "p" '(projectile-command-map :wk "Projectile"))
  
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
    "t l" '(display-line-numbers-mode :wk "Toggle line numbers")
    "t T" '(visual-line-mode :wk "Toggle truncated lines")
    "t t" '(load-theme :wk "Load theme"))

  (kahasta/leader-keys
    "u" '(:ignore t :wk "Utils")
    "u u" '(vundo :wk "Undo")
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
    "w w" '(evil-window-next :wk "Goto next window")
    ;; Move Windows
    "w H" '(buf-move-left :wk "Buffer move left")
    "w J" '(buf-move-down :wk "Buffer move down")
    "w K" '(buf-move-up :wk "Buffer move up")
    "w L" '(buf-move-right :wk "Buffer move right"))
  )

(use-package ace-window
  :ensure t
  :init
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))  ; Буквы для выбора окон
  (setq aw-scope 'frame)                       ; В рамках одного фрейма
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
  (setq aw-dispatch-algorithm 'aw-dispatch-algo-ivy)

  ;; Для отображения номеров окон
  (use-package window-numbering
    :ensure t
    :config
    (window-numbering-mode 1))
  
  ;; Привязки клавиш
  (global-set-key (kbd "M-o") 'ace-window))

(use-package aggressive-indent
  :ensure t)

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

(setq backup-directory-alist `(("." . ,(expand-file-name "backups/" user-emacs-directory))))

(require 'windmove)

;;;###autoload
(defun buf-move-up ()
  "Swap the current buffer and the buffer above the split.
If there is no split, ie now window above the current one, an
error is signaled."
;;  "Switches between the current buffer, and the buffer above the
;;  split, if possible."
  (interactive)
  (let* ((other-win (windmove-find-other-window 'up))
	 (buf-this-buf (window-buffer (selected-window))))
    (if (null other-win)
        (error "No window above this one")
      ;; swap top with this one
      (set-window-buffer (selected-window) (window-buffer other-win))
      ;; move this one to top
      (set-window-buffer other-win buf-this-buf)
      (select-window other-win))))

;;;###autoload
(defun buf-move-down ()
"Swap the current buffer and the buffer under the split.
If there is no split, ie now window under the current one, an
error is signaled."
  (interactive)
  (let* ((other-win (windmove-find-other-window 'down))
	 (buf-this-buf (window-buffer (selected-window))))
    (if (or (null other-win) 
            (string-match "^ \\*Minibuf" (buffer-name (window-buffer other-win))))
        (error "No window under this one")
      ;; swap top with this one
      (set-window-buffer (selected-window) (window-buffer other-win))
      ;; move this one to top
      (set-window-buffer other-win buf-this-buf)
      (select-window other-win))))

;;;###autoload
(defun buf-move-left ()
"Swap the current buffer and the buffer on the left of the split.
If there is no split, ie now window on the left of the current
one, an error is signaled."
  (interactive)
  (let* ((other-win (windmove-find-other-window 'left))
	 (buf-this-buf (window-buffer (selected-window))))
    (if (null other-win)
        (error "No left split")
      ;; swap top with this one
      (set-window-buffer (selected-window) (window-buffer other-win))
      ;; move this one to top
      (set-window-buffer other-win buf-this-buf)
      (select-window other-win))))

;;;###autoload
(defun buf-move-right ()
"Swap the current buffer and the buffer on the right of the split.
If there is no split, ie now window on the right of the current
one, an error is signaled."
  (interactive)
  (let* ((other-win (windmove-find-other-window 'right))
	 (buf-this-buf (window-buffer (selected-window))))
    (if (null other-win)
        (error "No right split")
      ;; swap top with this one
      (set-window-buffer (selected-window) (window-buffer other-win))
      ;; move this one to top
      (set-window-buffer other-win buf-this-buf)
      (select-window other-win))))

(use-package centaur-tabs
  :ensure t
  :demand
  :config
  (centaur-tabs-mode t)
  :bind
  ("C-<tab>" . centaur-tabs-forward))

(use-package company
  :ensure t
  :defer 2
  :diminish
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

(use-package dired-open
  :ensure t
  :config
  (setq dired-open-extensions '(("gif" . "sxiv")
                                ("jpg" . "sxiv")
                                ("jpeg" . "sxiv")
                                ("png" . "sxiv")
                                ("png" . "sxiv")
                                ("mkv" . "mpv")
                                ("mp4" . "mpv"))))

(use-package peep-dired
  :after dired
  :hook (evil-normalize-keymaps . peep-dired-hook)
  :config
    (evil-define-key 'normal dired-mode-map (kbd "h") 'dired-up-directory)
    (evil-define-key 'normal dired-mode-map (kbd "l") 'dired-open-file) ; use dired-find-file instead if not using dired-open package
    (evil-define-key 'normal peep-dired-mode-map (kbd "j") 'peep-dired-next-file)
    (evil-define-key 'normal peep-dired-mode-map (kbd "k") 'peep-dired-prev-file)
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

(use-package eglot
  :ensure nil  ; Встроен в Emacs 29+
  :hook
  ((python-mode js-mode rust-mode dart-mode) . eglot-ensure)
  
  :config
(add-to-list 'eglot-server-programs
               '(rust-mode . ("rust-analyzer")))
 ;; Оптимизации для Rust
  (setq eglot-ignored-server-capabilities
        '(:documentFormattingProvider))
  (setq eglot-autoshutdown t
        eglot-send-changes-idle-time 0.5))

(use-package flycheck
  :ensure t
  :defer t
  :diminish
  :init (global-flycheck-mode))

(use-package flymake
  :ensure t
  :config
  (setq elisp-flymake-byte-compile-load-path load-path)
  :hook ((emacs-lisp-mode . flymake-mode)))

(setq font-size 140)
  (add-hook 'after-init-hook
  	  (lambda ()
  (set-face-attribute 'default nil
  		    :font "JetBrains Mono"
  		    :height font-size
  		    :weight 'medium)
  (set-face-attribute 'variable-pitch nil
  		    :font "Noto Sans"
  		    :height (+ font-size 1) 
  		    :weight 'medium)
  (set-face-attribute 'fixed-pitch nil
  		    :font "JetBrains Mono"
  		    :height font-size
  		    :weight 'medium)
  (set-face-attribute 'font-lock-comment-face nil
  		    :slant 'italic)
  (set-face-attribute 'font-lock-keyword-face nil
  		    :slant 'italic)

  (add-to-list 'initial-frame-alist '(font . "JetBrains Mono-11"))
  (add-to-list 'default-frame-alist '(font . "JetBrains Mono-11"))

  (setq-default line-spacing 0.12)
  (when (display-graphic-p)
    (redraw-display))
(message "Font settings applied")
(message "Current font: %s" (face-attribute 'default :font))
))

(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

(use-package format-all
  :ensure t
  :hook ((prog-mode . format-all-ensure-formatter)
         (before-save . format-all-buffer)))

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(global-display-line-numbers-mode 1)
(global-visual-line-mode t)

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

(use-package marginalia
  :ensure t
  :after ivy
  :config
  (setq marginalia-annotators
	'(marginalia-annotators-heavy marginalia-annotators-light nil))

;; Кастомизация отображения
  (setq marginalia-align 'right
	marginalia-field-width 100)
  (marginalia-mode 1))



(use-package toc-org
  :ensure t
  :commands toc-org-enable
  :init (add-hook 'org-mode-hook 'toc-org-enable))

(add-hook 'org-mode-hook 'org-indent-mode)
(use-package org-bullets :ensure t)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(electric-indent-mode -1)
(setq org-edit-src-content-indentation 0)

(require 'org-tempo)

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
(setq shell-file-name "/usr/bin/nu"
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

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-gruvbox t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (nerd-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-one") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

  (use-package doom-modeline
    :ensure t
    :init (doom-modeline-mode 1)
	:config
	(setq doom-modeline-height 30
	      doom-modeline-bar-width 5
	      doom-modeline-persp-name t
	      doom-modeline-persp-icon t))

(use-package tree-sitter
  :ensure t
  :init
  (global-tree-sitter-mode 1))

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
