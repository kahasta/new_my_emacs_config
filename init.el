;; Загружаем необходимые модули Org
(require 'org)
(require 'ob-tangle)


(defalias 'yes-or-no-p 'y-or-n-p) ; don't make us spell "yes" or "no"

(defconst my/config-dir "~/.my-emacs.d/")
(defvar auto-complete-mode nil)

(defun my/load-org-config ()
  "Безопасная загрузка конфигурации из Org-файла"
  (interactive)
  (cl-block my/load-org-config
    (let ((org-file (expand-file-name (concat my/config-dir "config.org")))
          (el-file (expand-file-name (concat my/config-dir "config.el"))))

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
	      (message "Org file exists: %s" (file-exists-p org-file))
	      (message "El file exists: %s, size: %d" 
                 (file-exists-p el-file) 
                 (or (file-attribute-size (file-attributes el-file)) 0))
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
	(message "Empty or missing elisp file: %s" el-file)))))



;; Вызываем нашу функцию
(my/load-org-config)


;; Process performance tuning

;; performance

;; https://emacs-lsp.github.io/lsp-mode/page/performance/
(setq gc-cons-threshold 100000000
      read-process-output-max (* 4 1024 1024)
      process-adaptive-read-buffering nil)

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



(setq custom-file (expand-file-name (concat my/config-dir "custom.el")))
(when (file-exists-p custom-file)
  (load custom-file))

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
(setq temporary-file-directory (expand-file-name (concat my/config-dir "backups/")))
(unless (file-exists-p temporary-file-directory)
  (make-directory temporary-file-directory t))

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,(concat temporary-file-directory ".") t)))
(setq auto-save-default t) ; Включаем автосейвы
(setq auto-save-timeout 60) ; Сохранять каждые 5 секунд
(setq auto-save-interval 300) ; Сохранять каждые 300 вводов
