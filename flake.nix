{
  description = "Maurelian's Home Manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      darwinSystem = "aarch64-darwin";
      linuxSystem = "x86_64-linux";
      darwinPkgs = nixpkgs.legacyPackages.${darwinSystem};
      linuxPkgs = nixpkgs.legacyPackages.${linuxSystem};

      mkHome =
        {
          pkgs,
          username,
          homeDirectory,
        }:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home.nix
            {
              home.username = username;
              home.homeDirectory = homeDirectory;
            }
          ];
        };
    in
    {
      # One entry per machine/user; add a line here for a new machine.
      # Selected at runtime by the `hm` abbreviation via $USER.
      homeConfigurations = {
        john = mkHome {
          pkgs = darwinPkgs;
          username = "john";
          homeDirectory = "/Users/john";
        };
        # Linux box: home-manager switch --flake ~/Projects/Tools/nixfiles#root
        root = mkHome {
          pkgs = linuxPkgs;
          username = "root";
          homeDirectory = "/root";
        };
      };
    };
}
