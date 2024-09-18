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

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, ... }:
    let
      system = "aarch64-darwin";
      system.stateVersion = 5;
      pkgs = nixpkgs.legacyPackages.${system};
      configuration = { pkgs, ... }: {
        services.nix-daemon.enable = true;
        nixpkgs.hostPlatform = system;
        users.users.maurelian = {
          name = "maurelian";
          home = "/Users/maurelian";
        };
      };
    in {
      homeConfigurations.maurelian = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
        ];
      };

      darwinConfigurations."MacBook-Pro-13" = nix-darwin.lib.darwinSystem {
        inherit system;
        # system.stateVersion = 5;
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.maurelian = import ./home.nix;
          }
        ];
      };

      darwinPackages = self.darwinConfigurations."MacBook-Pro-13".pkgs;
    };
}
