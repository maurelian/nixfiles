{ pkgs }:

{
  # Nix packages (installed via home-manager)
  nixPackages = with pkgs; [
    ack
    bat
    btop
    bun
    circleci-cli
    cloc
    cowsay
    dasel
    difftastic
    diff-so-fancy
    delta
    foundry
    gh
    gitui
    glow
    gnupg
    grc
    python312Packages.grip
    go
    gotestsum
    lazygit
    miller
    mise
    mosh
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
    jujutsu
    jq
    kubectl
    kubie
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
      doCheck = false; # Skip running tests during build
    }))
    tig
    tmux
    usage
    vim
    uv
    watch
    xan
    yarn
    yq-go

    # Neovim + LSP servers for the native lazy.nvim config (dotfiles/config/nvim).
    # Servers are installed via nix (no mason) to keep one package manager.
    neovim
    bash-language-server
    gopls
    lua-language-server
    nil # nix LSP
    pyright
    # rust_analyzer comes from rustup (above), not a separate package
    typescript-language-server
    vscode-langservers-extracted # jsonls
    yaml-language-server
  ];

  # GUI apps (casks) and brew-only tools (taps, large builds like qemu/llama.cpp,
  # things not in nixpkgs): see the Brewfile. Install with `brew bundle`.
}
