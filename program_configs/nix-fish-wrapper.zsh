#!/bin/zsh
# Fixes issues with nix profiles being uninitialized when iterm2 starts up
# Call this script via Settings > Profiles > General > Command =  "zsh ~/.nix-fish-wrapper.zsh"
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
exec fish
