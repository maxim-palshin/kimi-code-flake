{
  lib,
  stdenv,
  fetchurl,
  glibc,
  patchelf,
}:

let
  version = "2.4.1";

  # Checksums from https://code.kimi.com/kimi-code/binaries/<version>/manifest.json
  platformMap = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "sha256-8rNjTBe2BOWw8MV4tqeH/QG8r7QKPA3WIgOuFP8uoGg=";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "sha256-MrLb5n5KYQvrGbi1z0RHOzEdLVpZH6GBzM5lg2yKHvU=";
    };
  };

  platformInfo = platformMap.${stdenv.hostPlatform.system} or (throw "kimi-code: unsupported system ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "kimi-code";
  inherit version;

  src = fetchurl {
    url = "https://code.kimi.com/kimi-code/binaries/${version}/kimi-code-${platformInfo.platform}";
    inherit (platformInfo) sha256;
  };

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isLinux patchelf;

  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;
  # Do NOT strip — the binary is a Node.js Single Executable Application
  # whose bundled JS lives in custom ELF sections; stripping segfaults it.
  dontStrip = true;

  installPhase =
    ''
      runHook preInstall

      install -Dm755 "$src" "$out/bin/kimi"
      chmod u+w "$out/bin/kimi"
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      # Point the ELF interpreter and rpath at the Nix glibc/libstdc++.
      # Fail loudly instead of shipping a binary that cannot exec.
      if [ ! -x "${stdenv.cc.bintools.dynamicLinker}" ]; then
        echo "kimi-code: dynamic linker not found at ${stdenv.cc.bintools.dynamicLinker}" >&2
        exit 1
      fi

      # NOTE: two separate patchelf calls, rpath BEFORE interpreter.
      # This binary is a Node.js Single Executable Application with a
      # postject-injected blob; a single combined patchelf call (or
      # interpreter-before-rpath) corrupts the ELF layout and segfaults
      # at startup with patchelf 0.19. Verified experimentally.
      ${lib.getExe patchelf} --set-rpath "${lib.makeLibraryPath [
        stdenv.cc.cc.lib # libstdc++.so.6, libgcc_s.so.1
        glibc # libc.so.6, ...
      ]}" "$out/bin/kimi"

      ${lib.getExe patchelf} --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" "$out/bin/kimi"
    ''
    + ''
      runHook postInstall
    '';

  meta = {
    description = "Kimi Code — AI coding agent CLI by Moonshot AI";
    homepage = "https://www.kimi.com/code";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "kimi";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
