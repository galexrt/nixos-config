{ ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.95;
        padding = {
          x = 6;
          y = 4;
        };
        dynamic_padding = true;
      };

      font = {
        size = 8.0;
        normal = {
          family = "Hack";
          style = "Regular";
        };
      };

      scrolling.history = 9999;

      mouse.hide_when_typing = false;

      # Cai (Gogh) - <https://github.com/Gogh-Co/Gogh/blob/master/themes/Cai.yml>
      colors = {
        draw_bold_text_with_bright_colors = true;

        primary = {
          # Override Cai's #ffffea background with black.
          background = "#000000";

          # Cai's original foreground is #000000, which would be invisible
          # on the black background, so use white instead of Cai's light white (#fcfcce) instead.
          foreground = "#FFFFFF";
        };

        normal = {
          #black = "#000000";
          #red = "#CA274D";
          #green = "#4DCA27";
          #yellow = "#CAA427";
          #blue = "#274DCA";
          #magenta = "#A427CA";
          #cyan = "#27CAA4";
          #white = "#808080";
          black = "#808080";
          red = "#E98DA3";
          green = "#A3E98D";
          yellow = "#E9D48D";
          blue = "#8DA3E9";
          magenta = "#D48DE9";
          cyan = "#8DE9D4";
          white = "#FFFFFF";
        };

        bright = {
          black = "#808080";
          red = "#E98DA3";
          green = "#A3E98D";
          yellow = "#E9D48D";
          blue = "#8DA3E9";
          magenta = "#D48DE9";
          cyan = "#8DE9D4";
          white = "#FFFFFF";
        };
      };
    };
  };

  # Use alacritty in "daemon mode", though needs different `alacritty msg create-window` command to create new windows.
  # systemd.user.services.alacritty-daemon = {
  #   description = "Alacritty Daemon";
  #   wantedBy = [ "graphical-session.target" ];
  #   serviceConfig = {
  #     ExecStart = "${pkgs.alacritty}/bin/alacritty --daemon";
  #     Restart = "on-failure";
  #   };
  # };
}
