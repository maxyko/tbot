APP := $(shell basename $(shell git remote get-url origin))
REGISTRY := maxyko
VERSION := $(shell git describe --tags --abbrev=0 --always)-$(shell git rev-parse --short HEAD)

TARGETOS    ?= linux
TARGETARCH  ?= amd64    # $(shell dpkg --print-architecture)


format:
	gofmt -s -w ./

lint:
	golint ./

vet:
	go vet ./

test:
	go test -v ./

get:
	go get ./

build:
	CGO_ENABLED=0 GOOS=$(TARGETOS) GOARCH=$(TARGETARCH) \
	go build -v -o tbot -ldflags "-X=github.com/maxyko/tbot/cmd.appVersion=$(VERSION)"

image:
	docker build . -t $(REGISTRY)/$(APP):$(VERSION)-$(TARGETARCH) \
	--build-arg TARGETARCH=$(TARGETARCH) --build-arg VERSION=$(VERSION)

linux:
	$(MAKE) TARGETOS=linux TARGETARCH=amd64 image

arm:
	$(MAKE) TARGETOS=linux TARGETARCH=arm64 image

windows:
	$(MAKE) TARGETOS=windows TARGETARCH=amd64 image

macos:
	$(MAKE) TARGETOS=darwin TARGETARCH=arm64 image

push:
	docker push $(REGISTRY)/$(APP):$(VERSION)-$(TARGETARCH)

clean:
	rm -rf tbot
	docker rmi $(REGISTRY)/$(APP):$(VERSION)-$(TARGETARCH) || true
