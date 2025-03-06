package cmd

import (
	"fmt"
	"os"
	"strings"

	"github.com/neontowel/awesome-git/pkg/gitutils"
	"github.com/spf13/cobra"
)

var cloneCmd = &cobra.Command{
	Use:   "clone [repository-url]",
	Short: "Clone a Git repository using custom SSH options",
	Args:  cobra.ExactArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		repoURL := args[0]

		// Check if key.pub file exist
		if _, err := os.Stat("./key.pub"); os.IsNotExist(err) {
			fmt.Println("Error: key.pub file not found.")
			os.Exit(1)
		}

		// Set custom SSH command
		sshCommand := os.Getenv("SSH_COMMAND")
		if sshCommand == "" {
			sshCommand = "ssh -o IdentitiesOnly=yes -i ./key.pub"
			// Attempt to retrieve the global SSH command
			globalSSHCommand, err := gitutils.CheckGlobalSSHCommand()
			if err != nil {
				// Use the default value of sshCommandFlag without replacing
				fmt.Printf("Warning: failed to retrieve global SSH command: %v\n", err)
				fmt.Println("Using our built-in SSH command value (override using SSH_COMMAND environment variable)...")
			} else if globalSSHCommand != "" {
				// Replace "ssh" with the path to the actual executable if found
				sshCommand = strings.Replace(sshCommand, "ssh", globalSSHCommand, 1)
				fmt.Printf("Injecting global SSH command: %s\n", sshCommand)
			}
		}
		os.Setenv("GIT_SSH_COMMAND", sshCommand)
		defer os.Unsetenv("GIT_SSH_COMMAND")

		// Clone the repository
		if err := gitutils.CloneRepository(repoURL); err != nil {
			fmt.Printf("Error: %v\n", err)
			os.Exit(1)
		}

		fmt.Println("Repository cloned successfully.")
	},
}

func init() {
	rootCmd.AddCommand(cloneCmd)
}
