{ lib, appimageTools, fetchurl, makeDesktopItem, ... }:

let
  pname = "Beeper";
  sha256 = "464c2246b47099b823b9757494cfa441d34569c5dca89fcf7fa5d7521ef69a65";
  version = "3.75.16";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://download.beeper.com/linux/appImage/x64";
    inherit sha256;
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };

  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = pname;
    comment = "A single app to chat on iMessage, WhatsApp, and 13 other chat networks. You can search, snooze, or archive messages. And with a unified inbox, you'll never miss a message again.";
    exec = pname;
    icon = "beeper";
    categories = [ "Chat" ];
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
        install -Dm444 ${appimageContents}/beeper.desktop -t $out/share/applications
        substituteInPlace $out/share/applications/beeper.desktop \
          --replace 'Exec=AppRun --no-sandbox' 'Exec=${pname}'
        install -m 444 -D ${appimageContents}/beeper.png \
          $out/share/icons/hicolor/512x512/apps/beeper.png
      '';

  meta = with lib; {
    description = "All your chats in one app. Yes, really.";
    longDescription = ''
      A single app to chat on iMessage, WhatsApp, and 13 other chat networks. You can search, snooze, or archive messages.
      And with a unified inbox, you'll never miss a message again.
    '';
    homepage = "https://www.beeper.com/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ galexrt ];
  };
}
