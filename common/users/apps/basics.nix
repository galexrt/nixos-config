{ config, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    loginExtra = ''
      if [[ -z "$DISPLAY" ]] && [[ $(tty) = "/dev/tty1" ]]; then
          exec sway
      fi
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "systemd" "common-aliases" "golang" "kubectl" "rsync" ];
      theme = "rkj-repos";
    };
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      style = "compact";
    };
  };

  programs.git = {
    enable = true;
    # Additional options for the git program
    package = pkgs.gitAndTools.gitFull; # Install git wiith all the optional extras
    userName = "Alexander Trost";
    userEmail = "galexrt@googlemail.com";
    extraConfig = {
      commit.gpgsign = true;
      user.signingkey = "5CF1D4600D4CBFDF";
      # Cache git credentials for an hour
      credential.helper = "cache --timeout=3600";
      diff.renameLimit = 3500;
      alias = {
        bclean = "!git fetch -p && for branch in $(git branch -vv | gawk '{print $1,$4}' | awk '/ gone]/{if ($1!=\"*\") print $1}'); do git branch -D $branch; done && echo 'Removed branches without remote anymore.'";
      };
      url = {
        "ssh://git@github.com/" = {
          insteadOf = "https://github.com/";
        };
      };
      pull.rebase = false;
      init.defaultBranch = "main";
      advice = {
        addEmptyPathspec = false;
      };
    };
  };

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
      }

      return config
    '';
  };
}
