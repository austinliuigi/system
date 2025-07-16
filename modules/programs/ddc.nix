#===========================================================================================
# - https://discourse.nixos.org/t/how-to-enable-ddc-brightness-control-i2c-permissions/20800/16
# - https://discourse.nixos.org/t/brightness-control-of-external-monitors-with-ddcci-backlight/8639/7
# - https://github.com/NixOS/nixpkgs/issues/292049
# - https://linux-i2c.vger.kernel.narkive.com/BwIEWfXY/ddc-ci-over-i2c
# - https://gist.github.com/emilcarr/795a470feb89d3777479e11b25f2931e
#===========================================================================================
{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.ddc;
in
{
  options.modules.programs.ddc.enable = lib.mkEnableOption "ddc module";

  config = lib.mkIf cfg.enable {
    boot.extraModulePackages = with config.boot.kernelPackages; [ ddcci-driver ];
    boot.kernelModules = [ "i2c-dev" "ddcci-backlight" ]; # load i2c-dev for ddcutil

    environment.systemPackages = with pkgs; [
      ddcutil
    ];

    # create i2c group and allow it rw access to i2c buses; necessary for ddcutil
    # be sure to add users to this group
    users.groups.i2c = {};
    services.udev.extraRules = ''
      KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"

      SUBSYSTEM=="i2c-dev", ACTION=="add",\
        ATTR{name}=="NVIDIA i2c adapter*",\
        TAG+="ddcci",\
        TAG+="systemd",\
        ENV{SYSTEMD_WANTS}+="ddcci@$kernel.service"
    '';

    systemd.services."ddcci@" = {
      scriptArgs = "%i";
      script = ''
        sleep 30
        echo Trying to attach ddcci to $1
        bus_id=$(echo $1 | cut -d "-" -f 2)
        if ${pkgs.ddcutil}/bin/ddcutil getvcp 10 -b $bus_id; then
          echo Attaching ddci to i2c bus $1
          echo ddcci 0x37 > /sys/bus/i2c/devices/$1/new_device
        fi
      '';
      serviceConfig.Type = "oneshot";
    };
  };
}
