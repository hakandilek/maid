.DEFAULT_TARGET: help
.PHONY: help setup setup-homebrew setup-tools setup-config
	generate-bundle clean-bundle bundle
	readme
	issues
	code-review
	missing-tasks

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
setup: setup-homebrew setup-tools setup-config setup-keys

setup-homebrew:
	@# check if homebrew is installed, install if not print out an error message and fail
	@which brew > /dev/null && echo "✔ homebrew is already installed" || { echo "homebrew is not installed, please install it from https://brew.sh"; exit 1; }

setup-tools:
	@# check if the necessary tools are installed, install if not
	@tools="git repomix llm"; \
	error_flag=0; \
	for tool in $$tools; do \
		if which $$tool > /dev/null; then \
			echo "✔ $$tool is already installed"; \
		else \
			brew install $$tool || error_flag=1; \
		fi; \
	done; \
	if [ $$error_flag -eq 1 ]; then \
		echo "⚠ Some tools failed to install. Please check your Homebrew setup."; \
		exit 1; \
	fi

setup-config:
	@# Prompt the user for the configuration repository URL
	@read -p "Enter the configuration repository URL (or leave empty to skip): " config_repo; \
	if [ -n "$$config_repo" ]; then \
		error_flag=0; \
		temp_dir=$$(mktemp -d) || error_flag=1; \
		git clone $$config_repo $$temp_dir || error_flag=1; \
		mkdir -p $(LLM_USER_PATH) || error_flag=1; \
		if [ -f $(LLM_USER_PATH)/keys.json ]; then \
			echo "✔ $(LLM_USER_PATH)/keys.json already exists. It will not be overwritten."; \
			rm -f $$temp_dir/.llm/keys.json || error_flag=1; \
		else \
			cp $$temp_dir/.llm/keys.json $(LLM_USER_PATH) || error_flag=1; \
			echo "⚠ $(LLM_USER_PATH)/keys.json has been set up. Please configure it as defined in the README.md."; \
		fi; \
		cp $$temp_dir/.llm/* $(LLM_USER_PATH) || error_flag=1; \
		rm -rf $$temp_dir || error_flag=1; \
		if [ $$error_flag -eq 1 ]; then \
			echo "⚠ Failed to set up configuration files. Please check the repository URL and your setup."; \
			exit 1; \
		else \
			echo "✔ Configuration files have been set up"; \
		fi; \
	else \
		echo "⚠ No configuration repository URL provided. Skipping configuration file setup."; \
	fi



# generate-bundle: Generate bundle.md
generate-bundle:
	@MAID_IGNORE_LIST="**/uv.lock,**/package-lock.json,**/.env,**/Cargo.lock,**/node_modules,**/target,**/dist,**/build,**/bundle.md,**/yarn.lock"; \
	if [ -n "$${MAID_IGNORE}" ]; then \
		MAID_IGNORE_LIST="$${MAID_IGNORE_LIST},$${MAID_IGNORE}"; \
	fi; \
	repomix \
		--style markdown \
		--output-show-line-numbers \
		--output bundle.md \
		--ignore "$${MAID_IGNORE_LIST}"


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
