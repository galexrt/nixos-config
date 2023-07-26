{ pkgs, config, lib, fetchurl, ... }:

{
  home-manager.users.atrost = {

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "23.05";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = "atrost";
    home.homeDirectory = "/home/atrost";

    nixpkgs.config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };

    xdg.userDirs = {
      enable = true;
      createDirectories = true;
    };

    home.packages = with pkgs; [
      _1password-gui
      android-tools
      calc
      dbeaver
      dconf
      discord
      docker-compose
      exiftool
      file
      geeqie
      gimp
      git-crypt
      gopass
      joplin-desktop
      jpegoptim
      kubectl
      meld
      ncdu
      netbird-ui
      nodejs_18
      optipng
      parsec-bin
      pcmanfm
      perl536Packages.AppClusterSSH
      protonup-qt
      s5cmd
      slack
      sshpass
      steam
      teamspeak_client
      thunderbird
      wdisplays
      wireguard-tools
      xarchiver
      xfce.mousepad
      xterm
      yarn
      youtube-music
      yt-dlp
      # Custom
      (callPackage ../pkgs/beeper.nix { })
    ];

    targets.genericLinux.enable = true;

    fonts.fontconfig.enable = true;

    # GPG
    services.gpg-agent = {
      enable = true;
      enableZshIntegration = true;
      enableSshSupport = false;
      defaultCacheTtl = 34560000;
      maxCacheTtl = 34560000;
      maxCacheTtlSsh = 34560000;
      defaultCacheTtlSsh = 34560000;
      pinentryFlavor = "gtk2";
    };
    programs.gpg = {
      enable = true;
    };

    services.gnome-keyring = {
      enable = true;
      components = [
        "pkcs11"
        "secrets"
        "ssh"
      ];
    };

    services.easyeffects.enable = true;

    services.nextcloud-client = {
      enable = true;
      startInBackground = true;
    };

    programs.obs-studio = {
      enable = true;
      plugins = [
        #pkgs.obs-studio-plugins.obs-ndi
        pkgs.obs-studio-plugins.wlrobs
        pkgs.obs-studio-plugins.obs-vaapi
        pkgs.obs-studio-plugins.droidcam-obs
        pkgs.obs-studio-plugins.obs-pipewire-audio-capture
      ];
    };

    services.syncthing = {
      enable = true;
      tray = {
        enable = true;
      };
    };

    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };
    };

    imports = [
      ./apps/basics.nix
      ./apps/sway.nix
      ./apps/waybar.nix
      ./apps/firefox.nix
      ./apps/thunderbird.nix
      ./apps/vscode.nix
    ];

    gtk = {
      enable = true;
      theme = {
        name = "Adementary-dark";
        package = pkgs.adementary-theme;
      };
      font = {
        name = "Hack";
        package = null;
        size = 10;
      };
      iconTheme = {
        name = "Adwaita";
        package = pkgs.gnome.adwaita-icon-theme;
      };
    };

    # Development Tools
    programs.go = {
      enable = true;
      goPath = "Projects/go";
    };

    programs.vim = {
      enable = true;
      settings = {
        history = 1000;
      };
    };

  };

  programs.streamdeck-ui = {
    enable = true;
    autoStart = true;
  };

}
