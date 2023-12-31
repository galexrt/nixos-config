{ config, pkgs, ... }: {
  imports = [
    ./wezterm.nix
  ];

  programs.zsh = {
    enable = true;
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    initExtra = ''
      randpw() {
        length="$1"
        if [ -z "$length" ]; then
            length="24"
        fi
        < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-$length} | sed 's/-/_/';echo;
    }
    '';

    loginExtra = ''
      if [[ -z "$DISPLAY" ]] && [[ $(tty) = "/dev/tty1" ]]; then
          exec sway
      fi

      export GNOME_KEYRING_CONTROL=/run/user/$UID/keyring
      export SSH_AUTH_SOCK=/run/user/$UID/keyring/ssh
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "systemd" "common-aliases" "golang" "kubectl" "rsync" ];
      theme = "rkj-repos";
    };

    shellAliases = {
      "code" = "codium";
      "sshknownhosts" = "vim ~/.ssh/known_hosts";
      "sshconfig" = "vim ~/.ssh/config";
      "killnamed" = "pkill -f";
      "ISMYINTERNETK" = "ping 8.8.8.8";
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
      core.editor = "vim";
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
      pack = {
        sparse = true;
      };
    };
  };

  home.file."ssh-connections" = {
    text = "";
    target = "${config.home.homeDirectory}/.ssh/connections/.keep";
  };

  programs.ssh = {
    serverAliveInterval = 360;
    compression = true;
    controlMaster = "auto";
    controlPersist = "yes";
    controlPath = "~/.ssh/connections/%C";

    extraConfig = ''
      NoHostAuthenticationForLocalhost yes
    '';
  };

}
