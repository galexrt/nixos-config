{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.myConfig.printing;
  hplipWithDeskjet1510ScanFix = pkgs.hplipWithPlugin.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ../patches/hplip-3.26.6-http-buffer-fix.patch
    ];
  });
in
{
  options.myConfig.printing = {
    enable = lib.mkEnableOption "printing and scanning support";
  };

  config = lib.mkIf cfg.enable {
    hardware.sane = {
      enable = true;
      extraBackends = [ hplipWithDeskjet1510ScanFix ];
    };

    services = {
      printing = {
        enable = true;
        drivers = [ hplipWithDeskjet1510ScanFix ];
      };
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    };
  };
}
