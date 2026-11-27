{
  config,
  lib,
  ...
}:

let
  cfg = config.myConfig.binfmt;
in
{
  options.myConfig.binfmt = {
    enable = lib.mkEnableOption "multi-architecture binary format support";

    emulatedSystems = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "aarch64-linux" ];
      description = "Systems to run through binfmt emulation.";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.binfmt.emulatedSystems = cfg.emulatedSystems;
  };
}
