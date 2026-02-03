# Documentation:
#   - configuration.nix(5) man page
#   - NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../_desktop
  ];

  config = {
    #===========================================================================================
    # Host
    #===========================================================================================
    boot.loader.grub = {
      enable = true;
      device = "/dev/sda";
      useOSProber = true;
      configurationLimit = 10; # limit number generations shown in boot menu
    };
    boot.resumeDevice = "/dev/disk/by-label/swap"; # sets the "resume" kernelParam (used to locate target partition for hibernation)

    networking.hostName = "x1-carbon";

    #===========================================================================================
    # Users
    #===========================================================================================
    users.users.austin = {
      isNormalUser = true;
      description = "Austin Liu";
      extraGroups = ["networkmanager" "wheel" "libvirtd"];
      shell = pkgs.zsh;
      packages = with pkgs; [];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIPMLU/Uxg/vRaNsjWIb2DpNmunkG6igcw8VFTamDwr5 austin@Austin-M1"
      ];
    };

    #===========================================================================================
    # Accelerated video playback
    # - https://nixos.wiki/wiki/Accelerated_Video_Playback
    #===========================================================================================
    hardware.graphics = {
      enable = true;
      extraPackages = [
        pkgs.intel-media-driver
        # pkgs.intel-vaapi-driver
      ];
    };
    environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";};
    # boot.initrd.kernelModules = [ "i915" ];

    #===========================================================================================
    # Fingerprint scanning
    # - https://wiki.nixos.org/wiki/Fingerprint_scanner
    #===========================================================================================
    systemd.services.fprintd = {
      wantedBy = ["multi-user.target"];
      serviceConfig.Type = "simple";
    };
    services.fprintd = {
      enable = true;
      package = inputs.nixpkgs-libfprint.legacyPackages."x86_64-linux".fprintd-tod;
    };
    services.fprintd.tod = {
      enable = true;
      # broken:
      #   - https://github.com/NixOS/nixpkgs/commit/392773a15445c850f7299ebdacaef0bf2c7a7ad8
      #   - https://gitlab.freedesktop.org/3v1n0/libfprint-tod-vfs0090/-/issues?show=eyJpaWQiOiIyIiwiZnVsbF9wYXRoIjoiM3YxbjAvbGliZnByaW50LXRvZC12ZnMwMDkwIiwiaWQiOjEzMDc3MX0%3D
      driver = inputs.nixpkgs-libfprint.legacyPackages."x86_64-linux".libfprint-2-tod1-vfs0090;
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
