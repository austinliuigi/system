{ config, pkgs, lib, _utils, ... }:

{
  # import all modules
  # - remove current file from list of files to avoid circular import
  # - don't include files with a starting underscore
  imports = (lib.remove
    "${./.}/default.nix"
    (builtins.filter
      (elem: (builtins.match "_.*" (builtins.baseNameOf elem)) == null)
      (_utils.scanDirFiles { dir = ./.; absolute_paths = true; })
    )
  );
}
