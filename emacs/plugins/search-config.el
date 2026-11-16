;;; search-config.el --- Async project search -*- lexical-binding: t; -*-
(require 'consult)
(require 'embark)
(require 'embark-consult)
(require 'vertico-buffer)
(require 'vertico-multiform)
(require 'grep)
(setq consult-async-min-input 3
      consult-async-input-debounce 0.3
      consult-ripgrep-args
      "rg --null --line-buffered --color=never --max-columns=1000 --path-separator / --smart-case --no-heading --line-number -B3 -A3")
(consult-customize consult-ripgrep :preview-key "M-.")
(setq vertico-multiform-commands
      '((consult-ripgrep buffer (vertico-count . 25))
        (my-project-find-file buffer (vertico-count . 25))
        (my-project-matching-files buffer (vertico-count . 25))))
(setq vertico-buffer-display-action
      '(display-buffer-in-side-window (side . bottom) (window-height . 0.4)))
(vertico-multiform-mode 1)
(defun my-search-directory (prompt)
  "Select directory with prefix argument, otherwise use project root."
  (if current-prefix-arg (read-directory-name prompt (my-project-root))
    (my-project-root)))
(defun my-rg-file-builder (contents)
  "Return an argv builder; CONTENTS selects literal content rather than glob search."
  (lambda (input)
    (unless (string-empty-p input)
      (cons (if contents
                (list "rg" "--files-with-matches" "--fixed-strings" "--color=never" "--" input ".")
              (list "rg" "--files" "--glob" (concat "*" input "*") "."))
            (apply-partially #'consult--highlight-literals (list input) t)))))
(defun my-project-find-file ()
  "Asynchronously find project files by glob, without enumerating project-files."
  (interactive)
  (let ((default-directory (my-search-directory "Find in directory: ")))
    (find-file (consult--find "Find file (glob): " (my-rg-file-builder nil) nil))))
(defun my-project-matching-files ()
  "List each file containing literal text once."
  (interactive)
  (let ((default-directory (my-search-directory "Search directory: ")))
    (find-file (consult--find "Files containing: " (my-rg-file-builder t) nil))))
(defun my-project-search-context (text context)
  "Search literal TEXT with CONTEXT lines in a persistent Grep buffer."
  (interactive (list (read-string "Literal text: " (thing-at-point 'symbol t))
                     (if current-prefix-arg (read-number "Context lines: " 3) 3)))
  (unless (and (integerp context) (>= context 0)) (user-error "Invalid context"))
  (let ((default-directory (my-project-root)))
    (grep (mapconcat #'shell-quote-argument
                     (list "rg" "--no-heading" "--line-number" "--color=never"
                           "--fixed-strings" "--context" (number-to-string context)
                           "--" text ".") " "))))
(define-key my-project-map (kbd "g") #'consult-ripgrep)
(define-key my-project-map (kbd "f") #'my-project-find-file)
(define-key my-project-map (kbd "l") #'my-project-matching-files)
(define-key my-project-map (kbd "G") #'my-project-search-context)
(global-set-key (kbd "C-.") #'embark-act)
(define-key minibuffer-local-map (kbd "C-c C-o") #'embark-export)
(add-hook 'embark-collect-mode-hook #'consult-preview-at-point-mode)
(provide 'search-config)
