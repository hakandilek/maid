.DEFAULT_TARGET: help
.PHONY: help setup llm generate-bundle clean-bundle readme bundle issues code-review missing-tasks

MAKEFILE_PATH :=  $(realpath $(lastword $(MAKEFILE_LIST)))
MAID_PATH := $(dir $(MAKEFILE_PATH))
LLM_USER_PATH := $(MAID_PATH).llm

ARGS = $(filter-out $@,$(MAKECMDGOALS))
%:
	@:



## help: Show this help message
help: Makefile
	@echo
	@echo "\033[0;33mM\033[0;37mAID\033[0;33m AI D\033[0;37mevelopment toolset\033[0m"
	@echo
	@echo "Usage:"
	@echo "  maid <command>"
	@echo
	@echo "Available commands:"
	@echo
	 @# Extract lines starting with '##', replace ':' with tab, and add leading space
	@sed -n 's/^##//p' $(MAKEFILE_PATH) \
	|	column -t -s ':' \
	|	sed -e 's/^/ /'
	@echo



## setup: Setup the local environment, install dependencies
setup:
	@# check if homebrew is installed, install if not print out an error message and fail
	@which brew > /dev/null && echo "✔ homebrew is already installed" || { echo "homebrew is not installed, please install it from https://brew.sh"; exit 1; }

	@tools="repomix aider llm"; \
	for tool in $$tools; do \
		if which $$tool > /dev/null; then \
			echo "✔ $$tool is already installed"; \
		else \
			brew install $$tool; \
		fi; \
	done



# generate-bundle: Generate bundle.md
generate-bundle:
	repomix \
		--style markdown \
		--output-show-line-numbers \
		--output bundle.md \
		--ignore **/uv.lock,**/package-lock.json,**/.env,**/Cargo.lock,**/node_modules,**/target,**/dist,**/build,**/bundle.md,**/yarn.lock


## clean: Clean up generated files.
clean:
	find . -name "bundle.md" -print -delete


## readme: Generate README.md from repository content
readme: generate-bundle
	cat bundle.md | llm -t readme-gen > README.md


## bundle: Bundle the repository into the file bundle.md and copy it`s content to the system clipboard
bundle: generate-bundle
	cat bundle.md | pbcopy
	echo "Pushed bundle.md to the copy buffer"


## issues: Generate GitHub/Gitlab issues from repository content, store them in issues.md
issues: generate-bundle
	cat bundle.md | llm -t issue-gen > issues.md


## code-review: Generate code review output from repository content, store it in code-review.md
code-review: generate-bundle
	cat bundle.md | llm -t code-review-gen > code-review.md


## missing-tasks: Generate missing tests for code in repository, store them in missing-tasks.md
missing-tasks: generate-bundle
	cat bundle.md | llm -t missing-tasks-gen > missing-tasks.md
