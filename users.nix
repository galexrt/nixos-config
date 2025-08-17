{ pkgs, ... }:

{
  users.users.atrost = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "video" "networkmanager" "rfkill" "power" "lp" "uucp" "network" "docker" "scanner" "dialout" "libvirtd" "gamemode" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIACcqbQlcdBFswQafVSTt0OvMkBLwXjTSLhBsqAdo5Gf atrost@debwrk01"
    ];
  };
}
