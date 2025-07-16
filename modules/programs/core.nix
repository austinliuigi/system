{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.core;
in
{
  options.modules.programs.core.enable = lib.mkEnableOption "core utilities module";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gcc
      git
      gnumake
      htop
      man-pages
      man-pages-posix
      moreutils
      vim
      wget
      curl
      gdu
      pv # pipe viewer
    ];
  };
}
