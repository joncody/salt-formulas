export RUSTUP_HOME ?= /opt/rust/rustup
export PATH := /opt/rust/bin:$(PATH)

.DEFAULT_GOAL := help

.PHONY: help bootstrap check update apply dry-run init-user clean

help: ## Show this help menu
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

bootstrap: ## Install SaltStack and baseline prerequisites on a fresh machine
	@sudo ./bootstrap.sh

check: ## Check for newer upstream versions across all formulas
	@cargo run --manifest-path updater/Cargo.toml -- check

update: ## Update all map.jinja files in-place with latest versions
	@cargo run --manifest-path updater/Cargo.toml -- update
	@echo "\n\033[32m[+] map.jinja files updated. Review with 'git diff' before committing.\033[0m"

dry-run: ## Run Salt in test mode without making changes
	@sudo salt-call --local state.apply test=True

apply: ## Apply all Salt states to the machine
	@sudo salt-call --local state.apply

init-user: ## Safely copy default configs into current user's ~/.config (helix, nushell)
	@mkdir -p $$HOME/.config/helix $$HOME/.config/nushell
	@cp -rn /etc/xdg/helix/* $$HOME/.config/helix/ 2>/dev/null || true
	@cp -rn /etc/nushell/* $$HOME/.config/nushell/ 2>/dev/null || true
	@echo "\033[32m[+] User configurations initialized in $$HOME/.config\033[0m"

clean: ## Clean up Cargo build artifacts from the updater
	@cargo clean --manifest-path updater/Cargo.toml
