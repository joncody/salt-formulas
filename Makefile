export RUSTUP_HOME ?= /opt/rust/rustup

.DEFAULT_GOAL := help

.PHONY: help check update apply dry-run clean

help: ## Show this help menu
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

check: ## Check for newer upstream versions across all formulas
	@cargo run --manifest-path updater/Cargo.toml -- check

update: ## Update all map.jinja files in-place with latest versions
	@cargo run --manifest-path updater/Cargo.toml -- update
	@echo "\n\033[32m[+] map.jinja files updated. Review with 'git diff' before committing.\033[0m"

dry-run: ## Run Salt in test mode without making changes
	@sudo salt-call --local state.apply test=True

apply: ## Apply all Salt states to the machine
	@sudo salt-call --local state.apply

clean: ## Clean up Cargo build artifacts from the updater
	@cargo clean --manifest-path updater/Cargo.toml
