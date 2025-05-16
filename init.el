;; Загружаем необходимые модули Org
(require 'org)
(require 'ob-tangle)



(defconst my/config-dir "~/.my-emacs.d/")

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
		treemacs xclip)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'dired-find-alternate-file 'disabled nil)
