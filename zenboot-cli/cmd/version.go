package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
)

func init() {
	RootCmd.AddCommand(versionCmd)
}

var versionCmd = &cobra.Command{
	Use:   "version",
	Short: "Print the version number of zenboot",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("zenboot CLI v0.13.0")
	},
}
