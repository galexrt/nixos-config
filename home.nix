{ ... }: {
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  imports = [
    ./users/atrost.nix
  ];
}
