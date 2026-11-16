;;; appearance-config.el --- Quiet whitespace and Markdown highlighting -*- lexical-binding: t; -*-
(require 'whitespace)
(require 'markdown-mode)

(defun my-subtle-whitespace ()
  "Show spaces and tabs without background shading or newline marks."
  (setq-local whitespace-style '(face tabs spaces space-mark tab-mark)
              whitespace-space-regexp "\\( +\\)"
              whitespace-display-mappings '((space-mark 32 [183] [46])
                                             (tab-mark 9 [8250 9] [62 9])))
  (whitespace-mode 1))
(set-face-attribute 'whitespace-space nil :foreground "#454545" :background 'unspecified)
(set-face-attribute 'whitespace-tab nil :foreground "#454545" :background 'unspecified)
(add-hook 'prog-mode-hook #'my-subtle-whitespace)
(add-hook 'text-mode-hook #'my-subtle-whitespace)

;; Plain source with font-lock, not a rendered/variable-pitch Markdown UI.
(setq markdown-fontify-code-blocks-natively t
      markdown-header-scaling nil
      markdown-hide-markup nil)
(add-to-list 'auto-mode-alist '("\\.\\(?:md\\|markdown\\)\\'" . markdown-mode))
(provide 'appearance-config)
