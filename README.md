[![Flake](https://github.com/stephenreynolds/nix-config/actions/workflows/flake-check.yml/badge.svg)](https://github.com/stephenreynolds/nix-config/actions/workflows/flake-check.yml)

# My Nix configurations

Based on [Misterio77's config](https://github.com/Misterio77/nix-config).

Currently managing two systems:
- nixie: NixOS install (not in use)
- wsl: Ubuntu on [Windows Subsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/) (in use).

## How to bootstrap

All you need is nix (any version). Run:
```
nix-shell
```

If you already have nix 2.4+, git, and have already enabled `flakes` and
`nix-command`, you can also use the non-legacy command:
```
nix develop
```

`nixos-rebuild --flake .` To build system configurations

`home-manager --flake .` To build user configurations

`nix build` (or shell or run) To build and use packages
