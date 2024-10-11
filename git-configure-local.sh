#!/bin/bash
# Script: git-configure-local
# Author: jaakko.leskinen@gmail.com
# Description: Configure local Git repository settings using git-local-repo-config function.

# Function to display help
show_help() {
    echo "Usage: ./git-configure-local.sh [-e email] [-s ssh_command] [-r rebase] [-k key] [-n] [-d] [-h]"
    echo "Options:"
    echo "  -e  Set the Git user email (default: jaakko.leskinen@gmail.com)"
    echo "  -s  Set the Git SSH command (default: ssh -F ../config -i ../key.pub)"
    echo "  -r  Set the Git pull rebase option (default: true)"
    echo "  -k  Set the Git signing key (default: content of ../key.pub if exists)"
    echo "  -n  Disable SSH command configuration (default: false)"
    echo "  -d  Disable signing key configuration (default: false)"
    echo "  -h  Display this help message"
}

# Parse command line arguments
while getopts "e:s:r:k:ndh" opt; do
    case $opt in
        e) export GIT_USER_EMAIL="$OPTARG" ;;
        s) export GIT_SSH_COMMAND="$OPTARG" ;;
        r) export GIT_PULL_REBASE="$OPTARG" ;;
        k) export GIT_SIGNING_KEY="$OPTARG" ;;
        n) export DISABLE_SSH_COMMAND="true" ;;
        d) export DISABLE_SIGNING_KEY="true" ;;
        h) show_help; exit 0 ;;
        \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
    esac
done

# Source the git functions
source "$(dirname "$0")/_functions-git.sh"

# Check if we're in a Git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: Not in a Git repository. Please run this script from within a Git repository."
    exit 1
fi

# Execute git-local-repo-config
git-local-repo-config

echo "Local Git repository configuration completed successfully."
