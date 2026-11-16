;;; text-config.el -*- lexical-binding: t; -*-
(require 'cape)
(defcustom my-text-dictionary-files
  (list (expand-file-name "dictionaries/russian.txt" user-emacs-directory)
        ;; macOS equivalent of Ubuntu's /usr/share/dict/american-english.
        (if (eq system-type 'darwin) "/usr/share/dict/words"
          "/usr/share/dict/american-english"))
  "UTF-8 word lists, one word per line."
  :type '(repeat file) :group 'completion)
(defun my-text-setup ()
  "Configure only plain text, not Org or Markdown."
  (when (eq major-mode 'text-mode)
    (setq-local cape-dict-file my-text-dictionary-files
                cape-dict-limit nil
                completion-at-point-functions (list (cape-capf-super #'dabbrev-capf #'cape-dict)))
    (visual-line-mode 1)
    (auto-fill-mode -1)
    (electric-indent-local-mode -1)
    (eldoc-mode -1)
    (show-paren-local-mode -1)
    (display-line-numbers-mode -1)
    (completion-preview-mode 1)
    (use-local-map (copy-keymap (current-local-map)))
    (dolist (key '("C-c f" "C-c c" "C-c r" "C-c v" "C-c e s" "C-c e r" "C-c e a"))
      (local-set-key (kbd key) #'ignore))))
(add-hook 'text-mode-hook #'my-text-setup)
(provide 'text-config)
