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
    networking.networkmanager.enable = false;
    networking.networkmanager.wifi.backend = "iwd";
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [
        2022 # eternal terminal
        3000 # nextjs dev server
        53317 # localsend
      ];
      allowedUDPPorts = [
        3000 # nextjs dev server
        53317 # localsend
      ];
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        } # kdeconnect
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        } # kdeconnect
        {
          from = 60000;
          to = 61000;
        } # mosh
      ];
    };

    #===========================================================================================
    # Sound
    #   - https://nixos.wiki/wiki/PipeWire
    #===========================================================================================
    security.rtkit.enable = true; # rtkit is optional but recommended
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    #===========================================================================================
    # iOS
    #   - https://nixos.wiki/wiki/IOS
    #===========================================================================================
    services.usbmuxd.enable = true;

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
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
      openFirewall = true;
    };

    #===========================================================================================
    # Printing
    # - http://localhost:631
    # - https://nixos.wiki/wiki/Printing
    #===========================================================================================
    services.printing = {
      enable = true;
      drivers = [
        pkgs.gutenprint
        pkgs.brlaser
        pkgs.hplip
      ];
    };

    #===========================================================================================
    # udisks
    # - wrapper around mnt that utilizes polkit to allow mounting without requiring root
    # - improves ui of mnt and utilizes d-bus to allow integration with other programs
    # - required for most automounting programs, e.g. udiskie
    # - https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/hardware/udisks2.nix
    #===========================================================================================
    services.udisks2.enable = true;

    #===========================================================================================
    # Programs
    #===========================================================================================
    environment.systemPackages = with pkgs; [
      swaylock
      wl-clipboard
      grim # screenshot utility
      slurp # screen area selection tool
      hyprpaper
      waybar

      firefox
      kitty
      pulsemixer
      pavucontrol
      brightnessctl
    ];

    security.pam.services.swaylock = {};

    programs = {
      nix-ld.enable = true;
      hyprland.enable = true;
      zsh.enable = true;
    };

    modules = {
      programs = {
        bluetooth.enable = true;
        core.enable = true;
        ddc.enable = true;
        protonvpn.enable = false;
        virt-manager.enable = true;
      };
    };

    #===========================================================================================
    # Misc
    #===========================================================================================

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
      ];
      config = {
        hyprland = {
          default = ["hyprland" "gtk"];
          "org.freedesktop.impl.portal.FileChooser" = "gtk";
        };
      };
    };
  };
}
