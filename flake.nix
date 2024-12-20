{
  description = "austin's nixos flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    # hyprland = { # used to set hyprland package to dev version
    #   url = "github:hyprwm/Hyprland";
    # };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      _utils = (import ./utils.nix) { lib = nixpkgs.lib; };
      baseSpecialArgs = {
        inherit inputs;
        inherit _utils;
      };
    in {
      nixosConfigurations = {
        x1-carbon = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = baseSpecialArgs;
          modules = [
            ./hosts/x1-carbon
          ];
        };
        ghost-s1 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = baseSpecialArgs;
          modules = [
            ./hosts/ghost-s1
          ];
        };
      };
    };
}
