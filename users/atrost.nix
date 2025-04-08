{ pkgs, config, lib, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
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
      android-tools
      appimagekit
      audacity
      bambu-studio
      unstable.bazecor
      btop
      calc
      cava
      dbeaver-bin
      dconf
      dnscontrol
      docker-compose
      ethtool
      exiftool
      ferdium
      ffmpeg
      file
      filezilla
      freecad
      geeqie
      gh
      gimp
      git-crypt
      gopass
      grafana-loki
      handbrake
      simple-scan
      unstable.hub
      hugo
      imhex
      inetutils
      ipcalc
      unstable.joplin-desktop
      jpegoptim
      kind
      krew
      kubectl
      unstable.kubelogin-oidc
      kubernetes-helm
      kubeseal
      libreoffice-fresh
      meld
      minikube
      minio-client
      mullvad-vpn
      mumble
      ncdu
      neofetch
      niv
      nodejs_22
      openshot-qt
      openssl
      optipng
      packer
      parsec-bin
      pcmanfm
      perl538Packages.AppClusterSSH
      projectm
      protonup-qt
      qemu-utils
      remmina
      s5cmd
      slack
      sops
      sshpass
      steam
      stern
      tailscale-systray
      teamspeak_client
      temurin-bin
      termdown
      transmission_4-qt
      unrar
      #vagrant
      vesktop
      vlc
      wallust
      waypipe
      wdisplays
      woeusb
      xarchiver
      xfce.mousepad
      xterm
      youtube-music
      yt-dlp
      zip
      # Development
      ansible_2_16
      buf
      chromium
      corepack_23
      delve
      gcc
      gdal
      graphviz
      lua
      mysql80
      php83
      php83Packages.composer
      protobuf
      protoc-gen-go
      protoc-gen-go-grpc
      python311
      python311Packages.libvirt
      python311Packages.pip
      python311Packages.requests
      rustup
      talosctl
      terraform
      terragrunt
      yarn
      unstable.kubecolor
      # Temp
      vscodium-fhs
    ];

    home.sessionPath = [
      "$HOME/Projects/go/bin"
    ];

    targets.genericLinux.enable = true;

    fonts.fontconfig.enable = true;

    programs.direnv = {
      enable = true;

      enableBashIntegration = true;
      enableZshIntegration = true;

      nix-direnv = {
        enable = true;
      };
    };

    # GPG
    services.gpg-agent = {
      enable = true;
      enableZshIntegration = true;
      enableSshSupport = false;
      defaultCacheTtl = 34560000;
      maxCacheTtl = 34560000;
      maxCacheTtlSsh = 34560000;
      defaultCacheTtlSsh = 34560000;
      pinentryPackage = pkgs.pinentry-gtk2;
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

    services.easyeffects.enable = false;

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
      ./apps/wofi.nix
      ./apps/firefox.nix
      ./apps/thunderbird.nix
      ./apps/ide.nix
    ];

    gtk = {
      enable = true;
      theme = {
        name = "Flat-Remix-GTK-Blue-Darkest-Solid";
        package = pkgs.flat-remix-gtk;
      };
      font = {
        name = "Hack";
        package = null;
        size = 10;
      };
      iconTheme = {
        name = "Flat-Remix-Blue-Dark";
        package = pkgs.flat-remix-icon-theme;
      };
    };

    home.pointerCursor = {
      name = "phinger-cursors-dark";
      package = pkgs.phinger-cursors;
      size = 24;
      gtk.enable = true;
    };

    /*
    programs.bazecor = {
      enable = true;
      package = unstable.bazecor;
    };
    */

    # Development Tools
    programs.go = {
      enable = true;
      package = pkgs.go_1_23;
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

  services.tailscale = {
    enable = true;
    extraUpFlags = [
      "--operator=atrost"
    ];
  };

  services.mullvad-vpn = {
    enable = true;
  };

  /*
  programs.joplin-desktop = {
    enable = true;
    extraConfig = {
      "dateFormat" = "YYYY-MM-DD";
      "theme" = 22;
      "style.editor.fontSize" = 10;
      "editor.beta" = true;
      "spellChecker.languages" = [
        "en-US"
        "de"
      ];
    };
    package = unstable.joplin-desktop;
    sync = {
      interval = "5m";
      target = "nextcloud";
    };
  };
  */

  /*
    xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
    };
  */

  programs.kubeswitch = {
    enable = true;
  };

}
