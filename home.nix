{ config, pkgs, ... }:

let
  aliasesAndAbbreviations = import ./abbreviations.nix;
  aliases = aliasesAndAbbreviations.aliases;
  abbreviations = aliasesAndAbbreviations.abbreviations;
  functions = aliasesAndAbbreviations.functions;
  gitConfig = import ./git.nix { inherit pkgs; };

  # Detect platform
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  # Platform-specific home directory
  homeDirectory = if isDarwin then "/Users/maurelian" else "/home/maurelian";
in
{
  home.username = "maurelian";
  home.homeDirectory = homeDirectory;
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  home = {
    file = {
      # Common dotfiles for both platforms
      ".vimrc".source = ./dotfiles/vimrc;
      ".ackrc".source = ./dotfiles/ackrc;
      ".aliases".source = ./dotfiles/aliases;
      ".functions".source = ./dotfiles/functions;
      ".gitconfig".source = ./dotfiles/gitconfig;

      # Config directory for both platforms
      ".config" = {
        source = ./dotfiles/config;
        recursive = true;
      };
    } // (if isDarwin then {
      # Darwin-specific files
      ".iterm2_shell_integration.zsh".source = ./dotfiles/iterm2_shell_integrations.zsh;
      ".iterm2_shell_integration.fish".source = ./dotfiles/iterm2_shell_integrations.fish;
      ".nix-fish-wrapper.zsh" = {
        source = ./dotfiles/nix-fish-wrapper.zsh;
        executable = true;
      };
    } else {});
  };

  home.packages = import ./packages.nix { inherit pkgs; } ++ [
    # Common packages for both platforms
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
  ] ++ gitConfig.home.packages;

  imports = [ ./git.nix ];

  programs.fish = {
    enable = true;
    shellAliases = aliases;
    shellAbbrs = abbreviations;
    functions = functions;
    shellInit = ''
      set -x EDITOR code
      set -x VISUAL nvim
      set -x GIT_EDITOR nvim
      set GPG_TTY $(tty)
      fish_add_path $HOME/bin /usr/bin /usr/local/bin $HOME/go/bin
      ${if isDarwin then ''
        fish_add_path --append /opt/homebrew/bin /bin /usr/sbin /sbin /etc/paths.d
      '' else ''
        fish_add_path --append /bin /usr/sbin /sbin
      ''}
      fish_add_path --append $GOPATH/bin $HOME/.nvm $HOME/.foundry/bin $HOME/.cargo/bin $HOME/.local/bin
      abbr -e gt
    '';

    shellInitLast = ''
      ${if isDarwin then ''
        # Darwin-specific initialization
        set -x HOMEBREW_PREFIX /opt/homebrew
        if test -d "/Users/maurelian"
          eval $(/opt/homebrew/bin/brew shellenv)
        end
        source $HOME/.iterm2_shell_integration.fish
      '' else ""}

      babelfish < $HOME/.aliases | source
      starship init fish | source
      babelfish < /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh | source

      set -x CDPATH "$HOME" "$HOME/.config" "$HOME/Projects/O" "$HOME/Projects/Hunting" "$HOME/Projects/Tools" "$HOME/Projects/Scoping" "$HOME/Projects/ReferenceCodebases" "$HOME/Projects/Miscellaneous" "$HOME/Projects/various-repos"
      set -U pisces_only_insert_at_eol 1 # quote/bracket completion setting

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

  # programs.gnupg.agent.enable = true;
}
