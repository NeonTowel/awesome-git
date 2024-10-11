#!/bin/bash

# ==================================================================================
# Function:         git-local-repo-config()
# Description:      Function to configure local Git repository settings
#
# This function sets up various Git configurations for the local repository:
# - User email
# - SSH command
# - Pull rebase strategy
# - User signing key
#
# It uses environment variables for customization, falling back to default values if not set:
# - GIT_USER_EMAIL: Email address for Git commits (default: jaakko.leskinen@gmail.com)
# - GIT_SSH_COMMAND: Custom SSH command for Git operations (default: ssh -F ../config -i ../key.pub)
# - GIT_PULL_REBASE: Whether to use rebase when pulling (default: true)
# - GIT_SIGNING_KEY: Key for signing commits (default: contents of ../key.pub)
# - DISABLE_SSH_COMMAND: Set to "true" to disable SSH command configuration (default: false)
# - DISABLE_SIGNING_KEY: Set to "true" to disable signing key configuration (default: false)
#
# The function checks if the current directory is a Git repository before applying changes.
# It provides feedback for each configuration step and a completion message at the end.
# ==================================================================================

git-local-repo-config() {
    # Ensure we're in a Git repository
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo "Error: Not in a Git repository. Please run this script from within a Git repository."
        exit 1
    fi

    echo "Configuring local Git repository settings..."

    # Set default values
    GIT_USER_EMAIL=${GIT_USER_EMAIL:-"jaakko.leskinen@gmail.com"}
    GIT_SSH_COMMAND=${GIT_SSH_COMMAND:-"ssh -F ../config -i ../key.pub"}
    GIT_PULL_REBASE=${GIT_PULL_REBASE:-"true"}
    GIT_SIGNING_KEY=${GIT_SIGNING_KEY:-"$(cat ../key.pub 2>/dev/null)"}
    DISABLE_SSH_COMMAND=${DISABLE_SSH_COMMAND:-"false"}
    DISABLE_SIGNING_KEY=${DISABLE_SIGNING_KEY:-"false"}

    # User email
    if [ -n "${GIT_USER_EMAIL}" ]; then
        echo "Setting user email..."
        git config --local user.email "$GIT_USER_EMAIL"
    fi

    # SSH command
    if [ "$DISABLE_SSH_COMMAND" != "true" ] && [ -n "${GIT_SSH_COMMAND}" ]; then
        echo "Configuring SSH command..."
        git config --local core.sshCommand "$GIT_SSH_COMMAND"
    elif [ "$DISABLE_SSH_COMMAND" = "true" ]; then
        echo "SSH command configuration disabled."
    fi

    # Pull rebase
    if [ -n "${GIT_PULL_REBASE}" ]; then
        echo "Setting pull.rebase..."
        git config --local pull.rebase "$GIT_PULL_REBASE"
    fi

    # User signing key
    if [ "$DISABLE_SIGNING_KEY" != "true" ]; then
        if [ -n "${GIT_SIGNING_KEY}" ]; then
            echo "Setting user signing key..."
            git config --local user.signingkey "$GIT_SIGNING_KEY"
        elif [ -f "../key.pub" ]; then
            echo "Setting user signing key from ../key.pub..."
            git config --local user.signingkey "$(cat ../key.pub)"
        fi
    else
        echo "Signing key configuration disabled."
    fi

    echo "Local Git repository configuration complete."
}

# ==================================================================================
# Function to clone a Git repository using custom SSH options
#
# This function performs the following tasks:
# 1. Checks for the existence of required SSH configuration files (config and key.pub)
# 2. Sets up a custom SSH command for Git operations
# 3. Clones the specified repository using the custom SSH command
# 4. Verifies the success of the cloning operation
#
# The function uses the following variables:
# - SSH_COMMAND: Custom SSH command (can be set externally)
# - REPO_URL: URL of the repository to be cloned (should be set before calling the function)
#
# If the cloning is successful, it prints a success message.
# If there's an error (missing files or failed clone), it exits with an error message.
#
# Usage:
# Set REPO_URL before calling the function
# Optionally set SSH_COMMAND to override the default SSH command
# Call the function: clone_repository
# ==================================================================================
function clone_repository() {
    # Override GIT_SSH_COMMAND to use custom SSH options
    # Check if config and key.pub files exist
    export GIT_SSH_COMMAND="$SSH_COMMAND"
    if [ ! -f ./config ] || [ ! -f ./key.pub ]; then
        echo "Error: config or key.pub file not found."
        exit 1
    fi

    # Allow overriding SSH_COMMAND from environment
    GIT_SSH_COMMAND=${GIT_SSH_COMMAND:-"ssh -F ./config -i ./key.pub"}

    # Clone the repository
    GIT_SSH_COMMAND="${GIT_SSH_COMMAND}" git clone "$REPO_URL"

    # Check if the clone was successful
    if [ $? -eq 0 ]; then
        echo "Repository cloned successfully."
    else
        echo "Error: Failed to clone the repository."
        exit 1
    fi

    # Unset GIT_SSH_COMMAND
    unset GIT_SSH_COMMAND
}
