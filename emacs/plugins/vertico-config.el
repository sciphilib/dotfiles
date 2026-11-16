;;; vertico-config.el -*- lexical-binding: t; -*-
(require 'vertico)
(require 'savehist)
(vertico-mode 1)
(savehist-mode 1)
(setq enable-recursive-minibuffers t
      minibuffer-prompt-properties '(read-only t cursor-intangible t face minibuffer-prompt))
(add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)
(provide 'vertico-config)
