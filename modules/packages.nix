{ pkgs }:

{
  # Nix packages (installed via home-manager)
  nixPackages =
    with pkgs;
    [
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
      gh
      git
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
        ps.jupyter
        ps.jupyterlab
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
      tig
      tmux
      vim
      uv
      watch
      yarn
      yq-go

      # CLI tools (moved from Homebrew)
      circleci-cli
      mise
      opencode
      usage
    ]
    # These build from source on Linux and cause OOM; install via system tools instead
    # (tailscale via package manager, foundry via foundryup)
    ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
      foundry
      tailscale
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
