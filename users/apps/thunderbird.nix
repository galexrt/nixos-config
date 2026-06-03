{ config, pkgs, ... }:
{
  programs.thunderbird = {
    enable = true;

    #package = pkgs.betterbird;

    profiles = {
      alex = {
        isDefault = true;

        extensions = with pkgs.nur.repos.rycee.thunderbird-addons; [
          send-later
          dictionary-german
          pkgs.nur.repos.rycee.firefox-addons.pywalfox
        ];

        settings = {
          "mail.uidensity" = 0;
          "mail.uifontsize" = 12;

          "calendar.dialogs.new.enabled" = true;

          "mail.spam.manualMark" = true;

          # Auto enable extensions
          "extensions.autoDisableScopes" = 0;
        };
      };
    };
  };
}
