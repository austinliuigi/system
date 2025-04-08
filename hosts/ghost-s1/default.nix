# Documentation:
#   - configuration.nix(5) man page
#   - NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix  # include the results of the hardware scan.
      ./nvidia.nix
      ../_desktop
    ];

  config = {
    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;


    # Networking
    networking.hostName = "ghost-s1"; # define hostname


    # Add user "austin"
    users.users.austin = {
      isNormalUser = true;
      description = "Austin Liu";
      extraGroups = [ "networkmanager" "wheel" "libvirtd" "i2c" ];
      shell = pkgs.zsh;
      packages = with pkgs; [];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIPMLU/Uxg/vRaNsjWIb2DpNmunkG6igcw8VFTamDwr5 austin@Austin-M1"
      ];
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
