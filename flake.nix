{
  description = "dandruff";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
  };

  outputs = { self, nixpkgs, ... }@args: {
    nixosConfigurations = {
      x1-carbon = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/x1-carbon
        ];
      };
    };
  };
}
