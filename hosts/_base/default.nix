{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [../../modules];
  config = {
    #===========================================================================================
    # Kernel
    #   - https://nixos.wiki/wiki/Linux_kernel
    #===========================================================================================
    boot.kernelPackages = pkgs.linuxPackages_latest;

    #===========================================================================================
    # Tailscale
    # - https://nixos.wiki/wiki/Tailscale
    #===========================================================================================
    services.tailscale.enable = true;

    #===========================================================================================
    # Kanata
    #===========================================================================================
    services.kanata = {
      enable = true;
      keyboards = {
        default = {
          devices = []; # catch all keybaord devices
          config =
            builtins.readFile
            ../../configs/kanata/default.kbd;
        };
      };
    };

    #===========================================================================================
    # Miscellaneous Options
    #===========================================================================================

    # Set time zone
    time.timeZone = "America/Los_Angeles";

    # Select internationalization properties
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

    # NOTE: by default "https://cache.nixos.org" is merged in with the substituters listed here, which can be confirmed by checking /etc/nix/nix.conf
    #   - to remove it, use `substituters = lib.mkForce [ ... ]`
    nix.settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://nixpkgs-python.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU="
      ];
    };

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # Garbage collection
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    # https://nixos.wiki/wiki/Storage_optimization
    nix.optimise.automatic = true;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Enable flakes and new commands
    nix.settings.experimental-features = ["nix-command" "flakes"];

    # Add system fonts
    fonts.packages = with pkgs; [
      noto-fonts
      vista-fonts
    ];

    # https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md
    nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  };
}
