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

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
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
          nixpkgs.hostPlatform = system;
          users.users.maurelian = {
            name = "maurelian";
            home = "/Users/maurelian";
            shell = pkgs.fish;
          };
          system.stateVersion = 5;
          system.primaryUser = "maurelian";
          nix.settings.experimental-features = "nix-command flakes";

          # https://determinate.systems/posts/nix-darwin-updates/
          nix.enable = false;
          nix.registry.nixpkgs.flake = nixpkgs;

          environment.systemPackages = packages.nixPackages;
          environment.shells = [ pkgs.fish ];

          security.pam.services.sudo_local.touchIdAuth = true;
          system.keyboard = {
            enableKeyMapping = true;
            remapCapsLockToEscape = true;
          };
          system.defaults = {
            dock = {
              autohide = true;
              show-recents = false;
              mru-spaces = false;
              minimize-to-application = true;
              # Additional dock settings
              orientation = "bottom";
              tilesize = 48;
              magnification = false;
              show-process-indicators = true;
              wvous-tl-corner = 1; # Top-left corner: disabled
              wvous-tr-corner = 1; # Top-right corner: disabled
              wvous-bl-corner = 1; # Bottom-left corner: disabled
              wvous-br-corner = 1; # Bottom-right corner: disabled
            };

            finder = {
              AppleShowAllExtensions = true;
              ShowPathbar = true;
              ShowStatusBar = false;
              _FXShowPosixPathInTitle = true;
              FXPreferredViewStyle = "Nlsv"; # List view
              # Additional finder settings
              FXEnableExtensionChangeWarning = false;
              CreateDesktop = true; # Show icons on desktop
              QuitMenuItem = true; # Allow quitting Finder
              AppleShowAllFiles = true; # Don't show hidden files by default
              FXDefaultSearchScope = "SCcf"; # Search current folder by default
            };

            NSGlobalDomain = {
              # Allow key repeat
              ApplePressAndHoldEnabled = false;
              # Delay before repeating keystrokes
              InitialKeyRepeat = 20;
              # Delay between repeated keystrokes upon holding a key
              KeyRepeat = 2;
              # Expand save panel by default
              NSNavPanelExpandedStateForSaveMode = true;
              NSNavPanelExpandedStateForSaveMode2 = true;
              # Expand print panel by default
              PMPrintingExpandedStateForPrint = true;
              PMPrintingExpandedStateForPrint2 = true;
              # Save to disk (not iCloud) by default
              NSDocumentSaveNewDocumentsToCloud = false;

              # Additional system-wide settings
              AppleShowScrollBars = "Automatic"; # Automatic, Always, WhenScrolling
              AppleScrollerPagingBehavior = true; # Jump to spot clicked on scroll bar
              NSWindowResizeTime = 0.001; # Faster window resize animations
              NSAutomaticWindowAnimationsEnabled = true;
              AppleEnableSwipeNavigateWithScrolls = true;
              _HIHideMenuBar = false;

              # Text and input settings
              NSAutomaticCapitalizationEnabled = false;
              NSAutomaticDashSubstitutionEnabled = false;
              NSAutomaticPeriodSubstitutionEnabled = false;
              NSAutomaticQuoteSubstitutionEnabled = false;
              NSAutomaticSpellingCorrectionEnabled = false;
            };

            screencapture = {
              location = "~/Downloads";
              type = "png";
              show-thumbnail = true;
              disable-shadow = false;
            };

            # Trackpad settings
            trackpad = {
              Clicking = true;
              TrackpadRightClick = true;
              TrackpadThreeFingerDrag = true;
            };

            # Menu bar and system UI
            menuExtraClock = {
              ShowSeconds = false;
              ShowDate = 1; # Show date
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

      darwinConfigurations."MacBook-Pro" = nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          configuration
        ];
      };

      darwinPackages = self.darwinConfigurations."MacBook-Pro".pkgs;
    };
}
