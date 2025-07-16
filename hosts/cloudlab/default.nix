# Documentation:
#   - configuration.nix(5) man page
#   - NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, modulesPath, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../_server
      (modulesPath + "/installer/scan/not-detected.nix")
      (modulesPath + "/profiles/qemu-guest.nix")
      ./disk-config.nix
    ];

  config = {
    #===========================================================================================
    # Host
    #===========================================================================================
    boot.loader.grub = {
      # no need to set devices, disko will add all devices that have a EF02 partition to the list already
      # devices = [ ];
      efiSupport = true;
      efiInstallAsRemovable = true;
    };

    networking.hostName = "cloudlab";

    #===========================================================================================
    # Users
    #===========================================================================================
    users.users.txn = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      shell = pkgs.zsh;
      packages = with pkgs; [];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJ9Vm0B2Hp83P5HuYSS4ZfxCt+xwbnWjDCnzXFnnsqy"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG1BEb3sEHT/MmALbKdV6uwWJRAwj8NSazYtSXrdw/vI txn_cloudlab_20250715"
      ];
    };

    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJ9Vm0B2Hp83P5HuYSS4ZfxCt+xwbnWjDCnzXFnnsqy"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG1BEb3sEHT/MmALbKdV6uwWJRAwj8NSazYtSXrdw/vI txn_cloudlab_20250715"
    ];

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.05";
  };
}
