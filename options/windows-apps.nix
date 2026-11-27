{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.myConfig.windowsApps;
in
{
  options.myConfig.windowsApps = {
    enable = lib.mkEnableOption "Windows compatibility applications";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.wineWow64Packages.stable
      (pkgs.bottles.override { removeWarningPopup = true; })
    ];
  };
}
