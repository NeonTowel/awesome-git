# 🚀 awesome-git

![Awesome Git Setup](awesome-git.png)

![Awesome Git Setup](https://img.shields.io/badge/Awesome-Git%20Setup-blue?style=for-the-badge&logo=visualstudiocode)


Welcome to the coolest Git configuration manager this side of the Milky Way! 🌌

## What's this all about?

`awesome-git` is your friendly neighborhood Git helper, designed to make your life easier when juggling multiple repos across different organizations. We've got an opinionated (but totally awesome) way of handling Git configs with SSH keys that'll make you feel like a Git wizard! 🧙‍♂️

## Features

- 🗂️ Opinionated directory structure (because chaos is so last season)
- 🔑 SSH key management (no more "which key was for what again?")
- 🏢 Multi-org repo support (like a boss)
- ⚙️ Smart Git configuration (because ain't nobody got time for manual setups)

## Installation Guide

### Windows (using Scoop)

To install `awesome-git` on Windows using Scoop, follow these steps:

1. Add the `neontowel` bucket to Scoop:

   ```sh
   scoop bucket add neontowel https://github.com/NeonTowel/scoop-bucket
   ```

2. Install `awesome-git` from the `neontowel` bucket:

   ```sh
   scoop install neontowel/awesome-git
   ```

Now you're ready to use `awesome-git` on Windows! 🎉


### Linux & macOS

To install `awesome-git` on Linux or macOS, follow these steps:

1. Download the appropriate zip package for your operating system from the [releases page](https://github.com/NeonTowel/awesome-git/releases). For Linux, download `awesome-git-linux.zip`, and for macOS, download `awesome-git-darwin.zip`.

2. Extract the downloaded zip file to a directory of your choice. For example:

   ```bash
   unzip awesome-git-linux.zip -d /your/desired/directory
   ```
   
   or for macOS:
   
   ```bash
   unzip awesome-git-darwin.zip -d /your/desired/directory
   ```

3. Add the extracted directory to your PATH to make the `awesome-git` commands available globally. You can do this by adding the following line to your `~/.bashrc` or `~/.zshrc` file:

   ```bash
   export PATH="/your/desired/directory:$PATH"
   ```

4. Reload your shell configuration:

   ```bash
   source ~/.bashrc
   ```
   
   or for zsh:
   
   ```bash
   source ~/.zshrc
   ```

Now you're ready to use `awesome-git` on Linux or macOS! 🎉

## Getting Started

1. Clone this repo (you know the drill)
2. Copy our super-cool scripts to your PATH:

    For Bash:

    ```bash
    cp git-configure-local.sh git-clone.sh _functions-git.sh /usr/local/bin/
    ```

    For PowerShell:
   
    ```powershell
    Copy-Item git-configure-local.ps1, git-clone.ps1, _functions-git.ps1 -Destination $env:USERPROFILE\Documents\WindowsPowerShell\Scripts\
    ```

3. Make the scripts executable (Bash only):
 
    ```bash
    chmod +x /usr/local/bin/git-configure-local /usr/local/bin/git-clone
    ```

4. Now you're ready to rock! 🎸 Here's how to use our magical scripts:

### git-configure-local

This script sets up your local Git config faster than you can say "supercalifragilisticexpialidocious"! 🤓

**Bash:**

```bash
Usage:

./git-configure-local.sh [-e email] [-s ssh_command] [-r rebase] [-k key] [-n] [-d] [-h]

Options:
-e  Set the Git user email (default: jaakko.leskinen@gmail.com)
-s  Set the Git SSH command (default: ssh -F ../config -i ../key.pub)
-r  Set the Git pull rebase option (default: true)
-k  Set the Git signing key (default: content of ../key.pub if exists)
-n  Disable SSH command configuration (default: false)
-d  Disable signing key configuration (default: false)
-h  Display help message

Examples:

./git-configure-local.sh -e john.doe@awesome-corp.com
./git-configure-local.sh -e jane.smith@cool-company.com -s "ssh -i ~/.ssh/custom_key"
./git-configure-local.sh -r false -k "ABC123XYZ"
./git-configure-local.sh -n -d
./git-configure-local.sh -h
```

**PowerShell:**

```powershell
Usage:

.\git-configure-local.ps1 [-email address] [-ssh command] [-rebase true|false] [-key value] [-no_ssh] [-no_key] [-h]

Options:
-email    Set the Git user email (default: jaakko.leskinen@gmail.com)
-ssh      Set the Git SSH command (default: ssh -F ../config -i ../key.pub)
-rebase   Set the Git pull rebase option (default: true)
-key      Set the Git signing key (default: content of ../key.pub if exists)
-no_ssh   Disable SSH command configuration (default: false)
-no_key   Disable signing key configuration (default: false)
-h        Display help message

Examples:

.\git-configure-local.ps1 -email john.doe@awesome-corp.com
.\git-configure-local.ps1 -email jane.smith@cool-company.com -ssh "ssh -i ~/.ssh/custom_key"
.\git-configure-local.ps1 -rebase false -key "ABC123XYZ"
.\git-configure-local.ps1 -no_ssh -no_key
.\git-configure-local.ps1 -h
```

### git-clone

Clone repos like a boss with this nifty script! It'll set up your SSH keys and Git config automagically. ✨

```bash
Usage:

git-clone <repository_url>
```

Example (Bash):

```bash
git-clone https://github.com/awesome-corp/super-secret-project.git
```


Example (PowerShell):

```powershell
.\git-clone.ps1 https://github.com/awesome-corp/super-secret-project.git
```
   
Now go forth and Git with awesomeness! 🚀

## Why awesome-git?

Because regular Git is just too mainstream. We're here to make Git great again! (Wait, was it ever not great? 🤔)

## Contributing

Found a bug? Want to add a feature? We're all ears! Open an issue or submit a PR. Just remember, with great power comes great responsibility. 🕷️

## License

MIT License (because sharing is caring), see the [LICENSE](LICENSE) file for details.
