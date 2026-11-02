{
  lib,
  fetchurl,
  appimageTools,
}:

let
  pname = "kimi-code-desktop";
  version = "1.2.1";

  src = fetchurl {
    url = "https://code.kimi.com/kimi-code/desktop/download/KimiCode-linux-x86_64.AppImage";
    sha256 = "sha256-cAlg0o91X7h1qONt4eBBZ6avPhN5B1bjyznW3ajeios=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/kimi-code.desktop $out/share/applications/kimi-code.desktop
    install -Dm444 ${appimageContents}/usr/share/icons/hicolor/512x512/apps/kimi-code.png \
      $out/share/icons/hicolor/512x512/apps/kimi-code.png

    substituteInPlace $out/share/applications/kimi-code.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = {
    description = "Kimi Code Desktop — graphical client for Kimi Code (Moonshot AI)";
    homepage = "https://www.kimi.com/code";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "kimi-code-desktop";
    platforms = [ "x86_64-linux" ];
  };
}
