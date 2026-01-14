{ pkgs }:

{
  # Nix packages (installed via home-manager)
  nixPackages = with pkgs; [
    ack
    bat
    btop
    bun
    cloc
    cowsay
    dasel
    difftastic
    diff-so-fancy
    delta
    foundry
    gh
    gitui
    gnupg
    grc
    python312Packages.grip
    go
    gotestsum
    lazygit
    # Python environment with packages
    (python3.withPackages (ps: [
      ps.llm
      ps.llm-anthropic
    ]))

    # Add pipx for installing Python applications
    pipx

    fzf
    just
    jq
    kustomize
    nodejs_22
    nixfmt-rfc-style
    peco
    pinentry-tty
    ripgrep
    rustup
    tree
    # Use a tailscale overlay to skip the failing tests due to not finding netstat
    (tailscale.overrideAttrs (oldAttrs: {
      doCheck = false;  # Skip running tests during build
    }))
    tig
    tmux
    vim
    uv
    yarn
    yq-go
  ];

  # Homebrew configuration (installed via nix-darwin)
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "none";
    };

    taps = [ ];

    brews = [
      "circleci"
      "gettext"
      "git"
      "libiconv"
      "libunistring"
      "mise"
      "ncurses"
      "pcre2"
      "rg"
      # "rotki"
      "usage"
      "watch"
      "wt"
      "xan"
      "xsv"
    ];

    casks = [
      "1password"
      "1password-cli"
      "alt-tab"
      "arc"
      "brave-browser"
      "brainfm"
      "cleanshot"
      "cursor"
      "discord"
      "docker-desktop"
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
      "proton-mail-bridge"
      "raycast"
      "rectangle"
      "signal"
      "slack"
      "spotify"
      "telegram"
      "whatsapp"
      "balenaetcher"
      "iterm2"
    ];
  };
}
