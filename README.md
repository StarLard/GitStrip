# Git Strip
A command line tool to format text into a git-friendly branch name.

## Installation

1. Clone the respository
2. `cd` into the repository directory
3. Build the binary with `swift build --configuration release`
4. Copy the binary from the build directory into your path: `cp -f .build/release/git-strip /usr/local/bin/git-strip`

## Usage

Strip text with: `git-strip <text>`:
```
$ git-strip "project hello world"
"PROJECT_hello_world" copied to pasteboard!
```

Use the `--lowercase-first-word` option if you want the entire branch name to be lowercased:
```
$ git-strip "hello world"
"hello_world" copied to pasteboard!
```
