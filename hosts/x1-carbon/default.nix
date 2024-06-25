# Documentation:
#   - configuration.nix(5) man page
#   - NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];


  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.configurationLimit = 10;  # limit number of generations to save space
  boot.resumeDevice = "/dev/disk/by-label/swap"; # sets the "resume" kernelParam (used to locate target partition hibernation)

  # Networking
  networking.hostName = "x1-carbon"; # define hostname
  networking.wireless.iwd.enable = true;
  networking.networkmanager.enable = false; # enable networking
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
  security.rtkit.enable = true;  # rtkit is optional but recommended
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # iOS
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
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes and new commands
  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  # Add fonts
  # fonts.packages = with pkgs; [
  #   (nerdfonts.override { fonts = [ "JetBrainsMono" "Mononoki" ]; })
  #   noto-fonts
  #   vistafonts
  # ];

  # Add user "austin"
  users.users.austin = {
    isNormalUser = true;
    description = "Austin Liu";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    shell = pkgs.zsh;
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIPMLU/Uxg/vRaNsjWIb2DpNmunkG6igcw8VFTamDwr5 austin@Austin-M1"
    ];
  };

  # Services
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    openFirewall = true;
  };

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

  services.udisks2.enable = true;  # user space mounting

  services.printing.enable = true;
  services.printing.drivers = [
    pkgs.brlaser
  ];


  # Programs
  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix
    vim
    gcc
    gnumake
    wget
    git
    htop

    firefox
    pulsemixer
    pavucontrol
    gdu
    brightnessctl
    pv  # pipe viewer

    virt-manager
  ];

  security.pam.services.swaylock = {};

  programs.hyprland = {
    enable = true;
    # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  programs.zsh.enable = true;

  virtualisation.virtualbox.host.enable = true;
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
