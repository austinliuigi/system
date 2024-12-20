{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.virt-manager;
in
{
  options.modules.programs.virt-manager.enable = lib.mkEnableOption "virt-manager module";

  config = lib.mkIf cfg.enable {
    # be sure to add users to the libvirtd group

    # users.users."${config.username}" = {
    #   extraGroups = [ "libvirtd" ];
    # };

    environment.systemPackages = with pkgs; [
      virt-manager
    ];

    virtualisation.libvirtd.enable = true;
    programs.dconf.enable = true;
    virtualisation.spiceUSBRedirection.enable = true; # https://discourse.nixos.org/t/having-an-issue-with-virt-manager-not-allowing-usb-passthrough/6272
  };
}
