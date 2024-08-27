{ config, ... }:
let
  cfg = config.wayland.windowManager.sway;
in
{
    programs.wofi = {
    enable = true;
    settings = {
      allow_images = true;
      image_size = 16;
      allow_markup = true;
      no_actions = true;
      width = 500;
      height = 500;
      terminal = "${cfg.config.terminal}";
      matching = "multi-contains";
      insensitive = true;
      prompt = "Search apps ...";
    };

    # Originally copied from https://github.com/cxOrz/dotfiles-hyprland/blob/main/wofi/style.css
    # customized to better fit my style
    style = ''
      #window {
      border-radius: 14px;
      background-color: #222436;
      }

      #input {
        padding: 6px;
        border-radius: 14px 14px 0 0;
        font-size: 12px;
        background-color: #222436;
        border: none;
        color: #ecf2f8;
      }

      #input:focus {
        box-shadow: none;
      }

      #scroll {
        border-radius: 14px;
        background-color: #222436;
        margin: 0 8px 8px;
      }

      #inner-box {
        border-radius: 14px;
        padding: 8px;
      }

      #entry {
        padding: 6px;
        border-radius: 6px;
      }

      #entry:selected {
        background-color: #303030;
      }

      #entry image {
        margin-right: 8px;
      }
    '';
  };
}
