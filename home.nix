{ config, pkgs, ... }:

let
  # Get username from config (passed from flake.nix) or fall back to environment
  username = config.home.username or (builtins.getEnv "USER");
  aliasesAndAbbreviations = import ./modules/abbreviations.nix { inherit username; };
  aliases = aliasesAndAbbreviations.aliases;
  abbreviations = aliasesAndAbbreviations.abbreviations;
  functions = aliasesAndAbbreviations.functions;
  gitConfig = import ./modules/git.nix { inherit pkgs; };
  packages = import ./modules/packages.nix { inherit pkgs; };
in
{
  # username and homeDirectory now set in flake.nix
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  home = {
    file = {
      # source dotfiles into home directory
      ".vimrc".source = ./dotfiles/vimrc;
      ".ackrc".source = ./dotfiles/ackrc;
      ".ripgreprc".source = ./dotfiles/ripgreprc;
      ".aliases".source = ./dotfiles/aliases;
      ".iterm2_shell_integration.zsh".source = ./dotfiles/iterm2_shell_integrations.zsh;
      ".iterm2_shell_integration.fish".source = ./dotfiles/iterm2_shell_integrations.fish;
      ".functions".source = ./dotfiles/functions;
      ".gitconfig".source = ./dotfiles/gitconfig;
      ".nix-fish-wrapper.zsh" = {
        source = ./dotfiles/nix-fish-wrapper.zsh;
        executable = true;
      };

      # source dotfiles $home/.config/
      ".config" = {
        source = ./dotfiles/config;
        recursive = true;
      };
      ".scripts" = {
        source = ./scripts;
        recursive = true;
        executable = true;
      };

      # Claude Code statusline script
      ".claude/statusline-command.sh" = {
        source = ./scripts/statusline-command.sh;
        executable = true;
      };

      # Claude Code hooks
      ".claude/hooks/idle-prompt.sh" = {
        source = ./scripts/claude-hooks/idle-prompt.sh;
        executable = true;
      };
      ".claude/hooks/permission-prompt.sh" = {
        source = ./scripts/claude-hooks/permission-prompt.sh;
        executable = true;
      };

      # Claude Code settings
      ".claude/settings.json".source = ./dotfiles/claude/settings.json;

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
      pkgs.fishPlugins.z
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
    shellInit = ''
      set -x EDITOR code
      set -x VISUAL nvim
      set -x GIT_EDITOR nvim
      set -x FOUNDRY_DISABLE_NIGHTLY_WARNING true
      set -x TENDERLY_USERNAME oplabs; set -x TENDERLY_PROJECT op-mainnet
      set -x RIPGREP_CONFIG_PATH $HOME/.config/ripgreprc
      set GPG_TTY $(tty)

      # Set up npm global directory outside of Nix management
      set -x NPM_GLOBAL $HOME/.npm-global
      npm config set prefix $NPM_GLOBAL 2>/dev/null

      # Set up pipx to install outside of Nix management
      set -x PIPX_HOME $HOME/.pipx
      set -x PIPX_BIN_DIR $PIPX_HOME/bin

      fish_add_path $HOME/bin /usr/bin /usr/local/bin $HOME/go/bin $HOME/.scripts $HOME/bin $HOME/.local/bin $NPM_GLOBAL/bin $PIPX_BIN_DIR
      fish_add_path --append $HOME/.foundry/bin /opt/homebrew/bin /bin /usr/sbin /sbin /etc/paths.d $GOPATH/bin $HOME/.nvm $HOME/.foundry/bin $HOME/.cargo/bin $HOME/.local/bin
      abbr -e gt
    '';

    shellInitLast = ''
      # makes homebrew work with Apple Silicon somehow.
      set -x HOMEBREW_PREFIX /opt/homebrew
      eval $(/opt/homebrew/bin/brew shellenv)

      babelfish < $HOME/.aliases | source
      starship init fish | source
      babelfish < /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh | source
      source $HOME/.iterm2_shell_integration.fish


      set -x CDPATH "$HOME" "$HOME/.config" "$HOME/Projects/" "$HOME/Projects/O" "$HOME/Projects/Tools" "$HOME/Projects/reference-codebases" "$HOME/Projects/misc"
      set -U pisces_only_insert_at_eol 1 # quote/bracket completion setting

      # set RPC URLs
      source ~/.rpc-urls > /dev/null

      # Run msa function when entering a git repo with mise.toml
      function __check_and_run_msa --on-variable PWD
        if git rev-parse --show-toplevel >/dev/null 2>&1
            set repo (git rev-parse --show-toplevel)
            if test -e "$repo/mise.toml"
                mise activate | source
            end
        end
      end

      # Call once at shell startup
      __check_and_run_msa

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
