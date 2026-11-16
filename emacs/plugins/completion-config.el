;;; completion-config.el -*- lexical-binding: t; -*-
(require 'dabbrev)
(require 'completion-preview)
(setq tab-always-indent 'complete
      completion-preview-minimum-symbol-length 3
      completion-preview-idle-delay 0.2)
(defun my-code-completion-setup ()
  "Keep buffer-word completion after language/Eglot completion."
  (when (derived-mode-p 'prog-mode)
    (setq-local completion-at-point-functions
                (append (remq #'dabbrev-capf completion-at-point-functions)
                        (list #'dabbrev-capf)))
    (completion-preview-mode 1)))
(add-hook 'prog-mode-hook #'my-code-completion-setup)
(add-hook 'eglot-managed-mode-hook #'my-code-completion-setup)
(keymap-set completion-preview-active-mode-map "M-n" #'completion-preview-next-candidate)
(keymap-set completion-preview-active-mode-map "M-p" #'completion-preview-prev-candidate)
(provide 'completion-config)
