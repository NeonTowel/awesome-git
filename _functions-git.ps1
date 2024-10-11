# Function to configure local Git repository settings
function Set-GitLocalRepoConfig {
    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "Error: Not in a Git repository. Please run this script from within a Git repository."
        exit 1
    }

    Write-Host "Configuring local Git repository settings..."

    $GIT_USER_EMAIL = if ($env:GIT_USER_EMAIL) { $env:GIT_USER_EMAIL } else { "jaakko.leskinen@gmail.com" }
    $GIT_SSH_COMMAND = if ($env:GIT_SSH_COMMAND) { $env:GIT_SSH_COMMAND } else { "ssh -F ../config -i ../key.pub" }
    $GIT_PULL_REBASE = if ($env:GIT_PULL_REBASE) { $env:GIT_PULL_REBASE } else { "true" }
    $GIT_SIGNING_KEY = if ($env:GIT_SIGNING_KEY) { $env:GIT_SIGNING_KEY } else { if (Test-Path "../key.pub") { Get-Content "../key.pub" } else { $null } }
    $DISABLE_SSH_COMMAND = if ($env:DISABLE_SSH_COMMAND) { $env:DISABLE_SSH_COMMAND } else { "false" }
    $DISABLE_SIGNING_KEY = if ($env:DISABLE_SIGNING_KEY) { $env:DISABLE_SIGNING_KEY } else { "false" }

    if ($GIT_USER_EMAIL) {
        Write-Host "Setting user email..."
        git config --local user.email $GIT_USER_EMAIL
    }

    if ($DISABLE_SSH_COMMAND -ne "true" -and $GIT_SSH_COMMAND) {
        Write-Host "Configuring SSH command..."
        git config --local core.sshCommand $GIT_SSH_COMMAND
    }
    elseif ($DISABLE_SSH_COMMAND -eq "true") {
        Write-Host "SSH command configuration disabled."
    }

    if ($GIT_PULL_REBASE) {
        Write-Host "Setting pull.rebase..."
        git config --local pull.rebase $GIT_PULL_REBASE
    }

    if ($DISABLE_SIGNING_KEY -ne "true") {
        if ($GIT_SIGNING_KEY) {
            Write-Host "Setting user signing key..."
            git config --local user.signingkey $GIT_SIGNING_KEY
        }
        elseif (Test-Path "../key.pub") {
            Write-Host "Setting user signing key from ../key.pub..."
            git config --local user.signingkey (Get-Content "../key.pub")
        }
    }
    else {
        Write-Host "Signing key configuration disabled."
    }

    Write-Host "Local Git repository configuration complete."
}

# Function to clone a Git repository using custom SSH options
function Clone-Repository {
    $env:GIT_SSH_COMMAND = $SSH_COMMAND

    if (-not (Test-Path ./config) -or -not (Test-Path ./key.pub)) {
        Write-Host "Error: config or key.pub file not found."
        exit 1
    }

    $GIT_SSH_COMMAND = if ($env:GIT_SSH_COMMAND) { $env:GIT_SSH_COMMAND } else { "ssh -F ./config -i ./key.pub" }

    $env:GIT_SSH_COMMAND = $GIT_SSH_COMMAND
    git clone $REPO_URL

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Repository cloned successfully."
    }
    else {
        Write-Host "Error: Failed to clone the repository."
        exit 1
    }

    Remove-Item Env:\GIT_SSH_COMMAND
}
