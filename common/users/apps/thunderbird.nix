{ config, pkgs, ... }: {
  programs.thunderbird = {
    enable = true;
    profiles = {
      "alex" = {
        isDefault = true;
      };
    };
  };
}
