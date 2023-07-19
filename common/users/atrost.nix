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
    thunderbird
    gnumake
    file
    joplin-desktop
    pavucontrol
    pcmanfm
    youtube-music
    # Development
    dbeaver
    go
    # Sway
    font-awesome # Icon font
    wl-clipboard
    wluma
    wob
    swaylock-fancy
    swaycwd
  ];

  targets.genericLinux.enable = true;

  fonts.fontconfig.enable = true;

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
