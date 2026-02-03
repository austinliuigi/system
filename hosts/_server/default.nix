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
  imports = [
    ../_base
  ];

  config = {
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
    # Programs
    #===========================================================================================
    environment.systemPackages = with pkgs; [
    ];

    programs = {
      nix-ld.enable = true;
      zsh.enable = true;
    };

    modules = {
      programs = {
        bluetooth.enable = false;
        core.enable = true;
        ddc.enable = false;
        protonvpn.enable = false;
        virt-manager.enable = false;
      };
    };
  };
}
