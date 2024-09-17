{ config, pkgs, ... }:

{
  home.username = "maurelian";
  home.homeDirectory = "/Users/maurelian";
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  home = {
    file = {
        ".vimrc" = {
            source = ./vim_configuration;
        };

        ".ackrc" = {
            source = ./ackrc;
        };

        ".home-manager-test.txt".text = "Hello from Home Manager!";
    };
  };

  home.packages = import ./packages.nix { inherit pkgs; };
}
