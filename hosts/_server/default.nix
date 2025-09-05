# Documentation:
#   - configuration.nix(5) man page
#   - NixOS manual (accessible by running ‘nixos-help’).
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
    # Networking
    #   - https://nixos.wiki/wiki/Iwd
    #===========================================================================================
    networking.wireless.iwd.enable = true;
    networking.networkmanager.enable = false; # enable networking
    networking.networkmanager.wifi.backend = "iwd";
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [
        2022 # eternal terminal
      ];
      allowedUDPPorts = [
      ];
      allowedTCPPortRanges = [
      ];
      allowedUDPPortRanges = [
        {
          from = 60000;
          to = 61000;
        } # mosh
      ];
    };

    #===========================================================================================
    # Eternal Terminal
    #===========================================================================================
    services.eternal-terminal = {
      enable = true;
    };

    #===========================================================================================
    # OpenSSH
    #===========================================================================================
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "yes";
        PasswordAuthentication = false;
      };
      openFirewall = true;
    };

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
    # Programs
    #===========================================================================================
    environment.systemPackages = with pkgs; [
    ];

    programs = {
      zsh.enable = true;
    };

    modules = {
      programs = {
        bluetooth.enable = false;
        core.enable = true;
        ddc.enable = false;
        virt-manager.enable = false;
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
      nerd-fonts.jetbrains-mono
      nerd-fonts.mononoki
      noto-fonts
      vistafonts
    ];

    # https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md
    nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  };
}
