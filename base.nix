{ config, pkgs, options, ... }:

{
  imports =
    [
      <home-manager/nixos>
      ./home.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.memtest86.enable = true;
  boot.plymouth.enable = false;
  boot.supportedFilesystems = [ "btrfs" ];
  boot.swraid.enable = true;

  hardware = {
    enableAllFirmware = true;

    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  networking.timeServers = [ "0.de.pool.ntp.org" "1.de.pool.ntp.org" "2.de.pool.ntp.org" ] ++ options.networking.timeServers.default;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  #console = {
  #  font = "Lat2-Terminus16";
  #  keyMap = "en";
  #  useXkbConfig = true; # use xkbOptions in tty.
  #};

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplipWithPlugin ];
  };
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.openFirewall = true;

  # Enable sound via Pipewire
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    wireplumber = {
      enable = true;
    };
  };

  services.dbus.enable = true;

  # Enable auto mount
  services.gvfs.enable = true;

  programs.zsh = {
    enable = true;
  };

  # LD Fix
  programs.nix-ld = {
    enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.atrost = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "video" "networkmanager" "rfkill" "power" "lp" "uucp" "network" "docker" "scanner" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIACcqbQlcdBFswQafVSTt0OvMkBLwXjTSLhBsqAdo5Gf atrost@debwrk01"
    ];
  };

  security.pam.services.swaylock.text = ''
    # PAM configuration file for the swaylock screen locker. By default, it includes
    # the 'login' configuration file (see /etc/pam.d/login)
    auth include login
  '';

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    appimage-run
    bridge-utils
    curl
    dig
    evince
    git
    gnumake
    gparted
    gptfdisk
    greetd.tuigreet
    gsmartcontrol
    htop
    jq
    lm_sensors
    lsof
    mtr
    nixpkgs-fmt
    nvme-cli
    parted
    pciutils
    pkg-config
    pulseaudio
    restic
    rsync
    traceroute
    tree
    unzip
    vim
    wget
    wineWowPackages.stable
    wireguard-tools
    xdg-utils
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

  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = "524288";
  };

  # Fonts
  fonts = {
    packages = with pkgs; [
      hack-font
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      roboto
      font-awesome
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

  services.gnome.gnome-keyring.enable = true;

  programs.dconf.enable = true;

  programs.light.enable = true;

  # List services that you want to enable:
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd ${pkgs.sway}/bin/sway";
        user = "atrost";
      };
    };
  };

  virtualisation.docker = {
    enable = true;
    liveRestore = true;
    storageDriver = "overlay2";
  };

  virtualisation.virtualbox.host = {
    enable = true;
  };

  security.polkit.enable = true;

  # Allow sudo without password
  security.sudo.wheelNeedsPassword = false;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

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
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
