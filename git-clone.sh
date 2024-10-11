#!/bin/bash
# Script: git-clone
# Author: jaakko.leskinen@gmail.com
# Description: Clone a Git repository using custom SSH options and configure local Git repository settings.
# ----------------------------------------------------------------------------------
#
# Purpose:
# This script is designed to clone Git repositories with customized SSH configurations.
# It's particularly useful for managing multiple Git repositories, each with its own
# author email and SSH key.
#
# Git global configuration is stored in the home directory (~) and includes:
# $ git config --global -l
# user.name=Jaakko Leskinen         # Sets the author name for Git commits
# gpg.format=ssh                    # Specifies SSH as the format for GPG signatures
# commit.gpgsign=true               # Enables automatic signing of all commits
# init.defaultbranch=main           # Sets the default branch name to 'main' when initializing a new repository
#
# Key Features:
# - Uses custom SSH options for cloning
# - Supports multiple Git repositories with individual configurations
# - Utilizes SSH public keys for identification (private keys provided by agent)
#
# Directory Structure:
# The script assumes a hierarchical organization of Git repositories:
# ~/git/[host]/[organization]/
#   - config (SSH config file)
#   - key.pub (Public SSH key)
#   - repo1, repo2, ... (Individual repositories)
#
# Example SSH Config (./config):
# Host github.com
#   HostName github.com
#   User git
#   IdentityFile ~/git/github.com/jleski/key.pub
#   IdentitiesOnly yes
#
# Example Public Key (./key.pub):
# ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ....
#
# Directory Structure Example:
# ~/git/
#   github.com/
#     jleski/
#       config
#       key.pub
#       repo1/
#       repo2/
#   gitlab.com/
#     jleski/
#       config
#       key.pub
#       repo1/
#       repo2/
#
# Usage:
# Place this script in a directory within your PATH, then run:
# $ git-clone [repository-url]
#
# Note: Ensure that the appropriate SSH configurations and public keys
# are in place before using this script.
# ----------------------------------------------------------------------------------

# Source the git functions
source "$(dirname "$0")/_functions-git.sh"

# Main program

# Check if a repository URL is provided
if [ $# -eq 0 ]; then
    echo "Error: No repository URL provided."
    echo "Usage: $0 <repository_url>"
    exit 1
fi

# Store the repository URL
REPO_URL="$1"

# Clone the repository
clone_repository

# Extract the repository name from the URL
REPO_NAME=$(basename "$REPO_URL" .git)

# Enter the cloned repository
cd "$REPO_NAME" || exit 1

# Execute git-local-config
git-local-repo-config

# Return to the original directory
cd - > /dev/null
