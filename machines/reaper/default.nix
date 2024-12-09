{
  imports = [
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/common/pc"
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/common/pc/ssd"
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  networking.hostName = "reaper";

  services.nfs.server = {
    enable = true;
    exports = ''
      /data/DATA/topsecret/Music 172.16.1.101(rw,fsid=0,no_subtree_check)
      /data/DATA/topsecret/Music 172.16.1.222(rw,fsid=0,no_subtree_check)
    '';
  };
}
