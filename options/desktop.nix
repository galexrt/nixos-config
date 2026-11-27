{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.myConfig.desktop;
in
{
  options.myConfig.desktop = {
    sway.enable = lib.mkEnableOption "the Sway desktop profile";
    #umbriel.enable = lib.mkEnableOption "the Umbriel desktop profile";
    kde.enable = lib.mkEnableOption "the KDE Plasma desktop profile";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.sway.enable {
      xdg.portal = {
        enable = true;
        xdgOpenUsePortal = false;
        wlr = {
          enable = true;
          settings.screencast = {
            max_fps = 60;
            chooser_cmd = "${pkgs.slurp}/bin/slurp -f 'Monitor: %o' -or";
            chooser_type = "simple";
          };
        };
        extraPortals = with pkgs; [
          inputs.luciole.packages.${stdenv.hostPlatform.system}.default
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
        ];
        config.common = {
          default = "*";
          "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "luciole" "gtk" ];
        };
      };
    })

    #(lib.mkIf cfg.umbriel.enable {
    #  programs.umbriel.enable = true;
    #})

    (lib.mkIf cfg.kde.enable {
      services = {
        desktopManager.plasma6.enable = true;
        displayManager.sddm = {
          enable = true;
          wayland.enable = true;
        };
      };

      environment.systemPackages = with pkgs; [
        kdePackages.discover
        kdePackages.kcalc
        kdePackages.kcharselect
        kdePackages.kcolorchooser
        kdePackages.kolourpaint
        kdePackages.ksystemlog
        kdePackages.sddm-kcm
        kdiff3
        kdePackages.isoimagewriter
        kdePackages.partitionmanager
        hardinfo2
        haruna
        wayland-utils
        wl-clipboard
      ];
    })
  ];
}
