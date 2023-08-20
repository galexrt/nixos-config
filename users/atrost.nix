{ pkgs, config, lib, ... }:

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
      appimagekit
      buf
      calc
      dbeaver
      dconf
      discord
      dnscontrol
      docker-compose
      exiftool
      file
      geeqie
      gimp
      git-crypt
      gopass
      inetutils
      joplin-desktop
      jpegoptim
      krew
      kubectl
      kubelogin-oidc
      kubernetes-helm
      meld
      mumble
      ncdu
      netbird-ui
      nodejs_18
      openssl
      optipng
      parsec-bin
      pcmanfm
      perl536Packages.AppClusterSSH
      protonup-qt
      s5cmd
      slack
      sshpass
      steam
      stern
      teamspeak_client
      thunderbird
      udiskie
      vlc
      wdisplays
      xarchiver
      xfce.mousepad
      xterm
      youtube-music
      yt-dlp
      zoom-us
      # Development
      delve
      mysql80
      protobuf
      protoc-gen-go
      protoc-gen-go-grpc
      python311
      python311Packages.pygeos
      python311Packages.gdal
      python311Packages.pip
      terraform
      terragrunt
      yarn
      # Custom
      (callPackage ../pkgs/beeper.nix { })
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
        # obs-ndi has some issues https://github.com/NixOS/nixpkgs/issues/219578#issuecomment-1454906546
      ] ++ (lib.optionals config.nixpkgs.config.allowUnfree [
        (obs-ndi.override {
          ndi = pkgs.ndi.overrideAttrs (attrs: rec {
            src = pkgs.fetchurl {
              name = "${attrs.pname}-${attrs.version}.tar.gz";
              url = "https://downloads.ndi.tv/SDK/NDI_SDK_Linux/Install_NDI_SDK_v5_Linux.tar.gz";
              hash = "sha256-flxUaT1q7mtvHW1J9I1O/9coGr0hbZ/2Ab4tVa8S9/U=";
            };

            unpackPhase = ''
              unpackFile $src
              echo y | ./${attrs.installerName}.sh
              sourceRoot="NDI SDK for Linux";
              mkdir -p "$sourceRoot/logos";
            '';
          });
        })
      ]);
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
      defaultEditor = true;
    };

  };

  #programs.streamdeck-ui = {
  #  enable = true;
  #  autoStart = true;
  #};

  #services.udiskie = {
  #  enable = true;
  #  automount = true;
  #  notify = false;
  #};

}
