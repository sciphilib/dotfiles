# dotfiles

## kitty

```sh
ln -sfn "$PWD/kitty" ~/.config/kitty
```

- `kitty/kitty.conf` — основная конфигурация
- `kitty/rexim.conf` — активная цветовая тема
- `kitty/gruber-darker.conf` — альтернативная тема

## zsh

```sh
ln -sf "$PWD/zsh/zshrc" ~/.zshrc
```

Требует oh-my-zsh в `~/.config/.oh-my-zsh`; для подсветки вывода — `brew install grc`.
