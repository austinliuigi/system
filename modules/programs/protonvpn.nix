{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.programs.protonvpn;
in {
  options.modules.programs.protonvpn.enable = lib.mkEnableOption "protonvpn module";

  config = lib.mkIf cfg.enable {
    # https://nixos.wiki/wiki/WireGuard#Setting_up_WireGuard_with_NetworkManager
    networking.networkmanager.enable = true;
    networking.firewall.checkReversePath = "loose";
    environment.systemPackages = with pkgs; [
      protonvpn-gui
      wireguard-tools
    ];
  };
}
