{
  config,
  pkgs,
  lib,
  ...
}:

let
  gitConfig = import ./modules/git.nix { inherit pkgs; };
  packages = import ./modules/packages.nix { inherit pkgs; };
  repoDir = "${config.home.homeDirectory}/Projects/Tools/nixfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${repoDir}/${path}";
  fzfFishInit = pkgs.runCommand "fzf-init.fish" { } ''
    ${pkgs.fzf}/bin/fzf --fish > "$out"
  '';
  grcFishPlugin = pkgs.runCommand "fishplugin-grc-lazy" { } ''
    functions_dir="$out/share/fish/vendor_functions.d"
    mkdir -p "$functions_dir"
    cp ${pkgs.fishPlugins.grc}/share/fish/vendor_functions.d/grc.wrap.fish "$functions_dir/grc.wrap.fish"
    while IFS= read -r executable; do
      printf 'function %s --wraps=%s\n    grc.wrap %s $argv\nend\n' \
        "$executable" "$executable" "$executable" > "$functions_dir/$executable.fish"
    done < ${pkgs.fishPlugins.grc}/share/fish/vendor_conf.d/executables
  '';
  starshipFishInit = pkgs.runCommand "starship-init.fish" { } ''
    ${pkgs.starship}/bin/starship init fish --print-full-init > "$out"
  '';
in
{
  # username and homeDirectory now set in flake.nix
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  home = {
    file = {
      # live symlinks into the repo working copy — edits apply instantly
      ".vimrc".source = link "dotfiles/vimrc";
      ".ackrc".source = link "dotfiles/ackrc";
      ".ripgreprc".source = link "dotfiles/ripgreprc";
      ".aliases".source = link "dotfiles/aliases";
      ".functions".source = link "dotfiles/functions";
      ".gitconfig".source = link "dotfiles/gitconfig";
      ".iterm2_shell_integration.zsh".source = link "dotfiles/iterm2_shell_integrations.zsh";
      ".iterm2_shell_integration.fish".source = link "dotfiles/iterm2_shell_integrations.fish";
      ".nix-fish-wrapper.zsh".source = link "dotfiles/nix-fish-wrapper.zsh";

      # directory-level links: adding a file inside needs no rebuild
      ".config/ghostty".source = link "dotfiles/config/ghostty";
      ".config/tmux".source = link "dotfiles/config/tmux";
      ".config/starship.toml".source = link "dotfiles/config/starship.toml";
      # config-only links: the dir also holds machine-local runtime state
      # (lazygit's state.yml, gh's hosts.yml/state.yml, jj's repos/) that must
      # stay out of the repo
      ".config/lazygit/config.yml".source = link "dotfiles/config/lazygit/config.yml";
      ".config/gh/config.yml".source = link "dotfiles/config/gh/config.yml";
      ".config/jj/config.toml".source = link "dotfiles/config/jj/config.toml";

      # ~/.scripts stays a real dir so machine-local bins (be-*, claude-tmux) survive
      ".scripts/apply-macos-defaults.sh".source = link "scripts/apply-macos-defaults.sh";
      ".scripts/getSafeDetails".source = link "scripts/getSafeDetails";
      ".scripts/qq".source = link "scripts/qq";
      ".scripts/readSystemConfig".source = link "scripts/readSystemConfig";
      ".scripts/statusline-command.sh".source = link "scripts/statusline-command.sh";
      ".scripts/claude-hooks".source = link "scripts/claude-hooks";
      ".claude/statusline-command.sh".source = link "scripts/statusline-command.sh";
      ".claude/hooks/idle-prompt.sh".source = link "scripts/claude-hooks/idle-prompt.sh";
      ".claude/hooks/permission-prompt.sh".source = link "scripts/claude-hooks/permission-prompt.sh";

      # Native fish config. config.fish + conf.d files are per-child links so
      # machine-local conf.d entries (wt.fish, fish_frozen_*) and fish_variables
      # stay out of the repo; functions/ has no machine-local state so it is a
      # whole-dir link (new function files then need no rebuild).
      ".config/fish/config.fish".source = link "dotfiles/config/fish/config.fish";
      ".config/fish/abbreviations.fish".source = link "dotfiles/config/fish/abbreviations.fish";
      ".config/fish/aliases.fish".source = link "dotfiles/config/fish/aliases.fish";
      ".config/fish/conf.d/00-nix-env.fish".source = link "dotfiles/config/fish/conf.d/00-nix-env.fish";
      ".config/fish/functions".source = link "dotfiles/config/fish/functions";
      ".config/fish/generated/fzf.fish".source = fzfFishInit;
      ".config/fish/generated/starship.fish".source = starshipFishInit;
      # Per-file so installers that drop their own completions into
      # ~/.config/fish/completions don't land in the repo.
      ".config/fish/completions/herdr.fish".source = link "dotfiles/config/fish/completions/herdr.fish";

      # Native neovim config (lazy.nvim). lazy writes lazy-lock.json back into
      # this dir — that's the version lockfile and is tracked in the repo.
      ".config/nvim".source = link "dotfiles/config/nvim";

      # Auto-create CDPATH directories
      "Projects/.keep".text = "";
      "Projects/O/.keep".text = "";
      "Projects/Tools/.keep".text = "";
      "Projects/reference-codebases/.keep".text = "";
      "Projects/misc/.keep".text = "";
    };
  };

  home.packages =
    packages.nixPackages
    ++ [
      # Additional packages can be added here
      pkgs.fish
      # z plugin (was programs.fish.plugins); loads natively from vendor_conf.d
      pkgs.fishPlugins.z
      pkgs.fishPlugins.foreign-env
      pkgs.zsh-history-to-fish
      pkgs.starship

      # Fish plugins that this guy uses: https://github.com/r17x/universe/blob/45595dda71df5c34b8110827a044e487ad52f7af/nix/home/shells.nix#L161
      pkgs.babelfish
      pkgs.fishPlugins.colored-man-pages
      # https://github.com/franciscolourenco/done - get notified when a long running command finishes
      pkgs.fishPlugins.done
      # use babelfish than foreign-env
      pkgs.fishPlugins.foreign-env
      # Paired symbols in the command line
      pkgs.fishPlugins.pisces
      pkgs.fishPlugins.puffer
      pkgs.fishPlugins.fifc
      pkgs.fishPlugins.bass
      pkgs.fishPlugins.git-abbr
      grcFishPlugin
    ]
    ++ gitConfig.home.packages;

  imports = [
    ./modules/git.nix
  ];

  # Fish config is native; generated integrations are linked above.

  programs.lazygit = {
    enable = true;
  };

  programs.gpg = {
    enable = true;
  };
}
