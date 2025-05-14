;; Загружаем необходимые модули Org
(require 'org)
(require 'ob-tangle)



(defconst my/config-dir "~/.my-emacs.d/")
(defvar auto-complete-mode nil)

(defun my/load-org-config ()
  "Безопасная загрузка конфигурации из Org-файла"
  (interactive)
  (let ((org-file (expand-file-name "~/.my-emacs.d/config.org"))
        (el-file (expand-file-name "~/.my-emacs.d/config.el")))

    ;; Проверяем существование исходного файла
    (unless (file-exists-p org-file)
      (message "Org config file not found: %s" org-file)
      (cl-return-from my/load-org-config))

    ;; Танглим только если нужно
    (when (or (not (file-exists-p el-file))
              (file-newer-than-file-p org-file el-file))
      (condition-case err
          (progn
            (message "Tangling org file...")
            (org-babel-tangle-file org-file el-file)
            (message "Successfully tangled: %s" el-file))
        (error
         (message "Failed to tangle org file: %s" err)
         (when (file-exists-p el-file)
           (delete-file el-file))
         (cl-return-from my/load-org-config))))

    ;; Проверяем и загружаем сгенерированный файл
    (if (and (file-exists-p el-file)
             (> (file-attribute-size (file-attributes el-file)) 0))
        (condition-case err
            (progn
              (load-file el-file)
              (message "Successfully loaded: %s" el-file))
          (error
           (message "Error loading %s: %s" el-file err)
           (delete-file el-file)))
      (message "Empty or missing elisp file: %s" el-file))))


;; Process performance tuning

(setq read-process-output-max (* 4 1024 1024))
(setq process-adaptive-read-buffering nil)
;; performance

;; https://emacs-lsp.github.io/lsp-mode/page/performance/
(setq gc-cons-threshold 100000000
      read-process-output-max (* 1024 1024))

;; https://www.masteringemacs.org/article/speed-up-emacs-libjansson-native-elisp-compilation
(if (and (fboundp 'native-comp-available-p)
         (native-comp-available-p))
    (setq comp-deferred-compilation t
          package-native-compile t)
  (message "Native complation is *not* available, lsp performance will suffer..."))

(unless (functionp 'json-serialize)
  (message "Native JSON is *not* available, lsp performance will suffer..."))

;; do not steal focus while doing async compilations
(setq warning-suppress-types '((comp)))


;; options
(setq-default
 frame-resize-pixelwise t ;; лучше поддерживать" определенные "оконные менеджеры", такие как "Ratpoison".
 fill-column 80 ; python friendly, almost. HAHAHA
 ;; better security
 gnutls-verify-error t
 gnutls-min-prime-bits 2048

 ;; dont expire a passphrase
 password-cache-expiry nil

 save-interprogram-paste-before-kill t ;; Сохраняет текст, скопированный из других программ, в kill-ring перед удалением (kill), чтобы его можно было восстановить.
 apropos-do-all t ;; Расширяет поиск в командах apropos (например, M-x apropos), включая все переменные, функции и символы, даже неинтерактивные.
 require-final-newline t ;; Автоматически добавляет новую строку в конец файла при сохранении, если её нет.
 vc-follow-symlinks t ;; Автоматически открывает файлы, на которые указывают символические ссылки, без запроса подтверждения.
 )

;; Указывает, что все резервные копии файлов (например, file~) будут сохраняться в директории, заданной temporary-file-directory(обычно/tmp/` или эквивалент), вместо текущей папки файла.
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(defalias 'yes-or-no-p 'y-or-n-p) ; don't make us spell "yes" or "no"


;; Вызываем нашу функцию
(my/load-org-config)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(tango-dark))
 '(package-selected-packages
   '(ace-window dash diff-hl emojify evil expand-region flycheck forge
		magit marginalia posframe projectile rust-mode toc-org
		treemacs ultra-scroll xclip))
 '(package-vc-selected-packages
   '((ultra-scroll :url "https://github.com/jdtsmith/ultra-scroll")))
 '(safe-local-variable-values '((eval setq elisp-flymake-byte-compile t))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'dired-find-alternate-file 'disabled nil)
