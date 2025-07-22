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

# Local Installation

1. Install nixos
2. Connect to internet via `nmtui`
3. Install git and vim via `sudo nano /etc/nixos/configuration.nix`
4. Add github ssh key-pair to `~/.ssh/`
5. Clone nixos configuration via `git clone git@github.com:austinliuigi/system.git ~/nixos`
6. Configure new host in `~/nixos`
7. Symlink configuration to `/etc/nixos/` via `sudo ln -s ~/nixos/ /etc/nixos`
8. Run `sudo nixos-rebuild switch`
9. Clone home-manager configuration via `git clone git@github.com:austinliuigi/home.git ~/.config/home-manager`
10. Bootstrap home-manager via `nix run home-manager/master -- switch --flake ~/.config/home-manager#austin`


# `nixos-anywhere` Installation

1. Create server that you can ssh into
2. \[Configure new host on source machine\]
    - Create flake
    - Create disko file
3. Remotely install nixos from source machine with nix installed
    - `nix run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-generate-config ./hardware-configuration.nix --flake <path to configuration>#<configuration name> --target-host root@<ip address>`
4. Update nixos on target machine
    1. Remotely: `nixos-rebuild switch --flake <URL to your flake> --target-host "root@<ip address>"`
    2. Locally: Follow steps 4-10 of the local installation above on the target machine

```bash
# 3
cd ~/nixos
nix run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-generate-config ./hosts/cloudlab/hardware-configuration.nix --flake .#cloudlab -i ~/.ssh/cloudlab --target-host root@5.78.74.50

# 4a
nixos-rebuild switch --flake .#cloudlab --target-host root@5.78.74.50

# 4b
git clone git@github.com:austinliuigi/system.git ~/nixos
sudo ln -s ~/nixos/ /etc/nixos
sudo nixos-rebuild switch --flake ~/nixos#cloudlab
git clone git@github.com:austinliuigi/home.git ~/.config/home-manager
nix run home-manager/master -- switch --flake ~/.config/home-manager#austin
```
