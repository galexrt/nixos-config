{ config, pkgs, ... }: {
  # Scripts
  home.file."get_weather.sh" = {
    executable = true;
    source = ./waybar/scripts/get_weather.sh;
    target = "${config.xdg.configHome}/waybar/scripts/get_weather.sh";
  };
  home.file."wluma.sh" = {
    executable = true;
    source = ./waybar/scripts/wluma.sh;
    target = "${config.xdg.configHome}/waybar/scripts/wluma.sh";
  };

  # wluma
  home.file."wluma-config.toml" = {
    executable = true;
    source = ./wluma/config.toml;
    target = "${config.xdg.configHome}/wluma/config.toml";
  };
  systemd.user.services.wluma = {
    Unit = {
      Description = "Adjusting screen brightness based on screen contents and amount of ambient light";
      PartOf = [
        "graphical-session.target"
      ];
      After = [
        "graphical-session.target"
      ];
    };

    Service = {
      Environment = "WLR_DRM_NO_MODIFIERS=1";
      ExecStart = "${pkgs.wluma}/bin/wluma";
      Restart = "always";
      PrivateNetwork = true;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  home.packages = with pkgs; [
    font-awesome # Icon font
    pavucontrol
    wluma
  ];

  programs.waybar = {
    enable = true;
    settings = {
      default = {
        layer = "top";
        position = "bottom";
        height = 32;
        modules-left = [ "sway/workspaces" "wlr/taskbar" ];
        modules-center = [ "sway/mode" "custom/weather" ];
        modules-right = [
          # Info
          "temperature"
          "cpu"
          "memory"
          "battery"

          # Network
          "network"
          "bluetooth"

          # System
          "idle_inhibitor"
          "custom/dnd"
          "custom/adaptive-light"
          "pulseaudio"
          "backlight"

          "tray"
          "clock"
        ];

        # Modules Left
        "sway/workspaces" = {
          all-outputs = false;
          sort-by-coordinates = true;
          format = "{name}:{icon}";
          format-icons = {
            urgent = "";
            focused = "";
            default = "";
          };
        };

        "wlr/taskbar" = {
          all-outputs = false;
          format = "{icon}";
          icon-size = 14;
          icon-theme = "Numix-Circle";
          tooltip-format = "{title}";
          on-click = "activate";
          on-click-middle = "close";
          ignore-list = [
            "joplin-desktop"
          ];
        };

        # Modules Center
        "sway/mode" = {
          format = "<span style=\"italic\">{}</span>";
          tooltip = false;
        };

        "custom/weather" = {
          icon-size = 42;
          format = "{icon} {}";
          tooltip = true;
          interval = 3600;
          exec = "${config.xdg.configHome}/waybar/scripts/get_weather.sh";
          return-type = "json";
        };

        "temperature" = {
          hwmon-path = "/sys/class/hwmon/hwmon3/temp1_input";
          critical-threshold = 75;
          format = "{temperatureC}°C {icon}";
          format-icons = [ "" "" "" ];
        };

        "cpu" = {
          interval = 3;
          format = " {}%";
          states = {
            warning = 70;
            critical = 90;
          };
          on-click = "${pkgs.sway}/bin/swaymsg exec \\$once \\$term_float htop";
          tooltip = true;
        };

        "memory" = {
          interval = 5;
          format = " {}%";
          states = {
            warning = 70;
            critical = 90;
          };
          on-click = "${pkgs.sway}/bin/swaymsg exec \\$once \\$term_float htop";
          tooltip = true;
        };

        "battery" = {
          states = {
            good = 90;
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = [ "" "" "" "" "" ];
        };

        "network" = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };

        "bluetooth" = {
          format = "";
          format-disabled = "";
          on-click = "${pkgs.sway}/bin/swaymsg exec \\$bluetooth";
          on-click-right = "rfkill toggle bluetooth";
          tooltip-format = "{}";
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
          tooltip = true;
          tooltip-format-activated = "power-saving disabled";
          tooltip-format-deactivated = "power-saving enabled";
        };

        "custom/dnd" = {
          interval = "once";
          return-type = "json";
          format = "{}{icon}";
          format-icons = {
            default = "󰚢";
            dnd = "󰚣";
          };
          on-click = "${pkgs.mako}/bin/makoctl mode | grep 'do-not-disturb' && ${pkgs.mako}/bin/makoctl mode -r do-not-disturb || ${pkgs.mako}/bin/makoctl mode -a do-not-disturb; pkill -RTMIN+11 waybar";
          on-click-right = "${pkgs.mako}/bin/makoctl restore";
          exec = "printf '{\"alt\":\"%s\",\"tooltip\":\"mode: %s\"}' $(${pkgs.mako}/bin/makoctl mode | grep -q 'do-not-disturb' && echo dnd || echo default) $(${pkgs.mako}/bin/makoctl mode | tail -1)";
          signal = 11;
        };

        "custom/adaptive-light" = {
          interval = "once";
          tooltip = true;
          return-type = "json";
          format = "{icon}";
          format-icons = {
            on = "󰃡";
            off = "󰃠";
          };
          exec = "${config.xdg.configHome}/waybar/scripts/wluma.sh";
          on-click = "${config.xdg.configHome}/waybar/scripts/wluma.sh toggle; pkill -RTMIN+12 waybar";
          exec-if = "${config.xdg.configHome}/waybar/scripts/wluma.sh check";
          signal = 12;
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = " ";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" ];
          };
          scroll-step = 5;
          tooltip-format = "{icon}  {volume}%";
          on-click = "swaymsg exec \\$pulseaudio";
          on-click-middle = "swaymsg exec \\$volume_mute";
          on-scroll-up = "swaymsg exec \\$volume_up";
          on-scroll-down = "swaymsg exec \\$volume_down";
          ignored-sinks = [ "Easy Effects Sink" ];
        };

        "backlight" = {
          format = "{icon} {percent}%";
          tooltip-frmat = "brightness {percent}%";
          format-icons = [ "" "" ];
          on-scroll-up = "${pkgs.sway}/bin/swaymsg exec \\$brightness_up";
          on-scroll-down = "${pkgs.sway}/bin/swaymsg exec \\$brightness_down";
        };

        "tray" = {
          icon-size = 23;
          spacing = 5;
        };

        "clock" = {
          interval = 1;
          format = "{:%H:%M:%S %d-%m-%Y}";
        };

      };
    };
    style = ''
      * {
          /* `otf-font-awesome` is required to be installed for icons */
          font-family: FontAwesome, Hack, Roboto;
          font-size: 13px;
      }

      window#waybar {
          background-color: rgba(43, 48, 59, 0.5);
          border-bottom: 3px solid rgba(100, 114, 125, 0.5);
          color: #ffffff;
          transition-property: background-color;
          transition-duration: .5s;
      }

      window#waybar.hidden {
          opacity: 0.2;
      }

      /*
      window#waybar.empty {
          background-color: transparent;
      }
      window#waybar.solo {
          background-color: #FFFFFF;
      }
      */

      window#waybar.termite {
          background-color: #3F3F3F;
      }

      window#waybar.chromium {
          background-color: #000000;
          border: none;
      }

      button {
          /* Use box-shadow instead of border so the text isn't offset */
          box-shadow: inset 0 -3px transparent;
          /* Avoid rounded borders under each button name */
          border: none;
          border-radius: 0;
      }

      /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
      button:hover {
          background: inherit;
          box-shadow: inset 0 -3px #ffffff;
      }

      #workspaces button {
          padding: 0 5px;
          background-color: transparent;
          color: #ffffff;
      }

      #workspaces button:hover {
          background: rgba(0, 0, 0, 0.2);
      }

      #workspaces button.focused {
          background-color: #64727D;
          box-shadow: inset 0 -3px #ffffff;
      }

      #workspaces button.urgent {
          background-color: #eb4d4b;
      }

      #mode {
          background-color: #64727D;
          border-bottom: 3px solid #ffffff;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #wireplumber,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #scratchpad,
      #mpd {
          padding: 0 10px;
          color: #ffffff;
      }

      #window,
      #workspaces {
          margin: 0 4px;
      }

      /* If workspaces is the leftmost module, omit left margin */
      .modules-left > widget:first-child > #workspaces {
          margin-left: 0;
      }

      /* If workspaces is the rightmost module, omit right margin */
      .modules-right > widget:last-child > #workspaces {
          margin-right: 0;
      }

      #clock {
          background-color: #64727D;
      }

      #battery {
          background-color: #ffffff;
          color: #000000;
      }

      #battery.charging, #battery.plugged {
          color: #ffffff;
          background-color: #26A65B;
      }

      @keyframes blink {
          to {
              background-color: #ffffff;
              color: #000000;
          }
      }

      #battery.critical:not(.charging) {
          background-color: #f53c3c;
          color: #ffffff;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      label:focus {
          background-color: #000000;
      }

      #cpu {
          background-color: #2ecc71;
          color: #000000;
      }

      #memory {
          background-color: #9b59b6;
      }

      #disk {
          background-color: #964B00;
      }

      #backlight {
          background-color: #90b1b1;
      }

      #network {
          background-color: #2980b9;
      }

      #network.disconnected {
          background-color: #f53c3c;
      }

      #pulseaudio {
          background-color: #f1c40f;
          color: #000000;
      }

      #pulseaudio.muted {
          background-color: #90b1b1;
          color: #2a5c45;
      }

      #wireplumber {
          background-color: #fff0f5;
          color: #000000;
      }

      #wireplumber.muted {
          background-color: #f53c3c;
      }

      #custom-media {
          background-color: #66cc99;
          color: #2a5c45;
          min-width: 100px;
      }

      #custom-media.custom-spotify {
          background-color: #66cc99;
      }

      #custom-media.custom-vlc {
          background-color: #ffa000;
      }

      #temperature {
          background-color: #f0932b;
      }

      #temperature.critical {
          background-color: #eb4d4b;
      }

      #tray {
          background-color: #2980b9;
      }

      #tray > .passive {
          -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: #eb4d4b;
      }

      #idle_inhibitor {
          background-color: #2d3436;
      }

      #idle_inhibitor.activated {
          background-color: #ecf0f1;
          color: #2d3436;
      }

      #mpd {
          background-color: #66cc99;
          color: #2a5c45;
      }

      #mpd.disconnected {
          background-color: #f53c3c;
      }

      #mpd.stopped {
          background-color: #90b1b1;
      }

      #mpd.paused {
          background-color: #51a37a;
      }

      #language {
          background: #00b093;
          color: #740864;
          padding: 0 5px;
          margin: 0 5px;
          min-width: 16px;
      }

      #keyboard-state {
          background: #97e1ad;
          color: #000000;
          padding: 0 0px;
          margin: 0 5px;
          min-width: 16px;
      }

      #keyboard-state > label {
          padding: 0 5px;
      }

      #keyboard-state > label.locked {
          background: rgba(0, 0, 0, 0.2);
      }

      #scratchpad {
          background: rgba(0, 0, 0, 0.2);
      }

      #scratchpad.empty {
        background-color: transparent;
      }

      /*
       * Taken from https://github.com/manjaro-sway/desktop-settings/blob/6a0e727fbe10b664d9e1ca7e64da4b9c7b633da3/community/sway${config.xdg.configHome}/templates/waybar/style.css
       */

      @keyframes blink-warning {
          70% {
              color: @wm_icon_bg;
          }

          to {
              color: @wm_icon_bg;
              background-color: @warning_color;
          }
      }

      @keyframes blink-critical {
          70% {
              color: @wm_icon_bg;
          }

          to {
              color: @wm_icon_bg;
              background-color: @error_color;
          }
      }

      /* -----------------------------------------------------------------------------
       * Base styles
       * -------------------------------------------------------------------------- */

      /* Reset all styles */
      * {
          border: none;
          border-radius: 0;
          min-height: 0;
          margin: 0;
          padding: 0;
      }

      /* The whole bar */
      window#waybar {
          background: @theme_bg_color;
          color: @wm_icon_bg;
          font-size: 14px;
      }

      /* Each module */
      #custom-pacman,
      #custom-menu,
      #custom-help,
      #custom-scratchpad,
      #custom-github,
      #custom-clipboard,
      #custom-zeit,
      #custom-dnd,
      #bluetooth,
      #battery,
      #clock,
      #cpu,
      #memory,
      #mode,
      #network,
      #pulseaudio,
      #temperature,
      #idle_inhibitor,
      #backlight,
      #language,
      #custom-adaptive-light,
      #custom-sunset,
      #custom-playerctl,
      #tray {
          padding-left: 10px;
          padding-right: 10px;
      }

      /* -----------------------------------------------------------------------------
       * Module styles
       * -------------------------------------------------------------------------- */

      #custom-scratchpad,
      #custom-menu,
      #workspaces button.focused,
      #clock {
          color: @theme_bg_color;
          background-color: @theme_selected_bg_color;
      }

      #custom-zeit.tracking {
          background-color: @warning_color;
      }

      #battery {
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      #battery.warning {
          color: @warning_color;
      }

      #battery.critical {
          color: @error_color;
      }

      #battery.warning.discharging {
          animation-name: blink-warning;
          animation-duration: 3s;
      }

      #battery.critical.discharging {
          animation-name: blink-critical;
          animation-duration: 2s;
      }

      #clock {
          font-weight: bold;
      }

      #cpu.warning {
          color: @warning_color;
      }

      #cpu.critical {
          color: @error_color;
      }

      #custom-menu {
          padding-left: 8px;
          padding-right: 13px;
      }

      #memory {
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      #memory.warning {
          color: @warning_color;
      }

      #memory.critical {
          color: @error_color;
          animation-name: blink-critical;
          animation-duration: 2s;
      }

      #mode {
          background: @background_color;
      }

      #network.disconnected {
          color: @warning_color;
      }

      #pulseaudio.muted {
          color: @warning_color;
      }

      #temperature.critical {
          color: @error_color;
      }

      #workspaces button {
          border-top: 2px solid transparent;
          /* To compensate for the top border and still have vertical centering */
          padding-bottom: 2px;
          padding-left: 10px;
          padding-right: 10px;
          color: @theme_selected_bg_color;
      }

      #workspaces button.focused {
          border-color: @theme_selected_bg_color;
      }

      #workspaces button.urgent {
          border-color: @error_color;
          color: @error_color;
      }

      #custom-pacman {
          color: @warning_color;
      }

      #bluetooth.disabled {
          color: @warning_color;
      }

      #custom-wf-recorder {
          color: @error_color;
          padding-right: 10px;
      }
    '';
  };
}
