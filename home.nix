{ config, pkgs, ... }:

let
  aliasesAndAbbreviations = import ./abbreviations.nix;
  aliases = aliasesAndAbbreviations.aliases;
  abbreviations = aliasesAndAbbreviations.abbreviations;
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
    # https://github.com/wfxr/forgit
    pkgs.fishPlugins.forgit
    # Paired symbols in the command line
    pkgs.fishPlugins.pisces
    pkgs.fishPlugins.puffer
    pkgs.fishPlugins.fifc
    pkgs.fishPlugins.bass
    pkgs.fishPlugins.git-abbr
  ];

  programs.fish = {
    enable = true;
    shellAliases = aliases;
    shellAbbrs = abbreviations;
    shellInit = ''
      fish_add_path $HOME/bin /usr/bin /usr/local/go /opt/homebrew/bin
      fish_add_path --append /bin /usr/sbin /sbin /etc/paths.d $GOPATH/bin $HOME/.nvm $HOME/.foundry/bin $HOME/.cargo/bin $HOME/.local/bin
      abbr -e gt
    '';

    shellInitLast = ''
      fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      babelfish < $HOME/.aliases | source
      starship init fish | source
      source $HOME/.iterm2_shell_integration.fish
      set -x CDPATH "$HOME" "$HOME/.config" "$HOME/Projects/O" "$HOME/Projects/Hunting" "$HOME/Projects/Tools" "$HOME/Projects/Scoping" "$HOME/Projects/ReferenceCodebases" "$HOME/Projects/Miscellaneous" "$HOME/Projects/various-repos"
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
