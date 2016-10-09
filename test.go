package main

import (
	"fmt"
	"github.com/kr/pty"
	"os"
)

func main() {
	rows, cols, err := pty.Getsize(os.Stdin)
	fmt.Printf("Found %d rows, %d columns, and error: %+v\n", rows, cols, err)
}
