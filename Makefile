.PHONY: all help xcode link brew pkg llm runtime moshi macos personal home-server clean test

OS := $(shell uname -s)

ifeq ($(OS),Darwin)
all: xcode link brew macos llm runtime
else
all: pkg link llm runtime moshi
endif
	@printf "\033[32m✓ Setup completed\033[0m\n"

help:
	@printf "Phase 1: Modularized Setup\n"
	@printf "\nAvailable targets:\n"
	@printf "  make all       - Run all setup (default)\n"
	@printf "  make xcode     - Install Xcode Command Line Tools\n"
	@printf "  make link      - Create symbolic links for dotfiles\n"
	@printf "  make brew      - Install Homebrew and related tools\n"
	@printf "  make pkg       - Install Linux packages (omarchy pkg add, yay)\n"
	@printf "  make macos     - Apply macOS settings\n"
	@printf "  make llm       - Apply Claude Code (LLM) settings\n"
	@printf "  make runtime   - Setup mise language runtimes\n"
	@printf "  make moshi     - Install moshi-hook and open mosh's UDP ports (Linux)\n"
	@printf "  make personal  - Opt this machine into personal-only Brewfile entries\n"
	@printf "  make home-server - Run this laptop as an always-on server (omarchy)\n"
	@printf "  make clean     - Clean up removable files\n"
	@printf "  make test      - Verify configuration files exist\n"

xcode:
	@[ "$(OS)" = Darwin ] || { printf "Skipping on %s\n" "$(OS)"; exit 0; }; \
		printf "Setting up Xcode Command Line Tools...\n"; \
		bash scripts/xcode.sh

link:
	@printf "Creating symbolic links for dotfiles...\n"
	@bash scripts/link.sh

brew:
	@[ "$(OS)" = Darwin ] || { printf "Skipping on %s\n" "$(OS)"; exit 0; }; \
		printf "Setting up Homebrew and related tools...\n"; \
		bash scripts/brew.sh

pkg:
	@[ "$(OS)" = Linux ] || { printf "Skipping on %s\n" "$(OS)"; exit 0; }; \
		printf "Installing Linux packages...\n"; \
		bash scripts/pkg.sh

llm:
	@printf "Setting up Claude Code configuration...\n"
	@bash scripts/llm.sh

runtime:
	@printf "Setting up mise language runtimes...\n"
	@bash scripts/runtime.sh

moshi:
	@[ "$(OS)" = Linux ] || { printf "Skipping on %s\n" "$(OS)"; exit 0; }; \
		printf "Setting up moshi...\n"; \
		bash scripts/moshi.sh

macos:
	@[ "$(OS)" = Darwin ] || { printf "Skipping on %s\n" "$(OS)"; exit 0; }; \
		printf "Applying macOS settings...\n"; \
		bash macos/defaults.sh

personal:
	@printf "Opting this machine into personal-only Brewfile entries...\n"
	@bash -c 'dir="$$HOME/.config/dotfiles"; \
		marker="$$dir/personal"; \
		if [ -e "$$marker" ]; then \
			printf "✓ Already opted in: %s\n" "$$marker"; \
		else \
			mkdir -p "$$dir" && touch "$$marker" \
				&& printf "✓ Created %s\n" "$$marker"; \
		fi; \
		printf "Run: make brew\n"'

home-server:
	@[ "$(OS)" = Linux ] || { printf "Skipping on %s\n" "$(OS)"; exit 0; }; \
		printf "Setting up the always-on server host...\n"; \
		bash scripts/home-server.sh

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
		[ -f scripts/pkg.sh ] && echo "✓ scripts/pkg.sh found" || { echo "✗ scripts/pkg.sh missing"; errors=1; }; \
		[ -f scripts/brew.sh ] && echo "✓ scripts/brew.sh found" || { echo "✗ scripts/brew.sh missing"; errors=1; }; \
		[ -f scripts/link.sh ] && echo "✓ scripts/link.sh found" || { echo "✗ scripts/link.sh missing"; errors=1; }; \
		[ -f scripts/llm.sh ] && echo "✓ scripts/llm.sh found" || { echo "✗ scripts/llm.sh missing"; errors=1; }; \
		[ -f scripts/runtime.sh ] && echo "✓ scripts/runtime.sh found" || { echo "✗ scripts/runtime.sh missing"; errors=1; }; \
		[ -d macos ] && echo "✓ macos directory found" || { echo "✗ macos directory missing"; errors=1; }; \
		[ -f macos/defaults.sh ] && echo "✓ macos/defaults.sh found" || { echo "✗ macos/defaults.sh missing"; errors=1; }; \
		[ -f Makefile ] && echo "✓ Makefile found" || { echo "✗ Makefile missing"; errors=1; }; \
		exit $$errors; \
	'
