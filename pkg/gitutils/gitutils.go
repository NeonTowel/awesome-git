package gitutils

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
)

// CloneRepository clones a Git repository using the provided URL.
func CloneRepository(repoURL string) error {
	fmt.Printf("Cloning repository: %s\n", repoURL)

	cloneCmd := exec.Command("git", "clone", repoURL)
	cloneCmd.Stdout = os.Stdout
	cloneCmd.Stderr = os.Stderr
	if err := cloneCmd.Run(); err != nil {
		return fmt.Errorf("error cloning repository: %w", err)
	}

	return nil
}

// ConfigureLocalRepo configures the local Git repository settings.
func ConfigureLocalRepo(email string) error {
	fmt.Println("Configuring local Git repository settings...")

	setEmailCmd := exec.Command("git", "config", "--local", "user.email", email)
	setEmailCmd.Stdout = os.Stdout
	setEmailCmd.Stderr = os.Stderr
	if err := setEmailCmd.Run(); err != nil {
		return fmt.Errorf("error setting user email: %w", err)
	}

	fmt.Println("Local Git repository configuration complete.")
	return nil
}

// Check if the current directory is a Git repository
func IsInsideGitRepo() bool {
	cmd := exec.Command("git", "rev-parse", "--is-inside-work-tree")
	cmd.Stdout = nil
	cmd.Stderr = nil
	return cmd.Run() == nil
}

// Set Git configuration
func SetGitConfig(key, value string) error {
	cmd := exec.Command("git", "config", "--local", key, value)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd.Run()
}

// Clone a repository using custom SSH options
func CloneRepositoryWithSSH(repoURL, sshCommand string) error {
	if _, err := os.Stat("./key.pub"); os.IsNotExist(err) {
		return fmt.Errorf("key.pub file not found")
	}

	os.Setenv("GIT_SSH_COMMAND", sshCommand)
	defer os.Unsetenv("GIT_SSH_COMMAND")

	cmd := exec.Command("git", "clone", repoURL)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	if err := cmd.Run(); err != nil {
		return fmt.Errorf("error cloning repository: %w", err)
	}

	return nil
}

// CheckGlobalSSHCommand checks if the global core.sshCommand is set to a valid executable path.
func CheckGlobalSSHCommand() (string, error) {
	// Retrieve the global core.sshCommand
	cmd := exec.Command("git", "config", "--global", "core.sshCommand")
	output, err := cmd.Output()
	if err != nil {
		return "", fmt.Errorf("error retrieving global core.sshCommand: %w", err)
	}

	sshCommand := strings.TrimSpace(string(output))

	// Check if the command is a path to an executable without additional options
	if strings.ContainsAny(sshCommand, " 	") {
		return "", fmt.Errorf("global core.sshCommand contains additional parameters")
	}

	// Check if the executable file exists
	if _, err := os.Stat(sshCommand); os.IsNotExist(err) {
		return "", fmt.Errorf("executable file does not exist: %s", sshCommand)
	}

	return sshCommand, nil
}
