{ config, pkgs, ... }:

{
  home.username = "maurelian";
  home.homeDirectory = "/Users/maurelian";
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # Add your desired packages here
    # git
    vim
  ];

  home = {
    file = {
        ".vimrc" = {
            source = ./vim_configuration;
        };
        # test file, not showing up
        ".home-manager-test.txt".text = "Hello from Home Manager!";
    };
  };
}
