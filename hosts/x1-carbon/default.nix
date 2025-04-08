# Documentation:
#   - configuration.nix(5) man page
#   - NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../_desktop
    ];

  config = {
    # Bootloader
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/sda";
    boot.loader.grub.useOSProber = true;
    boot.loader.grub.configurationLimit = 10;  # limit number of generations to save space
    boot.resumeDevice = "/dev/disk/by-label/swap"; # sets the "resume" kernelParam (used to locate target partition hibernation)

    # Networking
    networking.hostName = "x1-carbon"; # define hostname

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

    # Accelerated video playback
    hardware.graphics = {
      enable = true;
      extraPackages = [
        pkgs.intel-media-driver
        # pkgs.intel-vaapi-driver
      ];
    };
    environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };
    # boot.initrd.kernelModules = [ "i915" ];


    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.05"; # Did you read the comment?
  };
}
