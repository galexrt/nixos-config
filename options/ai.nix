{
  config,
  lib,
  ...
}:

let
  cfg = config.myConfig.ai;
in
{
  options.myConfig.ai = {
    enable = lib.mkEnableOption "local AI services";
  };

  config = lib.mkIf cfg.enable {
    services.ollama.enable = true;
  };
}
