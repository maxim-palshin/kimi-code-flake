# kimi-code-flake

Nix flake для [Kimi Code](https://www.kimi.com/code) — AI-агента для разработки от Moonshot AI.

Пакеты:

- **`kimi-code`** — CLI (`kimi`), официальный бинарник с `code.kimi.com`, patchelf под Nix glibc.
- **`kimi-code-desktop`** — графический десктоп-клиент (Electron, AppImage → `appimageTools.wrapType2`). Только `x86_64-linux` (так устроен официальный релиз).

## Использование

### Попробовать

```sh
nix run github:<you>/kimi-code-flake#kimi-code
nix run github:<you>/kimi-code-flake#kimi-code-desktop
```

### В профиль

```sh
nix profile install github:<you>/kimi-code-flake
```

### Как input в NixOS / home-manager (overlay)

```nix
# flake.nix
inputs.kimi-code.url = "github:<you>/kimi-code-flake";

# конфигурация
nixpkgs.overlays = [ inputs.kimi-code.overlays.default ];
environment.systemPackages = [ pkgs.kimi-code pkgs.kimi-code-desktop ];
# или home-manager:
home.packages = [ pkgs.kimi-code pkgs.kimi-code-desktop ];
```

## Обновление версий

### CLI

1. `curl -s https://code.kimi.com/kimi-code/latest` → новая версия.
2. `curl -s https://code.kimi.com/kimi-code/binaries/<VERSION>/manifest.json` → чексуммы.
3. Обновить `version` и `sha256` в `pkgs/kimi-code.nix`
   (hex → SRI: `nix-hash --type sha256 --to-sri "sha256:<HEX>"`).

### Desktop

1. Скачать AppImage, посмотреть версию в `X-AppImage-Version` внутри `kimi-code.desktop`.
2. Обновить `version` и `sha256` в `pkgs/kimi-code-desktop.nix`
   (`sha256sum` → SRI через `nix-hash --to-sri`).

## Лицензия

Пакетные скрипты — MIT. Сами бинарники Kimi Code — проприетарные, см.
[условия Kimi](https://www.kimi.com/code).
