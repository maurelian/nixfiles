# nixfiles

Personal [Home Manager](https://github.com/nix-community/home-manager) config.
nix installs CLI packages; all config files are **live symlinks** into this repo,
so editing a config applies immediately — `home-manager switch` is only needed when
you change packages or the set of managed files.

Repo lives at `~/Projects/Tools/nixfiles` (the path is hardcoded as the symlink
target in `home.nix`).

## Daily use

- Edit any config under `dotfiles/` (fish, nvim, ghostty, tmux, …) or `scripts/` —
  changes apply on the next shell/app launch. No rebuild.
- `hm` — `home-manager switch --flake ~/Projects/Tools/nixfiles#$USER`. Run only
  after changing a `.nix` file (packages or the symlink set).
- `brew bundle --file ~/Projects/Tools/nixfiles/Brewfile` — GUI apps / taps.

## New-machine bootstrap

```bash
# 1. Install nix (Determinate Systems installer)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# 2. Clone to the exact expected path (the symlink target is hardcoded)
git clone git@github.com:maurelian/nixfiles.git ~/Projects/Tools/nixfiles

# 3. Home Manager — creates every symlink and installs all nix packages
nix run home-manager/master -- switch --flake ~/Projects/Tools/nixfiles#john

# 4. GUI apps, taps, and brew-only tools
brew bundle --file ~/Projects/Tools/nixfiles/Brewfile
```

On first `nvim` launch, lazy.nvim bootstraps and installs plugins automatically.

- **Linux box:** same steps 1–3 with `#root`.
- **Different username:** add a one-line `homeConfigurations.<user>` entry in
  `flake.nix` (copy the `john`/`root` blocks), commit, then switch with `#<user>`.
- **Different repo path:** edit `repoDir` in `home.nix`.

## What lives where

| Area | Path |
|------|------|
| nix CLI packages + LSP servers | `modules/packages.nix` |
| GUI apps / taps / brew-only tools | `Brewfile` |
| fish (config, aliases, abbrs, functions) | `dotfiles/config/fish/` |
| neovim (lazy.nvim) | `dotfiles/config/nvim/` |
| git config + scripts | `modules/git.nix`, `scripts/` |
| other app configs | `dotfiles/config/` |
| flake / per-machine entries | `flake.nix` |
| symlink declarations | `home.nix` |
