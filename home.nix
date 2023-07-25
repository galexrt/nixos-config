{ ... }: {
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  home-manager.users.atrost = import ./users/atrost.nix;
}
