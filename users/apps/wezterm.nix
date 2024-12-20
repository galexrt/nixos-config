{ ... }: {
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
        color_scheme = "Solarized Dark Higher Contrast (Gogh)",
        colors = {
          background = '#222436',
        },
        enable_tab_bar = false,
        window_background_opacity = 0.96,
        enable_scroll_bar = true,
        scrollback_lines = 9999,
        hide_mouse_cursor_when_typing = false,
        pane_focus_follows_mouse = false,
        --front_end = "WebGpu",
      }

      return config
    '';
  };
}
