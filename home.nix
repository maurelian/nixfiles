{ config, pkgs, ... }:

{
  home.username = "maurelian";
  home.homeDirectory = "/Users/maurelian";
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # Add your desired packages here
    git
    # vim
  ];

  # Add more configuration as needed
}
