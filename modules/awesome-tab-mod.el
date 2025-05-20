(progn
  (defun awesome-tab-hide-tab (x)
    "Скрыть буферы, имя которых начинается и заканчивается на *."
    (let ((name (format "%s" x)))
      (and (string-prefix-p "*" name)
           (string-suffix-p "*" name)
	   (not (member name '("*scratch*"))))))

  (use-package awesome-tab
    :load-path "~/.my-emacs.d/awesome-tab"
    :ensure t
    :config
    (awesome-tab-mode t)
    :custom
    (setq awesome-tab-style "bar") ;; или 'wave, 'box и т.д.
    (setq awesome-tab-display-sticky-function-name nil)
    (setq awesome-tab-buffer-groups-function 'awesome-tab-buffer-groups-by-projectile)
    :init
    (setq awesome-tab-hide-tab-function 'awesome-tab-hide-tab)
    :bind
    (:map evil-normal-state-map
          ("gt" . awesome-tab-forward)
          ("gT" . awesome-tab-backward)))
  (message "Awesome-tab initializing complete.")
  )

(provide 'awesome-tab-mod)
