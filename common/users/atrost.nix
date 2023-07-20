{ pkgs, ... }: {
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

  home.packages = with pkgs; [
    gopass
    gnumake
    file
    joplin-desktop
    netbird-ui
    thunderbird
    pcmanfm
    xfce.mousepad
    youtube-music
    # Development
    dbeaver
    go
    nodejs_18
    yarn
  ];

  targets.genericLinux.enable = true;

  fonts.fontconfig.enable = true;

  # GPG
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 34560000;
    maxCacheTtl = 34560000;
    enableZshIntegration = true;
    pinentryFlavor = "gtk2";
  };
  programs.gpg = {
    enable = true;
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

  imports = [
    ./apps/basics.nix
    ./apps/sway.nix
    ./apps/waybar.nix
    ./apps/firefox.nix
    ./apps/thunderbird.nix
    ./apps/vscode.nix
  ];

}
