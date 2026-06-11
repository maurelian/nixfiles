{ config, pkgs, lib, ... }:

let
  username = config.home.username;
  aliasesAndAbbreviations = import ./modules/abbreviations.nix { inherit username; };
  aliases = aliasesAndAbbreviations.aliases;
  abbreviations = aliasesAndAbbreviations.abbreviations;
  functions = aliasesAndAbbreviations.functions;
  gitConfig = import ./modules/git.nix { inherit pkgs; };
  packages = import ./modules/packages.nix { inherit pkgs; };
  repoDir = "${config.home.homeDirectory}/Projects/Tools/nixfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${repoDir}/${path}";
in
{
  # username and homeDirectory now set in flake.nix
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  home = {
    file = {
      # live symlinks into the repo working copy — edits apply instantly
      ".vimrc".source = link "dotfiles/vimrc";
      ".ackrc".source = link "dotfiles/ackrc";
      ".ripgreprc".source = link "dotfiles/ripgreprc";
      ".aliases".source = link "dotfiles/aliases";
      ".functions".source = link "dotfiles/functions";
      ".gitconfig".source = link "dotfiles/gitconfig";
      ".iterm2_shell_integration.zsh".source = link "dotfiles/iterm2_shell_integrations.zsh";
      ".iterm2_shell_integration.fish".source = link "dotfiles/iterm2_shell_integrations.fish";
      ".nix-fish-wrapper.zsh".source = link "dotfiles/nix-fish-wrapper.zsh";

      # directory-level links: adding a file inside needs no rebuild
      ".config/ghostty".source = link "dotfiles/config/ghostty";
      ".config/tmux".source = link "dotfiles/config/tmux";
      ".config/starship.toml".source = link "dotfiles/config/starship.toml";
      # config-only links: the dir also holds machine-local runtime state
      # (lazygit's state.yml, gh's hosts.yml/state.yml) that must stay out of the repo
      ".config/lazygit/config.yml".source = link "dotfiles/config/lazygit/config.yml";
      ".config/gh/config.yml".source = link "dotfiles/config/gh/config.yml";

      # ~/.scripts stays a real dir so machine-local bins (be-*, claude-tmux) survive
      ".scripts/apply-macos-defaults.sh".source = link "scripts/apply-macos-defaults.sh";
      ".scripts/getSafeDetails".source = link "scripts/getSafeDetails";
      ".scripts/qq".source = link "scripts/qq";
      ".scripts/readSystemConfig".source = link "scripts/readSystemConfig";
      ".scripts/statusline-command.sh".source = link "scripts/statusline-command.sh";
      ".scripts/claude-hooks".source = link "scripts/claude-hooks";
      ".claude/statusline-command.sh".source = link "scripts/statusline-command.sh";
      ".claude/hooks/idle-prompt.sh".source = link "scripts/claude-hooks/idle-prompt.sh";
      ".claude/hooks/permission-prompt.sh".source = link "scripts/claude-hooks/permission-prompt.sh";

      # Auto-create CDPATH directories
      "Projects/.keep".text = "";
      "Projects/O/.keep".text = "";
      "Projects/Tools/.keep".text = "";
      "Projects/reference-codebases/.keep".text = "";
      "Projects/misc/.keep".text = "";
    };
  };

  home.packages =
    packages.nixPackages
    ++ [
      # Additional packages can be added here
      pkgs.fishPlugins.foreign-env
      pkgs.zsh-history-to-fish
      pkgs.starship

      # Fish plugins that this guy uses: https://github.com/r17x/universe/blob/45595dda71df5c34b8110827a044e487ad52f7af/nix/home/shells.nix#L161
      pkgs.babelfish
      pkgs.fishPlugins.colored-man-pages
      # https://github.com/franciscolourenco/done - get notified when a long running command finishes
      pkgs.fishPlugins.done
      # use babelfish than foreign-env
      pkgs.fishPlugins.foreign-env
      # Paired symbols in the command line
      pkgs.fishPlugins.pisces
      pkgs.fishPlugins.puffer
      pkgs.fishPlugins.fifc
      pkgs.fishPlugins.bass
      pkgs.fishPlugins.git-abbr

      pkgs.fishPlugins.grc
    ]
    ++ gitConfig.home.packages;

  imports = [
    ./modules/git.nix
    ./modules/nixvim.nix
  ];

  programs.fish = {
    enable = true;
    shellAliases = aliases;
    shellAbbrs = abbreviations;
    functions = functions;
    plugins = [
      { name = "z"; src = pkgs.fishPlugins.z.src; }
    ];
    shellInit = ''
      # Nix profile paths must be set first so nix-installed tools are available
      fish_add_path $HOME/.nix-profile/bin /nix/var/nix/profiles/default/bin

      set -x EDITOR code
      set -x VISUAL nvim
      set -x GIT_EDITOR nvim
      set -x FOUNDRY_DISABLE_NIGHTLY_WARNING true
      set -x TENDERLY_USERNAME oplabs; set -x TENDERLY_PROJECT op-mainnet
      set -x RIPGREP_CONFIG_PATH $HOME/.ripgreprc
      set GPG_TTY $(tty)

      # Set up npm global directory outside of Nix management
      set -x NPM_GLOBAL $HOME/.npm-global
      npm config set prefix $NPM_GLOBAL 2>/dev/null

      # Set up pipx to install outside of Nix management
      set -x PIPX_HOME $HOME/.pipx
      set -x PIPX_BIN_DIR $PIPX_HOME/bin

      # Note: fish_add_path only adds directories that actually exist on the filesystem
      # Non-existent paths (like ~/bin, ~/.pipx/bin, ~/.nvm) are silently skipped
      fish_add_path $HOME/bin /usr/bin /usr/local/bin $HOME/go/bin $HOME/.scripts $HOME/bin $HOME/.local/bin $NPM_GLOBAL/bin $PIPX_BIN_DIR
      fish_add_path --append $HOME/.foundry/bin /opt/homebrew/bin /bin /usr/sbin /sbin /etc/paths.d $GOPATH/bin $HOME/.nvm $HOME/.foundry/bin $HOME/.cargo/bin $HOME/.local/bin
      abbr -e gt
    '';

    shellInitLast = ''
      ${lib.optionalString pkgs.stdenv.isDarwin ''
      # makes homebrew work with Apple Silicon somehow.
      set -x HOMEBREW_PREFIX /opt/homebrew
      eval $(/opt/homebrew/bin/brew shellenv)
      ''}

      babelfish < /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh | source
      babelfish < $HOME/.aliases | source
      starship init fish | source
      source $HOME/.iterm2_shell_integration.fish


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
    '';
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.lazygit = {
    enable = true;
  };

  programs.gpg = {
    enable = true;
  };
}
