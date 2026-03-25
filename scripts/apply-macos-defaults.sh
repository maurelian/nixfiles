#!/usr/bin/env bash
# apply-macos-defaults.sh
#
# Applies macOS system preferences previously managed by nix-darwin.
# Run this once after removing nix-darwin, or anytime you want to
# reapply these settings (e.g., after an OS update resets them).
#
# After running, you may need to:
#   - Log out and back in (for keyboard/trackpad changes)
#   - Restart Finder: killall Finder
#   - Restart Dock: killall Dock
#   - Restart SystemUIServer: killall SystemUIServer

set -euo pipefail

echo "Applying macOS defaults..."

# ============================================================================
# Dock
# ============================================================================
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock orientation -string "left"
defaults write com.apple.dock tilesize -int 48
defaults write com.apple.dock magnification -bool false
defaults write com.apple.dock show-process-indicators -bool true
# Hot corners: 1 = disabled
defaults write com.apple.dock wvous-tl-corner -int 1
defaults write com.apple.dock wvous-tr-corner -int 1
defaults write com.apple.dock wvous-bl-corner -int 1
defaults write com.apple.dock wvous-br-corner -int 1

# ============================================================================
# Finder
# ============================================================================
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool false
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv" # List view
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder CreateDesktop -bool true
defaults write com.apple.finder QuitMenuItem -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf" # Search current folder

# ============================================================================
# NSGlobalDomain (system-wide)
# ============================================================================
# Key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain InitialKeyRepeat -int 20
defaults write NSGlobalDomain KeyRepeat -int 2

# Save/print panels
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk by default (not iCloud)
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Scrollbars and window behavior
defaults write NSGlobalDomain AppleShowScrollBars -string "Automatic"
defaults write NSGlobalDomain AppleScrollerPagingBehavior -bool true
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool true
defaults write NSGlobalDomain AppleEnableSwipeNavigateWithScrolls -bool true
defaults write NSGlobalDomain _HIHideMenuBar -bool false

# Disable auto-correct annoyances
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# ============================================================================
# Screenshots
# ============================================================================
defaults write com.apple.screencapture location -string "~/Downloads"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture show-thumbnail -bool true
defaults write com.apple.screencapture disable-shadow -bool false

# ============================================================================
# Trackpad
# ============================================================================
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

# ============================================================================
# Menu bar clock
# ============================================================================
defaults write com.apple.menuextra.clock ShowSeconds -bool false
defaults write com.apple.menuextra.clock ShowDate -int 1

# ============================================================================
# TouchID for sudo
# ============================================================================
SUDO_LOCAL="/etc/pam.d/sudo_local"
if [ ! -f "$SUDO_LOCAL" ] || ! grep -q "pam_tid.so" "$SUDO_LOCAL"; then
    echo "Configuring TouchID for sudo (requires admin password)..."
    sudo bash -c 'cat > /etc/pam.d/sudo_local << PAMSUDO
auth       sufficient     pam_tid.so
PAMSUDO'
    echo "TouchID for sudo configured."
else
    echo "TouchID for sudo already configured."
fi

# ============================================================================
# Keyboard: Caps Lock -> Escape
# ============================================================================
echo ""
echo "NOTE: Caps Lock -> Escape remapping cannot be set via defaults write."
echo "Set it manually: System Settings > Keyboard > Keyboard Shortcuts > Modifier Keys"
echo ""

# ============================================================================
# Restart affected services
# ============================================================================
echo "Restarting Dock, Finder, and SystemUIServer..."
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

echo "Done! Some changes may require logging out and back in."
