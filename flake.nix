{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, darwin, nixpkgs }: {
    darwinConfigurations."MacBook-Pro-13.local" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ({ pkgs, ... }: {
          users.users.maurelian = {
            name = "maurelian";
            home = "/Users/maurelian";
          };
        })
      ];
    };
  };
}
