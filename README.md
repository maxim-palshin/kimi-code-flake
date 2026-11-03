# kimi-code-flake

[English](README.md) | [Русский](README.ru.md) | [中文](README.zh.md)

Nix flake for [Kimi Code](https://www.kimi.com/code) — an AI coding agent by Moonshot AI.

Packages:

- **`kimi-code`** — the CLI (`kimi`), the official binary from `code.kimi.com`, patched with patchelf for Nix glibc.
- **`kimi-code-desktop`** — the graphical desktop client (Electron, AppImage → `appimageTools.wrapType2`). `x86_64-linux` only (as are the official releases).

## Usage

### Try it out

```sh
nix run github:maxim-palshin/kimi-code-flake#kimi-code
nix run github:maxim-palshin/kimi-code-flake#kimi-code-desktop
```

### Install into a profile

```sh
nix profile install github:maxim-palshin/kimi-code-flake
```

### As an input in NixOS / home-manager (overlay)

```nix
# flake.nix
inputs.kimi-code.url = "github:maxim-palshin/kimi-code-flake";

# configuration
nixpkgs.overlays = [ inputs.kimi-code.overlays.default ];
environment.systemPackages = [ pkgs.kimi-code pkgs.kimi-code-desktop ];
# or home-manager:
home.packages = [ pkgs.kimi-code pkgs.kimi-code-desktop ];
```

## Updating versions

### CLI

1. `curl -s https://code.kimi.com/kimi-code/latest` → new version.
2. `curl -s https://code.kimi.com/kimi-code/binaries/<VERSION>/manifest.json` → checksums.
3. Update `version` and `sha256` in `pkgs/kimi-code.nix`
   (hex → SRI: `nix-hash --type sha256 --to-sri "sha256:<HEX>"`).

### Desktop

1. Download the AppImage and check the version in `X-AppImage-Version` inside `kimi-code.desktop`.
2. Update `version` and `sha256` in `pkgs/kimi-code-desktop.nix`
   (`sha256sum` → SRI via `nix-hash --to-sri`).

## License

The packaging scripts are MIT. The Kimi Code binaries themselves are proprietary — see the
[Kimi terms](https://www.kimi.com/code).
