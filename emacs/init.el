;;; init.el --- Emacs configuration for macOS -*- lexical-binding: t; -*-
(require 'package)
(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)
;; Installation is explicit: scripts/install-packages.py, never at startup.
(setq package-selected-packages '(vertico cape consult embark embark-consult markdown-mode))
(add-to-list 'load-path (expand-file-name "plugins" user-emacs-directory))
(add-to-list 'custom-theme-load-path (expand-file-name "themes" user-emacs-directory))
(setq custom-file (expand-file-name "custom.el" user-emacs-directory)
      inhibit-startup-screen t
      gc-cons-threshold (* 16 1024 1024)
      ;; Let yabai fill the tile exactly, rather than rounding to character cells.
      frame-resize-pixelwise t
      window-resize-pixelwise t)
;; Finder-launched applications do not inherit the terminal's PATH.
(dolist (dir (reverse (list (expand-file-name "~/.local/bin")
                           "/opt/homebrew/bin" "/opt/homebrew/opt/llvm/bin"
                           "/usr/bin" "/bin" "/usr/sbin" "/sbin")))
  (when (file-directory-p dir)
    (setq exec-path (cons dir (delete dir exec-path)))
    (setenv "PATH" (mapconcat #'identity
                               (delete-dups (cons dir (split-string (or (getenv "PATH") "") path-separator t)))
                               path-separator))))
(dolist (mode '(menu-bar-mode tool-bar-mode scroll-bar-mode))
  (when (fboundp mode) (funcall mode -1)))
(load-theme 'gruber-darker t)
;; Use Command for M- bindings; Option retains native macOS character input.
(when (eq system-type 'darwin)
  (setq ns-command-modifier 'meta
        ns-alternate-modifier nil)
  ;; Like kitty's hide_window_decorations: no titlebar or traffic-light buttons.
  (add-to-list 'default-frame-alist '(undecorated . t))
  (dolist (frame (frame-list))
    (when (display-graphic-p frame)
      (modify-frame-parameters frame '((undecorated . t))))))
(setq-default indent-tabs-mode nil tab-width 4)
(setq display-line-numbers-type 'relative)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'prog-mode-hook #'eldoc-mode)
(add-hook 'prog-mode-hook #'show-paren-local-mode)
(let ((backup (expand-file-name "var/backups/" user-emacs-directory))
      (autosave (expand-file-name "var/auto-save/" user-emacs-directory)))
  (make-directory backup t)
  (make-directory autosave t)
  (setq backup-directory-alist `(("." . ,backup))
        auto-save-file-name-transforms `((".*" ,autosave t))
        auto-save-list-file-prefix (expand-file-name ".saves-" autosave)
        backup-by-copying t version-control t delete-old-versions t
        kept-new-versions 6 kept-old-versions 2
        make-backup-files t auto-save-default t))
(defun keys ()
  "Show active bindings with frequently used project commands first."
  (interactive)
  (describe-bindings)
  (with-current-buffer "*Help*"
    (let ((inhibit-read-only t))
      (goto-char (point-min))
      (insert (propertize "Часто используемые команды\n" 'face 'bold)
              "\nПоиск текста по репозиторию    C-c p g    (также C-x p g)\n"
              "Поиск файла по имени          C-c p f    (также C-x p f)\n"
              "\nC-u перед командой — выбрать другую директорию.\n"
              "В поиске текста: M-. — предпросмотр, C-c C-o — экспорт результатов.\n"
              "C-s — поиск слова под курсором; повторный C-s — следующее совпадение.\n"
              "C-x u — открыть kitty в каталоге текущего файла.\n"
              "\n")
      (insert (propertize "Все действующие сочетания клавиш\n\n" 'face 'bold))
      (goto-char (point-min)))))
(require 'isearch)
(defun my-isearch-forward-at-point (regexp)
  "Start incremental search with the symbol under point.
On whitespace start an empty search.  With a prefix, use ordinary regexp search."
  (interactive "P")
  (let ((word (and (not regexp)
                   (looking-at-p "\\(?:\\sw\\|\\s_\\)")
                   (thing-at-point 'symbol t))))
    (isearch-forward regexp t)
    (when word (isearch-yank-string word))))
(global-set-key (kbd "C-s") #'my-isearch-forward-at-point)
(global-set-key (kbd "C-x C-b") #'ibuffer)
(global-set-key (kbd "C-c a") #'beginning-of-buffer)
(global-set-key (kbd "C-c z") #'end-of-buffer)
(defun open-term-in-split-window ()
  "Open ansi-term below the current window."
  (interactive)
  (select-window (split-window-below))
  (ansi-term (or (getenv "SHELL") "/bin/zsh")))
(defun open-term-in-split-window-emacs ()
  "Open an Emacs shell below the current window."
  (interactive)
  (select-window (split-window-below))
  (shell))
(defun my-open-kitty ()
  "Open a separate kitty instance in the current file's directory."
  (interactive)
  (let ((directory (if buffer-file-name (file-name-directory buffer-file-name) default-directory)))
    (when (file-remote-p directory)
      (user-error "Kitty needs a local directory; use TRAMP's shell for remote files"))
    (make-process :name "open-kitty" :noquery t :buffer nil
                  :command (list "/usr/bin/open" "-n" "-a" "/Applications/kitty.app"
                                 "--args" "--directory" (expand-file-name directory)))))
(global-set-key (kbd "C-x u") #'my-open-kitty)
(global-set-key (kbd "C-x C-u") #'my-open-kitty)
(global-set-key (kbd "C-x C-y") #'open-term-in-split-window-emacs)
(require 'vertico-config)
(require 'dev-config)
(require 'completion-config)
(require 'text-config)
(require 'search-config)
(require 'appearance-config)
(load custom-file t)
;;; init.el ends here
