{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.myConfig.gaming;
in
{
  options.myConfig.gaming = {
    enable = lib.mkEnableOption "gaming support";
  };

  config = lib.mkIf cfg.enable {
    hardware = {
      graphics.enable32Bit = true;
      steam-hardware.enable = true;
    };

    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
      };
      gamemode = {
        enable = true;
        enableRenice = false;
      };
      nix-ld.libraries = lib.mkAfter (pkgs.steam-run.args.multiPkgs pkgs);
    };
  };
}
