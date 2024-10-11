param (
    [string]$email,
    [string]$ssh,
    [string]$rebase,
    [string]$key,
    [switch]$no_ssh,
    [switch]$no_key,
    [switch]$h
)
  # Display help if -h is used
  if ($h) {
      Write-Host "Usage: .\git-configure-local.ps1 [-email address] [-ssh command] [-rebase true|false] [-key value] [-no_ssh] [-no_key] [-h]"
      Write-Host "Options:"
      Write-Host "  -email    Set the Git user email (default: jaakko.leskinen@gmail.com)"
      Write-Host "  -ssh      Set the Git SSH command (default: ssh -F ../config -i ../key.pub)"
      Write-Host "  -rebase   Set the Git pull rebase option (default: true)"
      Write-Host "  -key      Set the Git signing key (default: content of ../key.pub if exists)"
      Write-Host "  -no_ssh   Disable SSH command configuration (default: false)"
      Write-Host "  -no_key   Disable signing key configuration (default: false)"
      Write-Host "  -h        Display this help message"
      exit 0
  }
# Source the functions-git.ps1 file
. $PSScriptRoot\_functions-git.ps1

# Check if we're in a Git repository
if (-not (Test-Path .git)) {
    Write-Host "Error: Not in a Git repository. Please run this script from within a Git repository."
    exit 1
}

# Set environment variables based on parameters or use defaults
$env:GIT_USER_EMAIL = if ($email) { $email } else { $env:GIT_USER_EMAIL }
$env:GIT_SSH_COMMAND = if ($ssh) { $ssh } else { $env:GIT_SSH_COMMAND }
$env:GIT_PULL_REBASE = if ($rebase) { $rebase } else { $env:GIT_PULL_REBASE }
$env:GIT_SIGNING_KEY = if ($key) { $key } else { $env:GIT_SIGNING_KEY }
$env:DISABLE_SSH_COMMAND = if ($no_ssh) { "true" } else { $env:DISABLE_SSH_COMMAND }
$env:DISABLE_SIGNING_KEY = if ($no_key) { "true" } else { $env:DISABLE_SIGNING_KEY }

# Execute Set-GitLocalRepoConfig
Set-GitLocalRepoConfig

Write-Host "Local Git repository configuration completed successfully."
