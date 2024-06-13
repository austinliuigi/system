{
  description = "austin's nixos flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      baseExtraSpecialArgs = {
        inherit inputs;
      };
    in {
      nixosConfigurations = {
        x1-carbon = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = baseExtraSpecialArgs;
          modules = [
            ./hosts/x1-carbon
          ];
        };
      };
    };
}
