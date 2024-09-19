{ config, pkgs, ... }:

{
  home.username = "maurelian";
  home.homeDirectory = "/Users/maurelian";
  home.stateVersion = "23.11"; # Use the version of Home Manager you initially installed

  programs.home-manager.enable = true;

  home = {
    file = {
        ".vimrc" = {
            source = ./program_configs/vim_configuration;
        };

        ".ackrc" = {
            source = ./program_configs/ackrc;
        };

        ".zshrc" = {
            source = ./program_configs/zshrc;
        };

        ".zshenv" = {
            source = ./program_configs/zshenv;
        };
    };
  };

  home.packages = import ./packages.nix { inherit pkgs; };

  programs.zsh = {
    enable = true;
    prezto = {
      enable = true;
      pmodules = [
        "terminal"
        "editor"
        "directory"
        "spectrum"
        "utility"
        "completion"
        "contrib-prompt"
        "prompt"
        "history-substring-search"
        "history"
        "git"
        "node"
        "ssh"
        "tmux"
        "environment"
      ];
      extraConfig = ''
        # Auto convert .... to ../..
        zstyle ':prezto:module:editor' dot-expansion 'yes'
      '';
    };
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
