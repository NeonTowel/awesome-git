package cmd

import (
	"os"

	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use:   "awesome-git",
	Short: "Awesome Git is a CLI tool for managing Git repositories",
	Long:  `A CLI tool to clone and configure Git repositories with custom settings.`,
}

func Execute() {
	if err := rootCmd.Execute(); err != nil {
		os.Exit(1)
	}
}
