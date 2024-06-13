# Structure

```
 .
├──  configs                             # contains system-wide configuration files for programs
│   └──  <program>
│       └──  <config>
├── 󰀂 hosts                               # system-specific configuration for various hosts
│   └──  <host>
│       ├──  default.nix                 # custom configuration
│       └──  hardware-configuration.nix  # system-generated configuration
├──  modules
│   └──  programs
│       ├──  core.nix
│       └──  virt-manager.nix
├──  flake.lock                          # lockfile
└──  flake.nix                           # flake
```

# Installation

1. `git clone https://github.com/austinliuigi/nixos`
2. symlink this directory to `/etc/nixos/`
3. `sudo nixos-rebuild switch`
4. install [home manager](https://github.com/austinliuigi/home-manager)
