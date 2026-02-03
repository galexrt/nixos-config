{ pkgs, ... }:

{
  virtualisation = {
    containers = {
      enable = true;
    };

    docker = {
      enable = true;
      liveRestore = true;
      storageDriver = "overlay2";
    };

    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = false;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };

    virtualbox.host = {
      enable = true;
    };

    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
  };
}
