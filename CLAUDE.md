# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Nix configuration repository using Nix Darwin and Home Manager to manage macOS system configuration and dotfiles. The configuration is structured as a flake with modular components for packages, git settings, shell abbreviations, and system preferences.

## Key Commands

### Nix Configuration Management
- `nds` - Apply Darwin (system) configuration: `nix run nix-darwin -- switch --flake ~/.config/nix`
- `hm` - Apply Home Manager configuration: `home-manager switch --flake $HOME/.config/nix#maurelian`

### Development Tools
- `nixfmt-rfc-style` - Format Nix files using the RFC style formatter
- `mise` - Runtime version manager (installed via Homebrew)
- `just` - Command runner (available but no justfile present)

### Shell Environment
- Fish shell is the primary shell with extensive abbreviations and functions
- Starship prompt for git-aware shell prompt
- Lazygit for git TUI operations

## Architecture

### Core Files
- `flake.nix` - Main flake configuration defining system and home-manager outputs
- `home.nix` - Home Manager configuration for user environment
- `modules/` - Modular configuration components

### Module Structure
- `modules/packages.nix` - Package definitions for both Nix and Homebrew
- `modules/git.nix` - Git configuration and custom git scripts
- `modules/abbreviations.nix` - Shell aliases, abbreviations, and functions
- `modules/ethUtils.nix` - Ethereum/blockchain development utilities

### Package Management
- **Nix packages**: Development tools, CLI utilities, programming languages
- **Homebrew casks**: GUI applications like browsers, editors, communication tools
- **Homebrew brews**: Additional CLI tools (rg, mise)

### Custom Scripts
- `scripts/getSafeDetails` - Utility script (executable)
- `scripts/qq` - Utility script (executable)  
- `scripts/readSystemConfig` - Utility script (executable)

## Development Workflow

### Making Changes
1. Edit the appropriate module file in `modules/`
2. Test changes with `nds` for system config or `hm` for home config
3. Format Nix files with `nixfmt-rfc-style`
4. Commit changes to git

### Common Tasks
- Adding new packages: Edit `modules/packages.nix`
- Modifying shell config: Edit `modules/abbreviations.nix`
- Updating git settings: Edit `modules/git.nix`
- System preferences: Edit the configuration block in `flake.nix`

## Important Notes

- The configuration targets `aarch64-darwin` (Apple Silicon Macs)
- Fish shell integration with extensive abbreviations for git, foundry, and development workflows
- Ethereum development focus with Foundry, Cast, and related tooling
- Custom path management for npm global packages and pipx installations
- TouchID authentication enabled for sudo operations
- remember this is a nix repo. The files and settings found here are moved to different locations based on the config defined in the .nix files. For example, if there is a file in dotfiles, it should be mirrored by a file somewhere in ~/.