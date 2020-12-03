package main

// tool to find reading post without cover image

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

const (
	readingFolder = "content/reading/"
	imagesFolder  = "static/images/reading/"
)

var (
	coverSuffixes = []string{".png", ".jpg"}
)

func main() {
	var files []string

	err := filepath.Walk(readingFolder, func(path string, info os.FileInfo, err error) error {
		files = append(files, strings.ReplaceAll(strings.ReplaceAll(path, readingFolder, ""), ".md", ""))
		return nil
	})
	if err != nil {
		panic(err)
	}
	for _, file := range files {
		if file == "" {
			continue
		}
		coverBasePath := fmt.Sprintf("%s/%s/cover", imagesFolder, file)
		needsCover := true
		for _, suffix := range coverSuffixes {
			if fileExists(fmt.Sprintf("%s%s", coverBasePath, suffix)) {
				needsCover = false
			}
		}
		if needsCover {
			fmt.Printf("Missing cover for: %s\n", file)
		}
	}
}

func fileExists(filename string) bool {
	info, err := os.Stat(filename)
	if os.IsNotExist(err) {
		return false
	}
	return !info.IsDir()
}
