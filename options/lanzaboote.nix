{
  config,
  lib,
  ...
}:

let
  cfg = config.myConfig.lanzaboote;
in
{
  options.myConfig.lanzaboote = {
    enable = lib.mkEnableOption "Lanzaboote";
  };

  config = lib.mkIf cfg.enable {
    # Lanzaboote replaces the systemd-boot module.
    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.loader.efi.canTouchEfiVariables = true;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";

      autoEnrollKeys = {
        enable = true;
        autoReboot = true;
      };
    };
  };
}
