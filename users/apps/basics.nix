{ config, pkgs, ... }: {
  imports = [
    ./wezterm.nix
  ];

  home.file."rkj-repos-custom.zsh-theme" = {
    executable = true;
    source = ./zsh/rkj-repos-custom.zsh-theme;
    target = "${config.home.homeDirectory}/.oh-my-zsh/custom/themes/rkj-repos-custom.zsh-theme";
  };

  programs.zsh = {
    enable = true;
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    initContent = ''
      export ZSH_CUSTOM="${config.home.homeDirectory}/.oh-my-zsh/custom"

      randpw() {
        length="$1"
        if [ -z "$length" ]; then
            length="24"
        fi
        < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c''\${1:-$length} | sed 's/-/_/';echo;
      }

      source <(switcher init zsh)
    '';

    loginExtra = ''
      export BROWSER=librewolf
      if [[ -z "$DISPLAY" ]] && [[ $(tty) = "/dev/tty1" ]]; then
          exec sway
      fi

      export GNOME_KEYRING_CONTROL=/run/user/$UID/keyring
      export SSH_AUTH_SOCK=/run/user/$UID/keyring/ssh
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "systemd" "common-aliases" "golang" "kubectl" "rsync" "kube-ps1" ];
      custom = "$HOME/.oh-my-zsh/custom";
      theme = "rkj-repos-custom";
      extraConfig = ''
        COMPLETION_WAITING_DOTS="true"
      '';
    };

    shellAliases = {
      #"code" = "codium";
      "sshknownhosts" = "vim ~/.ssh/known_hosts";
      "sshconfig" = "vim ~/.ssh/config";
      "killnamed" = "pkill -f";
      "ISMYINTERNETK" = "ping 8.8.8.8";
    };
  };

  # So /bin/bash is available
  programs.bash.enable = true;

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
    package = pkgs.gitFull; # Install git wiith all the optional extras
    
    settings = {
      user = {
        email = "galexrt@googlemail.com";
        name = "Alexander Trost";
      };

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
      oh-my-zsh = {
        hide-status = 0;
      };
      gpg.format = "openpgp";
    };
  };

  home.file."ssh-cons" = {
    text = "";
    target = "${config.home.homeDirectory}/.ssh/cons/.keep";
  };

  home.file."libvirt-qemu-conf" = {
    text = ''
    # Adapted from /var/lib/libvirt/qemu.conf
    # Note that AAVMF and OVMF are for Aarch64 and x86 respectively
    nvram = [ "/run/libvirt/nix-ovmf/AAVMF_CODE.fd:/run/libvirt/nix-ovmf/AAVMF_VARS.fd", "/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd" ]
    '';
    target = "${config.xdg.configHome}/libvirt/qemu.conf";
  };

  programs.ssh = {
    matchBlocks = {
      "*" = {
        serverAliveInterval = 360;
        compression = true;
        controlMaster = "auto";
        controlPersist = "yes";
        controlPath = "~/.ssh/cons/%C";
      };
    };

    extraConfig = ''
      NoHostAuthenticationForLocalhost yes
    '';
  };

  services.ssh-agent = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

}
