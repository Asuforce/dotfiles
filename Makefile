.PHONY: all help xcode link brew llm runtime macos clean test

all: xcode link brew macos llm runtime
	@printf "\033[32m✓ Setup completed\033[0m\n"

help:
	@printf "Phase 1: Modularized Setup\n"
	@printf "\nAvailable targets:\n"
	@printf "  make all       - Run all setup (default)\n"
	@printf "  make xcode     - Install Xcode Command Line Tools\n"
	@printf "  make link      - Create symbolic links for dotfiles\n"
	@printf "  make brew      - Install Homebrew and related tools\n"
	@printf "  make macos     - Apply macOS settings\n"
	@printf "  make llm       - Apply Claude Code (LLM) settings\n"
	@printf "  make runtime   - Setup mise language runtimes\n"
	@printf "  make clean     - Clean up removable files\n"
	@printf "  make test      - Verify configuration files exist\n"

xcode:
	@printf "Setting up Xcode Command Line Tools...\n"
	@bash scripts/xcode.sh

link:
	@printf "Creating symbolic links for dotfiles...\n"
	@bash scripts/link.sh

brew:
	@printf "Setting up Homebrew and related tools...\n"
	@bash scripts/brew.sh

llm:
	@printf "Setting up Claude Code configuration...\n"
	@bash scripts/llm.sh

runtime:
	@printf "Setting up mise language runtimes...\n"
	@bash scripts/runtime.sh

macos:
	@printf "Applying macOS settings...\n"
	@bash macos/defaults.sh

clean:
	@printf "Cleaning up...\n"
	@printf "This target will be extended in the future\n"

test:
	@printf "Verifying configuration files...\n"
	@bash -c '\
		errors=0; \
		echo "Checking dotfiles structure..."; \
		[ -d scripts ] && echo "✓ scripts directory found" || { echo "✗ scripts directory missing"; errors=1; }; \
		[ -f scripts/xcode.sh ] && echo "✓ scripts/xcode.sh found" || { echo "✗ scripts/xcode.sh missing"; errors=1; }; \
		[ -f scripts/brew.sh ] && echo "✓ scripts/brew.sh found" || { echo "✗ scripts/brew.sh missing"; errors=1; }; \
		[ -f scripts/link.sh ] && echo "✓ scripts/link.sh found" || { echo "✗ scripts/link.sh missing"; errors=1; }; \
		[ -f scripts/llm.sh ] && echo "✓ scripts/llm.sh found" || { echo "✗ scripts/llm.sh missing"; errors=1; }; \
		[ -f scripts/runtime.sh ] && echo "✓ scripts/runtime.sh found" || { echo "✗ scripts/runtime.sh missing"; errors=1; }; \
		[ -d macos ] && echo "✓ macos directory found" || { echo "✗ macos directory missing"; errors=1; }; \
		[ -f macos/defaults.sh ] && echo "✓ macos/defaults.sh found" || { echo "✗ macos/defaults.sh missing"; errors=1; }; \
		[ -d runtime ] && echo "✓ runtime directory found" || { echo "✗ runtime directory missing"; errors=1; }; \
		[ -f runtime/config.toml ] && echo "✓ runtime/config.toml found" || { echo "✗ runtime/config.toml missing"; errors=1; }; \
		[ -f Makefile ] && echo "✓ Makefile found" || { echo "✗ Makefile missing"; errors=1; }; \
		exit $$errors; \
	'
