# CLAUDE.md

Guidance for Claude Code (claude.ai/code) when working in this repository.

## Overview

Personal Nix configuration: a Home Manager flake that manages macOS (and a Linux
`root` profile) user environments. It installs CLI packages via nix and links all
config files **live** into the home directory, so editing a config applies
immediately with no rebuild.

The repo lives at `~/Projects/Tools/nixfiles` (this path is hardcoded in
`home.nix` as the symlink target — see Bootstrap in `README.md` for relocating).

## The model: live symlinks, nix for packages

`home.file` entries use `config.lib.file.mkOutOfStoreSymlink` (the `link` helper
in `home.nix`), so `~/.vimrc`, `~/.config/fish/*`, `~/.config/nvim`, `~/.scripts/*`,
etc. are symlinks **into this repo's working copy**. Editing the file in
`dotfiles/` (or `scripts/`, `dotfiles/config/{fish,nvim}/`) takes effect on the
next shell/app launch — no `hm` needed.

Run a Home Manager switch (`hm`) **only** when you change the set of packages or
the set of managed files/symlinks (anything in a `.nix` file).

- `hm` → `home-manager switch --flake $HOME/Projects/Tools/nixfiles#$USER`
  (no `--impure`; the flake is pure so eval-caching works).
- `nixfmt-rfc-style` formats `.nix` files.

To verify a managed file is live, resolve it fully: `readlink -f ~/.vimrc` should
land under `~/Projects/Tools/nixfiles/`, not `/nix/store/`. (One/two intermediate
hops through the store are normal — only the final target matters.)

## Layout

- `flake.nix` — Home Manager flake. `homeConfigurations` has one entry per
  machine/user (`john`, `root`); add a line for a new machine. Selected at
  runtime by `$USER`.
- `home.nix` — packages list + the `home.file` symlink declarations (the `link`
  helper points at `repoDir`).
- `modules/packages.nix` — nix CLI packages and LSP servers.
- `modules/git.nix` — git config and helper scripts.
- `dotfiles/` — all config files, symlinked into `~`.
  - `dotfiles/config/fish/` — native fish config: `config.fish`, `abbreviations.fish`,
    `aliases.fish` (sourced from `config.fish` so they override vendor plugins like
    git-abbr), `conf.d/`, `functions/`.
  - `dotfiles/config/nvim/` — native Neovim config (lazy.nvim); `lua/plugins/*.lua`
    one file per plugin group. `lazy-lock.json` pins versions.
  - `dotfiles/config/{ghostty,tmux,lazygit,starship.toml,gh}` — app configs.
- `scripts/` — utility scripts, linked into `~/.scripts` (per-file, so machine-local
  bins like `be-*` coexist there).
- `Brewfile` — GUI casks, third-party taps, and brew-only/large tools
  (qemu, llama.cpp, etc.). Applied with `brew bundle`.

## Package management

- **CLI tools & LSP servers** → nix, in `modules/packages.nix`.
- **GUI apps, taps, brew-only tools** → `Brewfile` (`brew bundle --file Brewfile`).

## Common tasks

- New CLI tool / LSP server → `modules/packages.nix`, then `hm`.
- New GUI app → `Brewfile`, then `brew bundle`.
- Shell aliases/abbrs/functions → edit files in `dotfiles/config/fish/` (live).
- Shared aliases in `dotfiles/aliases` → edit, then run `hm` to regenerate Fish aliases.
- Neovim → edit `dotfiles/config/nvim/` (applies on nvim restart; `:Lazy` for plugins).
- Adding a brand-new managed file → add it under `dotfiles/`, declare a `link`
  in `home.nix`, `git add` it, then `hm`.

## Notes

- Targets `aarch64-darwin` (Apple Silicon); a Linux `root` profile exists too.
- Fish is the interactive shell (launched via `dotfiles/nix-fish-wrapper.zsh`,
  which sources nix-daemon.sh then `exec fish`); plugins load natively from the
  nix profile's `vendor_conf.d` via `XDG_DATA_DIRS`.
- gh/lazygit runtime state (`hosts.yml`, `state.yml`) is intentionally NOT managed
  (per-file links only) so it stays machine-local and out of git.
