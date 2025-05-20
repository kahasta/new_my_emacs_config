(use-package all-the-icons
  :ensure t
  :config
  (unless (member "all-the-icons" (font-family-list))
    (all-the-icons-install-fonts t)))



(use-package centaur-tabs
  :ensure t
  :demand t
  :init
  (setq centaur-tabs-set-icons t
        centaur-tabs-gray-out-icons 'buffer
        centaur-tabs-set-bar 'left
        centaur-tabs-set-modified-marker t
        centaur-tabs-close-button "✕"
        centaur-tabs-modified-marker "•"
        centaur-tabs-icon-type 'nerd-icons
        ;; Scrolling (with the mouse wheel) past the end of the tab list
        ;; replaces the tab list with that of another Doom workspace. This
        ;; prevents that.
        centaur-tabs-cycle-scope 'tabs)
  (if (daemonp)
      (add-hook 'after-make-frame-functions
		(lambda (_frame)
                  (with-selected-frame _frame
                    (centaur-tabs-mode 1))))
    (add-hook 'emacs-startup-hook #'centaur-tabs-mode))

  :config
  (defun my-tabs-buffer-list ()
    "Возвращает список буферов, которые следует отображать во вкладках."
    (seq-filter
     (lambda (b)
       (or (eq (current-buffer) b)
           (buffer-file-name b)
           (buffer-live-p b)))
     (if (bound-and-true-p persp-mode)
	 (persp-get-buffer-names)
       (buffer-list))))
  (setq centaur-tabs-buffer-list-function #'my-tabs-buffer-list)
  (defun my-disable-centaur-tabs-maybe ()
    "Отключить `centaur-tabs-mode` в текущем буфере, если оно включено."
    (when (bound-and-true-p centaur-tabs-mode)
      (centaur-tabs-local-mode)))

  (add-hook 'dashboard-mode-hook #'my-disable-centaur-tabs-maybe)
  (add-hook 'help-mode-hook #'my-disable-centaur-tabs-maybe)
  (add-hook 'completion-list-mode-hook #'my-disable-centaur-tabs-maybe)
  :bind
  (("C-<tab>" . #'centaur-tabs-forward-tab)
   (:map evil-normal-state-map
         ("gt" . centaur-tabs-forward)
         ("gT" . centaur-tabs-backward))))

(provide 'centaur-tabs-mod)
