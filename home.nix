{ config, pkgs, ... }:

let
  aliasesAndAbbreviations = import ./abbreviations.nix;
  aliases = aliasesAndAbbreviations.aliases;
  abbreviations = aliasesAndAbbreviations.abbreviations;
  functions = aliasesAndAbbreviations.functions;
in
{
  home.username = "maurelian";
  home.homeDirectory = "/Users/maurelian";
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  home = {
    file = {
      # source dotfiles into home directory
      ".vimrc".source = ./dotfiles/vimrc;
      ".ackrc".source = ./dotfiles/ackrc;
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
    };
  };

  home.packages = import ./packages.nix { inherit pkgs; } ++ [
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

    (pkgs.stdenv.mkDerivation {
      name = "git-push-fork-to-upstream-branch";
      version = "1.0.0";
      src = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/maurelian/git-push-fork-to-upstream-branch/master/git-push-fork-to-upstream-branch";
        sha256 = "sha256-rgkvv03NbG0jZprlkzAmhEp/ehs3mq9kyAoJOAu6YzU";
      };
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/bin
        cp $src $out/bin/git-push-fork-to-upstream-branch
        chmod 755 $out/bin/git-push-fork-to-upstream-branch
      '';
    })
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
      set GPG_TTY $(tty)
      fish_add_path $HOME/bin /usr/bin /usr/local/bin $HOME/go/bin
      fish_add_path --append /opt/homebrew/bin /bin /usr/sbin /sbin /etc/paths.d
      fish_add_path --append $GOPATH/bin $HOME/.nvm $HOME/.foundry/bin $HOME/.cargo/bin $HOME/.local/bin
      abbr -e gt
    '';

    shellInitLast = ''
      babelfish < $HOME/.aliases | source
      starship init fish | source
      babelfish < /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh | source
      source $HOME/.iterm2_shell_integration.fish

      set -x CDPATH "$HOME" "$HOME/.config" "$HOME/Projects/O" "$HOME/Projects/Hunting" "$HOME/Projects/Tools" "$HOME/Projects/Scoping" "$HOME/Projects/ReferenceCodebases" "$HOME/Projects/Miscellaneous" "$HOME/Projects/various-repos"
      set -U pisces_only_insert_at_eol 1 # quote/bracket completion setting

      # only run this on my optimism machine.
      # it makes homebrew work with Apple Silicon somehow.
      set -x HOMEBREW_PREFIX /opt/homebrew
      if test -d "/Users/maurelian"
        eval $(/opt/homebrew/bin/brew shellenv)
      end
      if not set -q NIX_PROFILES
        echo "Warning: Nix environment doesn't seem to be properly sourced"
      end
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.lazygit = {
    enable = true;
    settings = (builtins.readFile ./dotfiles/config/lazygit-config.yml);
  };
}
