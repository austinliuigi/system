# Documentation:
#   - configuration.nix(5) man page
#   - NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = [ ../../modules ];

  config = {
    # Kernel
    boot.kernelPackages = pkgs.linuxPackages_6_11;

    # Networking
    #   - https://nixos.wiki/wiki/Iwd
    networking.wireless.iwd.enable = true;
    networking.networkmanager.enable = true; # enable networking
    networking.networkmanager.wifi.backend = "iwd";
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
      allowedTCPPortRanges = [ 
        { from = 1714; to = 1764; } # KDE Connect
      ];  
      allowedUDPPortRanges = [ 
        { from = 1714; to = 1764; } # KDE Connect
      ];
    };


    # Sound
    #   - https://nixos.wiki/wiki/PipeWire
    security.rtkit.enable = true;  # rtkit is optional but recommended
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };


    # iOS
    #   - https://nixos.wiki/wiki/IOS
    services.usbmuxd.enable = true;


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
      options = "--delete-older-than 1w";
    };


    # https://nixos.wiki/wiki/Storage_optimization
    nix.optimise.automatic = true;


    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;


    # Enable flakes and new commands
    nix.settings.experimental-features = [ "nix-command" "flakes" ];


    # Add fonts
    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.mononoki
      noto-fonts
      vistafonts
    ];


    # Services
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
      openFirewall = true;
    };

    services.tailscale.enable = true;

    services.kanata = {
      enable = true;
      keyboards = {
        default = {
          devices = [ ];  # catch all keybaord devices
          config = builtins.readFile
            ../../configs/kanata/default.kbd;
        };
      };
    };

    services.printing = {
      enable = true;
      drivers = [
        pkgs.brlaser
      ];
    };

    # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/hardware/udisks2.nix
    services.udisks2.enable = true;  # user space mounting


    # Programs
    environment.systemPackages = with pkgs; [
      rofi-wayland
      swaylock
      wl-clipboard
      grim   # screenshot utility
      slurp  # screen area selection tool
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
      hyprland.enable = true;
      zsh.enable = true;
    };

    modules = {
      programs = {
        bluetooth.enable = true;
        core.enable = true;
        ddc.enable = true;
        virt-manager.enable = true;
      };
    };


    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.05"; # Did you read the comment?
  };
}
