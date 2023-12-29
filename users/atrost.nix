{ pkgs, config, lib, ... }:

{
  xdg.portal.config.common.default = "*";

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
      appimagekit
      audacity
      azure-cli
      buf
      calc
      dbeaver
      dconf
      discord
      dnscontrol
      docker-compose
      ethtool
      exiftool
      file
      filezilla
      ffmpeg
      ferdium
      geeqie
      gimp
      git-crypt
      gnome.simple-scan
      gopass
      grafana-loki
      handbrake
      hugo
      inetutils
      joplin-desktop
      jpegoptim
      krew
      kubectl
      kubelogin-oidc
      kubernetes-helm
      meld
      minikube
      minio-client
      mumble
      mullvad-vpn
      ncdu
      nodejs_20
      openssl
      optipng
      parsec-bin
      pcmanfm
      perl536Packages.AppClusterSSH
      protonup-qt
      remmina
      s5cmd
      slack
      sshpass
      steam
      stern
      tailscale-systray
      teamspeak_client
      termdown
      temurin-bin
      thunderbird
      udiskie
      unrar
      vlc
      wdisplays
      xarchiver
      xfce.mousepad
      xterm
      #youtube-music # Uses old Electron 25.9
      yt-dlp
      zoom-us
      woeusb
      # Development
      ansible_2_14
      gcc
      delve
      gdal
      graphviz
      mysql80
      protobuf
      protoc-gen-go
      protoc-gen-go-grpc
      python311
      python311Packages.pip
      python311Packages.requests
      rustup
      terraform
      terragrunt
      yarn
    ];

    home.sessionPath = [
      "$HOME/Projects/go/bin"
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
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-vaapi
        droidcam-obs
        obs-pipewire-audio-capture
        obs-teleport
      ];
    };

    services.syncthing = {
      enable = true;
      tray = {
        enable = false;
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
      package = pkgs.go_1_21;
      goPath = "Projects/go";
    };

    programs.vim = {
      enable = true;
      settings = {
        history = 1000;
      };
      defaultEditor = true;
    };

  };

  programs.streamdeck-ui = {
    enable = true;
    autoStart = true;
  };

  #services.udiskie = {
  #  enable = true;
  #  automount = true;
  #  notify = false;
  #};

  services.tailscale = {
    enable = true;
    extraUpFlags = [
      "--operator=atrost"
    ];
  };

  services.mullvad-vpn = {
    enable = true;
  };

}
