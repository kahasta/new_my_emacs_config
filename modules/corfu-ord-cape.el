;;; package --- corfu orderless cape module
;;; Commentary:

;;; Autocompletion: Corfu + Orderless + Cape
(progn
  ;; Example configuration for Consult
  (use-package consult
    :ensure t
    ;; Replace bindings. Lazily loaded by `use-package'.
    :bind (;; C-c bindings in `mode-specific-map'
           ("C-c M-x" . consult-mode-command)
           ("C-c h" . consult-history)
           ("C-c k" . consult-kmacro)
           ("C-c m" . consult-man)
           ("C-c i" . consult-info)
           ([remap Info-search] . consult-info)
           ;; C-x bindings in `ctl-x-map'
           ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
           ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
           ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
           ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
           ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
           ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
           ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
           ;; Custom M-# bindings for fast register access
           ("M-#" . consult-register-load)
           ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
           ("C-M-#" . consult-register)
           ;; Other custom bindings
           ("M-y" . consult-yank-pop)                ;; orig. yank-pop
           ;; M-g bindings in `goto-map'
           ("M-g e" . consult-compile-error)
           ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
           ("M-g g" . consult-goto-line)             ;; orig. goto-line
           ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
           ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
           ("M-g m" . consult-mark)
           ("M-g k" . consult-global-mark)
           ("M-g i" . consult-imenu)
           ("M-g I" . consult-imenu-multi)
           ;; M-s bindings in `search-map'
           ("M-s d" . consult-find)                  ;; Alternative: consult-fd
           ("M-s c" . consult-locate)
           ("M-s g" . consult-grep)
           ("M-s G" . consult-git-grep)
           ("M-s r" . consult-ripgrep)
           ("M-s l" . consult-line)
           ("M-s L" . consult-line-multi)
           ("M-s k" . consult-keep-lines)
           ("M-s u" . consult-focus-lines)
           ;; Isearch integration
           ("M-s e" . consult-isearch-history)
           :map isearch-mode-map
           ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
           ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
           ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
           ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
           ;; Minibuffer history
           :map minibuffer-local-map
           ("M-s" . consult-history)                 ;; orig. next-matching-history-element
           ("M-r" . consult-history))                ;; orig. previous-matching-history-element

    ;; Enable automatic preview at point in the *Completions* buffer. This is
    ;; relevant when you use the default completion UI.
    :hook (completion-list-mode . consult-preview-at-point-mode)

    ;; The :init configuration is always executed (Not lazy)
    :init

    ;; Tweak the register preview for `consult-register-load',
    ;; `consult-register-store' and the built-in commands.  This improves the
    ;; register formatting, adds thin separator lines, register sorting and hides
    ;; the window mode line.
    (advice-add #'register-preview :override #'consult-register-window)
    (setq register-preview-delay 0.5)

    ;; Use Consult to select xref locations with preview
    (setq xref-show-xrefs-function #'consult-xref
          xref-show-definitions-function #'consult-xref)

    ;; Configure other variables and modes in the :config section,
    ;; after lazily loading the package.
    :config

    ;; Optionally configure preview. The default value
    ;; is 'any, such that any key triggers the preview.
    ;; (setq consult-preview-key 'any)
    ;; (setq consult-preview-key "M-.")
    ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
    ;; For some commands and buffer sources it is useful to configure the
    ;; :preview-key on a per-command basis using the `consult-customize' macro.
    (consult-customize
     consult-theme :preview-key '(:debounce 0.2 any)
     consult-ripgrep consult-git-grep consult-grep consult-man
     consult-bookmark consult-recent-file consult-xref
     consult--source-bookmark consult--source-file-register
     consult--source-recent-file consult--source-project-recent-file
     ;; :preview-key "M-."
     :preview-key '(:debounce 0.4 any))

    ;; Optionally configure the narrowing key.
    ;; Both < and C-+ work reasonably well.
    (setq consult-narrow-key "<") ;; "C-+"

    ;; Optionally make narrowing help available in the minibuffer.
    ;; You may want to use `embark-prefix-help-command' or which-key instead.
    ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
    )

  (use-package orderless
    :ensure t
    :custom
    (completion-styles '(orderless basic))
    (completion-category-defaults nil)
    :init
    (setq orderless-matching-styles '(orderless-literal orderless-regexp orderless-flex)))

  (use-package corfu
    :ensure t
    :init
    (global-corfu-mode)
    (corfu-popupinfo-mode)
    :custom
    (corfu-history-mode t)
    (corfu-auto t)
    (corfu-cycle t)
    (corfu-preview-current nil)
    (corfu-max-width 80)
    (corfu-auto-delay 0.2)
    (corfu-auto-prefix 1)
    :config
    (savehist-mode 1) ; Ensure history is saved
    (add-to-list 'savehist-additional-variables 'corfu-history)
    :bind
    (:map corfu-map
          ("TAB" . corfu-next)
          ([tab] . corfu-next)
          ("S-TAB" . corfu-previous)
          ([backtab] . corfu-previous)))

  (use-package cape
    :ensure t
    :init
    ;; (defun my/safe-add-capf (func)
    ;;   (when (fboundp func)
    ;;     (add-to-list 'completion-at-point-functions func)))
    ;; (defun my/setup-cape ()
    ;;   (my/safe-add-capf #'cape-file)
    ;;   (when (derived-mode-p 'emacs-lisp-mode)
    ;;     (my/safe-add-capf #'cape-elisp-symbol))
    ;;   (when (derived-mode-p 'text-mode)
    ;;     (my/safe-add-capf #'cape-ispell))
    ;;   (when (bound-and-true-p eglot--managed-mode)
    ;;     (my/safe-add-capf #'cape-capf-buster)))
    ;; (add-hook 'prog-mode-hook #'my/setup-cape)
    ;; (add-hook 'text-mode-hook #'my/setup-cape)
    ;; ;; Добавляем полезные источники
    (add-to-list 'completion-at-point-functions #'cape-file)
    (add-to-list 'completion-at-point-functions #'cape-dabbrev)
    (add-to-list 'completion-at-point-functions #'cape-symbol)
    (add-to-list 'completion-at-point-functions #'cape-keyword)
    (add-hook 'text-mode-hook
              (lambda () (add-to-list 'completion-at-point-functions #'cape-ispell))
     	      ;; Примеры: cape-keyword, cape-line, cape-tex и др.
	      ))

  (use-package kind-icon
    :ensure t
    :after corfu
    :custom
    (kind-icon-default-face 'corfu-default) ; чтобы подстраивался под тему
    (kind-icon-blend-background nil) ; Avoid background mismatch
    (kind-icon-use-icons t) ; Use icons instead of text
    :config
    (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

  (add-to-list 'completion-at-point-functions #'cape-lsp)
  (setq auto-complete-mode #'corfu-mode)

  (message "Corfu initializing complete.")
  )


(provide 'corfu-ord-cape)
