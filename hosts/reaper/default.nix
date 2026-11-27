{
  pkgs,
  nixos-hardware,
  ...
}:

{
  imports = [
    nixos-hardware.nixosModules.common-pc
    nixos-hardware.nixosModules.common-pc-ssd

    ./disko-config.nix

    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../../users/atrost.nix
    ../../options/lanzaboote.nix
  ];

  networking.hostName = "reaper";

  myConfig.lanzaboote.enable = true;
  myConfig.virtualisation.enable = true;
  myConfig.binfmt.enable = true;
  myConfig.vpnTools.enable = true;
  myConfig.desktop.sway.enable = true;
  myConfig.gaming.enable = true;
  myConfig.bluetooth.enable = true;
  myConfig.printing.enable = true;
  myConfig.windowsApps.enable = true;
  myConfig.ai.enable = true;

  home-manager.users.atrost = {
    wayland.windowManager.sway.config = {
      output = {
        DP-1 = {
          pos = "0,0";
          res = "2560x1440@239.970Hz";
          scale = "1";
          scale_filter = "nearest";
          transform = "normal";
          adaptive_sync = "off";
          power = "on";
          render_bit_depth = "10";
          hdr = "on";
          allow_tearing = "yes";
          max_render_time = "off";
        };
        DP-2 = {
          pos = "2560,0";
          res = "2560x1440@239.970Hz";
          scale = "1";
          scale_filter = "nearest";
          transform = "normal";
          adaptive_sync = "off";
          power = "on";
          render_bit_depth = "10";
          hdr = "on";
          allow_tearing = "yes";
          max_render_time = "off";
        };
        HDMI-A-1 = {
          pos = "5120,0";
          res = "2560x1440@143.991Hz";
          scale = "1";
          scale_filter = "nearest";
          transform = "normal";
          adaptive_sync = "off";
          power = "on";
          render_bit_depth = "10";
          hdr = "on";
          allow_tearing = "yes";
          max_render_time = "off";
        };
        HDMI-A-3.disable = "";
      };
      workspaceOutputAssign = [
        {
          workspace = "1";
          output = "DP-1";
        }
        {
          workspace = "2";
          output = "DP-2";
        }
        {
          workspace = "16";
          output = "HDMI-A-1";
        }
        {
          workspace = "20";
          output = "HDMI-A-1";
        }
      ];
    };

    #programs.umbriel.settings.output = {
    #  DP-1 = {
    #    mode = "2560x1440@239.970";
    #    position = [ 0 0 ];
    #    scale = 1.0;
    #    vrr = "disabled";
    #    hdr = "auto";
    #    sdr_white = 203;
    #    direct_scanout = true;
    #    tearing = true;
    #  };
    #  DP-2 = {
    #    mode = "2560x1440@239.970";
    #    position = [ 2560 0 ];
    #    scale = 1.0;
    #    vrr = "disabled";
    #    hdr = "auto";
    #    sdr_white = 203;
    #    direct_scanout = true;
    #    tearing = true;
    #  };
    #  #HDMI-A-1 = {
    #  #  mode = "2560x1440@143.991";
    #  #  position = [ 5120 0 ];
    #  #  scale = 1.0;
    #  #  vrr = "disabled";
    #  #  hdr = "auto";
    #  #  sdr_white = 203;
    #  #  direct_scanout = true;
    #  #  tearing = true;
    #  #};
    #};
  };

  systemd.services.lactd = {
    description = "AMDGPU Control Daemon";
    enable = true;
    serviceConfig = {
      # this path because we don't use pkgs.lact
      ExecStart = "/run/current-system/sw/bin/lact daemon";
    };
    wantedBy = [ "multi-user.target" ];
  };

  services.ollama = {
    package = pkgs.ollama-rocm;
    environmentVariables = {
      HCC_AMDGPU_TARGET = "gfx1100";
    };
    rocmOverrideGfx = "11.0.0";
  };

  services.antec-flux-pro-display = {
    enable = true;
    settings = {
      cpu_device = "coretemp";
      cpu_temp_type = "Package id 0";
      gpu_device = "amdgpu";
      gpu_temp_type = "edge";
      update_interval = 1000;
    };
  };

}
