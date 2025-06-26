{ config, pkgs, ... }: {
  programs.librewolf = {
    enable = true;
    settings = {
      # Enable WebGL
      "webgl.disabled" = false;
      "privacy.resistFingerprinting" = false;

      # Preserve browsing and download history
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.downloads" = false;

      # Enable Autoscroll
      "middlemouse.paste" = false;
      "general.autoScroll" = true;
    };
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;

    profiles = {
      alex = {
        id = 0;
        name = "Default";
        isDefault = true;
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          #bitwarden
          #darkreader
          #enhancer-for-youtube
          #floccus
          #grammarly
          #onepassword-password-manager
          #refined-github
          #steam-database
          #ublock-origin
          #vue-js-devtools
        ];
        settings = {
          "browser.aboutConfig.showWarning" = false;

          # Disable all sorts of telemetry
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.ping-centre.telemetry" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.hybridContent.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          # As well as Firefox 'experiments'
          "experiments.activeExperiment" = false;
          "experiments.enabled" = false;
          "experiments.supported" = false;
          "network.allow-experiments" = false;
          # Disable Pocket Integration
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
          "extensions.pocket.enabled" = false;
          "extensions.pocket.api" = "";
          "extensions.pocket.oAuthConsumerKey" = "";
          "extensions.pocket.showHome" = false;
          "extensions.pocket.site" = "";
          # Disable password save dialog
          "signon.rememberSignons" = false;
        };

        userChrome = ''
          #webrtcIndicator {
            display: none;
          }
        '';
      };
    };
  };
}
