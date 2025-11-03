#!/bin/bash

set -euo pipefail

# Install Xcode Command Line Tools
if ! type xcode-select > /dev/null 2>&1 || ! xcode-select -p &> /dev/null; then
  printf "Installing Xcode Command Line Tools...\n"
  xcode-select --install
  printf "Xcode Command Line Tools installation complete.\n"
else
  printf "Xcode Command Line Tools are already installed.\n"
fi
