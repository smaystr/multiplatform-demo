package main

import "fmt"

// AppVersion містить поточну версію додатку
var AppVersion = "1.0.0"

// BuildCommit містить Git-хеш комміту
var BuildCommit = "unknown"

// BuildTime містить час компіляції
var BuildTime = "unknown"

// PrintVersionInfo виводить інформацію про версію додатку
func PrintVersionInfo() {
	fmt.Println("Version Information:")
	fmt.Printf("- Version: %s\n", AppVersion)
	fmt.Printf("- Commit: %s\n", BuildCommit)
	fmt.Printf("- Build Time: %s\n", BuildTime)
}
