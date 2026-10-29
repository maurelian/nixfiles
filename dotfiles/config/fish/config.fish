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
set -x npm_config_prefix $NPM_GLOBAL

# Set up pipx to install outside of Nix management
set -x PIPX_HOME $HOME/.pipx
set -x PIPX_BIN_DIR $PIPX_HOME/bin

# fish_add_path only adds directories that actually exist on the filesystem
fish_add_path $HOME/bin /usr/bin /usr/local/bin $HOME/go/bin $HOME/.scripts $HOME/.local/bin $NPM_GLOBAL/bin $PIPX_BIN_DIR
fish_add_path --append $HOME/.foundry/bin /opt/homebrew/bin /bin /usr/sbin /sbin /etc/paths.d $GOPATH/bin $HOME/.nvm $HOME/.cargo/bin
abbr -e gt 2>/dev/null

if test (uname) = Darwin
    set -gx HOMEBREW_PREFIX /opt/homebrew
    set -gx HOMEBREW_CELLAR /opt/homebrew/Cellar
    set -gx HOMEBREW_REPOSITORY /opt/homebrew
    fish_add_path --global --move --path /opt/homebrew/bin /opt/homebrew/sbin
    if test -n "$MANPATH[1]"
        set -gx MANPATH '' $MANPATH
    end
    set -q INFOPATH; or set INFOPATH ''
    if not contains /opt/homebrew/share/info $INFOPATH
        set -gx INFOPATH /opt/homebrew/share/info $INFOPATH
    end
end

source $HOME/.config/fish/generated/aliases.fish
source $HOME/.config/fish/generated/starship.fish
source $HOME/.iterm2_shell_integration.fish

if status is-interactive
    source $HOME/.config/fish/generated/fzf.fish
    # Sourced here (last) so custom abbrs/aliases override vendor plugins
    # like git-abbr, whose conf.d loads after all user conf.d files.
    source $HOME/.config/fish/abbreviations.fish
    source $HOME/.config/fish/aliases.fish
end

if status is-interactive; and test (uname) = Darwin
    fix-ssh-agent
    function _fix_ssh_agent_preexec --on-event fish_preexec
        string match -qr '^\s*(ssh|ssh-add|scp|sftp|rsync|git)\b' -- $argv[1]; and fix-ssh-agent
    end
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
