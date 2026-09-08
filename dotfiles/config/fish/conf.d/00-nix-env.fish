# Loads before config.fish (conf.d runs first). Put nix-installed tools on
# PATH early so any conf.d snippet can use them.
#
# Fish plugins (pisces, puffer, fifc, git-abbr, z, …) load
# natively: nix-daemon.sh puts ~/.nix-profile/share on XDG_DATA_DIRS at login,
# so fish's own vendor_conf.d discovery sources them. No manual wiring here —
# doing so would double-load (re-bind keys, duplicate event handlers).
fish_add_path $HOME/.nix-profile/bin /nix/var/nix/profiles/default/bin
