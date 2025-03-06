package cmd

import (
	"fmt"
	"os"
	"strings"

	"github.com/neontowel/awesome-git/pkg/gitutils"
	"github.com/spf13/cobra"
)

var (
	emailFlag             string
	sshCommandFlag        string
	pullRebaseFlag        string
	signingKeyFlag        string
	disableSSHFlag        bool
	disableSigningKeyFlag bool
)

const (
	sshCommandFlagDefault = "ssh -o IdentitiesOnly=yes -i ../key.pub"
)

func isValidSSHKeyFormat(key string) bool {
	return strings.HasPrefix(key, "ssh-rsa") || strings.HasPrefix(key, "ecdsa-sha2-nistp256") ||
		strings.HasPrefix(key, "ecdsa-sha2-nistp384") || strings.HasPrefix(key, "ecdsa-sha2-nistp521") ||
		strings.HasPrefix(key, "ssh-ed25519")
}

var configureCmd = &cobra.Command{
	Use:   "configure",
	Short: "Configure local Git repository settings",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("Configuring local Git repository settings...")

		// Check if inside a Git repository
		if !gitutils.IsInsideGitRepo() {
			fmt.Println("Error: Not in a Git repository. Please run this command from within a Git repository.")
			os.Exit(1)
		}

		// Set user email
		if err := gitutils.SetGitConfig("user.email", emailFlag); err != nil {
			fmt.Printf("Error setting user email: %v\n", err)
			os.Exit(1)
		}
		fmt.Printf("+ User email: %s\n", emailFlag)

		// Configure SSH command
		if !disableSSHFlag {
			fmt.Printf("Configuring SSH command: %s\n", sshCommandFlag)
			if err := gitutils.SetGitConfig("core.sshCommand", sshCommandFlag); err != nil {
				fmt.Printf("Error configuring SSH command: %v\n", err)
				os.Exit(1)
			}
			if sshCommandFlag == sshCommandFlagDefault {
				// Attempt to retrieve the global SSH command
				globalSSHCommand, err := gitutils.CheckGlobalSSHCommand()
				if err != nil {
					// Use the default value of sshCommandFlag without replacing
					fmt.Printf("Warning: failed to retrieve global SSH command: %v\n", err)
					fmt.Println("Using default SSH command flag value...")
				} else if globalSSHCommand != "" {
					// Replace "ssh" with the path to the actual executable if found
					sshCommandFlag = strings.Replace(sshCommandFlag, "ssh", globalSSHCommand, 1)
					fmt.Printf("Injecting global SSH command: %s\n", sshCommandFlag)
				}
				if err := gitutils.SetGitConfig("core.sshCommand", sshCommandFlag); err != nil {
					fmt.Printf("Error configuring SSH command: %v\n", err)
					os.Exit(1)
				}
			}
			fmt.Printf("+ SSH command: %s\n", sshCommandFlag)
		} else {
			fmt.Println("SSH command configuration disabled.")
		}

		// Set pull rebase strategy
		if err := gitutils.SetGitConfig("pull.rebase", pullRebaseFlag); err != nil {
			fmt.Printf("Error setting pull rebase: %v\n", err)
			os.Exit(1)
		}
		fmt.Printf("+ Pull rebase: %s\n", pullRebaseFlag)

		// Set user signing key
		if !disableSigningKeyFlag {
			keyData := signingKeyFlag
			if _, err := os.Stat(signingKeyFlag); err == nil {
				// Read the file contents
				data, err := os.ReadFile(signingKeyFlag)
				if err != nil {
					fmt.Printf("Error reading signing key file: %v\n", err)
					os.Exit(1)
				}
				keyData = strings.TrimSpace(string(data))
			}

			// Validate the key format
			if !isValidSSHKeyFormat(keyData) {
				fmt.Println("Error: Invalid SSH key format. Supported formats are RSA and elliptic curve.")
				os.Exit(1)
			}

			if err := gitutils.SetGitConfig("user.signingkey", keyData); err != nil {
				fmt.Printf("Error setting signing key: %v\n", err)
				os.Exit(1)
			}
			fmt.Printf("+ Signing key: %s\n", keyData)
		} else {
			fmt.Println("Signing key configuration disabled.")
		}

		fmt.Println("Local Git repository configuration complete.")
	},
}

func init() {
	rootCmd.AddCommand(configureCmd)

	configureCmd.Flags().StringVarP(&emailFlag, "email", "e", "firstname.lastname@example.com", "Email address for Git commits")
	configureCmd.Flags().StringVarP(&sshCommandFlag, "ssh-command", "s", sshCommandFlagDefault, "Custom SSH command for Git operations")
	configureCmd.Flags().StringVarP(&pullRebaseFlag, "pull-rebase", "r", "true", "Use rebase when pulling")
	configureCmd.Flags().StringVarP(&signingKeyFlag, "signing-key", "k", "", "Path to the SSH key file for signing commits or key data content")
	configureCmd.Flags().BoolVarP(&disableSSHFlag, "disable-ssh", "d", false, "Disable SSH command configuration")
	configureCmd.Flags().BoolVarP(&disableSigningKeyFlag, "disable-signing-key", "g", false, "Disable signing key configuration")
}
