{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.wayland.windowManager.sway;
  lockCommand = "${pkgs.swaylock-fancy}/bin/swaylock-fancy -F";
in
{
  options = {
    services.sway = {
      scale = mkOption {
        type = with types; uniq float;
        default = 1.0;
        description = ''
          Scale set for window manager and apps.
        '';
      };
    };
  };

  config = {
    # Wallpaper
    home.file."wallpapers-eva-notes.png" = {
      executable = true;
      source = ../../common/wallpapers/eva-notes.png;
      target = "${config.xdg.configHome}/sway/wallpapers/eva-notes.png";
    };
    home.file."wallpapers-eva-notes-flipped.png" = {
      executable = true;
      source = ../../common/wallpapers/eva-notes-flipped.png;
      target = "${config.xdg.configHome}/sway/wallpapers/eva-notes-flipped.png";
    };

    # Sway Theme
    home.file."sway-theme-definitions" = {
      executable = true;
      source = ./sway/theme-definitions;
      target = "${config.xdg.configHome}/sway/theme-definitions";
    };
    # Sway Modes
    home.file."sway-modes-resize" = {
      executable = true;
      source = ./sway/modes/resize;
      target = "${config.xdg.configHome}/sway/modes/resize";
    };
    home.file."sway-modes-screenshot" = {
      executable = true;
      source = ./sway/modes/screenshot;
      target = "${config.xdg.configHome}/sway/modes/screenshot";
    };
    home.file."sway-modes-shutdown" = {
      executable = true;
      source = ./sway/modes/shutdown;
      target = "${config.xdg.configHome}/sway/modes/shutdown";
    };

    # Scripts
    home.file."sway-grimshot.sh" = {
      executable = true;
      source = ./sway/scripts/grimshot.sh;
      target = "${config.xdg.configHome}/sway/scripts/grimshot.sh";
    };
    home.file."sway-wob.sh" = {
      executable = true;
      source = ./sway/scripts/wob.sh;
      target = "${config.xdg.configHome}/sway/scripts/wob.sh";
    };

    home.packages = with pkgs; [
      grim
      libnotify
      slurp
      wl-clipboard
      wob
      swaycwd
    ];

    wayland.windowManager.sway = {
      enable = true;
      checkConfig = false;
      swaynag = {
        enable = true;
        settings = {
          "" = {
            edge = "top";
            font = "DM Sans 11";
          };

          green = {
            edge = "top";
            background = "00AA00";
            text = "FFFFFF";
            button-background = "00CC00";
            message-padding = 10;
          };
        };
      };
      # Sway config
      config = rec {
        modifier = "Mod4";
        left = "h";
        down = "j";
        up = "k";
        right = "l";
        terminal = "${pkgs.wezterm}/bin/wezterm";
        menu = "${pkgs.wofi}/bin/wofi --show drun";

        fonts = {
          names = [ "Hack" "Noto Color Emoji" ];
          size = 8.0;
          style = "Normal";
        };

        colors = {
          focused = {
            border = "#3b1261";
            background = "#3b1261";
            text = "#ffffff";
            indicator = "#662b9c";
            childBorder = "#662b9c";
          };
          focusedInactive = {
            border = "#333333";
            background = "#5f676a";
            text = "#ffffff";
            indicator = "#484e50";
            childBorder = "#484e50";
          };
          unfocused = {
            border = "#222222";
            background = "#222222";
            text = "#888888";
            indicator = "#292d2e";
            childBorder = "#292d2e";
          };
          urgent = {
            border = "#2f343a";
            background = "#900000";
            text = "#ffffff";
            indicator = "#900000";
            childBorder = "#900000";
          };
        };

        workspaceAutoBackAndForth = true;

        assigns = {
          "$ws1" = [
            { class = "YouTube Music"; }
          ];
          "$ws16" = [
            { app_id = "thunderbird"; }
          ];
          "$ws18" = [
            { class = "Steam"; }
          ];
          "$ws20" = [
            { class = "discord"; }
            { class = "vesktop"; }
            { class = "Slack"; }
            { class = "Ferdium"; }
          ];
        };
        gaps = {
          smartGaps = true;

          inner = 3;
          outer = 3;
        };

        # Keyboard
        input = {
          "type:keyboard" = {
            xkb_options = "grp_led:caps";
            xkb_layout = "de(nodeadkeys)";
            xkb_variant = ",";
          };
        };

        floating = {
          border = 2;
          titlebar = false;
        };

        focus = {
          followMouse = "no";
        };

        modes = { };

        keybindings = {
          "${cfg.config.modifier}+Mod1+c" = "reload";
          "${cfg.config.modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";

          "${cfg.config.modifier}+Shift+q" = "kill";
          "${cfg.config.modifier}+Return" = "exec ${cfg.config.terminal} start --cwd '$(${pkgs.swaycwd}/bin/swaycwd 2>/dev/null || echo $HOME)'";
          "${cfg.config.modifier}+Shift+Return" = "exec ${cfg.config.terminal}";
          "${cfg.config.modifier}+d" = "exec ${cfg.config.menu} --show drun";

          "${cfg.config.modifier}+Left" = "focus left";
          "${cfg.config.modifier}+Down" = "focus down";
          "${cfg.config.modifier}+Up" = "focus up";
          "${cfg.config.modifier}+Right" = "focus right";

          "${cfg.config.modifier}+Shift+${cfg.config.left}" = "move left";
          "${cfg.config.modifier}+Shift+${cfg.config.down}" = "move down";
          "${cfg.config.modifier}+Shift+${cfg.config.up}" = "move up";
          "${cfg.config.modifier}+Shift+${cfg.config.right}" = "move right";

          "${cfg.config.modifier}+Shift+Left" = "move left";
          "${cfg.config.modifier}+Shift+Down" = "move down";
          "${cfg.config.modifier}+Shift+Up" = "move up";
          "${cfg.config.modifier}+Shift+Right" = "move right";

          "${cfg.config.modifier}+h" = "splith";
          "${cfg.config.modifier}+v" = "splitv";
          "${cfg.config.modifier}+f" = "fullscreen toggle";

          "${cfg.config.modifier}+s" = "layout stacking";
          "${cfg.config.modifier}+w" = "layout tabbed";
          "${cfg.config.modifier}+e" = "layout toggle split";

          "${cfg.config.modifier}+Shift+space" = "floating toggle";
          "${cfg.config.modifier}+space" = "focus mode_toggle";

          # Modes are included via the ~/.config/sway/modes/* include

          # change borders
          "${cfg.config.modifier}+u" = "border none";
          "${cfg.config.modifier}+y" = "border pixel 2";
          "${cfg.config.modifier}+n" = "border normal";
          # Start Applications
          "${cfg.config.modifier}+F2" = "exec ${pkgs.librewolf}/bin/librewolf";
          "${cfg.config.modifier}+F3" = "exec ${pkgs.pcmanfm}/bin/pcmanfm";
          "${cfg.config.modifier}+F4" = "exec ${pkgs.pcmanfm}/bin/codium";
          "${cfg.config.modifier}+Ctrl+m" = "exec ${pkgs.easyeffects}/bin/easyeffects";
          ## Joplin
          "${cfg.config.modifier}+F5" = "[con_mark=\"Joplin\"] scratchpad show";
          "${cfg.config.modifier}+Shift+F5" = "[class=\"Joplin\"] mark -add Joplin, move scratchpad";

          # workspace back and forth (with/without active container)
          "${cfg.config.modifier}+b" = "workspace back_and_forth";
          "${cfg.config.modifier}+Shift+b" = "move container to workspace back_and_forth; workspace back_and_forth";

          # whole workspace to other desktop
          "${cfg.config.modifier}+shift+n" = "move workspace to output up";
          "${cfg.config.modifier}+shift+m" = "move workspace to output down";
          "${cfg.config.modifier}+shift+d" = "move workspace to output left";
          "${cfg.config.modifier}+shift+f" = "move workspace to output right";

          # toggle sticky
          "${cfg.config.modifier}+Shift+s" = "sticky toggle";

          # focus the parent container
          "${cfg.config.modifier}+a" = "focus parent";

          # navigate workspaces next / previous
          "${cfg.config.modifier}+Ctrl+Right" = "workspace next";
          "${cfg.config.modifier}+Ctrl+Left" = "workspace prev";

          # Move focused container to workspace
          "${cfg.config.modifier}+Ctrl+1" = "move container to workspace $ws1";
          "${cfg.config.modifier}+Ctrl+2" = "move container to workspace $ws2";
          "${cfg.config.modifier}+Ctrl+3" = "move container to workspace $ws3";
          "${cfg.config.modifier}+Ctrl+4" = "move container to workspace $ws4";
          "${cfg.config.modifier}+Ctrl+5" = "move container to workspace $ws5";
          "${cfg.config.modifier}+Ctrl+6" = "move container to workspace $ws6";
          "${cfg.config.modifier}+Ctrl+7" = "move container to workspace $ws7";
          "${cfg.config.modifier}+Ctrl+8" = "move container to workspace $ws8";
          "${cfg.config.modifier}+Ctrl+9" = "move container to workspace $ws9";
          "${cfg.config.modifier}+Ctrl+0" = "move container to workspace $ws10";
          "${cfg.config.modifier}+Mod1+Ctrl+1" = "move container to workspace $ws11";
          "${cfg.config.modifier}+Mod1+Ctrl+2" = "move container to workspace $ws12";
          "${cfg.config.modifier}+Mod1+Ctrl+3" = "move container to workspace $ws13";
          "${cfg.config.modifier}+Mod1+Ctrl+4" = "move container to workspace $ws14";
          "${cfg.config.modifier}+Mod1+Ctrl+5" = "move container to workspace $ws15";
          "${cfg.config.modifier}+Mod1+Ctrl+6" = "move container to workspace $ws16";
          "${cfg.config.modifier}+Mod1+Ctrl+7" = "move container to workspace $ws17";
          "${cfg.config.modifier}+Mod1+Ctrl+8" = "move container to workspace $ws18";
          "${cfg.config.modifier}+Mod1+Ctrl+9" = "move container to workspace $ws19";
          "${cfg.config.modifier}+Mod1+Ctrl+0" = "move container to workspace $ws20";

          # Move to workspace with focused container
          "${cfg.config.modifier}+Shift+1" = "move container to workspace $ws1, exec $focus_ws $ws1";
          "${cfg.config.modifier}+Shift+2" = "move container to workspace $ws2, exec $focus_ws $ws2";
          "${cfg.config.modifier}+Shift+3" = "move container to workspace $ws3, exec $focus_ws $ws3";
          "${cfg.config.modifier}+Shift+4" = "move container to workspace $ws4, exec $focus_ws $ws4";
          "${cfg.config.modifier}+Shift+5" = "move container to workspace $ws5, exec $focus_ws $ws5";
          "${cfg.config.modifier}+Shift+6" = "move container to workspace $ws6, exec $focus_ws $ws6";
          "${cfg.config.modifier}+Shift+7" = "move container to workspace $ws7, exec $focus_ws $ws7";
          "${cfg.config.modifier}+Shift+8" = "move container to workspace $ws8, exec $focus_ws $ws8";
          "${cfg.config.modifier}+Shift+9" = "move container to workspace $ws9, exec $focus_ws $ws9";
          "${cfg.config.modifier}+Shift+0" = "move container to workspace $ws10, exec $focus_ws $ws10";
          "${cfg.config.modifier}+Mod1+Shift+1" = "move container to workspace $ws11, exec $focus_ws $ws11";
          "${cfg.config.modifier}+Mod1+Shift+2" = "move container to workspace $ws12, exec $focus_ws $ws12";
          "${cfg.config.modifier}+Mod1+Shift+3" = "move container to workspace $ws13, exec $focus_ws $ws13";
          "${cfg.config.modifier}+Mod1+Shift+4" = "move container to workspace $ws14, exec $focus_ws $ws14";
          "${cfg.config.modifier}+Mod1+Shift+5" = "move container to workspace $ws15, exec $focus_ws $ws15";
          "${cfg.config.modifier}+Mod1+Shift+6" = "move container to workspace $ws16, exec $focus_ws $ws16";
          "${cfg.config.modifier}+Mod1+Shift+7" = "move container to workspace $ws17, exec $focus_ws $ws17";
          "${cfg.config.modifier}+Mod1+Shift+8" = "move container to workspace $ws18, exec $focus_ws $ws18";
          "${cfg.config.modifier}+Mod1+Shift+9" = "move container to workspace $ws19, exec $focus_ws $ws19";
          "${cfg.config.modifier}+Mod1+Shift+0" = "move container to workspace $ws20, exec $focus_ws $ws20";

          # switch to workspace
          "${cfg.config.modifier}+1" = "workspace $ws1";
          "${cfg.config.modifier}+2" = "workspace $ws2";
          "${cfg.config.modifier}+3" = "workspace $ws3";
          "${cfg.config.modifier}+4" = "workspace $ws4";
          "${cfg.config.modifier}+5" = "workspace $ws5";
          "${cfg.config.modifier}+6" = "workspace $ws6";
          "${cfg.config.modifier}+7" = "workspace $ws7";
          "${cfg.config.modifier}+8" = "workspace $ws8";
          "${cfg.config.modifier}+9" = "workspace $ws9";
          "${cfg.config.modifier}+0" = "workspace $ws10";
          "${cfg.config.modifier}+Mod1+1" = "workspace $ws11";
          "${cfg.config.modifier}+Mod1+2" = "workspace $ws12";
          "${cfg.config.modifier}+Mod1+3" = "workspace $ws13";
          "${cfg.config.modifier}+Mod1+4" = "workspace $ws14";
          "${cfg.config.modifier}+Mod1+5" = "workspace $ws15";
          "${cfg.config.modifier}+Mod1+6" = "workspace $ws16";
          "${cfg.config.modifier}+Mod1+7" = "workspace $ws17";
          "${cfg.config.modifier}+Mod1+8" = "workspace $ws18";
          "${cfg.config.modifier}+Mod1+9" = "workspace $ws19";
          "${cfg.config.modifier}+Mod1+0" = "workspace $ws20";

          # Lock screen
          "Mod1+l" = "exec ${lockCommand}";

          # Make the currently focused window a scratchpad
          "${cfg.config.modifier}+Shift+plus" = "mark --add scratch_plus, move scratchpad";
          "${cfg.config.modifier}+Shift+minus" = "mark --add scratch_minus, move scratchpad";

          # Show the first scratchpad window
          "${cfg.config.modifier}+plus" = "[con_mark=\"^scratch_plus$\"] scratchpad show";
          "${cfg.config.modifier}+minus" = "[con_mark=\"^scratch_minus$\"] scratchpad show";
        };

        window = {
          hideEdgeBorders = "smart";
          border = 2;
          titlebar = false;

          # for_windows
          commands = [
            # Window Transparency
            {
              command = "opacity 0.96";
              criteria = {
                app_id = ".*";
              };
            }
            {
              command = "opacity 0.96";
              criteria = {
                class = ".*";
              };
            }
            {
              command = "opacity 1.0";
              criteria = {
                class = "parsecd";
              };
            }
            # Switch to workspace with urgent window automatically
            {
              criteria = {
                urgent = "latest";
              };
              command = "focus";
            }
            # Floating mode overrides
            {
              criteria = {
                title = "QNote:.*";
              };
              command = "floating enable";
            }
            {
              criteria = {
                instance = "lxappearance";
              };
              command = "floating enable";
            }
            {
              criteria = {
                app_id = "pamac-manager";
              };
              command = "floating enable";
            }
            {
              criteria = {
                app_id = "blueberry.py";
              };
              command = "floating enable";
            }
            {
              criteria = {
                app_id = "librewolf";
                title = "^Library$";
              };
              command = "floating enable, border pixel 1, sticky enable";
            }
            {
              criteria = {
                app_id = "thunderbird";
                title = ".*Reminder";
              };
              command = "floating enable";
            }
            {
              criteria = {
                app_id = "floating_shell_portrait";
              };
              command = "floating enable, border pixel 1, sticky enable, resize set width 30 ppt height 40 ppt";
            }
            {
              criteria = {
                app_id = "floating_shell";
              };
              command = "floating enable, border pixel 1, sticky enable";
            }
            {
              criteria = {
                app_id = "Manjaro.manjaro-settings-manager";
              };
              command = "floating enable";
            }
            {
              criteria = {
                app_id = "";
                title = "Picture in picture";
              };
              command = "floating enable, sticky enable";
            }
            {
              criteria = {
                app_id = "";
                title = "Picture-in-Picture";
              };
              command = "floating enable, sticky enable";
            }
            {
              criteria = {
                app_id = "xsensors";
              };
              command = "floating enable";
            }
            {
              criteria = {
                title = "Save File";
              };
              command = "floating enable";
            }
            {
              criteria = {
                title = "Firefox — Sharing Indicator";
              };
              command = "floating enable";
            }
            {
              criteria = {
                title = "Librewolf — Sharing Indicator";
              };
              command = "floating enable";
            }
            {
              criteria = {
                app_id = "";
                title = ".* is sharing your screen.";
              };
              command = "floating enable";
            }
            {
              criteria = {
                title = "^wlay$";
              };
              command = "floating enable";
            }
            ## Custom Floating mode
            {
              criteria = {
                class = "Simple-scan";
              };
              command = "floating enable";
            }
            {
              criteria = {
                class = "Joplin";
              };
              command = "floating enable border pixel 2, mark -add Joplin, move scratchpad";
            }
            {
              criteria = {
                window_role = "GtkFilechooserdialog";
              };
              command = "floating enable";
            }
            {
              criteria = {
                app_id = "lxqt-openssh-askpass";
              };
              command = "floating enable";
            }
            {
              criteria = {
                class = "Cssh";
              };
              command = "floating enable";
            }
            {
              criteria = {
                class = "YouTube Music";
              };
              command = "floating enable";
            }
            # inhibit idle
            {
              criteria = {
                app_id = "microsoft teams - preview";
              };
              command = "inhibit_idle fullscreen";
            }
          ];
        };

        # Status bar(s)
        bars = [{
          id = "default";
          command = "${pkgs.waybar}/bin/waybar";
          position = "bottom";
        }];

        startup = [
          { command = "joplin-desktop"; }
          { command = "sleep 4 && ferdium"; }
          { command = "sleep 2 && vesktop"; }
        ];

        # Display device configuration
        output = {
          # Laptop Screens
          eDP-1 = {
            # Set HIDP scale (pixel integer scaling)
            scale = lib.strings.floatToString config.services.sway.scale;
            bg = "~/.config/sway/wallpapers/eva-notes.png fill";
          };
          eDP-2 = {
            # Set HIDP scale (pixel integer scaling)
            scale = lib.strings.floatToString config.services.sway.scale;
            bg = "~/.config/sway/wallpapers/eva-notes.png fill";
          };

          # Reaper
          DP-1 = {
            pos = "0,0";
            res = "2560x1440@239.970Hz";
            # Set HIDP scale (pixel integer scaling)
            scale = lib.strings.floatToString config.services.sway.scale;
            bg = "~/.config/sway/wallpapers/eva-notes.png fill";
          };
          DP-2 = {
            pos = "2560,0";
            res = "2560x1440@239.970Hz";
            # Set HIDP scale (pixel integer scaling)
            scale = lib.strings.floatToString config.services.sway.scale;
            bg = "~/.config/sway/wallpapers/eva-notes.png fill";
          };
          DP-3 = {
            pos = "5120,0";
            res = "2560x1440@239.970Hz";
            # Set HIDP scale (pixel integer scaling)
            scale = lib.strings.floatToString config.services.sway.scale;
            bg = "~/.config/sway/wallpapers/eva-notes.png fill";
          };
        };

      };

      extraConfigEarly = ''
        set $mod ${cfg.config.modifier}

        # Add --to-code to bindsym, support for non-latin layouts
        set $bindsym bindsym --to-code

        # For user's convenience, the same for unbindsym
        set $unbindsym unbindsym --to-code

        # workspace names
        set $ws1 number 1
        set $ws2 number 2
        set $ws3 number 3
        set $ws4 number 4
        set $ws5 number 5
        set $ws6 number 6
        set $ws7 number 7
        set $ws8 number 8
        set $ws9 number 9
        set $ws10 number 10
        set $ws11 number 11
        set $ws12 number 12
        set $ws13 number 13
        set $ws14 number 14
        set $ws15 number 15
        set $ws16 number 16
        set $ws17 number 17
        set $ws18 number 18
        set $ws19 number 19
        set $ws20 number 20

        # Load theme file
        include ${config.xdg.configHome}/sway/theme-definitions

        # Definitions
        set $term_float ${pkgs.wezterm}/bin/wezterm start --class floating_shell
        set $focus_after_move true
        set $focus_ws [ $focus_after_move == 'true' ] && swaymsg workspace

        set $locking ${lockCommand}

        set $onscreen_bar ${config.xdg.configHome}/sway/scripts/wob.sh "#bb88eb" "#ffffff"

        set $bluetooth $once $term_float blueman-manager

        # brightness control
        set $brightness_step bash -c 'echo $(( $(light -Mr) / 100 * 5 < 1 ? 1 : $(( $(light -Mr) / 100 * 5 )) ))'
        set $brightness_up light -r -A $($brightness_step) && $onscreen_bar $(light -G | cut -d'.' -f1)
        set $brightness_down light -r -U $($brightness_step) && $onscreen_bar $(light -G | cut -d'.' -f1)

        # audio control
        set $sink_volume pactl get-sink-volume @DEFAULT_SINK@ | grep '^Volume:' | cut -d / -f 2 | tr -d ' ' | sed 's/%//'
        set $source_volume pactl get-source-volume @DEFAULT_SOURCE@ | grep '^Volume:' | cut -d / -f 2 | tr -d ' ' | sed 's/%//'
        set $volume_down $onscreen_bar $(pactl set-sink-volume @DEFAULT_SINK@ -5% && $sink_volume)
        set $volume_up $onscreen_bar $(pactl set-sink-volume @DEFAULT_SINK@ +5% && $sink_volume)
        set $volume_mute $onscreen_bar $(pactl set-sink-mute @DEFAULT_SINK@ toggle && pactl get-sink-mute @DEFAULT_SINK@ | sed -En "/no/ s/.*/$($sink_volume)/p; /yes/ s/.*/0/p")
        set $mic_mute $onscreen_bar $(pactl set-source-mute @DEFAULT_SOURCE@ toggle && pactl get-source-mute @DEFAULT_SOURCE@ | sed -En "/no/ s/.*/$($source_volume)/p; /yes/ s/.*/0/p")

        # screenshot
        set $grimshot ${config.xdg.configHome}/sway/scripts/grimshot.sh
        set $screenshot_screen_clipboard $grimshot --notify copy output
        set $screenshot_screen_file $grimshot --notify save output
        set $screenshot_selection_clipboard $grimshot --notify copy window
        set $screenshot_selection_file $grimshot --notify save window

        # laptop buttons
        $bindsym --locked XF86AudioRaiseVolume exec $volume_up
        $bindsym --locked XF86AudioLowerVolume exec $volume_down
        $bindsym --locked XF86AudioMute exec $volume_mute
        $bindsym XF86AudioMicMute exec $mic_mute
        $bindsym --locked XF86MonBrightnessUp exec $brightness_up
        $bindsym --locked XF86MonBrightnessDown exec $brightness_down
        $bindsym --locked XF86AudioPlay exec playerctl play-pause
        $bindsym XF86AudioNext exec playerctl next
        $bindsym XF86AudioPrev exec playerctl previous
        $bindsym XF86Search exec $menu
        $bindsym XF86PowerOff exec $shutdown
        $bindsym XF86TouchpadToggle input type:touchpad events toggle enabled disabled

        # Drag floating windows by holding down $mod and left mouse button.
        # Resize them with right mouse button + $mod.
        # Despite the name, also works for non-floating windows.
        # Change normal to inverse to use left mouse button for resizing and right
        # mouse button for dragging.
        floating_modifier $mod normal

        titlebar_border_thickness 6
        titlebar_padding 0
      '';

      extraConfig = ''
        # Enable modes
        include ${config.xdg.configHome}/sway/modes/*

        exec --no-startup-id swaymsg workspace 1
      '';

      extraSessionCommands = ''
        export XDG_SESSION_TYPE=wayland
        export XDG_CURRENT_DESKTOP=sway
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        export QT_AUTO_SCREEN_SCALE_FACTOR=0
        export QT_SCALE_FACTOR=${lib.strings.floatToString config.services.sway.scale}
        export GDK_SCALE=${lib.strings.floatToString config.services.sway.scale}
        export GDK_DPI_SCALE=${lib.strings.floatToString config.services.sway.scale}
        export MOZ_ENABLE_WAYLAND=1
        export _JAVA_AWT_WM_NONREPARENTING=1

        export GNOME_KEYRING_CONTROL=/run/user/$UID/keyring
        export SSH_AUTH_SOCK=/run/user/$UID/keyring/ssh
      '';

      wrapperFeatures = {
        base = true;
        gtk = true;
      };
    };

    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-fancy;
      settings = {
        color = "000000";
        font-size = 20;
        indicator-idle-visible = false;
        indicator-radius = 100;
        line-color = "ffffff";
        show-failed-attempts = true;
      };
    };

    services.swayidle = {
      enable = true;
      events = [
        { event = "before-sleep"; command = lockCommand; }
        { event = "lock"; command = lockCommand; }
      ];
      timeouts = [
        {
          timeout = 290;
          command = "${pkgs.libnotify}/bin/notify-send 'Locking in 10 seconds' -t 9000";
        }
        { timeout = 300; command = lockCommand; }
      ];
    };
  };
}
