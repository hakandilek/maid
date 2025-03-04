# MAID AI Development toolset

## Project Summary

MAID AI Development toolset is a comprehensive set of command-line tools and utilities designed to help software engineers, developers, and AI enthusiasts streamline their workflow, automate repetitive tasks, and improve productivity. MAID leverages advanced AI and language models to provide features such as code review, issue detection, missing tests identification, and code summarization.

The toolset is heavily influenced by the [blog entry and setup by Harper Reed](https://harper.blog/2025/02/16/my-llm-codegen-workflow-atm/). The project aims to provide a more user-friendly and accessible version of the tools and utilities for this workflow.

## Getting Started

### Prerequisites

- [Homebrew](https://brew.sh) is for the initial setup of MAID.
- and [GNU Make](https://www.gnu.org/software/make/) is internally used for running the commands.

### Installation

- Clone this repository to your local machine and
- add it to your `PATH` environment variable.

## Commands

You can use the following commands to interact with MAID:

- `maid help`: Show this help message
- `maid setup`: Setup the local environment, install dependencies
- `maid clean`: Clean up generated files.
- `maid readme`: Generate the project's README.md file
- `maid bundle`: Bundle the repository into a file and copy it to the system clipboard
- `maid issues`: Generate GitHub or GitLab issues from repository content
- `maid code-review`: Generate detailed code review feedback
- `maid missing-tasks`: Identify potential missing tests for code in the repository

## Technical Stack

- [Repomix](https://repomix.com/): An analysis tool for reviewing and processing code repositories
- [LLM](https://llm.datasette.io/en/stable/): LLM CLI utility for interacting with the Large Language Models

## Setting up the default model

TODO: Add instructions on how to set up the default model for the LLM CLI utility.

## Setting up extra OpenAI compatible models

TODO: Add instructions on how to set up extra OpenAI compatible models for the LLM CLI utility.

## Setting up OpenAPI secret keys

TODO: Add instructions on how to set up OpenAPI secret keys for the LLM CLI utility.

## Contribution Guidelines (Optional)

To contribute to the project, merge requests are welcome for new features, bug fixes, or improvements to the existing code. Before making changes, please follow these guidelines:

1. Fork the repository and create a new branch for your changes.
2. Write test cases for new features or bug fixes.
3. Ensure your changes adhere to our coding standards and style guide.
4. Submit a pull request with a detailed description of your changes.

## License

The My AI Development Tools (MAID) project is licensed under the [MIT License](https://github.com/yourusername/your-repo/blob/master/LICENSE).

Contribute to the development of a smarter, more efficient workflow with MAID AI Development toolset 🚀✨
