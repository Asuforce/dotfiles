#!/bin/bash

set -euo pipefail

# macOS defaults configuration script
# This script applies various macOS system settings for optimal development environment
# Based on README.md preferences

printf "Configuring macOS system defaults...\n"

# General settings
printf "Configuring General settings...\n"
# Use dark menu bar and Dock
defaults write -g AppleInterfaceStyle -string "Dark"

# Menu bar settings
printf "Configuring Menu bar...\n"
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true
defaults write com.apple.menuextra.clock ShowSeconds -bool true
defaults write com.apple.menuextra.clock DateFormat "EEE MMM d HH:mm:ss"

# Battery percentage display
printf "Configuring Battery display...\n"
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Dock settings
printf "Configuring Dock...\n"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.4
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock tilesize -int 32
defaults write com.apple.dock orientation -string "left"
defaults write com.apple.dock mineffect -string "scale"
killall Dock 2>/dev/null || true

# Finder settings
printf "Configuring Finder...\n"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
killall Finder 2>/dev/null || true

# Keyboard settings
printf "Configuring Keyboard...\n"
# Continuous input (disable press and hold)
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable Spotlight shortcuts
printf "Configuring Spotlight shortcuts...\n"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 '<dict><key>enabled</key><false/></dict>'

# Trackpad settings
printf "Configuring Trackpad...\n"
# Tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# Tracking speed: Fast
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 3.0
# Click: Light
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad FirstClickThreshold -int 0

# Accessibility - Trackpad
printf "Configuring Accessibility settings...\n"
# Three finger drag
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

# Security settings
printf "Configuring Security settings...\n"
defaults write com.apple.LaunchServices LSQuarantine -bool false

printf "macOS configuration complete.\n"
printf "Note: Some settings may require a restart to take effect.\n"
