# Native fish config — edit live, no rebuild. (Was home.nix programs.fish.)
# conf.d/ holds aliases, abbreviations, and the nix-env PATH bootstrap.

set -x EDITOR code
set -x VISUAL nvim
set -x GIT_EDITOR nvim
set -x FOUNDRY_DISABLE_NIGHTLY_WARNING true
set -x TENDERLY_USERNAME oplabs
set -x TENDERLY_PROJECT op-mainnet
set -x RIPGREP_CONFIG_PATH $HOME/.ripgreprc
set -x GNUPGHOME $HOME/.gnupg
set GPG_TTY $(tty)

# Set up npm global directory outside of Nix management
set -x NPM_GLOBAL $HOME/.npm-global
npm config set prefix $NPM_GLOBAL 2>/dev/null

# Set up pipx to install outside of Nix management
set -x PIPX_HOME $HOME/.pipx
set -x PIPX_BIN_DIR $PIPX_HOME/bin

# fish_add_path only adds directories that actually exist on the filesystem
fish_add_path $HOME/bin /usr/bin /usr/local/bin $HOME/go/bin $HOME/.scripts $HOME/.local/bin $NPM_GLOBAL/bin $PIPX_BIN_DIR
fish_add_path --append $HOME/.foundry/bin /opt/homebrew/bin /bin /usr/sbin /sbin /etc/paths.d $GOPATH/bin $HOME/.nvm $HOME/.cargo/bin
abbr -e gt 2>/dev/null

if test (uname) = Darwin
    # makes homebrew work with Apple Silicon
    set -x HOMEBREW_PREFIX /opt/homebrew
    eval $(/opt/homebrew/bin/brew shellenv)
end

babelfish < /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh | source
babelfish < $HOME/.aliases | source
starship init fish | source
source $HOME/.iterm2_shell_integration.fish

if status is-interactive
    fzf --fish | source
    # Sourced here (last) so custom abbrs/aliases override vendor plugins
    # like git-abbr, whose conf.d loads after all user conf.d files.
    source $HOME/.config/fish/abbreviations.fish
    source $HOME/.config/fish/aliases.fish
end

set -x CDPATH "$HOME" "$HOME/.config" "$HOME/Projects/" "$HOME/Projects/O" "$HOME/Projects/Tools" "$HOME/Projects/reference-codebases" "$HOME/Projects/misc"
set -U pisces_only_insert_at_eol 1 # quote/bracket completion setting

# set RPC URLs
source ~/.rpc-urls > /dev/null

if test -f $HOME/.secrets
    source $HOME/.secrets
end

if test -f $HOME/.config.fish
    source $HOME/.config.fish
end

if not set -q NIX_PROFILES
    echo "Warning: Nix environment doesn't seem to be properly sourced"
end
