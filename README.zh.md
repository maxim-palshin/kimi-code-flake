# kimi-code-flake

[English](README.md) | [Русский](README.ru.md) | [中文](README.zh.md)

用于 [Kimi Code](https://www.kimi.com/code) 的 Nix flake —— Moonshot AI 出品的 AI 编程智能体。

软件包：

- **`kimi-code`** —— CLI（`kimi`），来自 `code.kimi.com` 的官方二进制文件，已通过 patchelf 适配 Nix glibc。
- **`kimi-code-desktop`** —— 图形桌面客户端（Electron，AppImage → `appimageTools.wrapType2`）。仅支持 `x86_64-linux`（官方发布如此）。

## 使用方法

### 快速体验

```sh
nix run github:maxim-palshin/kimi-code-flake#kimi-code
nix run github:maxim-palshin/kimi-code-flake#kimi-code-desktop
```

### 安装到 profile

```sh
nix profile install github:maxim-palshin/kimi-code-flake
```

### 在 NixOS / home-manager 中作为 input（overlay）

```nix
# flake.nix
inputs.kimi-code.url = "github:maxim-palshin/kimi-code-flake";

# 配置
nixpkgs.overlays = [ inputs.kimi-code.overlays.default ];
environment.systemPackages = [ pkgs.kimi-code pkgs.kimi-code-desktop ];
# 或 home-manager：
home.packages = [ pkgs.kimi-code pkgs.kimi-code-desktop ];
```

## 更新版本

### CLI

1. `curl -s https://code.kimi.com/kimi-code/latest` → 获取新版本号。
2. `curl -s https://code.kimi.com/kimi-code/binaries/<VERSION>/manifest.json` → 获取校验和。
3. 更新 `pkgs/kimi-code.nix` 中的 `version` 和 `sha256`
   （hex → SRI：`nix-hash --type sha256 --to-sri "sha256:<HEX>"`）。

### Desktop

1. 下载 AppImage，在 `kimi-code.desktop` 中查看 `X-AppImage-Version` 的版本号。
2. 更新 `pkgs/kimi-code-desktop.nix` 中的 `version` 和 `sha256`
   （`sha256sum` → SRI，使用 `nix-hash --to-sri`）。

## 许可证

打包脚本采用 MIT 许可证。Kimi Code 二进制文件本身为专有软件，请参阅
[Kimi 条款](https://www.kimi.com/code)。
