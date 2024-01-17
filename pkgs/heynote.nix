{ lib, appimageTools, fetchurl, makeDesktopItem, ... }:

let
  pname = "heynote";
  sha256 = "287cdfa03976301c38e7837a078a7f0f352e35054ce9318a217c854764de3c55";
  version = "1.6.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/heyman/heynote/releases/download/v${version}/Heynote_${version}_x86_64.AppImage";
    inherit sha256;
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };

  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = pname;
    comment = "A dedicated scratchpad for developers";
    exec = pname;
    icon = "heynote";
    categories = [ "Misc" ];
  };
in
appimageTools.wrapType2 rec {
  inherit name src;

  multiArch = false;

  extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;

  extraInstallCommands =
      let appimageContents = appimageTools.extractType2 { inherit name src; }; in
      ''
        mv $out/bin/{${name},${pname}}
        install -Dm444 ${appimageContents}/heynote.desktop -t $out/share/applications
        substituteInPlace $out/share/applications/heynote.desktop \
          --replace 'Exec=AppRun --no-sandbox' 'Exec=${pname}'
        install -m 444 -D ${appimageContents}/heynote.png \
          $out/share/icons/hicolor/512x512/apps/heynote.png
      '';

  meta = with lib; {
    description = "A dedicated scratchpad for developers";
    longDescription = ''
      Heynote is a dedicated scratchpad for developers. It functions as a large persistent text buffer where you can write down anything you like. Works great for that Slack message you don't want to accidentally send, a JSON response from an API you're working with, notes from a meeting, your daily to-do list, etc.
    '';
    homepage = "https://www.heynote.com/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ galexrt ];
  };
}
