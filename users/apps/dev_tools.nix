{ config, pkgs, ... }:

{
  # Development Tools
  programs.go = {
    enable = true;
    package = pkgs.go_1_25;
    env = {
      GOPATH = "${config.home.homeDirectory}/Projects/go";
    };
  };

  programs.vim = {
    enable = true;
    settings = {
      history = 1000;
    };
    defaultEditor = true;
  };
}
