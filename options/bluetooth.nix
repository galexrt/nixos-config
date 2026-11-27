{
  config,
  lib,
  ...
}:

let
  cfg = config.myConfig.bluetooth;
in
{
  options.myConfig.bluetooth = {
    enable = lib.mkEnableOption "Bluetooth support";
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      settings.General.Enable = "Source,Sink,Media,Socket";
    };

    services.blueman.enable = true;
  };
}
