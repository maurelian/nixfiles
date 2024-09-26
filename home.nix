{ config, pkgs, ... }:

{
  home.username = "maurelian";
  home.homeDirectory = "/Users/maurelian";
  home.stateVersion = "23.11"; # Use the version of Home Manager you initially installed

  programs.home-manager.enable = true;

  home = {
    file = {
      ".vimrc".source = ./program_configs/vim_configuration;
      ".ackrc".source = ./program_configs/ackrc;
      ".aliases".source = ./program_configs/aliases;
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
  ];

  programs.fish = {
    enable = true;
    shellAliases = {
      hm = "home-manager switch --flake $HOME/.config/nix#maurelian";
      lg = "lazygit --ucd ~/.config/lazygit/";
    };
    shellInit = ''
      fish_add_path $HOME/bin /usr/bin /usr/local/go
      fish_add_path --append /bin /usr/sbin /sbin /etc/paths.d $GOPATH/bin $HOME/.nvm $HOME/.foundry/bin $HOME/.cargo/bin $HOME/.local/bin
      '';

    shellInitLast = ''
      fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      starship init fish | source
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
