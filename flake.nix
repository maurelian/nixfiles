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
      # Define systems and configurations
      systems = {
        darwin = "aarch64-darwin";
        linux = "x86_64-linux";  # or "aarch64-linux" if on ARM
      };

      # Function to get pkgs for a system
      pkgsFor = system: nixpkgs.legacyPackages.${system};

      # Your existing darwin configuration
      darwinConfig = { pkgs, ... }: {
        services.nix-daemon.enable = true;
        nixpkgs.hostPlatform = systems.darwin;
        users.users.maurelian = {
          name = "maurelian";
          home = "/Users/maurelian";
        };
        system.stateVersion = 5;

        nix.settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
        };
      };
    in
    {
      # Keep your existing configuration
      homeConfigurations.maurelian = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor systems.darwin;
        modules = [ ./home.nix ];
      };

      # Add Linux configuration
      homeConfigurations."maurelian-linux" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor systems.linux;
        modules = [ ./home.nix ];
      };

      # Keep your existing Darwin configuration
      darwinConfigurations."MacBook-Pro-13" = nix-darwin.lib.darwinSystem {
        system = systems.darwin;
        modules = [
          darwinConfig
        ];
      };

      darwinPackages = self.darwinConfigurations."MacBook-Pro-13".pkgs;
    };
}
