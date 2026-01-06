{ config, lib, nixos-unstable, pkgs, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = lib.mkDefault "${pkgs.tuigreet}/bin/tuigreet --cmd ${pkgs.sway}/bin/sway";
        user = "atrost";
      };
    };
  };

  users.users.atrost = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "video" "networkmanager" "rfkill" "power" "lp" "uucp" "network" "docker" "scanner" "dialout" "libvirtd" "gamemode" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIACcqbQlcdBFswQafVSTt0OvMkBLwXjTSLhBsqAdo5Gf atrost@debwrk01"
    ];
  };

  home-manager.users.atrost = {

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "25.05";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = "atrost";
    home.homeDirectory = "/home/atrost";

    xdg.userDirs = {
      enable = true;
      createDirectories = true;
    };

    home.packages = with pkgs; [
      amdgpu_top
      android-tools
      audacity
      bambu-studio
      orca-slicer
      nixos-unstable.bazecor
      btop
      calc
      cava
      cabextract
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
      nixos-unstable.hub
      hugo
      imhex
      inetutils
      ipcalc
      nixos-unstable.joplin-desktop
      jpegoptim
      kind
      krew
      kubectl
      nixos-unstable.kubelogin-oidc
      kubernetes-helm
      kubeseal
      libreoffice-fresh
      meld
      minikube
      minio-client
      mullvad-vpn
      mumble
      natscli
      ncdu
      neofetch
      niv
      nodejs_22
      openshot-qt
      openssl
      openvpn
      optipng
      orca-slicer
      packer
      parsec-bin
      pcmanfm
      perl538Packages.AppClusterSSH
      projectm-sdl-cpp
      protonup-qt
      qemu-utils
      remmina
      s5cmd
      slack
      sops
      sshpass
      stern
      tailscale-systray
      teamspeak3
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
      xournalpp
      xterm
      youtube-music
      yt-dlp
      zip
      # Development
      ansible_2_16
      buf
      chromium
      corepack_latest
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
      python313
      python313Packages.libvirt
      python313Packages.pip
      python313Packages.requests
      rustup
      talosctl
      terraform
      terragrunt
      nixos-unstable.kubecolor
      # Temp
      vscodium-fhs
      # AI
      rocmPackages.rocm-runtime
      rocmPackages.rocminfo
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

      config = {
        global = {
          hide_env_diff = true;
        };
      };

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
      pinentry = {
        package = pkgs.pinentry-gtk2;
      };
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

    services.flameshot = {
      enable = true;
      package = pkgs.flameshot.override { enableWlrSupport = true; };
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
      ./apps/browser.nix
      ./apps/thunderbird.nix
      ./apps/ide.nix
      ./apps/dev_tools.nix
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
    package = nixos-unstable.joplin-desktop;
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
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/about" = "librewolf.desktop";
      "x-scheme-handler/unknown" = "librewolf.desktop";
    };
    };
  */

  programs.kubeswitch = {
    enable = true;
  };

  services.ollama = {
    enable = false;
    acceleration = "rocm";
    environmentVariables = {
      HCC_AMDGPU_TARGET = "gfx1100";
    };
    rocmOverrideGfx = "11.0.0";
  };

  services.scx = {
    enable = true;

    scheduler = "scx_lavd";

    extraArgs = [
      "--autopilot"
    ];
  };

}
