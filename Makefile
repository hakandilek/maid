.DEFAULT_TARGET: help
.PHONY: help setup llm


LLM_USER_PATH = $(PWD)/.llm

ARGS = $(filter-out $@,$(MAKECMDGOALS))
%:
	@:



## help: Show this help message
help: Makefile
	@echo
	@echo "LAIDS Local AI Development Setup"
	@echo
	@echo "Choose a command run in the Makefile:"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo
	@echo "LLM Tasks:"
	@echo
	@if which mise > /dev/null; then \
		mise tasks | awk 'NR==0 {next} {sub(/^llm:/, "", $$1); printf "llm %-15s %s\n", $$1, substr($$0, index($$0,$$2))}' | sed -e 's/^/ /'; \
	else \
		echo "mise is not installed. Run 'make setup' to install dependencies and get the full list of LLM tasks."; \
	fi
	@echo



## setup: Setup the local environment, install dependencies
setup:
	# check if homebrew is installed, install if not print out an error message and fail
	@which brew > /dev/null && echo "✔ homebrew is already installed" || { echo "homebrew is not installed, please install it from https://brew.sh"; exit 1; }

	@tools="repomix aider mise llm"; \
	for tool in $$tools; do \
		if which $$tool > /dev/null; then \
			echo "✔ $$tool is already installed"; \
		else \
			brew install $$tool; \
		fi; \
	done

	# upgrade/update mise tools
	@mise up



## llm <task name>: Run an llm task
llm:
	mise run 'llm:$(ARGS)'


