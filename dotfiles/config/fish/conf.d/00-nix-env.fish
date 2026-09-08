# Load Nix before config.fish.
if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
end
fish_add_path $HOME/.nix-profile/bin /nix/var/nix/profiles/default/bin
