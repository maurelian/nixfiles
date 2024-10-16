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
      ".vimrc".source = ./program_configs/vim_configuration;
      ".ackrc".source = ./program_configs/ackrc;
      ".aliases".source = ./program_configs/aliases;
      ".iterm2_shell_integration.zsh".source = ./program_configs/iterm2_shell_integrations.zsh;
      ".iterm2_shell_integration.fish".source = ./program_configs/iterm2_shell_integrations.fish;
      ".functions".source = ./program_configs/functions;
      ".gitconfig".source = ./program_configs/gitconfig;
      ".config/lazygit/config.yml".source = ./program_configs/lazygit-config.yml;
      ".config/gh/config.yml".source = ./program_configs/gh/config.yml;
      ".config/gh/hosts.yml".source = ./program_configs/gh/hosts.yml;
      ".config/gh/state.yml".source = ./program_configs/gh/state.yml;
      ".config/starship.toml".source = ./program_configs/starship.toml;
      ".nix-fish-wrapper.zsh" = {
        source = ./program_configs/nix-fish-wrapper.zsh;
        executable = true;
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

  # Derivation examples, just in case that's ever needed
  #   {
  #     name = "z";
  #     src = pkgs.fetchFromGitHub {
  #       owner = "jethrokuan";
  #       repo = "z";
  #       rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
  #       sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
  #    };
  #  }
  #  { name = "grc"; src = pkgs.fishPlugins.grc.src; }
  ];

  programs.fish = {
    enable = true;
    shellAliases = aliases;
    shellAbbrs = abbreviations;
    functions = functions;
    shellInit = ''
      export EDITOR=code
      export VISUAL=nvim
      export GIT_EDITOR=nvim
      fish_add_path $HOME/bin /usr/bin /usr/local/go /opt/homebrew/bin
      fish_add_path --append /bin /usr/sbin /sbin /etc/paths.d $GOPATH/bin $HOME/.nvm $HOME/.foundry/bin $HOME/.cargo/bin $HOME/.local/bin
      set GPG_TTY $(tty)
      abbr -e gt
    '';

    shellInitLast = ''
      babelfish < $HOME/.aliases | source
      starship init fish | source
      source $HOME/.iterm2_shell_integration.fish
      set -x CDPATH "$HOME" "$HOME/.config" "$HOME/Projects/O" "$HOME/Projects/Hunting" "$HOME/Projects/Tools" "$HOME/Projects/Scoping" "$HOME/Projects/ReferenceCodebases" "$HOME/Projects/Miscellaneous" "$HOME/Projects/various-repos"
      set -U pisces_only_insert_at_eol 1 # quote/bracket completion setting
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
    settings = (builtins.readFile ./program_configs/lazygit-config.yml);
  };
}
