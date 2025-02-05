{ pkgs }:
{
  # Nix packages
  nixPackages = with pkgs; [
    ack
    bat
    btop
    cloc
    cowsay
    difftastic
    diff-so-fancy
    gh
    gnupg
    grc
    go
    gotestsum
    lazygit
    fzf
    just
    jq
    kustomize
    neovim
    nodejs_22
    nixfmt-rfc-style
    peco
    pinentry-tty
    ripgrep
    rustup
    tree
    tailscale
    tig
    vim
    yq
  ];

  # Homebrew configuration
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "none";
    };

    taps = [];

    brews = [
      "rg"
      "mise"
    ];

    casks = [
      "1password"
      "arc"
      "brave-browser"
      "cleanshot"
      "cursor"
      "discord"
      "docker"
      "fantastical"
      "firefox"
      "gpg-suite"
      "hazeover"
      "jordanbaird-ice"
      "keybase"
      "logseq"
      "notion"
      "obsidian"
      "orbstack"
      "protonvpn"
      "protonmail-bridge"
      "raycast"
      "rectangle"
      "signal"
      "slack"
      "spotify"
      "telegram"
      "visual-studio-code"
      "warp"
      "watch"
      "whatsapp"
      "balenaetcher"
      "iterm2"
    ];
  };
}
