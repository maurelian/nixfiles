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
      # Define supported systems
      supportedSystems = [
        "aarch64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];

      # Function to get pkgs for each system
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgsFor = system: nixpkgs.legacyPackages.${system};

      # Your existing darwin configuration
      darwinConfig = { pkgs, ... }: {
        services.nix-daemon.enable = true;
        nixpkgs.hostPlatform = "aarch64-darwin";
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
      # Home Manager configurations for each platform
      homeConfigurations = {
        # Darwin configuration
        maurelian = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor "aarch64-darwin";
          modules = [ ./home.nix ];
        };

        # Linux configuration
        "maurelian-linux" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor "x86_64-linux";
          modules = [ ./home.nix ];
        };
      };

      # Darwin-specific configuration
      darwinConfigurations."MacBook-Pro-13" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          darwinConfig
        ];
      };

      darwinPackages = self.darwinConfigurations."MacBook-Pro-13".pkgs;
    };
}
