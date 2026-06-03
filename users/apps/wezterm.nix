{ ... }:
{
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;

    extraConfig = ''
      local config = {
        font = wezterm.font_with_fallback {
          {family="Hack", weight="Regular", stretch="Normal", style="Normal"},
          'Noto Color Emoji',
        },
        font_size = 8.0,
        color_scheme = "Cai (Gogh)", -- "Colors (base16)" or "deep"
        colors = {
          background = "black",
        },
        enable_tab_bar = false,
        window_background_opacity = 0.95,
        enable_scroll_bar = true,
        scrollback_lines = 9999,
        hide_mouse_cursor_when_typing = false,
        pane_focus_follows_mouse = false,
        front_end = "WebGpu",
      }

      config.keys = {
        {key = 't', mods = 'CTRL|SHIFT', action = wezterm.action.DisableDefaultAssignment},
      }

      return config
    '';
  };
}
