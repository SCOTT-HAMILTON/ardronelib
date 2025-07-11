{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay/master";
    # nixpkgs.follows = "nix-ros-overlay/nixpkgs";  # IMPORTANT!!!
    # package-nix = {
    #   url = "path:./package.nix";
    #   flake = false;
    # };
    # localArdronelib = {
    #   url = "git+file:./ardronelib";
    #   flake = false;
    # };
  };
  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.default = pkgs.callPackage ./package.nix { };
    });
}
