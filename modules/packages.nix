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

    taps = [
    ];

    brews = [
      "rg"
    ];

    casks = [ "jordanbaird-ice" "nikitabobko/tap/aerospace" ];
  };
}
