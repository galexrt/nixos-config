{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  workspaceKey = workspace:
    if workspace <= 9 then
      "Mod+${toString workspace}"
    else if workspace == 10 then
      "Mod+0"
    else if workspace <= 19 then
      "Mod+Alt+${toString (workspace - 10)}"
    else
      "Mod+Alt+0";
  moveWorkspaceKey = workspace:
    if workspace <= 9 then
      "Mod+Shift+${toString workspace}"
    else if workspace == 10 then
      "Mod+Shift+0"
    else if workspace <= 19 then
      "Mod+Shift+Alt+${toString (workspace - 10)}"
    else
      "Mod+Shift+Alt+0";
in
{
  home-manager.users.atrost = lib.mkIf config.myConfig.desktop.umbriel.enable {
    imports = [ inputs.umbriel.homeModules.default ];

    programs.umbriel = {
      enable = true;

      settings = {
        general = {
          autostart = [
            "noctalia"
            "joplin-desktop"
            "vesktop"
            "thunderbird"
            "Chiri"
          ];
          xwayland_native_resolution = true;
        };

        appearance = {
          prefer_no_csd = true;
          border_width = 2;
          corner_radius = 10;
          blur = {
            enabled = true;
            optimized = true;
            passes = 2;
            radius = 3;
            noise = 0.02;
            brightness = 0.9;
            contrast = 0.9;
            saturation = 1.1;
          };
        };

        input.keyboard = {
          layout = "de";
          numlock_toggle = true;
        };

        layout = {
          mode = "dwindle";
          gap = 5;
          dwindle.new_toward_cursor = true;
        };

        keybinds = {
          "Mod+Return" = {
            action = "spawn ${pkgs.alacritty}/bin/alacritty";
            repeat = false;
          };
          "Mod" = "spawn noctalia msg panel-toggle launcher";
          "Mod+Q" = {
            action = "window-close";
            repeat = false;
          };
          "Mod+Escape" = "session-quit";
          "Mod+L" = "window-focus-right";
          "Mod+H" = "window-focus-left";
          "Mod+J" = "window-focus-down";
          "Mod+K" = "window-focus-up";
          "Mod+Left" = "window-focus-left";
          "Mod+Down" = "window-focus-down";
          "Mod+Up" = "window-focus-up";
          "Mod+Right" = "window-focus-right";
          "Mod+Shift+H" = "column-move-left";
          "Mod+Shift+J" = "window-move-down";
          "Mod+Shift+K" = "window-move-up";
          "Mod+Shift+L" = "column-move-right";
          "Mod+F" = {
            action = "window-toggle-fullscreen";
            repeat = false;
          };
          "Mod+Space" = "scratchpad-toggle";
          "Mod+Shift+Space" = {
            action = "window-move-to-scratchpad";
            repeat = false;
          };
          "Alt+L" = {
            action = "spawn noctalia msg session lock";
            repeat = false;
          };
          "Alt+Ctrl+C" = "spawn noctalia msg panel-toggle session";
          "XF86AudioRaiseVolume" = {
            action = "spawn noctalia msg volume-up";
            allow_when_locked = true;
          };
          "XF86AudioLowerVolume" = {
            action = "spawn noctalia msg volume-down";
            allow_when_locked = true;
          };
          "XF86AudioMute" = {
            action = "spawn noctalia msg volume-mute";
            allow_when_locked = true;
            repeat = false;
          };
          "XF86AudioMicMute" = {
            action = "spawn noctalia msg mic-mute";
            allow_when_locked = true;
            repeat = false;
          };
          "XF86MonBrightnessUp" = {
            action = "spawn noctalia msg brightness-up";
            allow_when_locked = true;
          };
          "XF86MonBrightnessDown" = {
            action = "spawn noctalia msg brightness-down";
            allow_when_locked = true;
          };
        }
        // lib.listToAttrs (
          map (workspace: {
            name = workspaceKey workspace;
            value = "workspace-switch ${toString workspace}";
          }) (lib.range 1 20)
        )
        // lib.listToAttrs (
          map (workspace: {
            name = moveWorkspaceKey workspace;
            value = "window-move-to-workspace ${toString workspace}";
          }) (lib.range 1 20)
        );

        window_rule = [
          {
            blur = true;
            blur_optimized = true;
          }
          {
            match.app_id = "^dev.noctalia.Noctalia$";
            default_floating = true;
            default_floating_size_px = {
              width = 1020;
              height = 900;
            };
          }
        ];

        layer_rule = [
          {
            match.namespace = "^noctalia-(bar-[^\\\"]+|notification|dock|panel|attached-panel|osd|desktop-widget-[^\\\"]*)$";
            blur = true;
            blur_ignore_alpha = 0.5;
            blur_popups = true;
          }
          {
            match.namespace = "^noctalia-(notification|dock|panel|attached-panel|osd)$";
            blur_optimized = false;
          }
        ];
      };
    };
  };
}
