# emacs

Config for GNU Emacs 31 on macOS (`emacs-plus@31`).

- `init.el` — core settings and keybindings
- `plugins/` — completion (vertico, cape), project search (consult, embark, ripgrep), dev (eglot, formatting), text, appearance
- `themes/gruber-darker-theme.el` — [Gruber Darker](https://github.com/rexim/gruber-darker-theme) (MIT)
- `dictionaries/russian.txt` — word list for completion in text files
- `scripts/install-packages.py` — installs pinned package versions into `elpa/`

## Install

```sh
brew install d12frosted/emacs-plus/emacs-plus@31 ripgrep
pipx install basedpyright ruff   # optional: Python LSP and formatter
ln -sfn "$PWD" ~/.config/emacs
python3 scripts/install-packages.py /opt/homebrew/opt/emacs-plus@31/bin/emacs
```

Packages are installed only by the script, never at startup.
LSP servers start manually (`C-c e s`).
