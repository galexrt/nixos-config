{ config, inputs, lib, nixos-unstable, options, pkgs, system, home-manager, ... }:

{
  imports =
    [
      ./users.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.memtest86.enable = true;
  boot.plymouth.enable = lib.mkDefault false;
  boot.supportedFilesystems = [ "btrfs" ];
  boot.swraid.enable = true;

  # Linux kernel
  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linuxKernel.kernels.linux_6_18);

  hardware = {
    enableAllFirmware = true;

    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
    packageOverrides = pkgs: {
      nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
    };
    permittedInsecurePackages = [
      "qtwebengine-5.15.19" # For teamspeak3
    ];
  };

  # Enable binfmt
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs; };
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager = {
    enable = true; # Easiest to use and most distros use this by default.
    plugins = with pkgs; [ networkmanager-openvpn ];
  };

  networking.timeServers = [ "0.de.pool.ntp.org" "1.de.pool.ntp.org" "2.de.pool.ntp.org" ] ++ options.networking.timeServers.default;

  networking.extraHosts = ''
  '';

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
  console = {
  #  font = "Lat2-Terminus16";
    keyMap = "de";
  #  useXkbConfig = true; # use xkbOptions in tty.
  };

  services.dbus.enable = true;

  # Enable auto mount
  services.gvfs.enable = true;

  programs.zsh = {
    enable = true;
  };

  programs.nix-index = {
    enable = true;
    enableZshIntegration = false;
    enableBashIntegration = false;
  };

  # LD Fix
  programs.nix-ld = {
    enable = true;
    libraries = (with pkgs; [
      stdenv.cc.cc.lib
    ]) ++ options.programs.nix-ld.libraries.default
    ++ (pkgs.steam-run.args.multiPkgs pkgs);
  };

  security.pam.services.swaylock.text = ''
    # PAM configuration file for the swaylock screen locker. By default, it includes
    # the 'login' configuration file (see /etc/pam.d/login)
    auth include login
  '';

  xdg = {
    portal = {
      enable = true;

      xdgOpenUsePortal = false;

      wlr = {
        enable = true;

        settings = {
          screencast = {
            max_fps = 60;
            exec_before = "swaync-client -dn -sw";
            exec_after = "swaync-client -df -sw";
          };
        };
      };

      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      config.common.default = "*";
    };
  };

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.hplipWithPlugin ];
  };

  services.blueman.enable = true;

  services.earlyoom = {
    enable = true;
    freeSwapThreshold = 4;
    freeMemThreshold = 4;
    extraArgs = [
        "-g"
        "--avoid" "'^(Xwayland|sway|swaync-client)$'"
        "--prefer" "'^(electron|libreoffice|gimp|__debug_bin.*)$'"
    ];
    enableNotifications = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    appimage-run
    bridge-utils
    curl
    dig
    evince
    freetype
    git
    gnumake
    gparted
    gptfdisk
    tuigreet
    htop
    iotop
    jq
    lact
    linuxKernel.packages.linux_6_18.cpupower
    lm_sensors
    lsof
    mtr
    nixpkgs-fmt
    nvme-cli
    parallel
    parted
    pciutils
    pkg-config
    powertop
    pulseaudio
    qemu
    restic
    rsync
    screen
    smartmontools
    traceroute
    tree
    unzip
    usbutils
    vim
    wget
    wineWowPackages.stable
    wireguard-tools
    xdg-utils
    yq

    # WinBoat - Windows app runner
    nixos-unstable.winboat # Not yet in any release branch, only available on master branch
    freerdp
  ];

  environment.etc = {
    "xdg/gtk-2.0/gtkrc".text = ''
      gtk-error-bell=0
      gtk-application-prefer-dark-theme=1
    '';
    "xdg/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-error-bell=false
      gtk-application-prefer-dark-theme=1
    '';
    "xdg/gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-error-bell=false
      gtk-application-prefer-dark-theme=1
    '';
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches"   = 1048576;   # default:  8192
    "fs.inotify.max_user_instances" =    1024;   # default:   128
    "fs.inotify.max_queued_events"  =   32768;   # default: 16384
  };

  # Fonts
  fonts = {
    packages = with pkgs; [
      hack-font
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      roboto
      font-awesome
      google-fonts
      # Microsoft Fonts
      corefonts
      vista-fonts
    ];
    fontDir.enable = true;
    fontconfig.defaultFonts.monospace = [
      "Hack"
      "Noto Color Emoji"
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };

  services.gnome.gnome-keyring.enable = false;

  programs.dconf.enable = true;

  programs.light.enable = true;

  services.power-profiles-daemon.enable = true;

  services.upower.enable = true;

  security.polkit.enable = true;

  # Allow sudo without password
  security.sudo.wheelNeedsPassword = false;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Automatic updates every day
  system.autoUpgrade.enable = true;

  # Automatic GC
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 30d";

  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '';

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
