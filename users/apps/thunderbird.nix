{ config, pkgs, ... }: {
  programs.thunderbird = {
    enable = true;

    #package = pkgs.betterbird;

    profiles = {
      "alex" = {
        isDefault = true;
      };
    };
  };
}
