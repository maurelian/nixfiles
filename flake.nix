{
  description = "Maurelian's Darwin and Home Manager flake";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
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
      pkgs = nixpkgs.legacyPackages.${system};
      configuration = { pkgs, ... }: {
        # Auto upgrade nix package and the daemon service.
        services.nix-daemon.enable = true;
        # nix.package = pkgs.nix;
      };
    in {
      homeConfigurations.maurelian = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];
      };
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#MacBook-Pro-13.system
      darwinConfigurations."MacBook-Pro-13.system" = nix-darwin.lib.darwinSystem {
        modules = [ configuration ];
      };
      # darwinConfigurations."MacBook-Pro-13" = nix-darwin.lib.darwinSystem {
      #   modules = [ configuration ];
      # };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."MacBook-Pro-13.system".pkgs;
    };
}
