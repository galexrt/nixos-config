{
  config,
  lib,
  ...
}:

let
  cfg = config.myConfig.vpnTools;
in
{
  options.myConfig.vpnTools = {
    enable = lib.mkEnableOption "Tailscale and Mullvad VPN tools";
  };

  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      extraUpFlags = [
        "--operator=atrost"
      ];
    };

    services.mullvad-vpn.enable = true;
  };
}
