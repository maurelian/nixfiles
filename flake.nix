{
  description = "Maurelian's Darwin and Home Manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
      configuration =
        { pkgs, ... }:
        let
          packages = import ./modules/packages.nix { inherit pkgs; };
        in
        {
          services.nix-daemon.enable = true;
          nixpkgs.hostPlatform = system;
          users.users.maurelian = {
            name = "maurelian";
            home = "/Users/maurelian";
            shell = pkgs.fish;
          };
          system.stateVersion = 5;
          nix.settings.experimental-features = "nix-command flakes";

          environment.systemPackages = packages.nixPackages;
          environment.shells = [ pkgs.fish ];

          security.pam.enableSudoTouchIdAuth = true;
          system.defaults = {
            dock.autohide = true;
            finder.AppleShowAllExtensions = true;
            NSGlobalDomain = {
              # allow key repeat
              ApplePressAndHoldEnabled = false;
              # delay before repeating keystrokes
              InitialKeyRepeat = 20;
              # delay between repeated keystrokes upon holding a key
              KeyRepeat = 2;
            };
          };

          programs.fish.enable = true;

          # Import homebrew configuration from packages.nix
          homebrew = packages.homebrew;
        };
    in
    {
      homeConfigurations.maurelian = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
        ];
      };

      darwinConfigurations."MacBook-Pro-13" = nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          configuration
        ];
      };

      darwinPackages = self.darwinConfigurations."MacBook-Pro-13".pkgs;
    };
}
