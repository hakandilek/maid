MAKEFLAGS += --silent

.DEFAULT_TARGET: help
.PHONY: help

## help: Show this help message
help: Makefile
	@echo
	@echo "LAIDS Local AI Dev Setup"
	@echo
	@echo "Choose a command run in the Makefile:"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo

## setup: Setup the local environment, install dependencies
setup:
	# check if homebrew is installed, install if not print out an error message and fail
	@which brew > /dev/null && echo "✔ homebrew is already installed" || { echo "homebrew is not installed, please install it from https://brew.sh"; exit 1; }

	@tools="repomix aider mise"; \
	for tool in $$tools; do \
		if which $$tool > /dev/null; then \
			echo "✔ $$tool is already installed"; \
		else \
			brew install $$tool; \
		fi; \
	done
