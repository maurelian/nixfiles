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

        ".home-manager-test.txt".text = "Hello from Home Manager!";
    };
  };

  home.packages = import ./packages.nix { inherit pkgs; };
}
