{ pkgs, ... }:
{
  programs.librewolf = {
    enable = true;

    settings = {
      # Enable WebGL
      "webgl.disabled" = false;
      "librewolf.webgl.prompt" = true;
      "privacy.resistFingerprinting" = false;

      # Preserve browsing and download history
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.downloads" = false;

      # Enable Autoscroll
      "middlemouse.paste" = false;
      "general.autoScroll" = true;

      # Enable the widevine and the openh264 plugins
      "media.gmp-provider.enabled" = true;
      "media.gmp-gmpopenh264.enabled" = true;
      "media.webrtc.simulcast.vp9.enabled" = true;
    };

    profiles = {
      alex = {
        id = 0;
        name = "Default";
        isDefault = true;

        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ctrl-number-to-switch-tabs
          darkreader
          pywalfox
          dictionary-german

          bitwarden
          passbolt

          enhancer-for-youtube
          enhancer-for-nebula

          floccus
          refined-github

          kagi-search

          augmented-steam
          steam-database
        ];

        settings = {
          # Disable quick find ("/"-hotkey)
          "accessibility.typeaheadfind.manual" = false;

          "browser.startup.page" = 3;

          "font.size.variable.x-western" = 14;

          "places.history.enabled" = true;
          "browser.formfill.enable" = true;
          "privacy.sanitize.sanitizeOnShutdown" = false;
          # Disable password save dialog
          "signon.rememberSignons" = false;

          # Hide menu bar by default
          "ui.key.menuAccessKeyFocuses" = true;

          # Hide bookmarks bar
          "browser.toolbars.bookmarks.visibility" = "never";

          # Auto enable extensions
          "extensions.autoDisableScopes" = 0;
        };
      };
    };
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    configPath = ".mozilla/firefox";

    profiles = {
      alex = {
        id = 0;
        name = "Default";
        isDefault = true;

        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ctrl-number-to-switch-tabs
          dictionary-german
          darkreader
          pywalfox

          bitwarden
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
          # Disable Firefox 'experiments'
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
          # Disable quick find ("/"-hotkey)
          "accessibility.typeaheadfind.manual" = false;

          # Hide menu bar by default
          "ui.key.menuAccessKeyFocuses" = true;
          # Hide bookmarks bar
          "browser.toolbars.bookmarks.visibility" = "never";

          # Auto enable extensions
          "extensions.autoDisableScopes" = 0;
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
