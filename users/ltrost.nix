{ ... }:

{
  home-manager.users.ltrost = {

    home.stateVersion = "25.05";

    programs.home-manager.enable = true;

    home.username = "ltrost";
    home.homeDirectory = "/home/ltrost";

    xdg.userDirs = {
      enable = true;
      createDirectories = true;
    };

    home.packages = with pkgs; [
      simple-scan
    ];
  };
}
