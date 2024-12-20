{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.bluetooth;
in
{
  options.modules.programs.bluetooth.enable = lib.mkEnableOption "bluetooth module";

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true; # enables support for Bluetooth
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
    };

    environment.systemPackages = with pkgs; [
      blueman
    ];
  };
}
