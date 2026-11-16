# dotfiles

## kitty

```sh
ln -sfn "$PWD/kitty" ~/.config/kitty
```

- `kitty/kitty.conf` — main config
- `kitty/rexim.conf` — active color theme
- `kitty/gruber-darker.conf` — alternative theme

## zsh

```sh
ln -sf "$PWD/zsh/zshrc" ~/.zshrc
```

Requires oh-my-zsh in `~/.config/.oh-my-zsh`; `brew install grc` for colored command output.

## emacs

See [`emacs/README.md`](emacs/README.md).
