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
        color_scheme = "Ibm 3270 (High Contrast) (Gogh)",
        colors = {
          background = '#282a36',
        },
        enable_tab_bar = false,
        window_background_opacity = 0.96,
        enable_scroll_bar = true,
        scrollback_lines = 99999,
      }

      return config
    '';
  };
}