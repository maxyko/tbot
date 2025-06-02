# Application name and registry configuration
APP := $(shell basename $(shell git remote get-url origin))
REGISTRY := maxyko
VERSION := $(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)

# Build configuration
TARGETOS   = linux
TARGETARCH = arm64

format:
    gofmt -s -w ./

build:
    go build -v -o tbot -ldflags "-X=github.com/maxyko/tbot/cmd.appVersion=$(VERSION) -w -s"
