{
  description = "Maurelian's Home Manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
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
      # Get username from environment, fallback to "maurelian"
      username = builtins.getEnv "USER";

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
            inputs.nixvim.homeModules.nixvim
            {
              home.username = username;
              home.homeDirectory = homeDirectory;
            }
          ];
        };
    in
    {
      # macOS home config (used by `hm` abbreviation which passes --impure)
      homeConfigurations.${username} = mkHome {
        pkgs = darwinPkgs;
        inherit username;
        homeDirectory = "/Users/${username}";
      };

      # Linux home config: home-manager switch --flake ~/.config/nix#root
      homeConfigurations."root" = mkHome {
        pkgs = linuxPkgs;
        username = "root";
        homeDirectory = "/root";
      };
    };
}
