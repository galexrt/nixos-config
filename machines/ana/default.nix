{ nixos-hardware, ... }:

{
  imports = [
    nixos-hardware.nixosModules.common-pc-ssd
  
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../../users/ltrost.nix
  ];

  networking.hostName = "ana";

  i18n.defaultLocale = "de_DE.UTF-8";

  services.displayManager = {
    autoLogin.enable = true;
	  autoLogin.user = "ltrost";
  };
}
