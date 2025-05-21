package main

import (
	"fmt"
	"os"
	"runtime"
	"time"
)

func main() {
	fmt.Println("==================================================")
	fmt.Println("Multiplatform Demo Application")
	fmt.Println("==================================================")
	PrintVersionInfo()
	fmt.Println("--------------------------------------------------")
	fmt.Printf("OS: %s\n", runtime.GOOS)
	fmt.Printf("Architecture: %s\n", runtime.GOARCH)
	fmt.Printf("Go Version: %s\n", runtime.Version())
	fmt.Printf("Current Time: %s\n", time.Now().Format(time.RFC3339))

	// Перевіряємо наявність змінних середовища
	hostname, err := os.Hostname()
	if err != nil {
		hostname = "unknown"
	}

	fmt.Printf("Hostname: %s\n", hostname)

	// Виводимо деякі змінні середовища
	fmt.Printf("HOME: %s\n", os.Getenv("HOME"))
	fmt.Printf("PWD: %s\n", os.Getenv("PWD"))
	fmt.Printf("USER: %s\n", os.Getenv("USER"))

	fmt.Println("==================================================")
	fmt.Println("Application completed successfully!")
}
