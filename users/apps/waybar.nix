{ config, lib, pkgs, ... }: {
  # Scripts
  home.file."cava.sh" = {
    executable = true;
    source = ./waybar/scripts/cava.sh;
    target = "${config.xdg.configHome}/waybar/scripts/cava.sh";
  };
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

  services.swaync = {
    enable = false;
  };

  home.file."waybar-modules" = {
    executable = false;
    source = ./waybar/modules;
    target = "${config.xdg.configHome}/waybar/modules";
  };

  programs.waybar = {
    enable = true;

    style = ./waybar/style.css;

    settings = {
      default = {
        include = "~/.config/waybar/modules";
        layer = "bottom";
        exclusive = true;
        ipc = true;
        "margin-left" = 8;
        "margin-right" = 8;
        position = "bottom";
        height = 30;

        modules-left = [
          "sway/workspaces#4"
          "custom/separator#dot-line"
          "cpu"
          "custom/separator#dot-line"
          "temperature"
          "custom/separator#dot-line"
          "memory"
          "custom/separator#dot-line"
          "disk"
          "custom/separator#dot-line"
          "custom/separator#blank_2"
          "custom/gpu"
          "custom/separator#blank_2"
          "custom/separator#dot-line"
          "backlight"
          "battery"
          "power-profiles-daemon"
          "custom/separator#dot-line"
          "custom/separator#blank_2"
          "custom/cava_mviz"
          "custom/separator#blank_3"
        ];

        modules-center = [
          "sway/mode"
          "clock"
          "custom/separator#dot-line"
          "custom/weather"
        ];

        modules-right = [
          "network#speed"
          "custom/separator#dot-line"
          "custom/swaync"
          "custom/separator#dot-line"
          "idle_inhibitor"
          "custom/separator#dot-line"
          "custom/adaptive_light"
          "custom/separator#dot-line"
          "tray"
          "custom/separator#dot-line"
          "bluetooth"
          "custom/separator#dot-line"
          "pulseaudio"
        ];

        # Modules Center
        "sway/mode" = {
          format = "<span style=\"italic\">{}</span>";
          tooltip = false;
        };

        "custom/weather" = {
          icon-size = 42;
          format = "{icon} {text}";
          tooltip = true;
          interval = 3600;
          exec = "${config.xdg.configHome}/waybar/scripts/get_weather.sh";
          return-type = "json";
        };

        "temperature" = {
          interval = 5;
          tooltip = true;
          hwmon-path = lib.mkDefault "/sys/class/hwmon/hwmon6/temp1_input";
          critical-threshold = 75;
          format = "{icon} {temperatureC:2}°C";
          format-icons = [ "" "" "" ];
        };

        "cpu" = {
          interval = 1;
          format = " {usage:2}%";
          "format-alt-click" = "click-right";
	        "format-alt" = " {icon0}{icon1}{icon2}{icon3} {usage:>2}%";
	        "format-icons" = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
          states = {
            warning = 70;
            critical = 90;
          };
          min-length = 5;
          on-click = "${pkgs.sway}/bin/swaymsg exec \\$once \\$term_float htop";
          tooltip = true;
        };

        "memory" = {
          interval = 3;
          format = " {avail:2.0f}GB";
          states = {
            warning = 70;
            critical = 90;
          };
          on-click = "${pkgs.sway}/bin/swaymsg exec \\$once \\$term_float htop";
          tooltip = true;
          "tooltip-format" = "{used:0.1f}GB/{total:0.1f}G";
        };

        "disk" = {
          "interval" = 30;
          "format" = " {specific_free:2.0f}GB";
          "tooltip" = true;
	        "tooltip-format" = "{used} used out of {total} on {path} ({percentage_used}%)";
          "unit" = "GB";
          "states" = {
            warning = 70;
            critical = 90;
          };
          "disk" = "/home";
        };

        "custom/adaptive_light" = {
          interval = "once";
          tooltip = true;
          return-type = "json";
          format = "{icon}";
          format-icons = {
            on = "";
            off = "";
          };
          exec = "${config.xdg.configHome}/waybar/scripts/wluma.sh";
          on-click = "${config.xdg.configHome}/waybar/scripts/wluma.sh toggle; pkill -RTMIN+12 waybar";
          exec-if = "${config.xdg.configHome}/waybar/scripts/wluma.sh check";
          signal = 12;
        };

        "clock" = {
          interval = 1;
          format = "{:%H:%M:%S %d-%m-%Y}";
          format-alt = " {:%H:%M:%S   %Y, %d %B, %A";
          "format-alt-click" = "click-right";
          "tooltip-format" = "<tt><small>{calendar}</small></tt>";
          calendar = {
            "mode" = "year";
            "mode-mon-col" = 3;
            "weeks-pos" = "right";
            "on-scroll" = 1;
            "format" = {
              "months" = "<span color='#ffead3'><b>{}</b></span>";
              "days" = "<span color='#ecc6d9'><b>{}</b></span>";
              "weeks" = "<span color='#99ffdd'><b>{}</b></span>";
              "weekdays" = "<span color='#ffcc66'><b>{}</b></span>";
              "today" = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          "actions" = {
            "on-click-right" = "mode";
            "on-click-forward" = "tz_up";
            "on-click-backward" = "tz_down";
            "on-scroll-up" = "shift_up";
            "on-scroll-down" = "shift_down";
          };
        };

        "custom/gpu" = {
          interval = 1;
          exec = "echo \"$(cat /sys/class/hwmon/hwmon*/device/gpu_busy_percent)% $(echo $(( $(cat /sys/class/hwmon/hwmon*/device/mem_info_vram_total) - $(cat /sys/class/hwmon/hwmon*/device/mem_info_vram_used) )) | awk '{printf \"%.0fGB\", $1/1024/1024/1024}')\"";
          "return-type" = "";
          format = "🖵 {text}";
          on-click = "${pkgs.sway}/bin/swaymsg exec \\$once \\$term_float amdgpu_top";
          tooltip = true;
        };

      };
    };
  };
}
