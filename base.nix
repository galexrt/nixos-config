{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports =
    [
      (import "${home-manager}/nixos")
      ./home.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = false;
  boot.supportedFilesystems = [ "btrfs" ];

  hardware = {
    enableAllFirmware = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  #networking.hostName = "moira"; # Define your hostname.
  networking.hostName = "reaper"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

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
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.atrost = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "video" "networkmanager" "rfkill" "power" "lp" "uucp" "network" "docker" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAEAQC6m4WhWiz06iclmil//uT9LIuorqPascQOryrxD59BEk2p/bIBm/ewhd+/B/dN5AfI7uSH1iJUsz2dze08+lTMGtZXcR3j94xgEIr9FiSfpb52rTT+4S2b9dQ3rPVs0hqq3AbQtXp9pnfcVx+qqfzV83Rj61UGlYOy22aGT5OKJcEr06Bwa4lYzmS73xLc2HoPWwsscETO5l34Yn2UjdwQqdd4/I0m1zrRbVJYZrEFKSRY57pz/4OKcTqBiXC+G7ugZ5Vv02IWP1dKGpaJGkaGxN459t7Cq+28VyZmSpg7cyELEqQXJRCN3gQUXSjHv7oP4nAC4YW1jfAO6LQSvrJx+3L3UzA/fzAaSP+gtJO+E84pcSDtcsTcXC5X96lF8kGl8cIljLLq4Qc/R5pyyq+/fJt1ncgzq6Liu+EJ86VPFO8J8AYs7r28/EeEDsS2AQTzDKC/4p43lWDBxXxtqNC+2aYPUr+UqO5AlWi+R5VdSC7fnQqZcsou2jUagDvWrNlhl0lPxW3fLpOOn3XGoIOPXrDYaCPHc8PXHBLtOa1pMgyqSWwg06bvjg4FK1GGphhjkAS1v+QHR36OR0OKDOpDUQdgE/M6GZxV77BreD70UuS9Mf1lZWXwRJoehC6cz+9j8tNnepz0h0IeC6qu7rDrouWoKcitGuySDG6mEB+QSN/ETW5P+X63w+HIiCiXoYfxtwN3whaOP3uwskh5zz0uqqMk/jc9lN7nNWPDru9UAWZItVLb50v/CSYQU9uO3FDzB8QLapqmgV6+2ESrRM2+kmhFrGc61I3/UGX0TkkdqrbeVj0PM7hTUHnbEBE13t0Ry9FD+jEOutKwroxTCrT4L7KXHCudc6ZGuo88OkzWZ8/l4gGBBpkOu9LC4/oujAcSMYgWlYAlTqCZMpuvHdvi42RFhCwTEchqCVrmX/gJsM/MbOXlEcYlTkTIutxk0q7HM22duem7KURrBHtI5UW0Q7IGgxUwpP1Kv99BhFI6aRbQbqew1RbuvZ88m8uE/i8QZAsMdo7N8VezANtSF5DrQDbbuYO+3lpxPpBQOF7NoBVIBwwoBNeRRljGnosrow0Pq/8izaTOx+RbT6KpEVy8P+pCHM0jfF6Ey/gJN55n2saSkLGHU0OPHvzYcF6hpF579I+FKdrrq47M2zTvsE7FFLL/v2Rm20ljCcjkQYH9jzGl6Lpy0pUsyMsmSbE6c13j5fHCA+fG9STo5Da45aV+Z6Q1yBYikI0A0gTaK5Y55k8CjYLgwz+T9FVhCUxg0irbOkjS0GzUnrTwy3HU8CIK7FMlMvnUV0sLDun/3I1ld1M878mUhu4BrSVy2/dXxVW+T3YhpyjQIPpfDXm7exZt atrost@deblap01"
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

  services.blueman.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    appimage-run
    curl
    dig
    evince
    git
    gnumake
    gparted
    greetd.tuigreet
    htop
    jq
    lm_sensors
    mtr
    nixpkgs-fmt
    parted
    pciutils
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

  services.netbird.enable = true;

  virtualisation.docker = {
    enable = true;
    liveRestore = true;
    storageDriver = "overlay2";
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
  # networking.firewall.enable = false;

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
