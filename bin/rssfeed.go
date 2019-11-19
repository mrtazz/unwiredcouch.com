package main

import (
	"fmt"
	"github.com/gorilla/feeds"
	"gopkg.in/yaml.v2"
	"html"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
	"strings"
	"time"
)

type post struct {
	Date  string `yaml:"date"`
	URL   string `yaml:"url"`
	Title string `yaml:"title"`
}

type entry struct {
	Year  int    `yaml:"year"`
	Posts []post `yaml:"posts"`
}

type index struct {
	Title   string  `yaml:"title"`
	Entries []entry `yaml:"entries"`
}

func main() {
	if len(os.Args) != 3 {
		log.Fatalf("Usage: go run rssfeed.go index.yml atom.xml")
	}
	yamlFile := os.Args[1]
	outFile := os.Args[2]
	now := time.Now()
	timeLayout := "Jan 2, 2006"
	feed := &feeds.Feed{
		Title:       "unwiredcouch.com",
		Link:        &feeds.Link{Href: "https://unwiredcouch.com/atom.xml", Rel: "self"},
		Description: "thoughts which have made it into written existence",
		Author:      &feeds.Author{Name: "Daniel Schauenberg", Email: "d@unwiredcouch.com"},
		Created:     now,
	}
	index := getIndex(yamlFile)

	for _, entry := range index.Entries {
		for _, post := range entry.Posts {
			t, _ := time.Parse(timeLayout, post.Date)
			markdownSource := fmt.Sprintf("./src/%s", strings.Replace(post.URL, ".html", ".md", 1))
			htmlContent := runPandoc(markdownSource)
			feed.Items = append(feed.Items, &feeds.Item{
				Title:       post.Title,
				Link:        &feeds.Link{Href: fmt.Sprintf("https://unwiredcouch.com%s", post.URL)},
				Created:     t,
				Description: html.EscapeString(htmlContent[0:100]),
				Content:     html.EscapeString(htmlContent),
			})
		}
	}
	atom, err := feed.ToAtom()
	if err != nil {
		log.Fatal(err)
	}

	err = ioutil.WriteFile(outFile, []byte(atom), 0644)
	if err != nil {
		log.Fatal(err)
	}
}

func getIndex(file string) *index {

	index := &index{}

	yamlFile, err := ioutil.ReadFile(file)
	if err != nil {
		log.Printf("yamlFile.Get err   #%v ", err)
	}
	err = yaml.Unmarshal(yamlFile, index)
	if err != nil {
		log.Fatalf("Unmarshal: %v", err)
	}

	return index
}

func runPandoc(file string) string {
	log.Printf("Pandoc converting: %s", file)
	out, err := exec.Command(
		"pandoc", file, "--from=markdown_github-hard_line_breaks+yaml_metadata_block",
		"--email-obfuscation=none", "--to=html").Output()
	if err != nil {
		log.Fatalf("cmd.Run() failed with %s\n", err)
	}
	return string(out)
}
