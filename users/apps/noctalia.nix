{ inputs, pkgs, ... }:

{
  home-manager.users.atrost = {
    imports = [ inputs.noctalia.homeModules.default ];
    home.packages = [ pkgs.gpu-screen-recorder ];

    home.file."noctalia-face" = {
      executable = true;
      source = ../../assets/.face;
      target = ".face";
    };

    programs.noctalia = {
      enable = true;
      settings = {
        accessibility = {
          high_contrast = true;
          ui_scale = 0.9;
        };
        bar.main = {
          background_opacity = 0.65;
          capsule = true;
          capsule_opacity = 0.95;
          center = [ "taskbar" ];
          end = [
            "network-vpn"
            "network"
            "sysmon-network-rx"
            "sysmon-network-tx"
            "battery"
            "caffeine"
            "bluetooth"
            "notifications"
            "privacy"
            "input_volume"
            "output_volume"
            "tray"
            "clock"
            "session"
          ];
          margin_edge = 0;
          margin_ends = 0;
          padding = 2;
          position = "top";
          radius = 12;
          start = [
            "sysmon-cpu"
            "temp"
            "ram"
            "brightness"
            "nightlight"
            "power_profile"
            "audio_visualizer"
            "media"
            "weather"
          ];
          widget_spacing = 6;
          thickness = 24;
        };
        brightness.enable_ddcutil = false;
        desktop_widgets.enabled = false;
        dock.enabled = false;
        idle = {
          behavior_order = [
            "lock"
            "screen-off"
            "lock-and-suspend"
          ];
          behavior = {
            lock = {
              action = "lock";
              enabled = true;
              timeout = 300.0;
            };
            "lock-and-suspend" = {
              action = "lock_and_suspend";
              enabled = false;
              timeout = 900.0;
            };
            "screen-off" = {
              action = "screen_off";
              enabled = false;
              timeout = 660.0;
            };
          };
        };
        location = {
          address = "Karlsruhe, Germany";
          auto_locate = false;
        };
        lockscreen = {
          blur_intensity = 0.0;
          blurred_desktop = false;
          enabled = true;
          fingerprint = false;
          tint_intensity = 0.0;
          transition = [ ];
        };
        lockscreen_widgets = {
          enabled = true;
          schema_version = 2;
          widget_order = [
            "lockscreen-login-box@DP-1"
            "lockscreen-login-box@DP-2"
            "lockscreen-login-box@eDP-1"
            "lockscreen-widget-0000000000000002"
          ];
          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };

          widget."lockscreen-login-box@DP-2" = {
            box_height = 196.0;
            box_width = 810.0;
            cx = 1280.0;
            cy = 1258.0;
            output = "DP-2";
            placement_height = 1440.0;
            placement_width = 2560.0;
            rotation = 0.0;
            type = "login_box";
            settings = {
              background_color = "surface_variant";
              background_opacity = 0.88;
              background_radius = 12.0;
              center_password_text = false;
              input_opacity = 1.0;
              input_radius = 6.0;
              layout = "regular";
              show_caps_lock = true;
              show_keyboard_layout = true;
              show_login_button = true;
              show_media = true;
              show_session_buttons = true;
              show_unlock_hint = false;
              show_weather = true;
            };
          };

          widget."lockscreen-login-box@eDP-1" = {
            box_height = 196.0;
            box_width = 810.0;
            cx = 1280.0;
            cy = 1418.0;
            output = "eDP-1";
            placement_height = 1600.0;
            placement_width = 2560.0;
            rotation = 0.0;
            type = "login_box";
            settings = {
              background_color = "surface_variant";
              background_opacity = 0.88;
              background_radius = 12.0;
              center_password_text = false;
              input_opacity = 1.0;
              input_radius = 6.0;
              layout = "regular";
              show_caps_lock = true;
              show_keyboard_layout = true;
              show_login_button = true;
              show_media = true;
              show_session_buttons = true;
              show_unlock_hint = false;
              show_weather = true;
            };
          };
        };
        nightlight = {
          enabled = true;
          temperature_day = 6500;
          temperature_night = 4000;
        };
        notification = {
          background_opacity = 1.0;
          enable_daemon = true;
          keep_dismissed_in_history = false;
          layer = "overlay";
          monitors = [ "DP-1" ];
          position = "top_right";
          history_retention_hours = 24;
        };
        osd = {
          background_opacity = 1.0;
          hide_delay_ms = 2000;
          layer = "overlay";
          position = "top_right";
          monitors = [ "DP-1" ];
          kinds = {
            media = false;
          };
        };
        plugins = {
          auto_update = "none";
          enabled = [ "noctalia/screen_recorder" ];
          source = [
            {
              enabled = true;
              kind = "git";
              location = "https://github.com/noctalia-dev/official-plugins";
              name = "official";
            }
          ];
        };
        shell = {
          avatar_path = "/home/atrost/.face";
          clipboard_enabled = false;
          font_family = "Hack";
          telemetry_enabled = false;
          animation.enabled = false;
          launcher = {
            app_grid = false;
            auto_paste = "off";
            categories = true;
            compact = true;
            fetch_exchange_rates = false;
            sort_by_usage = true;
            providers = {
              session.global = true;
              windows.global = false;
            };
          };
          panel = {
            borders = false;
            control_center_placement = "attached";
            polkit_position = "center";
            shadow = false;
            transparency_mode = "glass";
            session_placement = "floating";
            session_position = "center";
          };
          screenshot = {
            confirm_region = true;
            remember_last_region = true;
          };
          shadow.alpha = 0.0;
        };
        theme = {
          builtin = "Catppuccin";
          community_palette = "Seoul256 Hard";
          mode = "dark";
          pure_black_dark = true;
          shell_mode = "dark";
          source = "community";
          wallpaper_scheme = "faithful";
          templates = {
            builtin_ids = [
              "gtk"
              "qt"
              "sway"
            ];
            enable_builtin_templates = true;
          };
        };
        wallpaper = {
          directory = "/home/atrost/Pictures/Wallpapers";
          edge_smoothness = 0.05;
          enabled = true;
          fill_color = "#000000";
          fill_mode = "crop";
          transition = [ "fade" ];
          transition_duration = 1500;
          transition_on_startup = false;
          automation = {
            enabled = false;
            interval_seconds = 300;
            order = "alphabetical";
            recursive = true;
          };
          default.path = "/home/atrost/Pictures/Wallpapers/eva-red-steel.jpg";
          last.path = "/home/atrost/Pictures/Wallpapers/eva-red-steel.jpg";
          monitors.eDP-1.path = "/home/atrost/Pictures/Wallpapers/eva-red-steel.jpg";
        };
        weather = {
          effects = true;
          enabled = true;
          unit = "celsius";
        };
        widget = {
          audio_visualizer = {
            width = 125;
            show_when_idle = true;
          };
          battery.warning_threshold = 30;
          clock = {
            format = "{:%H:%M:%S %a %d.%m.%Y}";
            tooltip_format = "{:%H:%M:%S %a, %b %d}";
          };
          media = {
            max_width = 145;
            show_album_art = true;
            show_progress_ring = true;
          };
          recorder.type = "noctalia/screen_recorder:recorder";
          network = {
            show_label = false;
            vpn_status = "hidden";
            actions = {
              right = "none";
            };
          };
          "network-vpn" = {
            show_vpn_label = true;
            type = "network";
            actions = {
              right = "none";
            };
          };
          "sysmon-cpu" = {
            metric = "cpu";
            type = "sysmon";
          };
          "sysmon-network-rx" = {
            metric = "network";
            stat = "net_rx";
            type = "sysmon";
          };
          "sysmon-network-tx" = {
            metric = "network";
            stat = "net_tx";
            type = "sysmon";
          };
          taskbar = {
            group_by_workspace = true;
            hide_empty_workspaces = true;
          };
          workspaces = {
            active_pill_size = 1.0;
          };
        };
      };
    };
  };
}
