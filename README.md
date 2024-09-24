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

1. install nixos
2. connect to internet via `nmtui`
3. install git and vim via `sudo nano /etc/nixos/configuration.nix`
4. generate ssh key via `ssh-keygen -t ed25519`
5. add public ssh key to github
6. clone nixos configuration via `git clone git@github.com:austinliuigi/system.git ~/nixos`
7. configure new host in `~/nixos`
8. symlink configuration to `/etc/nixos/` via `sudo ln -s ~/nixos/ /etc/nixos`
9. run `sudo nixos-rebuild switch`
10. clone home-manager configuration via `git clone git@github.com:austinliuigi/home.git ~/.config/home-manager`
11. bootstrap home-manager via `nix run home-manager/master -- switch --flake ~/.config/home-manager#austin`
